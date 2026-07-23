import 'dart:typed_data';

import 'package:serverpod/serverpod.dart' hide Order;

import '../generated/protocol.dart';
import '../modules/user/user_service.dart';
import 'placeify_endpoint.dart';

/// Profile and dashboard APIs for authenticated customers.
class UserEndpoint extends PlaceifyAuthenticatedEndpoint {
  final _service = UserService();

  Future<User?> getCurrentUser(Session session) {
    return _service.getCurrentUser(session);
  }

  Future<User> updateProfile(
    Session session,
    String name, {
    String? phone,
    String? address,
  }) {
    return _service.updateProfile(
      session,
      name,
      phone: phone,
      address: address,
    );
  }

  Future<User> changePassword(
    Session session,
    String currentPassword,
    String newPassword,
  ) {
    return _service.changePassword(session, currentPassword, newPassword);
  }

  Future<User> uploadProfileImage(
    Session session,
    ByteData fileData,
    String fileName,
  ) {
    return _service.uploadProfileImage(session, fileData, fileName);
  }

  Future<User> becomeVendor(Session session) {
    return _service.becomeVendor(session);
  }

  Future<User> becomeConsumer(Session session) {
    return _service.becomeConsumer(session);
  }

  Future<UserDashboard> getDashboard(Session session) {
    return _service.getDashboard(session);
  }

  Future<User> ensureDemoAdmin(Session session) {
    return _service.ensureDemoAdmin(session);
  }

  Future<List<UserOrderSummary>> listMyOrders(
    Session session, {
    int limit = 20,
    int offset = 0,
    OrderStatus? status,
  }) {
    return _service.listMyOrders(
      session,
      limit: limit,
      offset: offset,
      status: status,
    );
  }

  Future<UserOrderDetail> getMyOrder(Session session, int orderId) {
    return _service.getMyOrder(session, orderId);
  }

  Future<UserOrderDetail> cancelMyOrder(
    Session session,
    int orderId,
    String reason,
  ) {
    return _service.cancelMyOrder(session, orderId, reason);
  }

  Future<UserOrderPaymentSummary> getMyOrderPayment(
    Session session,
    int orderId,
  ) {
    return _service.getMyOrderPayment(session, orderId);
  }

  Future<List<UserOrderPaymentSummary>> listMyPayments(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) {
    return _service.listMyPayments(session, limit: limit, offset: offset);
  }

  /// Signed eSewa form fields (JSON) for an unpaid eSewa order.
  Future<String> getEsewaPaymentForm(Session session, int orderId) {
    return _service.getEsewaPaymentForm(session, orderId);
  }

  Future<UserOrderPaymentSummary> completePayment(
    Session session,
    int orderId,
  ) {
    return _service.completePayment(session, orderId);
  }

  Future<List<UserArSessionSummary>> listMyArSessions(
    Session session, {
    int limit = 20,
    int offset = 0,
  }) async {
    final user = await requirePlaceifyUser(session);

    final sessions = await ARSession.db.find(
      session,
      where: (row) => row.userId.equals(user.id!),
      include: ARSession.include(product: Product.include()),
      orderBy: (row) => row.startedAt,
      orderDescending: true,
      limit: limit,
      offset: offset,
    );

    return [
      for (final row in sessions)
        if (row.id != null)
          UserArSessionSummary(
            id: row.id!,
            productId: row.productId,
            productName: row.product?.name ?? 'Product',
            startedAt: row.startedAt,
            deviceInfo: row.deviceInfo,
            snapshotUrl: row.snapshotUrl,
          ),
    ];
  }
}
