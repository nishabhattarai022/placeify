import 'dart:io';
import 'dart:typed_data';

import 'package:placeify_client/placeify_client.dart' hide DeliveryStage;

import '../../../core/config/placeify_server_client.dart';
import '../domain/enums/delivery_stage.dart';
import '../domain/models/delivery_update.dart';
import '../domain/models/vendor_order.dart';
import 'vendor_order_exceptions.dart';
import 'vendor_order_mapper.dart';

/// Serverpod-backed vendor order actions (accept/reject + delivery timeline).
class ServerpodVendorOrderRepository {
  const ServerpodVendorOrderRepository();

  Future<List<VendorOrder>> getOrders(String vendorId, {int limit = 20}) async {
    try {
      final shopOrders = await client.vendor.listShopOrders(
        limit: limit,
        offset: 0,
      );
      return [
        for (final shopOrder in shopOrders)
          VendorOrderMapper.fromShopOrder(shopOrder, vendorId: vendorId),
      ];
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<VendorOrder?> getOrder(String vendorId, String orderId) async {
    final parsedId = _parseOrderId(orderId);
    if (parsedId == null) return null;

    try {
      final shopOrder = await client.vendor.getShopOrder(parsedId);
      return VendorOrderMapper.fromShopOrder(shopOrder, vendorId: vendorId);
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<VendorOrder> acceptOrder(String vendorId, String orderId) async {
    final parsedId = _requireOrderId(orderId);
    try {
      final shopOrder = await client.vendor.acceptShopOrder(parsedId);
      return VendorOrderMapper.fromShopOrder(shopOrder, vendorId: vendorId);
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<VendorOrder> rejectOrder(
    String vendorId,
    String orderId, {
    required String reason,
  }) async {
    final parsedId = _requireOrderId(orderId);
    try {
      final shopOrder = await client.vendor.rejectShopOrder(parsedId, reason);
      return VendorOrderMapper.fromShopOrder(shopOrder, vendorId: vendorId);
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<List<DeliveryUpdate>> getDeliveryUpdates(String orderId) async {
    final parsedId = _requireOrderId(orderId);
    try {
      final updates = await client.vendor.listDeliveryUpdates(parsedId);
      return [
        for (final update in updates)
          VendorOrderMapper.fromDeliveryUpdate(update),
      ];
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<DeliveryUpdate> submitDeliveryUpdate(
    String vendorId,
    String orderId, {
    required DeliveryStage stage,
    String? note,
    String? photoProofPath,
  }) async {
    final parsedId = _requireOrderId(orderId);
    try {
      final photoUrl = await _uploadProofIfNeeded(photoProofPath);
      final update = await client.vendor.submitDeliveryUpdate(
        parsedId,
        VendorOrderMapper.toApiDeliveryStage(stage),
        note: note,
        photoUrl: photoUrl,
      );
      return VendorOrderMapper.fromDeliveryUpdate(update);
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  int _requireOrderId(String orderId) {
    final parsed = _parseOrderId(orderId);
    if (parsed == null) {
      throw VendorOrderActionException('Order not found.');
    }
    return parsed;
  }

  int? _parseOrderId(String orderId) => int.tryParse(orderId.trim());

  Future<String?> _uploadProofIfNeeded(String? photoProofPath) async {
    if (photoProofPath == null || photoProofPath.trim().isEmpty) {
      return null;
    }

    final file = File(photoProofPath);
    if (!await file.exists()) {
      throw VendorOrderActionException('Delivery photo could not be read.');
    }

    final bytes = await file.readAsBytes();
    return client.vendor.uploadDeliveryProof(
      ByteData.sublistView(bytes),
      _fileName(photoProofPath),
    );
  }

  String _fileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index == -1 ? normalized : normalized.substring(index + 1);
  }

  String _mapError(Object error) {
    if (error is VendorOrderActionException) return error.message;
    if (error is PlaceifyException) return error.message;

    final raw = error.toString();

    if (_looksLikeConnectionError(raw)) {
      return 'Cannot reach the server. Make sure placeify_server is running.';
    }

    return raw;
  }

  bool _looksLikeConnectionError(String raw) {
    final lower = raw.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('connection refused') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable');
  }
}
