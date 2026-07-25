import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../../shared/user_role_audit_log.dart';
import '../notification/in_app_notification_store.dart';
import 'admin_action_audit_log.dart';
import 'admin_repository.dart';
import 'admin_user_guard.dart';
import 'admin_vendor_lifecycle.dart';

/// Admin moderation: vendor approval, user status, product removal, complaints.
class AdminModerationStore {
  AdminModerationStore({
    AdminStore? adminStore,
    InAppNotificationStore? notifications,
  }) : _adminStore = adminStore ?? AdminStore(),
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

  Future<void> _notifySafely(
    Session session, {
    required UuidValue userId,
    required String title,
    required String message,
  }) async {
    try {
      await _notifications.createAsync(
        session,
        userId: userId,
        title: title,
        message: message,
        type: InAppNotificationType.promotionUpdate,
      );
    } catch (_) {}
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

    AdminVendorLifecycle.ensureCanApprove(user, vendor);

    if (user.status == UserAccountStatus.approved &&
        user.role == UserRole.vendor) {
      return vendor;
    }

    final now = DateTime.now();
    final previousRole = user.role;
    final previousStatus = user.status.name;

    final updatedVendor = await session.db.transaction((transaction) async {
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
        transaction: transaction,
      );

      final vendorRow = await Vendor.db.updateRow(
        session,
        vendor.copyWith(
          approvedById: vendor.approvedById ?? admin.id,
          approvedAt: vendor.approvedAt ?? now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.approveVendor,
        targetUserId: vendorUserId,
        targetVendorId: vendor.id,
        previousStatus: previousStatus,
        newStatus: UserAccountStatus.approved.name,
        transaction: transaction,
      );

      return vendorRow;
    });

    if (previousRole != UserRole.vendor) {
      UserRoleAuditLog.roleChanged(
        session,
        userId: user.id!,
        previousRole: previousRole,
        newRole: UserRole.vendor,
        source: 'admin.approveVendor',
        changedByAdminId: admin.id,
      );
    }

    return updatedVendor;
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

    AdminVendorLifecycle.ensureCanReject(user);
    if (user.status == UserAccountStatus.rejected) {
      return user;
    }

    final previousStatus = user.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await User.db.updateRow(
        session,
        user.copyWith(
          status: UserAccountStatus.rejected,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.rejectVendor,
        targetUserId: vendorUserId,
        targetVendorId: vendor.id,
        previousStatus: previousStatus,
        newStatus: UserAccountStatus.rejected.name,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<VendorModerationResult> suspendVendor(
    Session session,
    UuidValue vendorUserId,
    String reason,
  ) async {
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

    final now = DateTime.now();
    final previousStatus = user.status.name;
    var userToSuspend = user;
    if (user.status != UserAccountStatus.approved ||
        user.role != UserRole.vendor) {
      userToSuspend = user.copyWith(
        role: UserRole.vendor,
        status: UserAccountStatus.approved,
        isActive: true,
      );
    }

    final result = await session.db.transaction((transaction) async {
      final updatedUser = await User.db.updateRow(
        session,
        userToSuspend.copyWith(
          status: UserAccountStatus.suspended,
          isActive: false,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      final updatedVendor = await Vendor.db.updateRow(
        session,
        vendor.copyWith(
          approvedAt: vendor.approvedAt ?? now,
          approvedById: vendor.approvedById ?? admin.id,
          moderationNote: trimmedReason,
          moderatedAt: now,
          appealMessage: null,
          appealSubmittedAt: null,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.suspendVendor,
        targetUserId: vendorUserId,
        targetVendorId: vendor.id,
        previousStatus: previousStatus,
        newStatus: UserAccountStatus.suspended.name,
        reason: trimmedReason,
        transaction: transaction,
      );

      return (
        user: updatedUser,
        vendor: updatedVendor,
      );
    });

    await _notifySafely(
      session,
      userId: vendorUserId,
      title: 'Vendor account suspended',
      message: trimmedReason,
    );

    return VendorModerationResult(
      vendorUserId: vendorUserId,
      vendorId: result.vendor.id!,
      status: result.user.status,
      message: 'Vendor has been suspended.',
      moderationNote: trimmedReason,
      moderatedAt: now,
    );
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

    AdminVendorLifecycle.ensureCanReinstate(user);

    if (user.status == UserAccountStatus.approved &&
        user.role == UserRole.vendor) {
      return VendorModerationResult(
        vendorUserId: vendorUserId,
        vendorId: vendor.id!,
        status: user.status,
        message: 'Vendor is already active.',
        moderationNote: vendor.moderationNote,
        moderatedAt: vendor.moderatedAt,
      );
    }

    final note = termsNote?.trim().isNotEmpty == true
        ? termsNote!.trim()
        : reinstateTermsText;
    final now = DateTime.now();
    final previousRole = user.role;
    final previousStatus = user.status.name;

    final result = await session.db.transaction((transaction) async {
      final updatedUser = await User.db.updateRow(
        session,
        user.copyWith(
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
          isActive: true,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      final updatedVendor = await Vendor.db.updateRow(
        session,
        vendor.copyWith(
          moderationNote: note,
          moderatedAt: now,
          appealMessage: null,
          appealSubmittedAt: null,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.reinstateVendor,
        targetUserId: vendorUserId,
        targetVendorId: vendor.id,
        previousStatus: previousStatus,
        newStatus: UserAccountStatus.approved.name,
        note: note,
        transaction: transaction,
      );

      return (
        user: updatedUser,
        vendor: updatedVendor,
      );
    });

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

    await _notifySafely(
      session,
      userId: vendorUserId,
      title: 'Vendor account reinstated',
      message: 'Your vendor account has been reinstated. $note',
    );

    return VendorModerationResult(
      vendorUserId: vendorUserId,
      vendorId: result.vendor.id!,
      status: result.user.status,
      message: 'Vendor has been reinstated.',
      moderationNote: note,
      moderatedAt: now,
    );
  }

  Future<User> suspendUser(Session session, UuidValue targetUserId) async {
    final admin = await _requireAdminProfile(session);
    final actorUser = await SessionService.requireUser(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(
        message: 'User not found.',
        code: 'USER_NOT_FOUND',
      );
    }

    AdminUserGuard.ensureCanModifyUser(actor: actorUser, target: user);

    if (user.status == UserAccountStatus.suspended && !user.isActive) {
      return user;
    }

    final previousStatus = user.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await User.db.updateRow(
        session,
        user.copyWith(
          status: UserAccountStatus.suspended,
          isActive: false,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.suspendUser,
        targetUserId: targetUserId,
        previousStatus: previousStatus,
        newStatus: UserAccountStatus.suspended.name,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<User> activateUser(Session session, UuidValue targetUserId) async {
    final admin = await _requireAdminProfile(session);
    final actorUser = await SessionService.requireUser(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(
        message: 'User not found.',
        code: 'USER_NOT_FOUND',
      );
    }

    AdminUserGuard.ensureCanModifyUser(actor: actorUser, target: user);

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(targetUserId),
    );

    final restoredRole = user.role == UserRole.admin
        ? UserRole.admin
        : vendor != null && user.role == UserRole.vendor
        ? UserRole.vendor
        : UserRole.consumer;

    final previousStatus = user.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await User.db.updateRow(
        session,
        user.copyWith(
          role: restoredRole,
          status: UserAccountStatus.approved,
          isActive: true,
          deletedAt: null,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.activateUser,
        targetUserId: targetUserId,
        previousStatus: previousStatus,
        newStatus: UserAccountStatus.approved.name,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<User> updateUserStatus(
    Session session,
    UuidValue targetUserId,
    UserAccountStatus status, {
    bool? isActive,
  }) async {
    final admin = await _requireAdminProfile(session);
    final actorUser = await SessionService.requireUser(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(
        message: 'User not found.',
        code: 'USER_NOT_FOUND',
      );
    }

    AdminUserGuard.ensureCanChangeStatus(
      actor: actorUser,
      target: user,
      newStatus: status,
    );

    final previousStatus = user.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await User.db.updateRow(
        session,
        user.copyWith(
          status: status,
          isActive: isActive ?? user.isActive,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.updateUserStatus,
        targetUserId: targetUserId,
        previousStatus: previousStatus,
        newStatus: status.name,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<User> deactivateUser(Session session, UuidValue targetUserId) async {
    final admin = await _requireAdminProfile(session);
    final actorUser = await SessionService.requireUser(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException(
        message: 'User not found.',
        code: 'USER_NOT_FOUND',
      );
    }

    AdminUserGuard.ensureCanModifyUser(actor: actorUser, target: user);

    final previousStatus = user.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await User.db.updateRow(
        session,
        user.copyWith(
          status: UserAccountStatus.suspended,
          isActive: false,
          deletedAt: now,
          statusChangedById: admin.id,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.deactivateUser,
        targetUserId: targetUserId,
        previousStatus: previousStatus,
        newStatus: UserAccountStatus.suspended.name,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<Product> removeProduct(
    Session session,
    int productId,
    String reason,
  ) async {
    final admin = await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw PlaceifyException(
        message: 'Removal reason is required.',
        code: 'INVALID_REASON',
      );
    }

    if (product.status == ProductStatus.removed &&
        product.removedById != null) {
      throw PlaceifyException(
        message: 'Product is already removed.',
        code: 'PRODUCT_ALREADY_REMOVED',
      );
    }

    final previousStatus = product.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await Product.db.updateRow(
        session,
        product.copyWith(
          status: ProductStatus.removed,
          isDeleted: true,
          deletedAt: now,
          removedReason: trimmedReason,
          removedById: admin.id,
          removedAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.removeProduct,
        targetProductId: productId,
        targetVendorId: product.vendorId,
        previousStatus: previousStatus,
        newStatus: ProductStatus.removed.name,
        reason: trimmedReason,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<Product> deleteProduct(Session session, int productId) async {
    final admin = await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }
    if (product.isDeleted) return product;

    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await Product.db.updateRow(
        session,
        product.copyWith(
          isDeleted: true,
          deletedAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.deleteProduct,
        targetProductId: productId,
        previousStatus: product.status.name,
        newStatus: 'deleted',
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<Product> restoreProduct(Session session, int productId) async {
    final admin = await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    if (!product.isDeleted &&
        product.status == ProductStatus.active &&
        product.removedReason == null) {
      throw PlaceifyException(
        message: 'Product is already active.',
        code: 'PRODUCT_ALREADY_ACTIVE',
      );
    }

    final previousStatus = product.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await Product.db.updateRow(
        session,
        product.copyWith(
          isDeleted: false,
          deletedAt: null,
          status: ProductStatus.active,
          removedReason: null,
          removedById: null,
          removedAt: null,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.restoreProduct,
        targetProductId: productId,
        targetVendorId: product.vendorId,
        previousStatus: previousStatus,
        newStatus: ProductStatus.active.name,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<Product> flagProduct(Session session, int productId) async {
    final admin = await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    final previousStatus = product.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await Product.db.updateRow(
        session,
        product.copyWith(
          status: ProductStatus.flagged,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.flagProduct,
        targetProductId: productId,
        previousStatus: previousStatus,
        newStatus: ProductStatus.flagged.name,
        transaction: transaction,
      );

      try {
        await _notifications.notifyActiveAdmins(
          session,
          title: 'Product flagged',
          message: '"${product.name}" was flagged for review.',
          type: InAppNotificationType.vendorFlagged,
          referenceId: productId,
          referenceKey: product.vendorId.uuid,
        );
      } catch (_) {}

      return updated;
    });
  }

  Future<Product> setProductFeatured(
    Session session,
    int productId, {
    required bool featured,
  }) async {
    final admin = await _requireAdminProfile(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    if (product.featured == featured) return product;

    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await Product.db.updateRow(
        session,
        product.copyWith(
          featured: featured,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.featureProduct,
        targetProductId: productId,
        previousStatus: product.featured.toString(),
        newStatus: featured.toString(),
        transaction: transaction,
      );

      return updated;
    });
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
      throw PlaceifyException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );
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
    PaginationInput? pagination,
  }) async {
    await _requireAdminProfile(session);
    final paging = _resolvePagination(pagination);

    return Complaint.db.find(
      session,
      where: status == null ? null : (row) => row.status.equals(status),
      include: Complaint.include(
        product: Product.include(vendor: Vendor.include()),
        reportedBy: User.include(),
        resolvedBy: Admin.include(),
        assignedTo: Admin.include(),
      ),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: paging.limit,
      offset: paging.offset,
    );
  }

  Future<Complaint> assignComplaint(
    Session session,
    UuidValue complaintId, {
    String? internalNote,
  }) async {
    final admin = await _requireAdminProfile(session);
    final complaint = await Complaint.db.findById(session, complaintId);
    if (complaint == null) {
      throw PlaceifyException(
        message: 'Complaint not found.',
        code: 'COMPLAINT_NOT_FOUND',
      );
    }

    if (complaint.status == ComplaintStatus.resolved ||
        complaint.status == ComplaintStatus.rejected) {
      throw PlaceifyException(
        message: 'Resolved complaints cannot be reassigned.',
        code: 'INVALID_COMPLAINT_STATUS',
      );
    }

    final now = DateTime.now();
    final previousStatus = complaint.status.name;

    return session.db.transaction((transaction) async {
      final updated = await Complaint.db.updateRow(
        session,
        complaint.copyWith(
          assignedToId: admin.id,
          status: ComplaintStatus.reviewed,
          internalNote: internalNote?.trim().isNotEmpty == true
              ? internalNote!.trim()
              : complaint.internalNote,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.assignComplaint,
        targetComplaintId: complaintId,
        previousStatus: previousStatus,
        newStatus: ComplaintStatus.reviewed.name,
        note: internalNote,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<Complaint> resolveComplaint(
    Session session,
    UuidValue complaintId,
  ) async {
    final admin = await _requireAdminProfile(session);
    final complaint = await Complaint.db.findById(session, complaintId);
    if (complaint == null) {
      throw PlaceifyException(
        message: 'Complaint not found.',
        code: 'COMPLAINT_NOT_FOUND',
      );
    }

    if (complaint.status == ComplaintStatus.resolved) {
      return complaint;
    }

    final previousStatus = complaint.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await Complaint.db.updateRow(
        session,
        complaint.copyWith(
          status: ComplaintStatus.resolved,
          resolvedById: admin.id,
          resolvedAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.resolveComplaint,
        targetComplaintId: complaintId,
        previousStatus: previousStatus,
        newStatus: ComplaintStatus.resolved.name,
        transaction: transaction,
      );

      return updated;
    });
  }

  Future<Complaint> reopenComplaint(
    Session session,
    UuidValue complaintId, {
    String? internalNote,
  }) async {
    final admin = await _requireAdminProfile(session);
    final complaint = await Complaint.db.findById(session, complaintId);
    if (complaint == null) {
      throw PlaceifyException(
        message: 'Complaint not found.',
        code: 'COMPLAINT_NOT_FOUND',
      );
    }

    if (complaint.status != ComplaintStatus.resolved &&
        complaint.status != ComplaintStatus.rejected) {
      throw PlaceifyException(
        message: 'Only resolved or rejected complaints can be reopened.',
        code: 'INVALID_COMPLAINT_STATUS',
      );
    }

    final previousStatus = complaint.status.name;
    final now = DateTime.now();

    return session.db.transaction((transaction) async {
      final updated = await Complaint.db.updateRow(
        session,
        complaint.copyWith(
          status: ComplaintStatus.pending,
          resolvedById: null,
          resolvedAt: null,
          internalNote: internalNote?.trim().isNotEmpty == true
              ? internalNote!.trim()
              : complaint.internalNote,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await AdminActionAuditLog.record(
        session,
        actorAdminId: admin.id!,
        actionType: AdminActionType.reopenComplaint,
        targetComplaintId: complaintId,
        previousStatus: previousStatus,
        newStatus: ComplaintStatus.pending.name,
        note: internalNote,
        transaction: transaction,
      );

      return updated;
    });
  }

  ({int limit, int offset}) _resolvePagination(PaginationInput? pagination) {
    if (pagination == null) {
      return (limit: 1000, offset: 0);
    }
    final page = pagination.page.clamp(1, 1000000);
    final pageSize = pagination.pageSize.clamp(1, 100);
    return (limit: pageSize, offset: (page - 1) * pageSize);
  }
}
