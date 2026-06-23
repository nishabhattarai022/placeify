import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../marketplace/marketplace_events.dart';
import '../order/order_lifecycle_store.dart';
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
    PaymentMethod paymentMethod = PaymentMethod.mockOnline,
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

    final order = await Order.db.findById(session, orderId);
    await PaymentSync.ensureAllocationsForOrder(session, orderId);

    final allocation = await OrderVendorPayment.db.findFirstRow(
      session,
      where: (row) =>
          row.orderId.equals(orderId) & row.vendorId.equals(vendor.id!),
    );
    final amount = allocation?.amount ?? order?.totalAmount ?? 0;

    final history = await OrderStatusHistory.db.find(
      session,
      where: (row) =>
          row.orderId.equals(orderId) &
          row.statusType.equals(OrderStatusHistoryType.payment),
      orderBy: (row) => row.changedAt,
    );

    return [
      for (final row in history)
        if (row.id != null)
          PaymentUpdateSummary(
            id: row.id!,
            orderId: orderId,
            amount: amount,
            status: PaymentTransactionStatus.succeeded,
            note: _paymentHistoryNote(row.newStatus, row.note),
            updatedAt: row.changedAt,
          ),
    ];
  }

  Future<PaymentUpdateSummary> updateOrderPaymentStatus(
    Session session,
    int orderId,
    PaymentTransactionStatus status, {
    required String note,
  }) async {
    final vendor = await _vendorStore.requireOwnedVendor(session);
    final user = await SessionService.requireUser(session);
    await _requireVendorOrderAccess(session, vendor.id!, orderId);

    final order = await Order.db.findById(session, orderId);
    if (order == null) {
      throw PlaceifyException(message: 'Order not found.', code: 'ORDER_NOT_FOUND');
    }

    final trimmedNote = note.trim();
    final resolvedNote = trimmedNote.isEmpty
        ? _defaultNoteForStatus(status)
        : trimmedNote;

    PaymentUpdateSummary? summary;

    await session.db.transaction((transaction) async {
      await PaymentSync.ensureAllocationsForOrder(
        session,
        orderId,
        transaction: transaction,
      );

      var allocation = await OrderVendorPayment.db.findFirstRow(
        session,
        where: (row) =>
            row.orderId.equals(orderId) & row.vendorId.equals(vendor.id!),
        transaction: transaction,
      );

      if (allocation == null) {
        throw PlaceifyException(
          message: 'Order not found.',
          code: 'ORDER_NOT_FOUND',
        );
      }

      final currentPaymentStatus = order.paymentStatus;
      OrderPaymentStatus? nextPaymentStatus;

      if (status == PaymentTransactionStatus.succeeded) {
        if (currentPaymentStatus == OrderPaymentStatus.paymentConfirmed) {
          throw PlaceifyException(
            message: 'Payment is already confirmed.',
            code: 'PAYMENT_LOCKED',
          );
        }

        if (currentPaymentStatus == OrderPaymentStatus.paymentReceived &&
            allocation.status == PaymentTransactionStatus.succeeded) {
          nextPaymentStatus = OrderPaymentStatus.paymentConfirmed;
        } else if (currentPaymentStatus == OrderPaymentStatus.unpaid) {
          nextPaymentStatus = OrderPaymentStatus.paymentReceived;
        } else if (!OrderLifecycleStore.canAdvancePaymentStatus(
          currentPaymentStatus,
          OrderPaymentStatus.paymentConfirmed,
        )) {
          throw PlaceifyException(
            message: 'Payment status cannot move backward.',
            code: 'INVALID_PAYMENT_STATUS',
          );
        }
      }

      if (allocation.status != PaymentTransactionStatus.succeeded &&
          status == PaymentTransactionStatus.succeeded) {
        allocation = await OrderVendorPayment.db.updateRow(
          session,
          allocation.copyWith(
            status: status,
            note: resolvedNote,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      } else if (status != PaymentTransactionStatus.succeeded) {
        if (allocation.status == PaymentTransactionStatus.succeeded) {
          throw PlaceifyException(
            message:
                'Payment is already marked as received and cannot be changed.',
            code: 'PAYMENT_LOCKED',
          );
        }

        allocation = await OrderVendorPayment.db.updateRow(
          session,
          allocation.copyWith(
            status: status,
            note: resolvedNote,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      }

      await PaymentSync.syncOrderPaymentStatus(
        session,
        orderId,
        transaction: transaction,
      );

      if (nextPaymentStatus != null &&
          nextPaymentStatus != currentPaymentStatus) {
        final updatedOrder = await OrderLifecycleStore.updateOrderWithVersion(
          session,
          order,
          (current) => current.copyWith(paymentStatus: nextPaymentStatus),
          transaction: transaction,
        );

        await OrderLifecycleStore.appendHistory(
          session,
          orderId,
          statusType: OrderStatusHistoryType.payment,
          previousStatus: currentPaymentStatus.name,
          newStatus: nextPaymentStatus.name,
          changedByUserId: user.id,
          note: resolvedNote,
          transaction: transaction,
        );

        await marketplaceEventDispatcher.dispatch(
          session,
          PaymentStatusChangedEvent(
            order: updatedOrder,
            status: nextPaymentStatus,
            vendorId: vendor.id!,
          ),
        );
      }

      summary = _allocationSummary(allocation);
    });

    return summary!;
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

  static String _defaultNoteForStatus(PaymentTransactionStatus status) {
    return switch (status) {
      PaymentTransactionStatus.succeeded => 'Payment marked as received.',
      PaymentTransactionStatus.failed => 'Payment marked as failed.',
      PaymentTransactionStatus.refunded => 'Payment marked as refunded.',
      PaymentTransactionStatus.pending => 'Payment marked as pending.',
    };
  }

  static String _paymentHistoryNote(String newStatus, String? note) {
    final trimmed = note?.trim();
    if (trimmed != null && trimmed.isNotEmpty) return trimmed;

    return switch (newStatus) {
      'paymentReceived' => 'Payment received by vendor',
      'paymentConfirmed' => 'Payment confirmed',
      _ => newStatus,
    };
  }
}
