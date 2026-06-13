import 'dart:io';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../vendor/domain/enums/vendor_status.dart';
import '../constants/demo_credentials.dart';
import '../data/mock_auth_repository.dart';
import '../domain/models/app_user.dart';
import '../domain/repositories/auth_repository.dart';

/// Serverpod email/JWT auth backed by the Placeify backend.
class ServerpodAuthRepository implements AuthRepository {
  ServerpodAuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _sessionEmailKey = 'placeify_auth_session_email';
  static const _vendorStatusKey = 'placeify_vendor_status';
  static const _vendorIdKey = 'placeify_vendor_id';
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
    await _prefs.setString(_vendorStatusKey, status.name);
    if (vendorId != null) {
      await _prefs.setString(_vendorIdKey, vendorId);
    }
    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) {
      throw AuthException('User profile not found');
    }
    return _loadAppUser(email);
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOutDevice();
    await _prefs.remove(_sessionEmailKey);
    await _prefs.remove(_vendorStatusKey);
    await _prefs.remove(_vendorIdKey);
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    return MockAuthRepository(_prefs).getAllUsers();
  }

  @override
  Future<void> updateVendorStatusForUser({
    required String userId,
    required VendorStatus status,
    String? vendorId,
  }) async {
    await MockAuthRepository(_prefs).updateVendorStatusForUser(
      userId: userId,
      status: status,
      vendorId: vendorId,
    );
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
      final profile = await client.user.becomeConsumer();
      final email = _prefs.getString(_sessionEmailKey);
      if (email == null) {
        throw AuthException('User profile not found');
      }
      final hasVendorShop = await _loadHasVendorShop();
      return _toAppUser(profile, email, hasVendorShop: hasVendorShop);
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
    final vendorStatus = _vendorStatusFromServer(
      profile,
      hasVendorShop: hasVendorShop,
    );
    if (vendorStatus != null) {
      await _prefs.setString(_vendorStatusKey, vendorStatus.name);
    }
    return _toAppUser(
      profile,
      email,
      hasVendorShop: hasVendorShop,
      vendorStatus: vendorStatus,
    );
  }

  Future<bool> _loadHasVendorShop() async {
    try {
      return await client.vendor.hasShop();
    } catch (_) {
      return false;
    }
  }

  AppUser _toAppUser(
    User profile,
    String email, {
    bool? hasVendorShop,
    VendorStatus? vendorStatus,
  }) {
    return AppUser(
      id: profile.id.toString(),
      fullName: profile.name,
      email: email,
      role: profile.role,
      phone: profile.phone,
      address: profile.address,
      hasVendorShop: hasVendorShop ?? false,
      registeredVendorStatus: vendorStatus ?? _readVendorStatus(),
      registeredVendorId: _prefs.getString(_vendorIdKey),
    );
  }

  /// Maps server moderation status for vendor accounts.
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

  VendorStatus? _readVendorStatus() {
    final raw = _prefs.getString(_vendorStatusKey);
    if (raw == null) return null;
    return VendorStatus.values.asNameMap()[raw];
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw AuthException('Sign in to continue');
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
