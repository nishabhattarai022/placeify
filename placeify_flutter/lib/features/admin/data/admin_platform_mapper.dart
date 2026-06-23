import 'package:placeify_client/placeify_client.dart' as api;
import 'package:placeify_flutter/features/admin/domain/enums/application_decision.dart';
import 'package:placeify_flutter/features/admin/domain/enums/audit_action.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart'
    as admin;
import 'package:placeify_flutter/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_stats.dart';
import 'package:placeify_flutter/features/admin/domain/models/platform_user.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/vendor/data/vendor_shop_category_codec.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';

abstract final class AdminPlatformMapper {
  static AdminStats toAdminStats(api.AdminPlatformStats stats) {
    return AdminStats(
      totalVendors: stats.totalVendors,
      pendingCount: stats.pendingCount,
      totalUsers: stats.totalUsers,
      platformGmv: stats.platformGmv,
      approvedCount: stats.approvedCount,
      declinedCount: stats.declinedCount,
      suspendedCount: stats.suspendedCount,
      recentActivity: stats.recentActivity.map(toAuditLogEntry).toList(),
      signupSeries: stats.signupSeries,
      recentApplications:
          stats.recentApplications.map(toVendorApplication).toList(),
    );
  }

  static PlatformUser toPlatformUser(api.PlatformUserSummary user) {
    return PlatformUser(
      id: user.id.toString(),
      name: user.name,
      email: user.email,
      role: toAdminRole(user.role),
      vendorStatus: toVendorStatus(user.status),
      vendorId: user.vendorId?.toString(),
      createdAt: user.createdAt,
    );
  }

  static VendorApplication toVendorApplication(
    api.VendorApplicationSummary summary,
  ) {
    return VendorApplication(
      vendorId: summary.vendorId.toString(),
      userId: summary.userId.toString(),
      businessName: summary.businessName,
      contactEmail: summary.contactEmail,
      submittedAt: summary.submittedAt,
      registration: VendorRegistration(
        business: VendorBusinessInfo(
          businessName: summary.businessName,
          email: summary.contactEmail,
        ),
      ),
      status: toVendorStatus(summary.status),
    );
  }

  static VendorApplication toVendorApplicationDetail(
    api.VendorApplicationDetail detail,
  ) {
    return VendorApplication(
      vendorId: detail.vendorId.toString(),
      userId: detail.userId.toString(),
      businessName: detail.businessName,
      contactEmail: detail.contactEmail,
      submittedAt: detail.submittedAt,
      registration: VendorRegistration(
        business: VendorBusinessInfo(
          businessName: detail.businessName,
          contactName: detail.contactName,
          email: detail.contactEmail,
          phone: detail.phone,
          taxId: detail.taxId ?? '',
        ),
        address: VendorAddress(
          street: detail.street,
          city: detail.city,
          state: detail.state,
          postalCode: detail.postalCode,
          country: detail.country,
        ),
        category: VendorCategoryInfo(
          categories: VendorShopCategoryCodec.decode(detail.category),
          description: detail.description,
        ),
        documents: VendorDocuments(
          businessLicensePath: detail.businessLicenseUrl,
          governmentIdPath: detail.governmentIdUrl,
          taxCertificatePath: detail.taxCertificateUrl,
        ),
      ),
      status: toVendorStatus(detail.status),
    );
  }

  static AdminAuditLogEntry toAuditLogEntry(api.AdminAuditLogSummary entry) {
    return AdminAuditLogEntry(
      id: entry.id,
      action: toAuditAction(entry.actionType),
      actorAdminId: entry.actorAdminId.toString(),
      targetUserId: entry.targetUserId.toString(),
      timestamp: entry.timestamp,
      note: entry.note,
    );
  }

  static AdminAuditAction toAuditAction(String actionType) {
    return switch (actionType) {
      'application_approved' => const AdminAuditAction.application(
          decision: ApplicationDecision.approved,
        ),
      'application_declined' => const AdminAuditAction.application(
          decision: ApplicationDecision.declined,
        ),
      'vendor_suspended' => const AdminAuditAction.vendor(
          action: AuditAction.suspended,
        ),
      'vendor_reinstated' => const AdminAuditAction.vendor(
          action: AuditAction.reinstated,
        ),
      _ => const AdminAuditAction.vendor(action: AuditAction.suspended),
    };
  }

  static admin.UserRole toAdminRole(api.UserRole role) => switch (role) {
        api.UserRole.consumer => admin.UserRole.customer,
        api.UserRole.vendor => admin.UserRole.vendor,
        api.UserRole.admin => admin.UserRole.admin,
      };

  static api.UserRole? toApiRole(admin.UserRole? role) => switch (role) {
        admin.UserRole.customer => api.UserRole.consumer,
        admin.UserRole.vendor => api.UserRole.vendor,
        admin.UserRole.admin => api.UserRole.admin,
        null => null,
      };

  static VendorStatus toVendorStatus(api.UserAccountStatus status) =>
      switch (status) {
        api.UserAccountStatus.approved => VendorStatus.approved,
        api.UserAccountStatus.pending => VendorStatus.pending,
        api.UserAccountStatus.suspended => VendorStatus.suspended,
        api.UserAccountStatus.rejected => VendorStatus.none,
      };

  static api.UserAccountStatus? toApiStatus(VendorApplicationListFilter? filter) {
    return switch (filter) {
      VendorApplicationListFilter.pending => api.UserAccountStatus.pending,
      VendorApplicationListFilter.approved => api.UserAccountStatus.approved,
      VendorApplicationListFilter.declined => api.UserAccountStatus.rejected,
      null => null,
    };
  }
}
