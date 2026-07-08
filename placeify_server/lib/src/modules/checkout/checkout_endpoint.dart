import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'checkout_service.dart';

/// Converts a cart into a persisted order.
class CheckoutEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = CheckoutService();

  Future<CheckoutResult> checkout(
    Session session,
    CheckoutRequest request,
  ) async {
    print(
      'ORDER_ROUTE_DEBUG req.user: ${session.authenticated?.userIdentifier}',
    );
    print(
      'ORDER_ROUTE_DEBUG headers auth: '
      '${session.authenticated != null ? "exists" : "missing"}',
    );
    print('ORDER_ROUTE_DEBUG body: ${request.toJson()}');
    try {
      final result = await _service.checkout(session, request);
      print(
        'ORDER_ROUTE_DEBUG result: '
        '{orderId: ${result.order.id}, itemCount: ${result.itemCount}}',
      );
      return result;
    } catch (error, stackTrace) {
      print('ORDER_ROUTE_DEBUG error: $error');
      print('ORDER_ROUTE_DEBUG stackTrace: $stackTrace');
      rethrow;
    }
  }
}
