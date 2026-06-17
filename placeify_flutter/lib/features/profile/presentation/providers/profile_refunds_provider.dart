import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
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
  });

  final List<ProfileRefund> active;
  final List<ProfileRefund> completed;
  final List<RefundOrderOption> orderOptions;

  static const empty = ProfileRefundsState(
    active: [],
    completed: [],
    orderOptions: [],
  );
}

@riverpod
class ProfileRefunds extends _$ProfileRefunds {
  static final _repository = ServerpodRefundRepository();

  @override
  Future<ProfileRefundsState> build() async {
    if (!client.auth.isAuthenticated) return ProfileRefundsState.empty;

    final refunds = await _repository.listRefunds();
    final orders = await ref.watch(profileOrdersProvider.future);

    final orderOptions = [
      for (final order in orders)
        RefundOrderOption(
          orderId: order.id,
          label:
              '${order.primaryProductName ?? 'Order'} — #${order.orderNumber}',
        ),
    ];

    return ProfileRefundsState(
      active: ProfileRefundMapper.active(refunds),
      completed: ProfileRefundMapper.completed(refunds),
      orderOptions: orderOptions,
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

    if (combinedReason.isEmpty || reason.trim() == 'Select a reason') {
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
