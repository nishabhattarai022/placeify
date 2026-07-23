import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_payment_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
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
    required this.totalEarned,
    required this.pendingPaymentCount,
    this.paymentHistory = const [],
    this.todayRevenue = 0,
    this.monthlyRevenue = 0,
    this.refundAmount = 0,
    this.refundCount = 0,
    this.successfulPaymentCount = 0,
    this.codPaymentCount = 0,
    this.esewaPaymentCount = 0,
    this.averageOrderValue = 0,
    this.pendingRefundCount = 0,
  });

  final double totalEarned;
  final int pendingPaymentCount;
  final List<PaymentUpdate> paymentHistory;
  final double todayRevenue;
  final double monthlyRevenue;
  final double refundAmount;
  final int refundCount;
  final int successfulPaymentCount;
  final int codPaymentCount;
  final int esewaPaymentCount;
  final double averageOrderValue;
  final int pendingRefundCount;

  double get netEarnings => totalEarned - refundAmount;

  VendorPaymentsData copyWith({
    double? totalEarned,
    int? pendingPaymentCount,
    List<PaymentUpdate>? paymentHistory,
    double? todayRevenue,
    double? monthlyRevenue,
    double? refundAmount,
    int? refundCount,
    int? successfulPaymentCount,
    int? codPaymentCount,
    int? esewaPaymentCount,
    double? averageOrderValue,
    int? pendingRefundCount,
  }) {
    return VendorPaymentsData(
      totalEarned: totalEarned ?? this.totalEarned,
      pendingPaymentCount: pendingPaymentCount ?? this.pendingPaymentCount,
      paymentHistory: paymentHistory ?? this.paymentHistory,
      todayRevenue: todayRevenue ?? this.todayRevenue,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      refundAmount: refundAmount ?? this.refundAmount,
      refundCount: refundCount ?? this.refundCount,
      successfulPaymentCount:
          successfulPaymentCount ?? this.successfulPaymentCount,
      codPaymentCount: codPaymentCount ?? this.codPaymentCount,
      esewaPaymentCount: esewaPaymentCount ?? this.esewaPaymentCount,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
      pendingRefundCount: pendingRefundCount ?? this.pendingRefundCount,
    );
  }
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
      final orderId = notification.referenceId?.toString();
      if (orderId != null) {
        ref.invalidate(orderPaymentAuditTrailProvider(orderId));
        ref.invalidate(vendorOrderDetailProvider(orderId));
      }
      ref.invalidate(vendorOrdersProvider);
      ref.invalidate(vendorStatsProvider);
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
        totalEarned: 0,
        pendingPaymentCount: 0,
      );
    }

    final repo = ref.watch(vendorPaymentRepositoryProvider);
    final overview = await repo.getPaymentsOverview(user!.vendorId!);

    return VendorPaymentsData(
      totalEarned: overview.totalEarned,
      pendingPaymentCount: overview.pendingPaymentCount,
      paymentHistory: overview.paymentHistory,
      todayRevenue: overview.todayRevenue,
      monthlyRevenue: overview.monthlyRevenue,
      refundAmount: overview.refundAmount,
      refundCount: overview.refundCount,
      successfulPaymentCount: overview.successfulPaymentCount,
      codPaymentCount: overview.codPaymentCount,
      esewaPaymentCount: overview.esewaPaymentCount,
      averageOrderValue: overview.averageOrderValue,
      pendingRefundCount: overview.pendingRefundCount,
    );
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

@riverpod
Future<List<PaymentUpdate>> orderPaymentAuditTrail(
  Ref ref,
  String orderId,
) async {
  final repo = ref.watch(vendorPaymentRepositoryProvider);
  return repo.getPaymentUpdates(orderId);
}
