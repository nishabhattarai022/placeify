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

  Future<Vendor> approveVendor(Session session, UuidValue vendorUserId) {
    return _service.approveVendor(session, vendorUserId);
  }

  Future<User> rejectVendor(Session session, UuidValue vendorUserId) {
    return _service.rejectVendor(session, vendorUserId);
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

  Future<Product> flagProduct(Session session, int productId) {
    return _service.flagProduct(session, productId);
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
  }) {
    return _service.listComplaints(session, status: status);
  }

  Future<Complaint> resolveComplaint(Session session, UuidValue complaintId) {
    return _service.resolveComplaint(session, complaintId);
  }

  Future<AdminPlatformStats> getPlatformStats(Session session) {
    return _service.getPlatformStats(session);
  }

  Future<List<PlatformUserSummary>> listUsers(
    Session session, {
    String? query,
    UserRole? role,
  }) {
    return _service.listUsers(session, query: query, role: role);
  }

  Future<List<VendorApplicationSummary>> listVendorApplications(
    Session session, {
    UserAccountStatus? status,
  }) {
    return _service.listVendorApplications(session, status: status);
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
  }) {
    return _service.getAuditLog(session, limit: limit);
  }

  Future<List<AdminVendorPayoutSummary>> listVendorPayouts(
    Session session, {
    VendorPayoutStatus? status,
  }) {
    return _service.listVendorPayouts(session, status: status);
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
  }) {
    return _service.listRefundRequests(session, status: status);
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
}
