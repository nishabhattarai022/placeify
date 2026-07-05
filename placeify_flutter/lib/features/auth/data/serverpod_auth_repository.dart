import 'dart:io';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../admin/domain/enums/user_role.dart' as ui_role;
import '../../vendor/domain/enums/vendor_status.dart';
import '../constants/demo_credentials.dart';
import '../domain/models/app_user.dart';
import '../domain/repositories/auth_repository.dart';

/// Serverpod email/JWT auth backed by the Placeify backend.
class ServerpodAuthRepository implements AuthRepository {
  ServerpodAuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _sessionEmailKey = 'placeify_auth_session_email';
  static const _devVerificationCode = '123456';

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
    return _withConnectionRetry(
      () => _register(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );
  }

  Future<AppUser> _register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final requestId = await client.emailIdp.startRegistration(
        email: normalizedEmail,
      );
      final registrationToken = await client.emailIdp.verifyRegistrationCode(
        accountRequestId: requestId,
        verificationCode: _devVerificationCode,
      );
      final authSuccess = await client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      await client.auth.updateSignedInUser(authSuccess);

      await client.user.updateProfile(
        fullName.trim(),
        phone: null,
        address: null,
      );

      await _prefs.setString(_sessionEmailKey, normalizedEmail);
      return _loadAppUser(normalizedEmail);
    } catch (error) {
      throw _mapError(error);
    }
  }

  /// Signs in with the built-in demo account, registering it first if needed.
  Future<AppUser> signInWithDemoCredentials() async {
    try {
      return await signIn(
        email: DemoCredentials.email,
        password: DemoCredentials.password,
      );
    } on AuthException catch (error) {
      if (!_isMissingAccountError(error.message)) rethrow;

      await register(
        fullName: DemoCredentials.fullName,
        email: DemoCredentials.email,
        password: DemoCredentials.password,
      );
      return signIn(
        email: DemoCredentials.email,
        password: DemoCredentials.password,
      );
    }
  }

  /// Signs in with the demo admin account for local admin dashboard access.
  Future<AppUser> signInWithDemoAdminCredentials() async {
    try {
      await signIn(
        email: DemoCredentials.adminEmail,
        password: DemoCredentials.adminPassword,
      );
    } on AuthException catch (error) {
      if (!_isMissingAccountError(error.message)) rethrow;

      await register(
        fullName: DemoCredentials.adminFullName,
        email: DemoCredentials.adminEmail,
        password: DemoCredentials.adminPassword,
      );
      await signIn(
        email: DemoCredentials.adminEmail,
        password: DemoCredentials.adminPassword,
      );
    }

    return _loadAppUser(DemoCredentials.adminEmail);
  }

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
    final hasVendorShop = await _loadHasVendorShop();
    final vendorId = hasVendorShop ? await _loadVendorId() : null;
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
    if (email.trim().toLowerCase() != DemoCredentials.adminEmail.trim().toLowerCase()) {
      return;
    }
    try {
      await client.user.ensureDemoAdmin();
    } catch (_) {}
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
    if (rawMessage.isNotEmpty && rawMessage != 'Exception') {
      return AuthException(rawMessage);
    }

    return AuthException('Something went wrong. Please try again.');
  }

  bool _isMissingAccountError(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('no account') ||
        normalized.contains('password is wrong') ||
        normalized.contains('invalidcredentials');
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
          'On a physical phone, set your Mac Wi‑Fi IP in '
          'placeify_flutter/assets/config.json → physicalApiUrl, '
          'then rebuild the app. Mac and phone must be on the same Wi‑Fi.';
    }

    return base;
  }
}
