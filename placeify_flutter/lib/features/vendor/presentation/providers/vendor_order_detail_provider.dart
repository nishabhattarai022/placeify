import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/delivery_update.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_order_detail_provider.g.dart';

class VendorOrderDetail {
  const VendorOrderDetail({
    required this.order,
    required this.deliveryUpdates,
  });

  final VendorOrder order;
  final List<DeliveryUpdate> deliveryUpdates;
}

@riverpod
Future<VendorOrderDetail?> vendorOrderDetail(Ref ref, String orderId) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
    return null;
  }

  final repo = ref.watch(vendorRepositoryProvider);
  final order = await repo.getOrder(user!.vendorId!, orderId);
  if (order == null) return null;

  final deliveryUpdates = await repo.getDeliveryUpdates(orderId);
  return VendorOrderDetail(order: order, deliveryUpdates: deliveryUpdates);
}
