import 'package:placeify_client/placeify_client.dart' hide VendorPayout;

import '../../../core/config/placeify_server_client.dart';
import '../domain/enums/payment_status.dart';
import '../domain/models/payment_update.dart';
import '../domain/models/vendor_payout.dart';
import '../domain/repositories/vendor_payment_repository.dart';
import 'vendor_payment_mapper.dart';

/// Vendor payouts and order payment status backed by PostgreSQL.
class ServerpodVendorPaymentRepository implements VendorPaymentRepository {
  const ServerpodVendorPaymentRepository();

  @override
  Future<List<VendorPayout>> getPayouts(String vendorId) async {
    final overview = await _loadOverview();
    return overview.payouts.map(VendorPaymentMapper.toPayout).toList();
  }

  @override
  Future<double> getPendingBalance(String vendorId) async {
    final overview = await _loadOverview();
    return overview.pendingBalance;
  }

  @override
  Future<double> getTotalEarned(String vendorId) async {
    final overview = await _loadOverview();
    return overview.totalEarned;
  }

  @override
  Future<List<PaymentUpdate>> getPaymentUpdates(String orderId) async {
    final parsedId = _parseOrderId(orderId);
    if (parsedId == null) return const [];

    try {
      final updates = await client.payment.listPaymentUpdates(parsedId);
      return updates.map(VendorPaymentMapper.toUpdate).toList();
    } catch (error) {
      throw VendorPaymentException(_mapError(error));
    }
  }

  @override
  Future<PaymentUpdate> updatePaymentStatus({
    required String vendorId,
    required String orderId,
    required PaymentStatus status,
    required String note,
  }) async {
    final parsedId = _parseOrderId(orderId);
    if (parsedId == null) {
      throw VendorPaymentException('Invalid order id.');
    }

    try {
      final update = await client.payment.updateOrderPaymentStatus(
        parsedId,
        VendorPaymentMapper.toApiStatus(status),
        note: _resolveNote(status, note),
      );
      return VendorPaymentMapper.toUpdate(update);
    } catch (error) {
      throw VendorPaymentException(_mapError(error));
    }
  }

  @override
  Future<VendorPayout> requestPayout(String vendorId) async {
    try {
      final payout = await client.payment.requestPayout();
      return VendorPaymentMapper.toPayout(payout);
    } catch (error) {
      throw VendorPaymentException(_mapError(error));
    }
  }

  Future<VendorPaymentsOverview> _loadOverview() async {
    try {
      return await client.payment.getOverview();
    } catch (error) {
      throw VendorPaymentException(_mapError(error));
    }
  }

  int? _parseOrderId(String orderId) => int.tryParse(orderId.trim());

  String _resolveNote(PaymentStatus status, String note) {
    final trimmed = note.trim();
    if (trimmed.isNotEmpty) return trimmed;

    return switch (status) {
      PaymentStatus.paid => 'Payment marked as received.',
      PaymentStatus.failed => 'Payment marked as failed.',
      PaymentStatus.refunded => 'Payment marked as refunded.',
      PaymentStatus.pending => 'Payment marked as pending.',
      PaymentStatus.partial => 'Payment marked as partially received.',
    };
  }

  String _mapError(Object error) {
    if (error is VendorPaymentException) return error.message;
    if (error is PlaceifyException) return error.message;

    final raw = error is ServerpodClientException
        ? error.message
        : error.toString();

    if (_looksLikeConnectionError(raw)) {
      return 'Cannot reach the server. Make sure placeify_server is running.';
    }

    final colonIndex = raw.indexOf(': ');
    if (colonIndex > 0 && colonIndex < 40) {
      final message = raw.substring(colonIndex + 2).trim();
      if (message.isNotEmpty && !message.startsWith('Exception')) {
        return message.length <= 200 ? message : 'Could not update payment status.';
      }
    }

    if (raw.contains('ORDER_NOT_FOUND')) {
      return 'Order not found for this vendor.';
    }

    if (raw.contains('PAYMENT_LOCKED')) {
      return 'Payment is already marked as received and cannot be changed.';
    }

    return raw.length <= 200 ? raw : 'Could not update payment status.';
  }

  bool _looksLikeConnectionError(String raw) {
    final lower = raw.toLowerCase();
    return lower.contains('socketexception') ||
        lower.contains('connection refused') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable');
  }
}
