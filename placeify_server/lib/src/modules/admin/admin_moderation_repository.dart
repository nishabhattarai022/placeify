import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/agent_debug_log.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../../shared/user_role_audit_log.dart';
import '../notification/in_app_notification_store.dart';
import 'admin_repository.dart';
import 'admin_vendor_lifecycle.dart';

/// Admin moderation: vendor approval, user status, product removal, complaints.
class AdminModerationStore {
  AdminModerationStore({
    AdminStore? adminStore,
    InAppNotificationStore? notifications,
  })  : _adminStore = adminStore ?? AdminStore(),
        _notifications = notifications ?? InAppNotificationStore();

  final AdminStore _adminStore;
  final InAppNotificationStore _notifications;

  static const reinstateTermsText =
      'By reinstating this vendor, you confirm they have addressed the '
      'suspension reason and agree to comply with all Placeify vendor policies, '
      'including product quality standards, order fulfillment, and customer service.';

  Future<Admin> _requireAdminProfile(Session session) {
    return _adminStore.requireAdminProfile(session);
  }

  Future<Vendor> approveVendor(Session session, UuidValue vendorUserId) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, vendorUserId);
    if (user == null) {
      throw PlaceifyException(
        message: 'Vendor account not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(vendorUserId),
    );
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    if (user.status == UserAccountStatus.approved && user.role == UserRole.vendor) {
      return vendor;
    }

    if (user.role == UserRole.vendor || vendor.approvedAt != null) {
      final now = DateTime.now();
      await User.db.updateRow(
        session,
        user.copyWith(
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
          isActive: true,
          approvedById: admin.id,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
      );
      return Vendor.db.updateRow(
        session,
        vendor.copyWith(
          approvedById: vendor.approvedById ?? admin.id,
          approvedAt: vendor.approvedAt ?? now,
          updatedAt: now,
        ),
      );
    }

    if (user.status != UserAccountStatus.pending) {
      throw PlaceifyException(
        message: 'Only pending vendor applications can be approved.',
        code: 'INVALID_VENDOR_STATUS',
      );
    }

    final now = DateTime.now();
    final previousRole = user.role;
    await User.db.updateRow(
      session,
      user.copyWith(
        role: UserRole.vendor,
        status: UserAccountStatus.approved,
        isActive: true,
        approvedById: admin.id,
        statusChangedById: admin.id,
        updatedAt: now,
      ),
    );

    UserRoleAuditLog.roleChanged(
      session,
      userId: user.id!,
      previousRole: previousRole,
      newRole: UserRole.vendor,
      source: 'admin.approveVendor',
      changedByAdminId: admin.id,
    );

    return Vendor.db.updateRow(
      session,
      vendor.copyWith(
        approvedById: admin.id,
        approvedAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<VendorModerationResult> suspendVendor(
    Session session,
    UuidValue vendorUserId,
    String reason,
  ) async {
    try {
      final admin = await _requireAdminProfile(session);
      final trimmedReason = reason.trim();
      if (trimmedReason.isEmpty) {
        throw PlaceifyException(
          message: 'Suspension reason is required.',
          code: 'INVALID_REASON',
        );
      }

      final user = await User.db.findById(session, vendorUserId);
      if (user == null) {
        throw PlaceifyException(
          message: 'Vendor account not found.',
          code: 'VENDOR_NOT_FOUND',
        );
      }

      final vendor = await Vendor.db.findFirstRow(
        session,
        where: (row) => row.userId.equals(vendorUserId),
      );
      if (vendor == null) {
        throw PlaceifyException(
          message: 'Vendor profile not found.',
          code: 'VENDOR_NOT_FOUND',
        );
      }

      // #region agent log
      AgentDebugLog.log(
        'admin_moderation_repository.dart:suspendVendor:entry',
        'suspendVendor called',
        {
          'vendorUserId': vendorUserId.toString(),
          'userRole': user.role.name,
          'userStatus': user.status.name,
          'vendorApprovedAt': vendor.approvedAt?.toIso8601String(),
          'reasonLength': trimmedReason.length,
        },
        hypothesisId: 'A',
      );
      // #endregion

      if (user.status == UserAccountStatus.suspended) {
        return VendorModerationResult(
          vendorUserId: vendorUserId,
          vendorId: vendor.id!,
          status: user.status,
          message: 'Vendor is already suspended.',
          moderationNote: vendor.moderationNote ?? trimmedReason,
          moderatedAt: vendor.moderatedAt,
        );
      }

      AdminVendorLifecycle.ensureCanSuspend(user, vendor);

      // #region agent log
      AgentDebugLog.log(
        'admin_moderation_repository.dart:suspendVendor:precheck',
        'ensureCanSuspend passed',
        {
          'vendorUserId': vendorUserId.toString(),
          'isApprovedActive':
              AdminVendorLifecycle.isApprovedActiveVendor(user, vendor),
        },
        hypothesisId: 'A',
      );
      // #endregion

      final now = DateTime.now();
      var userToSuspend = user;
      if (user.status != UserAccountStatus.approved ||
          user.role != UserRole.vendor) {
        userToSuspend = user.copyWith(
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
          isActive: true,
        );
      }

      final updatedUser = await User.db.updateRow(
        session,
        userToSuspend.copyWith(
          status: UserAccountStatus.suspended,
          isActive: false,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
      );

      final updatedVendor = await Vendor.db.updateRow(
        session,
        vendor.copyWith(
          approvedAt: vendor.approvedAt ?? now,
          approvedById: vendor.approvedById ?? admin.id,
          moderationNote: trimmedReason,
          moderatedAt: now,
          updatedAt: now,
        ),
      );

      // #region agent log
      AgentDebugLog.log(
        'admin_moderation_repository.dart:suspendVendor:dbUpdated',
        'user and vendor rows updated',
        {
          'vendorUserId': vendorUserId.toString(),
          'newUserStatus': updatedUser.status.name,
        },
        hypothesisId: 'B',
      );
      // #endregion

      try {
        await _notifications.createAsync(
          session,
          userId: vendorUserId,
          title: 'Vendor account suspended',
          message: trimmedReason,
          type: InAppNotificationType.promotionUpdate,
        );
        // #region agent log
        AgentDebugLog.log(
          'admin_moderation_repository.dart:suspendVendor:notify',
          'notification sent',
          {'vendorUserId': vendorUserId.toString()},
          hypothesisId: 'E',
        );
        // #endregion
      } catch (notificationError) {
        // #region agent log
        AgentDebugLog.log(
          'admin_moderation_repository.dart:suspendVendor:notifyFailed',
          'notification failed but suspend succeeded',
          {
            'vendorUserId': vendorUserId.toString(),
            'error': notificationError.toString(),
          },
          hypothesisId: 'E',
        );
        // #endregion
      }

      return VendorModerationResult(
        vendorUserId: vendorUserId,
        vendorId: updatedVendor.id!,
        status: updatedUser.status,
        message: 'Vendor has been suspended.',
        moderationNote: trimmedReason,
        moderatedAt: now,
      );
    } catch (error, stackTrace) {
      // #region agent log
      AgentDebugLog.log(
        'admin_moderation_repository.dart:suspendVendor:error',
        'suspendVendor failed',
        {
          'vendorUserId': vendorUserId.toString(),
          'error': error.toString(),
          'stack': stackTrace.toString().split('\n').take(3).join(' | '),
        },
        hypothesisId: 'B',
      );
      // #endregion
      rethrow;
    }
  }

  Future<String> getReinstateTerms(Session session) async {
    await _requireAdminProfile(session);
    return reinstateTermsText;
  }

  Future<VendorModerationResult> reactivateVendor(
    Session session,
    UuidValue vendorUserId, {
    required bool termsAccepted,
    String? termsNote,
  }) async {
    final admin = await _requireAdminProfile(session);
    if (!termsAccepted) {
      throw PlaceifyException(
        message: 'Terms and conditions must be accepted before reinstating.',
        code: 'TERMS_NOT_ACCEPTED',
      );
    }

    final user = await User.db.findById(session, vendorUserId);
    if (user == null) {
      throw PlaceifyException(
        message: 'Vendor account not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(vendorUserId),
    );
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    if (user.status != UserAccountStatus.suspended) {
      throw PlaceifyException(
        message: 'Only suspended vendors can be reactivated.',
        code: 'INVALID_VENDOR_STATUS',
      );
    }

    final note = termsNote?.trim().isNotEmpty == true
        ? termsNote!.trim()
        : reinstateTermsText;
    final now = DateTime.now();
    final previousRole = user.role;
    final updatedUser = await User.db.updateRow(
      session,
      user.copyWith(
        role: UserRole.vendor,
        status: UserAccountStatus.approved,
        isActive: true,
        statusChangedById: admin.id,
        updatedAt: now,
      ),
    );

    if (previousRole != UserRole.vendor) {
      UserRoleAuditLog.roleChanged(
        session,
        userId: user.id!,
        previousRole: previousRole,
        newRole: UserRole.vendor,
        source: 'admin.reactivateVendor',
        changedByAdminId: admin.id,
      );
    }

    final updatedVendor = await Vendor.db.updateRow(
      session,
      vendor.copyWith(
        moderationNote: note,
        moderatedAt: now,
        updatedAt: now,
      ),
    );

    try {
      await _notifications.createAsync(
        session,
        userId: vendorUserId,
        title: 'Vendor account reinstated',
        message: 'Your vendor account has been reinstated. $note',
        type: InAppNotificationType.promotionUpdate,
      );
    } catch (_) {}

    return VendorModerationResult(
      vendorUserId: vendorUserId,
      vendorId: updatedVendor.id!,
      status: updatedUser.status,
      message: 'Vendor has been reinstated.',
      moderationNote: note,
      moderatedAt: now,
    );
  }

  Future<User> suspendUser(Session session, UuidValue targetUserId) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(message: 'User not found.', code: 'USER_NOT_FOUND');
    }

    if (user.role == UserRole.admin) {
      throw PlaceifyException(
        message: 'Admin accounts cannot be suspended.',
        code: 'FORBIDDEN',
      );
    }

    if (user.status == UserAccountStatus.suspended && !user.isActive) {
      return user;
    }

    return User.db.updateRow(
      session,
      user.copyWith(
        status: UserAccountStatus.suspended,
        isActive: false,
        statusChangedById: admin.id,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<User> activateUser(Session session, UuidValue targetUserId) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(message: 'User not found.', code: 'USER_NOT_FOUND');
    }

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(targetUserId),
    );

    final restoredRole = user.role == UserRole.admin
        ? UserRole.admin
        : vendor != null && user.role == UserRole.vendor
            ? UserRole.vendor
            : UserRole.consumer;

    return User.db.updateRow(
      session,
      user.copyWith(
        role: restoredRole,
        status: UserAccountStatus.approved,
        isActive: true,
        deletedAt: null,
        statusChangedById: admin.id,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<User> rejectVendor(Session session, UuidValue vendorUserId) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, vendorUserId);
    if (user == null) {
      throw PlaceifyException(
        message: 'Vendor account not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(vendorUserId),
    );
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    return User.db.updateRow(
      session,
      user.copyWith(
        status: UserAccountStatus.rejected,
        statusChangedById: admin.id,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<User> updateUserStatus(
    Session session,
    UuidValue targetUserId,
    UserAccountStatus status, {
    bool? isActive,
  }) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(message: 'User not found.', code: 'USER_NOT_FOUND');
    }

    return User.db.updateRow(
      session,
      user.copyWith(
        status: status,
        isActive: isActive ?? user.isActive,
        statusChangedById: admin.id,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<User> deactivateUser(Session session, UuidValue targetUserId) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(message: 'User not found.', code: 'USER_NOT_FOUND');
    }

    final now = DateTime.now();
    return User.db.updateRow(
      session,
      user.copyWith(
        status: UserAccountStatus.suspended,
        isActive: false,
        deletedAt: now,
        statusChangedById: admin.id,
        updatedAt: now,
      ),
    );
  }

  Future<Product> removeProduct(
    Session session,
    int productId,
    String reason,
  ) async {
    final admin = await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw PlaceifyException(
        message: 'Removal reason is required.',
        code: 'INVALID_REASON',
      );
    }

    final now = DateTime.now();
    return Product.db.updateRow(
      session,
      product.copyWith(
        status: ProductStatus.removed,
        removedReason: trimmedReason,
        removedById: admin.id,
        removedAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<Product> deleteProduct(Session session, int productId) async {
    await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }
    if (product.isDeleted) return product;

    final now = DateTime.now();
    return Product.db.updateRow(
      session,
      product.copyWith(
        isDeleted: true,
        deletedAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<Product> restoreProduct(Session session, int productId) async {
    await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    final now = DateTime.now();
    return Product.db.updateRow(
      session,
      product.copyWith(
        isDeleted: false,
        deletedAt: null,
        status: ProductStatus.active,
        updatedAt: now,
      ),
    );
  }

  Future<Product> flagProduct(Session session, int productId) async {
    await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    return Product.db.updateRow(
      session,
      product.copyWith(
        status: ProductStatus.flagged,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<Complaint> fileComplaint(
    Session session,
    int productId,
    String reason,
    String description,
  ) async {
    final reporter = await SessionService.requireUser(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(message: 'Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    final trimmedReason = reason.trim();
    final trimmedDescription = description.trim();
    if (trimmedReason.isEmpty || trimmedDescription.isEmpty) {
      throw PlaceifyException(
        message: 'Reason and description are required.',
        code: 'INVALID_COMPLAINT',
      );
    }

    return Complaint.db.insertRow(
      session,
      Complaint(
        productId: productId,
        reportedById: reporter.id!,
        reason: trimmedReason,
        description: trimmedDescription,
      ),
    );
  }

  Future<List<Complaint>> listComplaints(
    Session session, {
    ComplaintStatus? status,
  }) async {
    await _requireAdminProfile(session);
    return Complaint.db.find(
      session,
      where: status == null
          ? null
          : (row) => row.status.equals(status),
      include: Complaint.include(
        product: Product.include(vendor: Vendor.include()),
        reportedBy: User.include(),
        resolvedBy: Admin.include(),
      ),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );
  }

  Future<Complaint> resolveComplaint(Session session, UuidValue complaintId) async {
    final admin = await _requireAdminProfile(session);
    final complaint = await Complaint.db.findById(session, complaintId);
    if (complaint == null) {
      throw PlaceifyException(
        message: 'Complaint not found.',
        code: 'COMPLAINT_NOT_FOUND',
      );
    }

    final now = DateTime.now();
    return Complaint.db.updateRow(
      session,
      complaint.copyWith(
        status: ComplaintStatus.resolved,
        resolvedById: admin.id,
        resolvedAt: now,
      ),
    );
  }
}
