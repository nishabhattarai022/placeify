import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import 'admin_auth_service.dart';

/// Unauthenticated admin authorization endpoint.
class AdminAuthEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  final _service = AdminAuthService();

  /// Verifies admin credentials and returns an auth session for an admin user.
  Future<AuthSuccess> login(
    Session session,
    String adminId,
    String password,
  ) {
    return _service.login(
      session,
      adminId: adminId,
      password: password,
    );
  }
}
