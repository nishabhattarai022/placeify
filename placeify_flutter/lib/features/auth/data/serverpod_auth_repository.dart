import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/config/resolve_server_url.dart';
import '../../admin/domain/enums/user_role.dart' as ui_role;
import '../../vendor/domain/enums/vendor_status.dart';
import '../domain/models/app_user.dart';
import '../domain/models/consumer_profile_details.dart';
import '../domain/repositories/auth_repository.dart';

/// Serverpod email/JWT auth backed by the Placeify backend.
class ServerpodAuthRepository implements AuthRepository {
  ServerpodAuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _sessionEmailKey = 'placeify_auth_session_email';
  static const _pendingEmailKey = 'placeify_pending_registration_email';
  static const _pendingPasswordKey = 'placeify_pending_registration_password';
  static const _pendingNameKey = 'placeify_pending_registration_name';
  static const _devVerificationCode = '123456';
  static const _adminBootstrapEmail = 'admin@placeify.com';

  static Future<ServerpodAuthRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ServerpodAuthRepository(prefs);
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    // Legacy signature: start verification only — never auto-login.
    await beginEmailRegistration(
      fullName: fullName,
      email: email,
      password: password,
    );
    throw AuthException(
      'Registration started. Check your email to verify your Placeify account.',
    );
  }

  @override
  Future<String> beginEmailRegistration({
    required String fullName,
    required String email,
    required String password,
  }) async {
    return _withConnectionRetry(
      () => _beginEmailRegistration(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );
  }

  Future<String> _beginEmailRegistration({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final trimmedName = fullName.trim();

    try {
      await client.emailIdp.startRegistration(email: normalizedEmail);
      await _prefs.setString(_pendingEmailKey, normalizedEmail);
      await _prefs.setString(_pendingPasswordKey, password);
      await _prefs.setString(_pendingNameKey, trimmedName);

      // Ensure we do not keep an accidental session from prior attempts.
      if (client.auth.isAuthenticated) {
        await client.auth.signOutDevice();
      }
      await _prefs.remove(_sessionEmailKey);

      return normalizedEmail;
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> verifyEmailRegistration({
    required String token,
    required String password,
    String? fullName,
  }) async {
    return _withConnectionRetry(
      () => _verifyEmailRegistration(
        token: token,
        password: password,
        fullName: fullName,
      ),
    );
  }

  Future<void> _verifyEmailRegistration({
    required String token,
    required String password,
    String? fullName,
  }) async {
    final resolvedName = (fullName ?? _prefs.getString(_pendingNameKey) ?? '')
        .trim();
    await _postAuthJson(
      '/auth/verify-email',
      body: {
        'token': token.trim(),
        'password': password,
        if (resolvedName.isNotEmpty) 'fullName': resolvedName,
      },
    );

    await _prefs.remove(_pendingEmailKey);
    await _prefs.remove(_pendingPasswordKey);
    await _prefs.remove(_pendingNameKey);

    if (client.auth.isAuthenticated) {
      await client.auth.signOutDevice();
    }
    await _prefs.remove(_sessionEmailKey);
  }

  @override
  Future<void> resendVerificationEmail({
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    await _postAuthJson(
      '/auth/resend-verification',
      body: {'email': normalizedEmail},
    );
  }

  /// Password saved during [beginEmailRegistration] for the magic-link finish.
  String? get pendingRegistrationPassword =>
      _prefs.getString(_pendingPasswordKey);

  String? get pendingRegistrationEmail => _prefs.getString(_pendingEmailKey);

  String? get pendingRegistrationName => _prefs.getString(_pendingNameKey);

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    return _withConnectionRetry(
      () => _signIn(email: email, password: password),
    );
  }

  Future<AppUser> _signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final authSuccess = await client.emailIdp.login(
        email: normalizedEmail,
        password: password,
      );
      await client.auth.updateSignedInUser(authSuccess);
      await _prefs.setString(_sessionEmailKey, normalizedEmail);
      await _ensureDemoAdminIfNeeded(normalizedEmail);
      return _loadAppUser(normalizedEmail);
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    if (!client.auth.isAuthenticated) {
      await _prefs.remove(_sessionEmailKey);
      return null;
    }

    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) return null;

    try {
      await _ensureDemoAdminIfNeeded(email);
      return await _loadAppUser(email);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AppUser> updateVendorStatus({
    required VendorStatus status,
    String? vendorId,
  }) async {
    _requireAuthenticated();
    final cachedEmail = _prefs.getString(_sessionEmailKey);
    if (cachedEmail != null) {
      return _loadAppUser(cachedEmail);
    }

    final profile = await client.user.getCurrentUser();
    if (profile?.email != null && profile!.email!.trim().isNotEmpty) {
      final email = profile.email!.trim().toLowerCase();
      await _prefs.setString(_sessionEmailKey, email);
      return _loadAppUser(email);
    }

    throw AuthException('User profile not found');
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    throw UnsupportedError(
      'Use AdminRepository.listUsers for platform user listing.',
    );
  }

  @override
  Future<void> updateVendorStatusForUser({
    required String userId,
    required VendorStatus status,
    String? vendorId,
  }) async {
    throw UnsupportedError(
      'Use AdminRepository moderation APIs for vendor status changes.',
    );
  }

  @override
  Future<ConsumerProfileDetails?> getConsumerProfile() async {
    if (!client.auth.isAuthenticated) return null;

    try {
      final profile = await client.user.getCurrentUser();
      if (profile == null) return null;

      final email = profile.email ?? _prefs.getString(_sessionEmailKey) ?? '';
      final extras = ConsumerProfileDetails.decodeAddressPayload(
        profile.address,
      );
      final firstName = extras.firstName.trim();
      final lastName = extras.lastName.trim();
      return ConsumerProfileDetails(
        fullName: profile.name,
        email: email,
        firstName: firstName.isNotEmpty
            ? firstName
            : _splitName(profile.name).$1,
        lastName: lastName.isNotEmpty
            ? lastName
            : _splitName(profile.name).$2,
        phone: profile.phone ?? '',
        city: extras.city,
        username: extras.username,
        bio: extras.bio,
        gender: extras.gender,
        dateOfBirth: extras.dateOfBirth,
        addressLine1: extras.addressLine1,
        addressLine2: extras.addressLine2,
        district: extras.district,
        province: extras.province,
        postalCode: extras.postalCode,
        country: extras.country,
        preferredLanguage: extras.preferredLanguage,
        defaultDeliveryAddress: extras.defaultDeliveryAddress,
        profileImageUrl: profile.profileImageUrl ?? '',
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<AppUser> updateConsumerProfile(ConsumerProfileDetails profile) async {
    _requireAuthenticated();

    try {
      await client.user.updateProfile(
        profile.resolvedFullName.isEmpty
            ? profile.fullName.trim()
            : profile.resolvedFullName,
        phone: profile.phone.trim().isEmpty ? null : profile.phone.trim(),
        address: ConsumerProfileDetails.encodeAddressPayload(
          city: profile.city.trim(),
          username: profile.username.trim(),
          bio: profile.bio.trim(),
          firstName: profile.firstName.trim(),
          lastName: profile.lastName.trim(),
          gender: profile.gender.trim(),
          dateOfBirth: profile.dateOfBirth.trim(),
          addressLine1: profile.addressLine1.trim(),
          addressLine2: profile.addressLine2.trim(),
          district: profile.district.trim(),
          province: profile.province.trim(),
          postalCode: profile.postalCode.trim(),
          country: profile.country.trim(),
          preferredLanguage: profile.preferredLanguage.trim(),
          defaultDeliveryAddress: profile.defaultDeliveryAddress.trim(),
        ),
      );

      final email = _prefs.getString(_sessionEmailKey) ?? profile.email;
      return _loadAppUser(email);
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      throw AuthException('Enter your email');
    }
    if (newPassword.length < 8) {
      throw AuthException('Password must be at least 8 characters');
    }

    try {
      final requestId = await client.emailIdp.startPasswordReset(
        email: normalizedEmail,
      );
      final finishToken = await client.emailIdp.verifyPasswordResetCode(
        passwordResetRequestId: requestId,
        verificationCode: _devVerificationCode,
      );
      await client.emailIdp.finishPasswordReset(
        finishPasswordResetToken: finishToken,
        newPassword: newPassword,
      );
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOutDevice();
    await _prefs.remove(_sessionEmailKey);
  }

  @override
  Future<AppUser> becomeVendor() async {
    _requireAuthenticated();
    try {
      await client.user.becomeVendor();
      final email = _prefs.getString(_sessionEmailKey);
      if (email == null) {
        throw AuthException('User profile not found');
      }
      return _loadAppUser(email);
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<AppUser> becomeConsumer() async {
    _requireAuthenticated();
    try {
      await client.user.becomeConsumer();
      final email = _prefs.getString(_sessionEmailKey);
      if (email == null) {
        throw AuthException('User profile not found');
      }
      return _loadAppUser(email);
    } catch (error) {
      throw _mapError(error);
    }
  }

  Future<AppUser> _loadAppUser(String email) async {
    final profile = await client.user.getCurrentUser();
    if (profile == null) {
      throw AuthException('User profile not found');
    }
    // Always resolve shop id when present so client purchase policy can run.
    final vendorId = await _loadVendorId();
    final hasVendorShop = vendorId != null || await _loadHasVendorShop();
    final vendorStatus = _vendorStatusFromServer(
      profile,
      hasVendorShop: hasVendorShop,
    );

    return _toAppUser(
      profile,
      email,
      hasVendorShop: hasVendorShop,
      vendorStatus: vendorStatus,
      vendorId: vendorId,
    );
  }

  Future<bool> _loadHasVendorShop() async {
    try {
      return await client.vendor.hasShop();
    } catch (_) {
      return false;
    }
  }

  Future<String?> _loadVendorId() async {
    try {
      final shop = await client.vendor.getMyShop();
      return shop.id?.toString();
    } catch (_) {
      return null;
    }
  }

  AppUser _toAppUser(
    User profile,
    String email, {
    bool? hasVendorShop,
    VendorStatus? vendorStatus,
    String? vendorId,
  }) {
    return AppUser(
      id: profile.id.toString(),
      fullName: profile.name,
      email: email,
      role: _mapRole(profile.role),
      vendorStatus: vendorStatus ?? VendorStatus.none,
      vendorId: vendorId,
    );
  }

  ui_role.UserRole _mapRole(UserRole role) {
    return switch (role) {
      UserRole.admin => ui_role.UserRole.admin,
      UserRole.vendor => ui_role.UserRole.vendor,
      UserRole.consumer => ui_role.UserRole.customer,
    };
  }

  VendorStatus? _vendorStatusFromServer(
    User profile, {
    required bool hasVendorShop,
  }) {
    if (!hasVendorShop && profile.role != UserRole.vendor) return null;

    return switch (profile.status) {
      UserAccountStatus.approved => VendorStatus.approved,
      UserAccountStatus.pending => VendorStatus.pending,
      UserAccountStatus.suspended => VendorStatus.suspended,
      UserAccountStatus.rejected => VendorStatus.none,
    };
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw AuthException('Sign in to continue');
    }
  }

  Future<void> _ensureDemoAdminIfNeeded(String email) async {
    if (email.trim().toLowerCase() != _adminBootstrapEmail) {
      return;
    }
    try {
      await client.user.ensureDemoAdmin();
    } catch (_) {
      // Promotion may already be applied; profile reload below still runs.
    }
  }

  Future<T> _withConnectionRetry<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (error) {
      if (!_looksLikeConnectionError(error)) rethrow;
      await reconnectPlaceifyClient(forceRefresh: true);
      try {
        return await action();
      } catch (retryError) {
        throw _mapError(retryError);
      }
    }
  }

  AuthException _mapError(Object error) {
    if (error is AuthException) return error;

    final errorText = error.toString();

    if (errorText.contains('EmailAccountLoginException')) {
      if (errorText.contains('invalidCredentials')) {
        return AuthException(
          'No account found for this email, or the password is wrong.',
        );
      }
      if (errorText.contains('tooManyAttempts')) {
        return AuthException(
          'Too many failed attempts. Wait a moment and try again.',
        );
      }
    }

    if (errorText.contains('EmailAccountRequestException')) {
      if (errorText.contains('policyViolation') ||
          errorText.contains('EmailPasswordPolicyViolationException')) {
        return AuthException(
          'Password is too weak. Use at least 8 characters with letters and numbers.',
        );
      }
      if (errorText.contains('tooManyAttempts')) {
        return AuthException(
          'Too many verification attempts. Wait a moment and try again.',
        );
      }
      if (errorText.contains('expired')) {
        return AuthException(
          'Verification code expired. Go back and start registration again.',
        );
      }
      return AuthException(
        'Could not verify email. If you already have an account, try logging in instead.',
      );
    }

    if (errorText.contains('EmailAccountAlreadyRegisteredException') ||
        (errorText.contains('already') && errorText.contains('email'))) {
      return AuthException('An account with this email already exists. Try logging in.');
    }

    final rawMessage = error is ServerpodClientException
        ? error.message
        : error.toString();
    final message = rawMessage.toLowerCase();

    if (_isConnectionError(message) || _looksLikeConnectionError(error)) {
      return AuthException(_connectionHelpMessage());
    }
    if (message.contains('password') &&
        (message.contains('invalid') || message.contains('incorrect'))) {
      return AuthException('Incorrect password');
    }
    if (message.contains('not found') ||
        message.contains('no account') ||
        message.contains('unknown user')) {
      return AuthException('No account found for this email');
    }
    if (message.contains('already') && message.contains('email')) {
      return AuthException('An account with this email already exists');
    }
    if (message.contains('profile not found')) {
      return AuthException('User profile not found. Try registering again.');
    }
    if (message.contains('shop_not_found') ||
        message.contains('complete vendor registration')) {
      return AuthException(
        'Register your shop first to switch to vendor mode.',
      );
    }
    if (message.contains('invalid_shop_name')) {
      return AuthException('Enter a shop name.');
    }
    if (message.contains('invalid_shop_description')) {
      return AuthException('Enter a shop description.');
    }
    if (message.contains('invalid_phone')) {
      return AuthException('Enter a phone number.');
    }
    if (message.contains('invalid_address')) {
      return AuthException('Enter your shop address.');
    }
    if (message.contains('vendor_exists')) {
      return AuthException('You already have a registered shop.');
    }
    if (message.contains('internal server error') ||
        message.contains('statuscode = 500') ||
        message.contains('statuscode=500')) {
      return AuthException(
        'Could not create your account right now. Please try again in a moment.',
      );
    }
    if (message.contains('email') &&
        (message.contains('deliver') ||
            message.contains('smtp') ||
            message.contains('provider'))) {
      return AuthException(
        'Could not send the verification email. Please try again later.',
      );
    }
    if (rawMessage.isNotEmpty && rawMessage != 'Exception') {
      return AuthException(rawMessage);
    }

    return AuthException('Something went wrong. Please try again.');
  }

  bool _isConnectionError(String message) {
    return message.contains('socketexception') ||
        message.contains('connection refused') ||
        message.contains('connection reset') ||
        message.contains('failed host lookup') ||
        message.contains('network is unreachable') ||
        message.contains('timed out') ||
        message.contains('no route to host') ||
        message.contains('connection closed') ||
        message.contains('handshake') ||
        message.contains('network error');
  }

  bool _looksLikeConnectionError(Object error) {
    if (error is ServerpodClientException) {
      final message = error.message.toLowerCase();
      return _isConnectionError(message);
    }
    return _isConnectionError(error.toString().toLowerCase());
  }

  String _connectionHelpMessage() {
    final base =
        'Cannot reach the server at $serverUrl. '
        'Start it with: cd placeify_server && dart bin/main.dart --apply-migrations';

    if (Platform.isAndroid || Platform.isIOS) {
      return '$base\n\n'
          'On a physical phone, set your PC Wi‑Fi IP in '
          'placeify_flutter/assets/config.json → physicalApiUrl '
          '(or run placeify_flutter/scripts/sync_network_config.ps1), '
          'then rebuild the app. PC and phone must be on the same Wi‑Fi. '
          'On Windows, allow inbound TCP port 8080 in the firewall.';
    }

    return base;
  }

  Future<void> _postAuthJson(
    String path, {
    required Map<String, Object?> body,
  }) async {
    try {
      // Auth HTML routes live on the web server (8082), not the API (8080).
      final apiBase = await resolveServerUrl(forceRefresh: true);
      final apiUri = Uri.parse(apiBase);
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      final uri = Uri(
        scheme: apiUri.scheme,
        host: apiUri.host,
        port: 8082,
        path: normalizedPath,
      );
      final response = await http.post(
        uri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final payload = response.body.isEmpty
          ? const <String, dynamic>{}
          : jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return;
      }

      final message = payload['message']?.toString();
      if (message != null && message.trim().isNotEmpty) {
        throw AuthException(message);
      }
      throw AuthException('Request failed. Please try again.');
    } on AuthException {
      rethrow;
    } catch (error) {
      throw _mapError(error);
    }
  }

  static (String, String) _splitName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return ('', '');
    if (parts.length == 1) return (parts.first, '');
    return (parts.first, parts.sublist(1).join(' '));
  }
}
