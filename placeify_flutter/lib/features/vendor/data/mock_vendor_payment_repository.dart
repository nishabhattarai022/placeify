import 'package:placeify_flutter/features/vendor/data/config/vendor_mock_config.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
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
      paymentMethodLabel: 'eSewa',
      customerName: 'Demo Customer',
    ),
    PaymentUpdate(
      id: 'pu2',
      orderId: 'vo2',
      amount: 9800,
      status: PaymentStatus.pending,
      note: 'Awaiting vendor confirmation.',
      updatedAt: DateTime(2026, 6, 5, 11, 0),
      paymentMethodLabel: 'COD',
    ),
  ];

  @override
  Future<VendorPaymentsOverviewData> getPaymentsOverview(String vendorId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final paid = _paymentUpdates.where((u) => u.status == PaymentStatus.paid);
    final pending = _paymentUpdates
        .where((u) => u.status == PaymentStatus.pending)
        .length;
    final earned = paid.fold<double>(0, (sum, u) => sum + u.amount);
    final history = paid.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return VendorPaymentsOverviewData(
      totalEarned: earned,
      pendingPaymentCount: pending,
      paymentHistory: history,
    );
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
      paymentMethodLabel: 'COD',
      customerName: order.customerName,
    );
    _paymentUpdates.insert(0, update);
    return update;
  }
}
