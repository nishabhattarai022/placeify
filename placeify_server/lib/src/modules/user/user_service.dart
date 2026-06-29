import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
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
      throw PlaceifyException(message: 'Complete vendor registration before switching to vendor mode.',
        code: 'SHOP_NOT_FOUND',
      );
    }

    return User.db.updateRow(
      session,
      user.copyWith(role: UserRole.vendor),
    );
  }

  Future<User> becomeConsumer(Session session) async {
    final user = await SessionService.requireUser(session);
    if (user.role == UserRole.admin) return user;
    if (user.role == UserRole.consumer) return user;

    return User.db.updateRow(
      session,
      user.copyWith(role: UserRole.consumer),
    );
  }

  Future<UserDashboard> getDashboard(Session session) async {
    final user = await SessionService.requireUser(session);
    return _repository.buildDashboard(session, user);
  }

  /// Development-only: creates or resets the demo admin auth account and profile.
  Future<void> provisionDemoAdmin(Session session) async {
    _requireDevelopmentMode(session);

    const email = 'admin@placeify.com';
    const password = 'demo1234';
    const fullName = 'Demo Admin';
    const devCode = '123456';

    final emailIdp = AuthServices.instance.emailIdp;
    await emailIdp.admin.deleteExpiredAccountRequests(session);

    var account = await emailIdp.admin.findAccount(session, email: email);
    if (account == null) {
      await _registerDemoAdminAccount(
        session,
        email: email,
        password: password,
        devCode: devCode,
      );
      account = await emailIdp.admin.findAccount(session, email: email);
    }

    if (account == null) {
      throw PlaceifyException(
        message: 'Could not provision demo admin account.',
        code: 'DEMO_ADMIN_PROVISION_FAILED',
      );
    }

    await emailIdp.admin.setPassword(
      session,
      email: email,
      password: password,
    );
    await emailIdp.admin.deleteFailedLoginAttempts(session);

    await _upsertDemoAdminProfile(
      session,
      authUserId: account.authUserId,
      email: email,
      fullName: fullName,
    );
  }

  Future<void> _registerDemoAdminAccount(
    Session session, {
    required String email,
    required String password,
    required String devCode,
  }) async {
    final emailIdp = AuthServices.instance.emailIdp;

    for (var attempt = 0; attempt < 2; attempt++) {
      await emailIdp.admin.deleteExpiredAccountRequests(session);

      final requestId = await emailIdp.startRegistration(
        session,
        email: email,
      );

      try {
        final token = await emailIdp.verifyRegistrationCode(
          session,
          accountRequestId: requestId,
          verificationCode: devCode,
        );
        await emailIdp.finishRegistration(
          session,
          registrationToken: token,
          password: password,
        );
        return;
      } on EmailAccountRequestException {
        final account = await emailIdp.admin.findAccount(session, email: email);
        if (account != null) return;
        if (attempt == 1) rethrow;
      }
    }
  }

  Future<void> _upsertDemoAdminProfile(
    Session session, {
    required UuidValue authUserId,
    required String email,
    required String fullName,
  }) async {
    final existing = await User.db.findFirstRow(
      session,
      where: (row) => row.authUserId.equals(authUserId),
    );

    if (existing == null) {
      await User.db.insertRow(
        session,
        User(
          authUserId: authUserId,
          name: fullName,
          email: email,
          role: UserRole.admin,
          status: UserAccountStatus.approved,
          isActive: true,
        ),
      );
      return;
    }

    await User.db.updateRow(
      session,
      existing.copyWith(
        name: fullName,
        email: email,
        role: UserRole.admin,
        status: UserAccountStatus.approved,
        isActive: true,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void _requireDevelopmentMode(Session session) {
    final mode = session.serverpod.runMode;
    if (mode != ServerpodRunMode.development && mode != ServerpodRunMode.test) {
      throw PlaceifyException(
        message: 'Demo admin provisioning is only available in development.',
        code: 'DEMO_ADMIN_FORBIDDEN',
      );
    }
  }

  /// Promotes the configured demo admin account for local dashboard access.
  Future<User> ensureDemoAdmin(Session session) async {
    _requireDevelopmentMode(session);

    const demoAdminEmail = 'admin@placeify.com';
    final user = await SessionService.requireUser(session);
    final email = await _resolveAuthEmail(session, user);
    if (email != demoAdminEmail) {
      throw PlaceifyException(
        message: 'Demo admin access is limited to $demoAdminEmail.',
        code: 'DEMO_ADMIN_ONLY',
      );
    }

    if (user.role == UserRole.admin &&
        user.email?.trim().toLowerCase() == demoAdminEmail) {
      return user;
    }

    return User.db.updateRow(
      session,
      user.copyWith(
        email: demoAdminEmail,
        role: UserRole.admin,
        status: UserAccountStatus.approved,
        isActive: true,
        updatedAt: DateTime.now(),
      ),
    );
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
