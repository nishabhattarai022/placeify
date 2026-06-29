import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Order, VendorPayout;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_payment_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_payout.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_payment_repository.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_order_detail_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_orders_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_stats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_payments_provider.g.dart';

@Riverpod(keepAlive: true)
VendorPaymentRepository vendorPaymentRepository(Ref ref) {
  return const ServerpodVendorPaymentRepository();
}

class VendorPaymentsData {
  const VendorPaymentsData({
    required this.payouts,
    required this.pendingBalance,
    required this.totalEarned,
    this.isRequestingPayout = false,
  });

  final List<VendorPayout> payouts;
  final double pendingBalance;
  final double totalEarned;
  final bool isRequestingPayout;

  bool get canRequestPayout => pendingBalance > 0 && !isRequestingPayout;
}

@riverpod
class VendorPayments extends _$VendorPayments {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<VendorPaymentsData> build() async {
    ref.onDispose(() => _subscription?.cancel());
    unawaited(_attachRealtimeListener());
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((notification) {
      if (notification.type != InAppNotificationType.paymentUpdate &&
          notification.type != InAppNotificationType.refundUpdate) {
        return;
      }
      unawaited(refresh(silent: true));
    });
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
  }

  Future<VendorPaymentsData> _load() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return const VendorPaymentsData(
        payouts: [],
        pendingBalance: 0,
        totalEarned: 0,
      );
    }

    final repo = ref.watch(vendorPaymentRepositoryProvider);
    final vendorId = user!.vendorId!;

    final results = await Future.wait([
      repo.getPayouts(vendorId),
      repo.getPendingBalance(vendorId),
      repo.getTotalEarned(vendorId),
    ]);

    return VendorPaymentsData(
      payouts: results[0] as List<VendorPayout>,
      pendingBalance: results[1] as double,
      totalEarned: results[2] as double,
    );
  }

  Future<String?> requestPayout() async {
    final user = await ref.read(currentUserProvider.future);
    final vendorId = user?.vendorId;
    if (vendorId == null) return 'Vendor account not found.';

    final current = state.value;
    if (current == null || !current.canRequestPayout) {
      return 'No pending balance to request.';
    }

    state = AsyncData(current.copyWith(isRequestingPayout: true));

    try {
      final repo = ref.read(vendorPaymentRepositoryProvider);
      await repo.requestPayout(vendorId);
      ref.invalidateSelf();
      return null;
    } on VendorPaymentException catch (e) {
      state = AsyncData(current);
      return e.message;
    } catch (_) {
      state = AsyncData(current);
      return 'Payout request failed.';
    }
  }

  Future<String?> updateOrderPayment({
    required String orderId,
    required PaymentStatus status,
    required String note,
  }) async {
    final user = await ref.read(currentUserProvider.future);
    final vendorId = user?.vendorId;
    if (vendorId == null) return 'Vendor account not found.';

    try {
      final repo = ref.read(vendorPaymentRepositoryProvider);
      await repo.updatePaymentStatus(
        vendorId: vendorId,
        orderId: orderId,
        status: status,
        note: note,
      );
      ref.invalidateSelf();
      ref.invalidate(orderPaymentAuditTrailProvider(orderId));
      ref.invalidate(vendorOrderDetailProvider(orderId));
      ref.invalidate(vendorOrdersProvider);
      ref.invalidate(vendorStatsProvider);
      return null;
    } on VendorPaymentException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not update payment status.';
    }
  }
}

extension on VendorPaymentsData {
  VendorPaymentsData copyWith({
    List<VendorPayout>? payouts,
    double? pendingBalance,
    double? totalEarned,
    bool? isRequestingPayout,
  }) {
    return VendorPaymentsData(
      payouts: payouts ?? this.payouts,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      totalEarned: totalEarned ?? this.totalEarned,
      isRequestingPayout: isRequestingPayout ?? this.isRequestingPayout,
    );
  }
}

@riverpod
Future<List<PaymentUpdate>> orderPaymentAuditTrail(
  Ref ref,
  String orderId,
) async {
  final repo = ref.watch(vendorPaymentRepositoryProvider);
  return repo.getPaymentUpdates(orderId);
}
