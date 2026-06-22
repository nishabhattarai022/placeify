import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../vendor/vendor_repository.dart';
import 'payment_sync.dart';

/// Payment transactions and vendor payout persistence.
class PaymentStore {
  PaymentStore({VendorStore? vendorStore})
      : _vendorStore = vendorStore ?? VendorStore();

  final VendorStore _vendorStore;

  Future<PaymentTransaction> createForOrder(
    Session session, {
    required int orderId,
    required UuidValue userId,
    required double amount,
    required PaymentMethod paymentMethod,
    Transaction? transaction,
  }) async {
    final provider = _providerForMethod(paymentMethod);
    final payment = await PaymentTransaction.db.insertRow(
      session,
      PaymentTransaction(
        orderId: orderId,
        userId: userId,
        provider: provider,
        paymentMethod: paymentMethod,
        providerTransactionId:
            '$provider-$orderId-${DateTime.now().microsecondsSinceEpoch}',
        amount: amount,
        status: PaymentTransactionStatus.pending,
      ),
      transaction: transaction,
    );

    await PaymentSync.ensureAllocationsForOrder(
      session,
      orderId,
      transaction: transaction,
    );

    return payment;
  }

  String _providerForMethod(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cod => 'cod',
      PaymentMethod.mockOnline => 'mock',
      PaymentMethod.esewa => 'esewa',
      PaymentMethod.khalti => 'khalti',
    };
  }

  Future<VendorPaymentsOverview> getOverview(Session session) async {
    final vendor = await _vendorStore.requireOwnedVendor(session);
    final vendorId = vendor.id!;

    final payouts = await VendorPayout.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    final totalEarned = await _vendorEarnedAmount(session, vendorId);
    final reserved = payouts
        .where(
          (payout) =>
              payout.status == VendorPayoutStatus.pending ||
              payout.status == VendorPayoutStatus.paid,
        )
        .fold<double>(0, (sum, payout) => sum + payout.amount);
    final rawBalance = totalEarned - reserved;
    final pendingBalance = rawBalance < 0 ? 0.0 : rawBalance;

    return VendorPaymentsOverview(
      payouts: [
        for (final payout in payouts)
          if (payout.id != null)
            VendorPayoutSummary(
              id: payout.id!,
              amount: payout.amount,
              status: payout.status,
              paidAt: payout.paidAt,
              reference: payout.reference,
              createdAt: payout.createdAt,
            ),
      ],
      pendingBalance: pendingBalance,
      totalEarned: totalEarned,
    );
  }

  Future<List<PaymentUpdateSummary>> listUpdatesForOrder(
    Session session,
    int orderId,
  ) async {
    final vendor = await _vendorStore.requireOwnedVendor(session);
    await _requireVendorOrderAccess(session, vendor.id!, orderId);

    await PaymentSync.ensureAllocationsForOrder(session, orderId);

    final rows = await OrderVendorPayment.db.find(
      session,
      where: (row) =>
          row.orderId.equals(orderId) & row.vendorId.equals(vendor.id!),
      orderBy: (row) => row.updatedAt,
      orderDescending: true,
    );

    return [
      for (final row in rows)
        if (row.id != null) _allocationSummary(row),
    ];
  }

  Future<PaymentUpdateSummary> updateOrderPaymentStatus(
    Session session,
    int orderId,
    PaymentTransactionStatus status, {
    required String note,
  }) async {
    final vendor = await _vendorStore.requireOwnedVendor(session);
    await _requireVendorOrderAccess(session, vendor.id!, orderId);

    final trimmedNote = note.trim();
    if (trimmedNote.isEmpty) {
      throw PlaceifyException(
        message: 'A payment note is required.',
        code: 'INVALID_NOTE',
      );
    }

    await PaymentSync.ensureAllocationsForOrder(session, orderId);

    var allocation = await OrderVendorPayment.db.findFirstRow(
      session,
      where: (row) =>
          row.orderId.equals(orderId) & row.vendorId.equals(vendor.id!),
    );

    if (allocation == null) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }

    allocation = await OrderVendorPayment.db.updateRow(
      session,
      allocation.copyWith(
        status: status,
        note: trimmedNote,
        updatedAt: DateTime.now(),
      ),
    );

    await PaymentSync.syncOrderPaymentStatus(session, orderId);

    return _allocationSummary(allocation);
  }

  Future<VendorPayoutSummary> requestPayout(Session session) async {
    final vendor = await _vendorStore.requireOwnedVendor(session);
    final vendorId = vendor.id!;

    final overview = await getOverview(session);
    if (overview.pendingBalance <= 0) {
      throw PlaceifyException(
        message: 'No pending balance to request.',
        code: 'NO_PENDING_BALANCE',
      );
    }

    final existingPending = await VendorPayout.db.findFirstRow(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) &
          row.status.equals(VendorPayoutStatus.pending),
    );
    if (existingPending != null) {
      throw PlaceifyException(
        message: 'A payout request is already pending.',
        code: 'PAYOUT_EXISTS',
      );
    }

    final reference =
        'PO-${DateTime.now().millisecondsSinceEpoch.toString().padLeft(13, '0')}';
    final payout = await VendorPayout.db.insertRow(
      session,
      VendorPayout(
        vendorId: vendorId,
        amount: overview.pendingBalance,
        status: VendorPayoutStatus.pending,
        payoutMethod: 'bank_transfer',
        reference: reference,
        scheduledAt: DateTime.now().add(const Duration(days: 3)),
      ),
    );

    return VendorPayoutSummary(
      id: payout.id!,
      amount: payout.amount,
      status: payout.status,
      paidAt: payout.paidAt,
      reference: payout.reference,
      createdAt: payout.createdAt,
    );
  }

  Future<double> _vendorEarnedAmount(
    Session session,
    UuidValue vendorId,
  ) async {
    final allocations = await OrderVendorPayment.db.find(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) &
          row.status.equals(PaymentTransactionStatus.succeeded),
      include: OrderVendorPayment.include(order: Order.include()),
    );

    var total = 0.0;
    for (final allocation in allocations) {
      final order = allocation.order;
      if (order?.status != OrderStatus.delivered) continue;
      total += allocation.amount;
    }

    return total;
  }

  PaymentUpdateSummary _allocationSummary(OrderVendorPayment row) {
    return PaymentUpdateSummary(
      id: row.id!,
      orderId: row.orderId,
      amount: row.amount,
      status: row.status,
      note: row.note ?? '',
      updatedAt: row.updatedAt,
    );
  }

  Future<void> _requireVendorOrderAccess(
    Session session,
    UuidValue vendorId,
    int orderId,
  ) async {
    final item = await OrderItem.db.findFirstRow(
      session,
      where: (row) =>
          row.orderId.equals(orderId) & row.vendorId.equals(vendorId),
    );
    if (item == null) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }
  }
}
