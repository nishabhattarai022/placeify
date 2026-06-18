import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';

class RefundRepositoryException implements Exception {
  RefundRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Live refund requests via [client.refund].
class ServerpodRefundRepository {
  const ServerpodRefundRepository();

  Future<List<RefundRequestSummary>> listRefunds({
    int limit = 50,
    int offset = 0,
  }) async {
    _requireAuthenticated();
    try {
      return await client.refund.listMyRefundRequests(
        pagination: PaginationInput(page: (offset ~/ limit) + 1, pageSize: limit),
      );
    } catch (error) {
      throw RefundRepositoryException(_mapError(error));
    }
  }

  Future<RefundRequestSummary> createRefund({
    required int orderId,
    required String reason,
  }) async {
    _requireAuthenticated();
    final trimmed = reason.trim();
    if (trimmed.isEmpty) {
      throw RefundRepositoryException('A reason is required.');
    }

    try {
      return await client.refund.createRefundRequest(orderId, trimmed);
    } catch (error) {
      throw RefundRepositoryException(_mapError(error));
    }
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw RefundRepositoryException('Sign in to manage refunds.');
    }
  }

  String _mapError(Object error) {
    if (error is RefundRepositoryException) return error.message;
    if (error is PlaceifyException) return error.message;
    return error.toString();
  }
}
