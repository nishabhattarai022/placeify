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

  Future<Complaint> resolveComplaint(Session session, int complaintId) {
    return _service.resolveComplaint(session, complaintId);
  }
}
