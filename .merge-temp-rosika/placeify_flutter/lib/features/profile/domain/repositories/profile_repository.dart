import 'package:placeify_client/placeify_client.dart';

/// Customer profile dashboard API contract.
abstract interface class ProfileRepository {
  Future<UserDashboard> getDashboard();

  Future<List<UserOrderSummary>> listOrders({
    int limit = 20,
    int offset = 0,
    OrderStatus? status,
  });

  Future<List<UserArSessionSummary>> listArSessions({
    int limit = 20,
    int offset = 0,
  });
}

class ProfileException implements Exception {
  ProfileException(this.message);

  final String message;

  @override
  String toString() => message;
}
