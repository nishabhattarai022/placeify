import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'payment_repository.dart';

class PaymentService {
  PaymentService({PaymentStore? repository})
      : _repository = repository ?? PaymentStore();

  final PaymentStore _repository;

  Future<VendorPaymentsOverview> getOverview(Session session) {
    return _repository.getOverview(session);
  }

  Future<List<PaymentUpdateSummary>> listPaymentUpdates(
    Session session,
    int orderId,
  ) {
    return _repository.listUpdatesForOrder(session, orderId);
  }

  Future<PaymentUpdateSummary> updateOrderPaymentStatus(
    Session session,
    int orderId,
    PaymentTransactionStatus status, {
    required String note,
  }) {
    return _repository.updateOrderPaymentStatus(
      session,
      orderId,
      status,
      note: note,
    );
  }

  Future<VendorPayoutSummary> requestPayout(Session session) {
    return _repository.requestPayout(session);
  }
}
