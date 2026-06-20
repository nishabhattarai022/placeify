import 'package:placeify_client/placeify_client.dart' hide VendorPayout;

import '../../../core/config/placeify_server_client.dart';
import '../domain/enums/payment_status.dart';
import '../domain/models/payment_update.dart';
import '../domain/models/vendor_payout.dart';
import '../domain/repositories/vendor_payment_repository.dart';
import 'vendor_payment_mapper.dart';

/// Vendor payouts and order payment status backed by PostgreSQL.
class ServerpodVendorPaymentRepository implements VendorPaymentRepository {
  const ServerpodVendorPaymentRepository();

  @override
  Future<List<VendorPayout>> getPayouts(String vendorId) async {
    final overview = await _loadOverview();
    return overview.payouts.map(VendorPaymentMapper.toPayout).toList();
  }

  @override
  Future<double> getPendingBalance(String vendorId) async {
    final overview = await _loadOverview();
    return overview.pendingBalance;
  }

  @override
  Future<double> getTotalEarned(String vendorId) async {
    final overview = await _loadOverview();
    return overview.totalEarned;
  }

  @override
  Future<List<PaymentUpdate>> getPaymentUpdates(String orderId) async {
    final parsedId = int.tryParse(orderId);
    if (parsedId == null) return const [];

    try {
      final updates = await client.payment.listPaymentUpdates(parsedId);
      return updates.map(VendorPaymentMapper.toUpdate).toList();
    } on PlaceifyException catch (e) {
      throw VendorPaymentException(e.message);
    }
  }

  @override
  Future<PaymentUpdate> updatePaymentStatus({
    required String vendorId,
    required String orderId,
    required PaymentStatus status,
    required String note,
  }) async {
    final parsedId = int.tryParse(orderId);
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
    } on PlaceifyException catch (e) {
      throw VendorPaymentException(e.message);
    }
  }

  @override
  Future<VendorPayout> requestPayout(String vendorId) async {
    try {
      final payout = await client.payment.requestPayout();
      return VendorPaymentMapper.toPayout(payout);
    } on PlaceifyException catch (e) {
      throw VendorPaymentException(e.message);
    }
  }

  Future<VendorPaymentsOverview> _loadOverview() async {
    try {
      return await client.payment.getOverview();
    } on PlaceifyException catch (e) {
      throw VendorPaymentException(e.message);
    }
  }
}
