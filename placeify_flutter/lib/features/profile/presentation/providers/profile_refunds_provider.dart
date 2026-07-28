import 'package:flutter/foundation.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../orders/domain/enums/consumer_order_status.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../data/profile_constants.dart';
import '../../domain/models/profile_ui_models.dart';
import '../../data/profile_refund_mapper.dart';
import '../../data/serverpod_refund_repository.dart';
import '../../domain/refund_order_eligibility.dart';
import 'profile_dashboard_provider.dart';

part 'profile_refunds_provider.g.dart';

class RefundOrderOption {
  const RefundOrderOption({required this.orderId, required this.label});

  final int orderId;
  final String label;
}

class ProfileRefundsState {
  const ProfileRefundsState({
    required this.active,
    required this.completed,
    required this.orderOptions,
    required this.pendingTotal,
    required this.completedTotal,
    this.eligibilityDebug = const [],
  });

  final List<ProfileRefund> active;
  final List<ProfileRefund> completed;
  final List<RefundOrderOption> orderOptions;
  final double pendingTotal;
  final double completedTotal;

  /// Per-order exclusion reasons for empty-state / diagnostics.
  final List<String> eligibilityDebug;

  static const empty = ProfileRefundsState(
    active: [],
    completed: [],
    orderOptions: [],
    pendingTotal: 0,
    completedTotal: 0,
  );
}

@riverpod
class ProfileRefunds extends _$ProfileRefunds {
  static final _repository = ServerpodRefundRepository();

  @override
  Future<ProfileRefundsState> build() async {
    if (!client.auth.isAuthenticated) return ProfileRefundsState.empty;

    final refunds = await _repository.listRefunds();
    final orders = await ref.watch(ordersProvider.future);

    final blockedOrderIds = refunds
        .where(
          (refund) =>
              refund.status == RequestStatus.pending ||
              refund.status == RequestStatus.inProgress,
        )
        .map((refund) => refund.orderId)
        .toSet();

    final now = DateTime.now().toUtc();
    final deliveredCount = orders
        .where((order) => order.status == ConsumerOrderStatus.delivered)
        .length;
    final eligibilityDebug = <String>[];
    final orderOptions = <RefundOrderOption>[];

    for (final order in orders) {
      final reason = RefundOrderEligibility.exclusionReason(
        order,
        blockedOrderIds: blockedOrderIds,
        now: now,
      );
      if (reason != null) {
        eligibilityDebug.add('ORD-${order.id}: $reason');
        continue;
      }
      final orderId = int.parse(order.id);
      orderOptions.add(
        RefundOrderOption(
          orderId: orderId,
          label:
              '${order.items.isNotEmpty ? order.items.first.productName : 'Order'} — ${order.orderNumber}',
        ),
      );
    }

    debugPrint(
      '[refund-eligibility] total=${orders.length} '
      'delivered=$deliveredCount '
      'blockedOpenRefund=${blockedOrderIds.length} '
      'eligible=${orderOptions.length} '
      'excluded=${eligibilityDebug.length}',
    );
    for (final line in eligibilityDebug) {
      debugPrint('[refund-eligibility] $line');
    }

    final active = ProfileRefundMapper.active(refunds);
    final completed = ProfileRefundMapper.completed(refunds);
    final pendingTotal = refunds
        .where(
          (refund) =>
              refund.status == RequestStatus.pending ||
              refund.status == RequestStatus.inProgress,
        )
        .fold<double>(0, (sum, refund) => sum + refund.refundAmount);
    final completedTotal = refunds
        .where((refund) => refund.status == RequestStatus.completed)
        .fold<double>(0, (sum, refund) => sum + refund.refundAmount);

    return ProfileRefundsState(
      active: active,
      completed: completed,
      orderOptions: orderOptions,
      pendingTotal: pendingTotal,
      completedTotal: completedTotal,
      eligibilityDebug: eligibilityDebug,
    );
  }

  Future<String?> submitRefund({
    required int orderId,
    required String reason,
    String? details,
  }) async {
    final combinedReason = [
      reason.trim(),
      if (details != null && details.trim().isNotEmpty) details.trim(),
    ].join(' — ');

    if (combinedReason.isEmpty ||
        reason.trim() == ProfileRefundReasons.selectPlaceholder) {
      return 'Select a reason for your refund request.';
    }

    try {
      await _repository.createRefund(orderId: orderId, reason: combinedReason);
      ref.invalidateSelf();
      ref.invalidate(ordersProvider);
      ref.invalidate(profileDashboardProvider);
      return null;
    } on RefundRepositoryException catch (error) {
      return error.message;
    } catch (_) {
      return 'Could not submit refund request.';
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
