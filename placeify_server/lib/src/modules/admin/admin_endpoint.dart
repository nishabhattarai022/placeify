import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../auth/placeify_endpoint.dart';
import 'admin_service.dart';

/// Admin profile APIs for platform administrators.
class AdminEndpoint extends PlaceifyAuthenticatedEndpoint {
  final _service = AdminService();

  Future<bool> hasAdminProfile(Session session) {
    return _service.hasAdminProfile(session);
  }

  Future<Admin?> getMyAdmin(Session session) {
    return _service.getMyAdmin(session);
  }

  Future<Admin> getMyProfile(Session session) {
    return _service.getMyProfile(session);
  }

  Future<Admin> updateMyProfile(
    Session session,
    String fullName, {
    String? email,
    String? phoneNumber,
    AdminType? adminType,
    bool? isActive,
  }) {
    return _service.updateMyProfile(
      session,
      fullName,
      email: email,
      phoneNumber: phoneNumber,
      adminType: adminType,
      isActive: isActive,
    );
  }

  Future<Admin> updateNotificationPreferences(
    Session session, {
    required bool newApplicationAlerts,
    required bool systemAlerts,
  }) {
    return _service.updateNotificationPreferences(
      session,
      newApplicationAlerts: newApplicationAlerts,
      systemAlerts: systemAlerts,
    );
  }

  Future<List<InAppNotificationSummary>> listNotifications(
    Session session, {
    int limit = 50,
  }) {
    return _service.listNotifications(session, limit: limit);
  }

  Future<void> markNotificationRead(Session session, int notificationId) {
    return _service.markNotificationRead(session, notificationId);
  }

  Future<void> markAllNotificationsRead(Session session) {
    return _service.markAllNotificationsRead(session);
  }

  Future<Vendor> approveVendor(Session session, UuidValue vendorUserId) {
    return _service.approveVendor(session, vendorUserId);
  }

  Future<User> rejectVendor(Session session, UuidValue vendorUserId) {
    return _service.rejectVendor(session, vendorUserId);
  }

  Future<VendorModerationResult> suspendVendor(
    Session session,
    UuidValue vendorUserId,
    String reason,
  ) {
    return _service.suspendVendor(session, vendorUserId, reason);
  }

  Future<String> getVendorReinstateTerms(Session session) {
    return _service.getVendorReinstateTerms(session);
  }

  Future<VendorModerationResult> reactivateVendor(
    Session session,
    UuidValue vendorUserId, {
    required bool termsAccepted,
    String? termsNote,
  }) {
    return _service.reactivateVendor(
      session,
      vendorUserId,
      termsAccepted: termsAccepted,
      termsNote: termsNote,
    );
  }

  Future<User> suspendUser(Session session, UuidValue targetUserId) {
    return _service.suspendUser(session, targetUserId);
  }

  Future<User> activateUser(Session session, UuidValue targetUserId) {
    return _service.activateUser(session, targetUserId);
  }

  Future<User> updateUserStatus(
    Session session,
    UuidValue targetUserId,
    UserAccountStatus status, {
    bool? isActive,
  }) {
    return _service.updateUserStatus(
      session,
      targetUserId,
      status,
      isActive: isActive,
    );
  }

  Future<User> deactivateUser(Session session, UuidValue targetUserId) {
    return _service.deactivateUser(session, targetUserId);
  }

  Future<Product> removeProduct(
    Session session,
    int productId,
    String reason,
  ) {
    return _service.removeProduct(session, productId, reason);
  }

  Future<Product> deleteProduct(Session session, int productId) {
    return _service.deleteProduct(session, productId);
  }

  Future<Product> restoreProduct(Session session, int productId) {
    return _service.restoreProduct(session, productId);
  }

  Future<Product> flagProduct(Session session, int productId) {
    return _service.flagProduct(session, productId);
  }

  Future<Product> setProductFeatured(
    Session session,
    int productId, {
    required bool featured,
  }) {
    return _service.setProductFeatured(session, productId, featured: featured);
  }

  Future<Complaint> fileComplaint(
    Session session,
    int productId,
    String reason,
    String description,
  ) {
    return _service.fileComplaint(session, productId, reason, description);
  }

  Future<List<Complaint>> listComplaints(
    Session session, {
    ComplaintStatus? status,
    PaginationInput? pagination,
  }) {
    return _service.listComplaints(
      session,
      status: status,
      pagination: pagination,
    );
  }

  Future<Complaint> assignComplaint(
    Session session,
    UuidValue complaintId, {
    String? internalNote,
  }) {
    return _service.assignComplaint(
      session,
      complaintId,
      internalNote: internalNote,
    );
  }

  Future<Complaint> resolveComplaint(Session session, UuidValue complaintId) {
    return _service.resolveComplaint(session, complaintId);
  }

  Future<Complaint> reopenComplaint(
    Session session,
    UuidValue complaintId, {
    String? internalNote,
  }) {
    return _service.reopenComplaint(
      session,
      complaintId,
      internalNote: internalNote,
    );
  }

  Future<AdminPlatformStats> getPlatformStats(Session session) {
    return _service.getPlatformStats(session);
  }

  Future<List<PlatformUserSummary>> listUsers(
    Session session, {
    String? query,
    UserRole? role,
    PaginationInput? pagination,
  }) {
    return _service.listUsers(
      session,
      query: query,
      role: role,
      pagination: pagination,
    );
  }

  Future<PlatformUserDetail?> getUserDetail(
    Session session,
    UuidValue userId,
  ) {
    return _service.getUserDetail(session, userId);
  }

  Future<List<VendorApplicationSummary>> listVendorApplications(
    Session session, {
    UserAccountStatus? status,
    PaginationInput? pagination,
  }) {
    return _service.listVendorApplications(
      session,
      status: status,
      pagination: pagination,
    );
  }

  Future<VendorApplicationDetail?> getVendorApplication(
    Session session,
    UuidValue vendorId,
  ) {
    return _service.getVendorApplication(session, vendorId);
  }

  Future<List<AdminAuditLogSummary>> getAuditLog(
    Session session, {
    int limit = 50,
    PaginationInput? pagination,
  }) {
    return _service.getAuditLog(
      session,
      limit: limit,
      pagination: pagination,
    );
  }

  Future<List<AdminVendorPayoutSummary>> listVendorPayouts(
    Session session, {
    VendorPayoutStatus? status,
    PaginationInput? pagination,
  }) {
    return _service.listVendorPayouts(
      session,
      status: status,
      pagination: pagination,
    );
  }

  Future<AdminVendorPayoutSummary> approveVendorPayout(
    Session session,
    int payoutId,
  ) {
    return _service.approveVendorPayout(session, payoutId);
  }

  Future<AdminVendorPayoutSummary> failVendorPayout(
    Session session,
    int payoutId, {
    String? reason,
  }) {
    return _service.failVendorPayout(session, payoutId, reason: reason);
  }

  Future<List<AdminRefundRequestSummary>> listRefundRequests(
    Session session, {
    RequestStatus? status,
    PaginationInput? pagination,
  }) {
    return _service.listRefundRequests(
      session,
      status: status,
      pagination: pagination,
    );
  }

  Future<AdminRefundRequestSummary> approveRefundRequest(
    Session session,
    int refundId,
  ) {
    return _service.approveRefundRequest(session, refundId);
  }

  Future<AdminRefundRequestSummary> rejectRefundRequest(
    Session session,
    int refundId,
  ) {
    return _service.rejectRefundRequest(session, refundId);
  }

  Future<List<AdminProductSummary>> listProducts(
    Session session,
    AdminProductListInput input,
  ) {
    return _service.listProducts(session, input);
  }

  Future<List<AdminProductSummary>> listReportedProducts(
    Session session, {
    AdminProductListInput? input,
  }) {
    return _service.listReportedProducts(session, input: input);
  }

  Future<AdminProductDetail?> getProductDetails(
    Session session,
    int productId,
  ) {
    return _service.getProductDetails(session, productId);
  }
}
