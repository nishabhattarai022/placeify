import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../domain/models/vendor_pending_refund.dart';

class ServerpodVendorRefundRepository {
  const ServerpodVendorRefundRepository();

  Future<List<VendorPendingRefund>> listPending() async {
    try {
      final rows = await client.vendor.listPendingRefundRequests();
      return rows.map(_map).toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<void> approve(int refundId) async {
    await client.vendor.approveRefundRequest(refundId);
  }

  Future<void> reject(int refundId, {String? reason}) async {
    await client.vendor.rejectRefundRequest(refundId, reason: reason);
  }

  VendorPendingRefund _map(RefundRequestSummary row) {
    return VendorPendingRefund(
      id: row.id,
      orderId: row.orderId,
      orderNumber: row.orderNumber,
      refundAmount: row.refundAmount,
      reason: row.reason,
      createdAt: row.createdAt,
    );
  }
}
