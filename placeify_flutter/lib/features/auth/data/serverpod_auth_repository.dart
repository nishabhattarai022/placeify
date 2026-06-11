import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart' show client;
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

      final profile = await client.user.updateProfile(
        fullName.trim(),
        phone: null,
        address: null,
      );

      await client.auth.signOutDevice();

      return _toAppUser(profile, normalizedEmail);
    } catch (error) {
      throw _mapError(error);
    }
  }

  @override
  Future<AppUser> signIn({
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
  Future<void> signOut() async {
    await client.auth.signOutDevice();
    await _prefs.remove(_sessionEmailKey);
  }

  @override
  Future<AppUser> becomeVendor() async {
    _requireAuthenticated();
    try {
      final profile = await client.user.becomeVendor();
      final email = _prefs.getString(_sessionEmailKey);
      if (email == null) {
        throw AuthException('User profile not found');
      }
      return _toAppUser(profile, email, hasVendorShop: true);
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
    return _toAppUser(
      profile,
      email,
      hasVendorShop: hasVendorShop,
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
  }) {
    return AppUser(
      id: profile.id.toString(),
      fullName: profile.name,
      email: email,
      role: profile.role,
      phone: profile.phone,
      address: profile.address,
      hasVendorShop: hasVendorShop ?? false,
    );
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw AuthException('Sign in to continue');
    }
  }

  AuthException _mapError(Object error) {
    if (error is AuthException) return error;

    final rawMessage = error is ServerpodClientException
        ? error.message
        : error.toString();
    final message = rawMessage.toLowerCase();

    if (_isConnectionError(message)) {
      return AuthException(
        'Cannot reach the server. Start placeify_server and try again.',
      );
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

  bool _isConnectionError(String message) {
    return message.contains('socketexception') ||
        message.contains('connection refused') ||
        message.contains('connection reset') ||
        message.contains('failed host lookup') ||
        message.contains('network is unreachable') ||
        message.contains('timed out') ||
        message.contains('no route to host');
  }
}
