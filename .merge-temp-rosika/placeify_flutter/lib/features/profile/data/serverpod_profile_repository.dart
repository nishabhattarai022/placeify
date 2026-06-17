import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../domain/repositories/profile_repository.dart';

/// Serverpod-backed customer profile dashboard repository.
class ServerpodProfileRepository implements ProfileRepository {
  @override
  Future<UserDashboard> getDashboard() async {
    _requireAuthenticated();
    try {
      return await client.user.getDashboard();
    } catch (error) {
      throw ProfileException('Could not load dashboard');
    }
  }

  @override
  Future<List<UserOrderSummary>> listOrders({
    int limit = 20,
    int offset = 0,
    OrderStatus? status,
  }) async {
    _requireAuthenticated();
    try {
      return await client.user.listMyOrders(
        limit: limit,
        offset: offset,
        status: status,
      );
    } catch (error) {
      throw ProfileException('Could not load orders');
    }
  }

  @override
  Future<List<UserArSessionSummary>> listArSessions({
    int limit = 20,
    int offset = 0,
  }) async {
    _requireAuthenticated();
    try {
      return await client.user.listMyArSessions(
        limit: limit,
        offset: offset,
      );
    } catch (error) {
      throw ProfileException('Could not load AR history');
    }
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw ProfileException('Sign in to view your profile');
    }
  }
}
