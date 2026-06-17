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
  ) {
    return _service.checkout(session, request);
  }
}
