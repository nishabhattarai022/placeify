import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_refund_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_pending_refund.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_order_detail_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_orders_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_payments_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_stats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_refunds_provider.g.dart';

@riverpod
ServerpodVendorRefundRepository vendorRefundRepository(Ref ref) {
  return const ServerpodVendorRefundRepository();
}

@riverpod
class VendorPendingRefunds extends _$VendorPendingRefunds {
  @override
  Future<List<VendorPendingRefund>> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<List<VendorPendingRefund>> _load() {
    return ref.read(vendorRefundRepositoryProvider).listPending();
  }

  Future<String?> approve(int refundId, {required String orderId}) async {
    try {
      await ref.read(vendorRefundRepositoryProvider).approve(refundId);
      ref.invalidate(vendorOrderDetailProvider(orderId));
      ref.invalidate(orderPaymentAuditTrailProvider(orderId));
      ref.invalidate(vendorOrdersProvider);
      ref.invalidate(vendorPaymentsProvider);
      ref.invalidate(vendorStatsProvider);
      return null;
    } catch (error) {
      return _mapError(error);
    }
  }

  Future<String?> reject(
    int refundId, {
    required String orderId,
    String? reason,
  }) async {
    try {
      await ref.read(vendorRefundRepositoryProvider).reject(
            refundId,
            reason: reason,
          );
      ref.invalidate(vendorOrderDetailProvider(orderId));
      ref.invalidate(orderPaymentAuditTrailProvider(orderId));
      ref.invalidate(vendorOrdersProvider);
      ref.invalidate(vendorPaymentsProvider);
      ref.invalidate(vendorStatsProvider);
      return null;
    } catch (error) {
      return _mapError(error);
    }
  }

  String _mapError(Object error) {
    if (error is PlaceifyException) return error.message;
    return 'Could not update refund request. Try again.';
  }
}
