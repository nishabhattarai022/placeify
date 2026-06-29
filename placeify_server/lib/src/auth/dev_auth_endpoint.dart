import 'package:serverpod/serverpod.dart';

import '../modules/user/user_service.dart';

/// Development-only auth helpers (no login required).
class DevAuthEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  final _service = UserService();

  /// Ensures the demo admin account exists with known credentials.
  Future<bool> provisionDemoAdmin(Session session) async {
    await _service.provisionDemoAdmin(session);
    return true;
  }
}
