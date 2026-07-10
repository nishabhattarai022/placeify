import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../../core/config/placeify_server_client.dart';
import '../../data/serverpod_refund_repository.dart';

part 'profile_refunds_provider.g.dart';

class ProfileRefundsState {
  const ProfileRefundsState({
    required this.active,
    required this.completed,
    required this.pendingTotal,
  });

  final List<RefundRequestSummary> active;
  final List<RefundRequestSummary> completed;
  final double pendingTotal;
}

@Riverpod(keepAlive: true)
ServerpodRefundRepository refundRepository(Ref ref) {
  return const ServerpodRefundRepository();
}

@Riverpod(keepAlive: true)
class ProfileRefunds extends _$ProfileRefunds {
  @override
  Future<ProfileRefundsState> build() async {
    if (!client.auth.isAuthenticated) {
      return const ProfileRefundsState(
        active: [],
        completed: [],
        pendingTotal: 0,
      );
    }
    final repo = ref.watch(refundRepositoryProvider);
    final refunds = await repo.listRefunds();

    final active = refunds
        .where((r) =>
            r.status == RequestStatus.pending ||
            r.status == RequestStatus.inProgress)
        .toList();
    final completed = refunds
        .where((r) =>
            r.status == RequestStatus.completed ||
            r.status == RequestStatus.rejected)
        .toList();
    final pendingTotal =
        active.fold<double>(0, (sum, r) => sum + r.refundAmount);

    return ProfileRefundsState(
      active: active,
      completed: completed,
      pendingTotal: pendingTotal,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (!client.auth.isAuthenticated) {
        return const ProfileRefundsState(
          active: [],
          completed: [],
          pendingTotal: 0,
        );
      }
      final repo = ref.read(refundRepositoryProvider);
      final refunds = await repo.listRefunds();
      final active = refunds
          .where((r) =>
              r.status == RequestStatus.pending ||
              r.status == RequestStatus.inProgress)
          .toList();
      final completed = refunds
          .where((r) =>
              r.status == RequestStatus.completed ||
              r.status == RequestStatus.rejected)
          .toList();
      final pendingTotal =
          active.fold<double>(0, (sum, r) => sum + r.refundAmount);
      return ProfileRefundsState(
        active: active,
        completed: completed,
        pendingTotal: pendingTotal,
      );
    });
  }
}
