import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../../shared/user_role_audit_log.dart';
import '../admin/admin_repository.dart';
import 'user_order_store.dart';
import 'user_payment_store.dart';
import 'user_profile_image_storage.dart';
import 'user_repository.dart';

class UserService {
  UserService({
    UserProfileStore? repository,
    UserOrderStore? orderStore,
    UserPaymentStore? paymentStore,
  })  : _repository = repository ?? UserProfileStore(),
        _orderStore = orderStore ?? UserOrderStore(),
        _paymentStore = paymentStore ?? UserPaymentStore();

  final UserProfileStore _repository;
  final UserOrderStore _orderStore;
  final UserPaymentStore _paymentStore;

  Future<User?> getCurrentUser(Session session) {
    return SessionService.resolveUserIfAuthenticated(session);
  }

  Future<User> changePassword(
    Session session,
    String currentPassword,
    String newPassword,
  ) async {
    final user = await SessionService.requireUser(session);
    final emailIdp = AuthServices.instance.emailIdp;
    final email = await _resolveAuthEmail(session, user);

    if (newPassword == currentPassword) {
      throw PlaceifyException(
        message: 'New password must be different from your current password.',
        code: 'PASSWORD_UNCHANGED',
      );
    }

    if (!emailIdp.config.passwordValidationFunction(newPassword)) {
      throw PlaceifyException(
        message:
            'Password is too weak. Use at least 8 characters with letters and numbers.',
        code: 'PASSWORD_POLICY_VIOLATION',
      );
    }

    try {
      await emailIdp.utils.authentication.authenticate(
        session,
        email: email,
        password: currentPassword,
        transaction: null,
      );
    } on EmailAuthenticationInvalidCredentialsException {
      throw PlaceifyException(
        message: 'Current password is incorrect.',
        code: 'INVALID_CURRENT_PASSWORD',
      );
    } on EmailAuthenticationTooManyAttemptsException {
      throw PlaceifyException(
        message: 'Too many failed attempts. Wait a moment and try again.',
        code: 'TOO_MANY_ATTEMPTS',
      );
    }

    await emailIdp.admin.setPassword(
      session,
      email: email,
      password: newPassword,
    );

    return User.db.updateRow(
      session,
      user.copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<String> _resolveAuthEmail(Session session, User user) async {
    final fromProfile = user.email?.trim().toLowerCase();
    if (fromProfile != null && fromProfile.isNotEmpty) {
      return fromProfile;
    }

    final account = await EmailAccount.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(user.authUserId),
    );
    if (account == null) {
      throw PlaceifyException(
        message: 'Email account not found.',
        code: 'EMAIL_NOT_FOUND',
      );
    }

    return account.email;
  }

  Future<User> updateProfile(
    Session session,
    String name, {
    String? phone,
    String? address,
  }) async {
    final authUserId =
        UuidValue.fromString(session.authenticated!.userIdentifier);
    return _repository.upsertProfile(
      session,
      authUserId,
      name,
      phone: phone,
      address: address,
    );
  }

  Future<User> uploadProfileImage(
    Session session,
    ByteData fileData,
    String fileName,
  ) async {
    final user = await SessionService.requireUser(session);
    final imageUrl = await UserProfileImageStorage.persist(
      session: session,
      userId: user.id!,
      fileData: fileData,
      fileName: fileName,
    );

    return User.db.updateRow(
      session,
      user.copyWith(
        profileImageUrl: imageUrl,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<User> becomeVendor(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role == UserRole.admin) return user;

    final shop = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(user.id!),
    );
    if (shop == null) {
      throw PlaceifyException(
        message: 'Complete vendor registration before switching to vendor mode.',
        code: 'SHOP_NOT_FOUND',
      );
    }

    if (user.role != UserRole.vendor) {
      throw PlaceifyException(
        message: 'Vendor account is pending admin approval.',
        code: 'VENDOR_NOT_APPROVED',
      );
    }

    if (user.status != UserAccountStatus.approved || !user.isActive) {
      throw PlaceifyException(
        message: 'Vendor account is not approved yet.',
        code: 'VENDOR_NOT_APPROVED',
      );
    }

    return user;
  }

  Future<User> becomeConsumer(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role == UserRole.admin) return user;
    if (user.role == UserRole.consumer) return user;

    final previousRole = user.role;
    final updated = await User.db.updateRow(
      session,
      user.copyWith(role: UserRole.consumer),
    );
    UserRoleAuditLog.roleChanged(
      session,
      userId: user.id!,
      previousRole: previousRole,
      newRole: UserRole.consumer,
      source: 'user.becomeConsumer',
      changedByUserId: user.id,
    );
    return updated;
  }

  Future<UserDashboard> getDashboard(Session session) async {
    final user = await SessionService.requireUser(session);
    return _repository.buildDashboard(session, user);
  }

  /// Promotes the configured demo admin account for local dashboard access.
  Future<User> ensureDemoAdmin(Session session) async {
    const demoAdminEmail = 'admin@placeify.com';
    final user = await SessionService.requireUser(session);
    final email = user.email?.trim().toLowerCase();
    if (email != demoAdminEmail) {
      throw PlaceifyException(
        message: 'Demo admin access is limited to $demoAdminEmail.',
        code: 'DEMO_ADMIN_ONLY',
      );
    }

    final adminStore = AdminStore();
    if (user.role == UserRole.admin) {
      await adminStore.requireAdminProfile(session);
      return user;
    }

    final updated = await User.db.updateRow(
      session,
      user.copyWith(
        role: UserRole.admin,
        status: UserAccountStatus.approved,
        isActive: true,
        updatedAt: DateTime.now(),
      ),
    );
    await adminStore.requireAdminProfile(session);
    return updated;
  }

  Future<List<UserOrderSummary>> listMyOrders(
    Session session, {
    int limit = 20,
    int offset = 0,
    OrderStatus? status,
  }) async {
    final user = await SessionService.requireUser(session);
    return _orderStore.listSummaries(
      session,
      user.id!,
      limit: limit,
      offset: offset,
      status: status,
    );
  }

  Future<UserOrderDetail> getMyOrder(Session session, int orderId) async {
    final user = await SessionService.requireUser(session);
    return _orderStore.getDetail(session, user.id!, orderId);
  }

  Future<UserOrderDetail> cancelMyOrder(
    Session session,
    int orderId,
    String reason,
  ) async {
    final user = await SessionService.requireUser(session);
    return _orderStore.cancelOrder(session, user.id!, orderId, reason);
  }

  Future<UserOrderPaymentSummary> getMyOrderPayment(
    Session session,
    int orderId,
  ) async {
    final user = await SessionService.requireUser(session);
    return _paymentStore.getPaymentSummary(session, user.id!, orderId);
  }

  Future<UserOrderPaymentSummary> completePayment(
    Session session,
    int orderId,
  ) async {
    final user = await SessionService.requireUser(session);
    return _paymentStore.completePayment(session, user.id!, orderId);
  }
}
