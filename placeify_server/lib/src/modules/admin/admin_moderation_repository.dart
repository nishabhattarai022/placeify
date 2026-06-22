import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/session_service.dart';
import '../product/catalog_seed.dart';
import 'admin_repository.dart';

/// Admin moderation: vendor approval, user status, product removal, complaints.
class AdminModerationStore {
  AdminModerationStore({AdminStore? adminStore})
      : _adminStore = adminStore ?? AdminStore();

  final AdminStore _adminStore;

  Future<Admin> _requireAdminProfile(Session session) {
    return _adminStore.requireAdminProfile(session);
  }

  Future<Vendor> approveVendor(Session session, UuidValue vendorUserId) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, vendorUserId);
    if (user == null || user.role != UserRole.vendor) {
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

    final now = DateTime.now();
    await User.db.updateRow(
      session,
      user.copyWith(
        status: UserAccountStatus.approved,
        isActive: true,
        approvedById: admin.id,
        statusChangedById: admin.id,
        updatedAt: now,
      ),
    );

    final approvedVendor = await Vendor.db.updateRow(
      session,
      vendor.copyWith(
        approvedById: admin.id,
        approvedAt: now,
        updatedAt: now,
      ),
    );

    if (approvedVendor.id != null) {
      await CatalogSeed.ensureStarterProductsForVendor(
        session,
        approvedVendor.id!,
      );
    }

    return approvedVendor;
  }

  Future<User> rejectVendor(Session session, UuidValue vendorUserId) async {
    final admin = await _requireAdminProfile(session);
    final user = await User.db.findById(session, vendorUserId);
    if (user == null || user.role != UserRole.vendor) {
      throw PlaceifyException(
        message: 'Vendor account not found.',
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
