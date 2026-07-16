import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/session_service.dart';
import '../marketplace/marketplace_events.dart';
import '../notification/order_notification_service.dart';
import '../order/order_lifecycle_store.dart';
import '../vendor/vendor_repository.dart';
import 'esewa_gateway.dart';
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
    final providerTransactionId = paymentMethod == PaymentMethod.esewa
        ? EsewaGateway.newTransactionUuid(orderId)
        : '$provider-$orderId-${DateTime.now().microsecondsSinceEpoch}';
    final payment = await PaymentTransaction.db.insertRow(
      session,
      PaymentTransaction(
        orderId: orderId,
        userId: userId,
        provider: provider,
        paymentMethod: paymentMethod,
        providerTransactionId: providerTransactionId,
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
      PaymentMethod.cashOnDelivery => 'cod',
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
    final pendingPaymentCount = await OrderVendorPayment.db.count(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) &
          row.status.equals(PaymentTransactionStatus.pending),
    );
    final reserved = payouts
        .where(
          (payout) =>
              payout.status == VendorPayoutStatus.pending ||
              payout.status == VendorPayoutStatus.paid,
        )
        .fold<double>(0, (sum, payout) => sum + payout.amount);
    final rawBalance = totalEarned - reserved;
    final pendingBalance = rawBalance < 0 ? 0.0 : rawBalance;

    final paymentHistory = await _listVendorPaymentHistory(session, vendorId);

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
      pendingPaymentCount: pendingPaymentCount,
      paymentHistory: paymentHistory,
    );
  }

  /// Completed (paid) customer payments for this vendor — COD + eSewa.
  /// One [OrderVendorPayment] row per order; no duplicates.
  Future<List<PaymentUpdateSummary>> _listVendorPaymentHistory(
    Session session,
    UuidValue vendorId,
  ) async {
    final allocations = await OrderVendorPayment.db.find(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) &
          row.status.equals(PaymentTransactionStatus.paid),
      orderBy: (row) => row.updatedAt,
      orderDescending: true,
      include: OrderVendorPayment.include(
        order: Order.include(user: User.include()),
      ),
    );

    if (allocations.isEmpty) return const [];

    final orderIds = {
      for (final row in allocations) row.orderId,
    }.toList();
    final transactions = await PaymentTransaction.db.find(
      session,
      where: (row) => row.orderId.inSet(orderIds.toSet()),
    );
    final methodByOrderId = <int, PaymentMethod>{
      for (final tx in transactions) tx.orderId: tx.paymentMethod,
    };

    return [
      for (final row in allocations)
        if (row.id != null)
          PaymentUpdateSummary(
            id: row.id!,
            orderId: row.orderId,
            amount: row.amount,
            status: row.status,
            note: row.note ?? '',
            updatedAt: row.updatedAt,
            paymentMethod: methodByOrderId[row.orderId],
            customerName: row.order?.user?.name,
          ),
    ];
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
            status: _paymentStatusFromHistory(row.newStatus),
            note: _paymentHistoryNote(row.newStatus, row.note),
            updatedAt: row.changedAt,
          ),
    ];
  }

  static PaymentTransactionStatus _paymentStatusFromHistory(String newStatus) {
    return switch (newStatus) {
      'paymentReceived' || 'paymentConfirmed' =>
        PaymentTransactionStatus.paid,
      _ => PaymentTransactionStatus.fromJson(newStatus),
    };
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

    if (!_isEligibleForPaymentUpdate(order.status)) {
      throw PlaceifyException(
        message:
            'Payment can only be updated for accepted, processing, shipped, or delivered orders.',
        code: 'ORDER_NOT_ELIGIBLE_FOR_PAYMENT_UPDATE',
      );
    }

    final trimmedNote = note.trim();
    final resolvedNote = trimmedNote.isEmpty
        ? _defaultNoteForStatus(status)
        : trimmedNote;

    PaymentUpdateSummary? summary;
    Order? updatedOrderForEvent;
    OrderPaymentStatus? eventPaymentStatus;
    var notifyAllocationOnly = false;

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

      if (status == PaymentTransactionStatus.paid) {
        if (currentPaymentStatus != OrderPaymentStatus.unpaid) {
          throw PlaceifyException(
            message:
                'Payment has already been updated and cannot be changed again.',
            code: 'PAYMENT_LOCKED',
          );
        }

        nextPaymentStatus = OrderPaymentStatus.paymentReceived;
      }

      if (allocation.status != PaymentTransactionStatus.paid &&
          status == PaymentTransactionStatus.paid) {
        allocation = await OrderVendorPayment.db.updateRow(
          session,
          allocation.copyWith(
            status: status,
            note: resolvedNote,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
      } else if (status != PaymentTransactionStatus.paid) {
        if (allocation.status == PaymentTransactionStatus.paid &&
            status != PaymentTransactionStatus.refunded) {
          throw PlaceifyException(
            message:
                'Payment is already marked as received and cannot be changed.',
            code: 'PAYMENT_LOCKED',
          );
        }

        final allocationStatusChanged = allocation.status != status;
        if (allocationStatusChanged) {
          allocation = await OrderVendorPayment.db.updateRow(
            session,
            allocation.copyWith(
              status: status,
              note: resolvedNote,
              updatedAt: DateTime.now(),
            ),
            transaction: transaction,
          );

          if (status == PaymentTransactionStatus.failed ||
              status == PaymentTransactionStatus.refunded) {
            await OrderLifecycleStore.appendHistory(
              session,
              orderId,
              statusType: OrderStatusHistoryType.payment,
              previousStatus: currentPaymentStatus.name,
              newStatus: status.name,
              changedByUserId: user.id,
              note: resolvedNote,
              transaction: transaction,
            );
            notifyAllocationOnly = true;
          }
        }
      }

      await PaymentSync.syncOrderPaymentStatus(
        session,
        orderId,
        transaction: transaction,
      );

      if (nextPaymentStatus != null &&
          nextPaymentStatus != currentPaymentStatus) {
        updatedOrderForEvent = await OrderLifecycleStore.updateOrderWithVersion(
          session,
          order,
          (current) => current.copyWith(paymentStatus: nextPaymentStatus),
          transaction: transaction,
        );
        eventPaymentStatus = nextPaymentStatus;

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
      }

      summary = _allocationSummary(allocation);
    });

    if (updatedOrderForEvent != null && eventPaymentStatus != null) {
      await marketplaceEventDispatcher.dispatch(
        session,
        PaymentStatusChangedEvent(
          order: updatedOrderForEvent!,
          status: eventPaymentStatus!,
          vendorId: vendor.id!,
        ),
      );
    } else if (notifyAllocationOnly) {
      await OrderNotificationService.notifyCustomerPaymentAllocation(
        session,
        order: order,
        allocationStatus: status,
        note: resolvedNote,
      );
    }

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

  /// Sum of paid [OrderVendorPayment] amounts for this vendor (COD + eSewa).
  Future<double> _vendorEarnedAmount(
    Session session,
    UuidValue vendorId,
  ) async {
    final allocations = await OrderVendorPayment.db.find(
      session,
      where: (row) =>
          row.vendorId.equals(vendorId) &
          row.status.equals(PaymentTransactionStatus.paid),
    );

    return allocations.fold<double>(0, (sum, row) => sum + row.amount);
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

  static bool _isEligibleForPaymentUpdate(OrderStatus status) {
    return switch (status) {
      OrderStatus.accepted ||
      OrderStatus.processing ||
      OrderStatus.shipped ||
      OrderStatus.delivered =>
        true,
      OrderStatus.pending ||
      OrderStatus.confirmed ||
      OrderStatus.rejected ||
      OrderStatus.cancelled ||
      OrderStatus.autoCancelled =>
        false,
    };
  }

  static String _defaultNoteForStatus(PaymentTransactionStatus status) {
    return switch (status) {
      PaymentTransactionStatus.paid => 'Payment marked as received.',
      PaymentTransactionStatus.failed => 'Payment marked as failed.',
      PaymentTransactionStatus.refunded => 'Payment marked as refunded.',
      PaymentTransactionStatus.pending => 'Payment marked as pending.',
      PaymentTransactionStatus.cancelled => 'Payment cancelled.',
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
