import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'refund_repository.dart';

class RefundService {
  RefundService({RefundStore? repository})
    : _repository = repository ?? RefundStore();

  final RefundStore _repository;

  Future<List<RefundRequestSummary>> listMyRefundRequests(
    Session session, {
    PaginationInput? pagination,
  }) {
    return _repository.listForUser(session, pagination: pagination);
  }

  Future<RefundRequestSummary> getRefundRequest(Session session, int refundId) {
    return _repository.getForUser(session, refundId);
  }

  Future<RefundRequestSummary> createRefundRequest(
    Session session,
    int orderId,
    String reason,
  ) {
    return _repository.createForUser(session, orderId, reason);
  }
}
