import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'payment_service.dart';

/// Vendor payment and payout APIs.
class PaymentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = PaymentService();

  Future<VendorPaymentsOverview> getOverview(Session session) {
    return _service.getOverview(session);
  }

  Future<List<PaymentUpdateSummary>> listPaymentUpdates(
    Session session,
    int orderId,
  ) {
    return _service.listPaymentUpdates(session, orderId);
  }

  Future<PaymentUpdateSummary> updateOrderPaymentStatus(
    Session session,
    int orderId,
    PaymentTransactionStatus status, {
    required String note,
  }) {
    return _service.updateOrderPaymentStatus(
      session,
      orderId,
      status,
      note: note,
    );
  }

  Future<VendorPayoutSummary> requestPayout(Session session) {
    return _service.requestPayout(session);
  }
}
