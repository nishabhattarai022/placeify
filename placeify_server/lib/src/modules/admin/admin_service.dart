import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'admin_moderation_repository.dart';
import 'admin_platform_repository.dart';
import 'admin_repository.dart';

class AdminService {
  AdminService({
    AdminStore? repository,
    AdminModerationStore? moderation,
    AdminPlatformStore? platform,
  })  : _repository = repository ?? AdminStore(),
        _moderation = moderation ?? AdminModerationStore(),
        _platform = platform ?? AdminPlatformStore();

  final AdminStore _repository;
  final AdminModerationStore _moderation;
  final AdminPlatformStore _platform;

  Future<bool> hasAdminProfile(Session session) {
    return _repository.hasAdminProfile(session);
  }

  Future<Admin?> getMyAdmin(Session session) {
    return _repository.getMyAdmin(session);
  }

  Future<Admin> getMyProfile(Session session) {
    return _repository.requireAdminProfile(session);
  }

  Future<Admin> updateMyProfile(
    Session session,
    String fullName, {
    String? email,
    String? phoneNumber,
    AdminType? adminType,
    bool? isActive,
  }) {
    return _repository.updateMyAdmin(
      session,
      fullName,
      email: email,
      phoneNumber: phoneNumber,
      adminType: adminType,
      isActive: isActive,
    );
  }

  Future<Vendor> approveVendor(Session session, UuidValue vendorUserId) {
    return _moderation.approveVendor(session, vendorUserId);
  }

  Future<User> rejectVendor(Session session, UuidValue vendorUserId) {
    return _moderation.rejectVendor(session, vendorUserId);
  }

  Future<User> updateUserStatus(
    Session session,
    UuidValue targetUserId,
    UserAccountStatus status, {
    bool? isActive,
  }) {
    return _moderation.updateUserStatus(
      session,
      targetUserId,
      status,
      isActive: isActive,
    );
  }

  Future<User> deactivateUser(Session session, UuidValue targetUserId) {
    return _moderation.deactivateUser(session, targetUserId);
  }

  Future<Product> removeProduct(
    Session session,
    int productId,
    String reason,
  ) {
    return _moderation.removeProduct(session, productId, reason);
  }

  Future<Product> flagProduct(Session session, int productId) {
    return _moderation.flagProduct(session, productId);
  }

  Future<Complaint> fileComplaint(
    Session session,
    int productId,
    String reason,
    String description,
  ) {
    return _moderation.fileComplaint(
      session,
      productId,
      reason,
      description,
    );
  }

  Future<List<Complaint>> listComplaints(
    Session session, {
    ComplaintStatus? status,
  }) {
    return _moderation.listComplaints(session, status: status);
  }

  Future<Complaint> resolveComplaint(Session session, UuidValue complaintId) {
    return _moderation.resolveComplaint(session, complaintId);
  }

  Future<AdminPlatformStats> getPlatformStats(Session session) {
    return _platform.getPlatformStats(session);
  }

  Future<List<PlatformUserSummary>> listUsers(
    Session session, {
    String? query,
    UserRole? role,
  }) {
    return _platform.listUsers(session, query: query, role: role);
  }

  Future<List<VendorApplicationSummary>> listVendorApplications(
    Session session, {
    UserAccountStatus? status,
  }) {
    return _platform.listVendorApplications(session, status: status);
  }

  Future<VendorApplicationDetail?> getVendorApplication(
    Session session,
    UuidValue vendorId,
  ) {
    return _platform.getVendorApplication(session, vendorId);
  }

  Future<List<AdminAuditLogSummary>> getAuditLog(
    Session session, {
    int limit = 50,
  }) {
    return _platform.getAuditLog(session, limit: limit);
  }
}
