import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../domain/enums/payment_status.dart';
import '../domain/models/payment_update.dart';
import '../domain/repositories/vendor_payment_repository.dart';
import 'vendor_payment_mapper.dart';

/// Vendor payment status and history backed by PostgreSQL.
class ServerpodVendorPaymentRepository implements VendorPaymentRepository {
  const ServerpodVendorPaymentRepository();

  @override
  Future<VendorPaymentsOverviewData> getPaymentsOverview(String vendorId) async {
    final overview = await _loadOverview();
    return VendorPaymentsOverviewData(
      totalEarned: overview.totalEarned,
      pendingPaymentCount: overview.pendingPaymentCount,
      paymentHistory:
          overview.paymentHistory.map(VendorPaymentMapper.toUpdate).toList(),
      todayRevenue: overview.todayRevenue,
      monthlyRevenue: overview.monthlyRevenue,
      refundAmount: overview.refundAmount,
      refundCount: overview.refundCount,
      successfulPaymentCount: overview.successfulPaymentCount,
      codPaymentCount: overview.codPaymentCount,
      esewaPaymentCount: overview.esewaPaymentCount,
      averageOrderValue: overview.averageOrderValue,
      pendingRefundCount: overview.pendingRefundCount,
    );
  }

  @override
  Future<List<PaymentUpdate>> getPaymentUpdates(String orderId) async {
    final parsedId = _parseOrderId(orderId);
    if (parsedId == null) return const [];

    try {
      final updates = await client.payment.listPaymentUpdates(parsedId);
      return updates.map(VendorPaymentMapper.toUpdate).toList();
    } catch (error) {
      throw VendorPaymentException(_mapError(error));
    }
  }

  @override
  Future<PaymentUpdate> updatePaymentStatus({
    required String vendorId,
    required String orderId,
    required PaymentStatus status,
    required String note,
  }) async {
    final parsedId = _parseOrderId(orderId);
    if (parsedId == null) {
      throw VendorPaymentException('Invalid order id.');
    }

    try {
      final update = await client.payment.updateOrderPaymentStatus(
        parsedId,
        VendorPaymentMapper.toApiStatus(status),
        note: note,
      );
      return VendorPaymentMapper.toUpdate(update);
    } catch (error) {
      throw VendorPaymentException(_mapError(error));
    }
  }

  Future<VendorPaymentsOverview> _loadOverview() async {
    try {
      return await client.payment.getOverview();
    } catch (error) {
      throw VendorPaymentException(_mapError(error));
    }
  }

  int? _parseOrderId(String orderId) => int.tryParse(orderId);

  String _mapError(Object error) {
    if (error is PlaceifyException) return error.message;
    return 'Something went wrong. Please try again.';
  }
}
