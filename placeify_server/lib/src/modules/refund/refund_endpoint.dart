import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'refund_service.dart';

/// Refund and return requests for authenticated customers.
class RefundEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = RefundService();

  Future<List<RefundRequestSummary>> listMyRefundRequests(
    Session session, {
    PaginationInput? pagination,
  }) {
    return _service.listMyRefundRequests(session, pagination: pagination);
  }

  Future<RefundRequestSummary> getRefundRequest(
    Session session,
    int refundId,
  ) {
    return _service.getRefundRequest(session, refundId);
  }

  Future<RefundRequestSummary> createRefundRequest(
    Session session,
    int orderId,
    String reason,
  ) {
    return _service.createRefundRequest(session, orderId, reason);
  }
}
