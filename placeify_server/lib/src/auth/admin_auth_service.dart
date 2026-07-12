import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'admin_auth_config.dart';
import 'auth_email_resolver.dart';
import '../generated/protocol.dart';
import '../modules/admin/admin_repository.dart';
import '../modules/user/user_service.dart';

/// Dedicated admin authentication (not the consumer email signup/login UX).
class AdminAuthService {
  AdminAuthService({
    UserService? userService,
    AdminStore? adminStore,
  }) : _userService = userService ?? UserService(),
       _adminStore = adminStore ?? AdminStore();

  final UserService _userService;
  final AdminStore _adminStore;

  static const _genericFailureMessage = 'Invalid admin credentials.';
  static const _genericFailureCode = 'ADMIN_AUTH_FAILED';

  Future<AuthSuccess> login(
    Session session, {
    required String adminId,
    required String password,
  }) async {
    final normalizedId = adminId.trim().toLowerCase();
    final normalizedPassword = password;
    if (normalizedId.isEmpty || normalizedPassword.isEmpty) {
      throw PlaceifyException(
        message: _genericFailureMessage,
        code: _genericFailureCode,
      );
    }

    final configuredEmail = AdminAuthConfig.adminEmail(session);
    if (normalizedId != configuredEmail) {
      throw PlaceifyException(
        message: _genericFailureMessage,
        code: _genericFailureCode,
      );
    }

    await _ensureAuthAccountExists(session, email: configuredEmail);

    final emailIdp = AuthServices.instance.emailIdp;
    late final AuthSuccess authSuccess;
    try {
      authSuccess = await emailIdp.login(
        session,
        email: configuredEmail,
        password: normalizedPassword,
      );
    } on EmailAccountLoginException {
      throw PlaceifyException(
        message: _genericFailureMessage,
        code: _genericFailureCode,
      );
    } catch (_) {
      throw PlaceifyException(
        message: _genericFailureMessage,
        code: _genericFailureCode,
      );
    }

    var user = await User.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authSuccess.authUserId),
    );
    if (user == null) {
      throw PlaceifyException(
        message: _genericFailureMessage,
        code: _genericFailureCode,
      );
    }

    user = await AuthEmailResolver.syncProfileEmail(session, user);
    if (user.email?.trim().toLowerCase() != configuredEmail) {
      user = await User.db.updateRow(
        session,
        user.copyWith(
          email: configuredEmail,
          name: user.name.trim().isEmpty
              ? AdminAuthConfig.defaultAdminName
              : user.name,
          updatedAt: DateTime.now(),
        ),
      );
    }

    await _adminStore.ensureAdminAccount(
      session,
      user,
      adminType: AdminType.super_admin,
    );

    return authSuccess;
  }

  /// Creates the auth account in development/test only when missing.
  /// Does not assign admin role until password verification succeeds.
  Future<void> _ensureAuthAccountExists(
    Session session, {
    required String email,
  }) async {
    final emailIdp = AuthServices.instance.emailIdp;
    final existing = await emailIdp.admin.findAccount(session, email: email);
    final mode = session.serverpod.runMode;
    final isDevOrTest =
        mode == ServerpodRunMode.development || mode == ServerpodRunMode.test;

    if (existing != null) {
      if (isDevOrTest) {
        // Keep the configured admin password authoritative in local/test.
        await emailIdp.admin.setPassword(
          session,
          email: email,
          password: AdminAuthConfig.adminPassword(session),
        );
        await emailIdp.admin.deleteFailedLoginAttempts(session);
      }
      return;
    }

    if (!isDevOrTest) {
      throw PlaceifyException(
        message: _genericFailureMessage,
        code: _genericFailureCode,
      );
    }

    await _userService.provisionDemoAdmin(session);

    final account = await emailIdp.admin.findAccount(session, email: email);
    if (account == null) {
      throw PlaceifyException(
        message: _genericFailureMessage,
        code: _genericFailureCode,
      );
    }

    await emailIdp.admin.setPassword(
      session,
      email: email,
      password: AdminAuthConfig.adminPassword(session),
    );
    await emailIdp.admin.deleteFailedLoginAttempts(session);
  }
}
