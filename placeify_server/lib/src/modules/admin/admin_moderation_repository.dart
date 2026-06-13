import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';

/// Admin moderation: vendor approval, user status, product removal, complaints.
class AdminModerationStore {
  Future<User> _requireAdminUser(Session session) {
    return SessionService.requireRole(session, {UserRole.admin});
  }

  Future<Vendor> approveVendor(Session session, UuidValue vendorUserId) async {
    final admin = await _requireAdminUser(session);
    final user = await User.db.findById(session, vendorUserId);
    if (user == null || user.role != UserRole.vendor) {
      throw PlaceifyException(
        'Vendor account not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(vendorUserId),
    );
    if (vendor == null) {
      throw PlaceifyException(
        'Vendor profile not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    final now = DateTime.now();
    await User.db.updateRow(
      session,
      user.copyWith(
        status: UserAccountStatus.approved,
        isActive: true,
        updatedAt: now,
      ),
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

  Future<User> rejectVendor(Session session, UuidValue vendorUserId) async {
    await _requireAdminUser(session);
    final user = await User.db.findById(session, vendorUserId);
    if (user == null || user.role != UserRole.vendor) {
      throw PlaceifyException(
        'Vendor account not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    return User.db.updateRow(
      session,
      user.copyWith(
        status: UserAccountStatus.rejected,
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
    await _requireAdminUser(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException('User not found.', code: 'USER_NOT_FOUND');
    }

    return User.db.updateRow(
      session,
      user.copyWith(
        status: status,
        isActive: isActive ?? user.isActive,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<User> deactivateUser(Session session, UuidValue targetUserId) async {
    await _requireAdminUser(session);
    final user = await User.db.findById(session, targetUserId);
    if (user == null) {
      throw PlaceifyException('User not found.', code: 'USER_NOT_FOUND');
    }

    final now = DateTime.now();
    return User.db.updateRow(
      session,
      user.copyWith(
        status: UserAccountStatus.suspended,
        isActive: false,
        deletedAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<Product> removeProduct(
    Session session,
    int productId,
    String reason,
  ) async {
    final admin = await _requireAdminUser(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException('Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw PlaceifyException(
        'Removal reason is required.',
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

  Future<Product> flagProduct(Session session, int productId) async {
    await _requireAdminUser(session);
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw PlaceifyException('Product not found.', code: 'PRODUCT_NOT_FOUND');
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
      throw PlaceifyException('Product not found.', code: 'PRODUCT_NOT_FOUND');
    }

    final trimmedReason = reason.trim();
    final trimmedDescription = description.trim();
    if (trimmedReason.isEmpty || trimmedDescription.isEmpty) {
      throw PlaceifyException(
        'Reason and description are required.',
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
    await _requireAdminUser(session);
    return Complaint.db.find(
      session,
      where: status == null
          ? null
          : (row) => row.status.equals(status),
      include: Complaint.include(
        product: Product.include(vendor: Vendor.include()),
        reportedBy: User.include(),
      ),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );
  }

  Future<Complaint> resolveComplaint(Session session, int complaintId) async {
    await _requireAdminUser(session);
    final complaint = await Complaint.db.findById(session, complaintId);
    if (complaint == null) {
      throw PlaceifyException(
        'Complaint not found.',
        code: 'COMPLAINT_NOT_FOUND',
      );
    }

    return Complaint.db.updateRow(
      session,
      complaint.copyWith(status: ComplaintStatus.resolved),
    );
  }
}
