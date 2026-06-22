import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_payment_repository.dart';

class MockVendorPaymentRepository implements VendorPaymentRepository {
  MockVendorPaymentRepository();

  static final List<PaymentUpdate> _paymentUpdates = [
    PaymentUpdate(
      id: 'pu1',
      orderId: 'vo3',
      amount: 50000,
      status: PaymentStatus.paid,
      note: 'Payment received via eSewa.',
      updatedAt: DateTime(2026, 5, 28, 14, 0),
    ),
    PaymentUpdate(
      id: 'pu2',
      orderId: 'vo2',
      amount: 9800,
      status: PaymentStatus.pending,
      note: 'Awaiting customer confirmation.',
      updatedAt: DateTime(2026, 6, 5, 11, 0),
    ),
  ];

  bool simulatePayoutError = false;

  @override
  Future<List<VendorPayout>> getPayouts(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.from(VendorMockConfig.payoutsFor(vendorId));
  }

  @override
  Future<double> getPendingBalance(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final payouts = VendorMockConfig.payoutsFor(vendorId);
    return payouts
        .where((p) => p.status == PaymentStatus.pending)
        .fold<double>(0, (sum, p) => sum + p.amount);
  }

  @override
  Future<double> getTotalEarned(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (!VendorMockConfig.usesDemoPortalData(vendorId)) return 0;
    return VendorMockConfig.stats.revenue;
  }

  @override
  Future<List<PaymentUpdate>> getPaymentUpdates(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _paymentUpdates
        .where((u) => u.orderId == orderId)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<PaymentUpdate> updatePaymentStatus({
    required String vendorId,
    required String orderId,
    required PaymentStatus status,
    required String note,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final order = VendorMockConfig.orderById(vendorId, orderId);
    if (order == null) {
      throw VendorPaymentException('Order not found.');
    }

    final update = PaymentUpdate(
      id: 'pu-${DateTime.now().millisecondsSinceEpoch}',
      orderId: orderId,
      amount: order.totalAmount,
      status: status,
      note: note,
      updatedAt: DateTime.now(),
    );
    _paymentUpdates.insert(0, update);
    return update;
  }

  @override
  Future<VendorPayout> requestPayout(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (simulatePayoutError) {
      throw VendorPaymentException('Payout request failed. Try again.');
    }

    final pending = await getPendingBalance(vendorId);
    if (pending <= 0) {
      throw VendorPaymentException('No pending balance to request.');
    }

    return VendorPayout(
      id: 'pay-${DateTime.now().millisecondsSinceEpoch}',
      amount: pending,
      status: PaymentStatus.pending,
      reference: 'PO-${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
