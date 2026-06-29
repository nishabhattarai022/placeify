import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../data/profile_constants.dart';
import '../../data/profile_mock_data.dart';
import '../../data/profile_refund_mapper.dart';
import '../../data/serverpod_refund_repository.dart';
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
  });

  final List<ProfileRefund> active;
  final List<ProfileRefund> completed;
  final List<RefundOrderOption> orderOptions;
  final double pendingTotal;
  final double completedTotal;

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

    final pendingOrderIds = refunds
        .where((refund) => refund.status == RequestStatus.pending)
        .map((refund) => refund.orderId)
        .toSet();

    final orderOptions = [
      for (final order in orders)
        if (!order.isCancelled)
          if (int.tryParse(order.id) case final orderId?
              when !pendingOrderIds.contains(orderId))
            RefundOrderOption(
              orderId: orderId,
              label:
                  '${order.items.isNotEmpty ? order.items.first.productName : 'Order'} — #${order.orderNumber}',
            ),
    ];

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
