import 'dart:convert';
import 'dart:io';

import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_repository.dart';
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
  // #region agent log
  void agentLog(String message, Map<String, Object?> data) {
    try {
      File('/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-1d536e.log')
          .writeAsStringSync(
        '${jsonEncode({
          'sessionId': '1d536e',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'location': 'vendor_order_detail_provider.dart',
          'message': message,
          'data': data,
          'hypothesisId': 'H1',
        })}\n',
        mode: FileMode.append,
      );
    } catch (_) {}
  }
  // #endregion

  final user = await ref.watch(currentUserProvider.future);
  agentLog('load order detail', {
    'orderId': orderId,
    'vendorApproved': user?.vendorStatus == VendorStatus.approved,
    'vendorId': user?.vendorId,
  });

  if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
    agentLog('vendor not approved', {'orderId': orderId});
    return null;
  }

  final repo = ref.watch(vendorRepositoryProvider);
  try {
    final order = await repo.getOrder(user!.vendorId!, orderId);
    if (order == null) {
      agentLog('order not found', {'orderId': orderId});
      return null;
    }

    final deliveryUpdates = await repo.getDeliveryUpdates(orderId);
    agentLog('order detail loaded', {
      'orderId': orderId,
      'status': order.status.name,
      'deliveryStage': order.currentDeliveryStage?.name,
      'updateCount': deliveryUpdates.length,
    });
    return VendorOrderDetail(order: order, deliveryUpdates: deliveryUpdates);
  } on VendorOrderActionException catch (e) {
    agentLog('order detail error', {'orderId': orderId, 'error': e.message});
    rethrow;
  }
}
