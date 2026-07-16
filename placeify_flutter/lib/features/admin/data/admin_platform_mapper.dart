import 'package:placeify_client/placeify_client.dart' as api;
import 'package:placeify_flutter/core/config/resolve_media_url.dart';
import 'package:placeify_flutter/features/admin/domain/enums/admin_product_visibility_filter.dart';
import 'package:placeify_flutter/features/admin/domain/enums/application_decision.dart';
import 'package:placeify_flutter/features/admin/domain/enums/audit_action.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart'
    as admin;
import 'package:placeify_flutter/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify_flutter/features/admin/domain/enums/admin_notification_type.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_notification.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_product_complaint_summary.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_product_summary.dart';
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
      recentApplications:
          stats.recentApplications.map(toVendorApplication).toList(),
    );
  }

  static AdminNotification toAdminNotification(
    api.InAppNotificationSummary notification,
  ) {
    return AdminNotification(
      id: notification.id.toString(),
      title: notification.title,
      body: notification.message,
      createdAt: notification.createdAt,
      read: notification.isRead,
      type: switch (notification.type) {
        api.InAppNotificationType.vendorApplication =>
          AdminNotificationType.newApplication,
        api.InAppNotificationType.vendorFlagged =>
          AdminNotificationType.vendorFlagged,
        _ => AdminNotificationType.systemAlert,
      },
      linkedVendorId: notification.referenceKey,
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
      moderationNote: summary.moderationNote,
      moderatedAt: summary.moderatedAt,
      appealMessage: summary.appealMessage,
      appealSubmittedAt: summary.appealSubmittedAt,
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
      moderationNote: detail.moderationNote,
      moderatedAt: detail.moderatedAt,
      appealMessage: detail.appealMessage,
      appealSubmittedAt: detail.appealSubmittedAt,
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

  static api.AdminProductVisibilityFilter toApiProductVisibility(
    AdminProductVisibilityFilter filter,
  ) {
    return switch (filter) {
      AdminProductVisibilityFilter.all => api.AdminProductVisibilityFilter.all,
      AdminProductVisibilityFilter.active =>
        api.AdminProductVisibilityFilter.active,
      AdminProductVisibilityFilter.removed =>
        api.AdminProductVisibilityFilter.removed,
    };
  }

  static Future<AdminProductSummary> toAdminProductSummary(
    api.AdminProductSummary product,
  ) async {
    return AdminProductSummary(
      productId: product.productId,
      productName: product.productName,
      description: product.description,
      price: product.price,
      categoryName: product.categoryName,
      thumbnailUrl: await _resolvePrimaryImageUrl(product.thumbnailUrl),
      status: product.status.name,
      isDeleted: product.isDeleted,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      vendorId: product.vendorId.toString(),
      shopName: product.shopName,
      ownerName: product.ownerName,
      vendorEmail: product.vendorEmail,
      complaintCount: product.complaintCount,
      latestComplaintAt: product.latestComplaintAt,
    );
  }

  static Future<AdminProductDetail> toAdminProductDetail(
    api.AdminProductDetail product,
  ) async {
    final viewImageUrls = <String>[];
    for (final viewUrl in product.viewImageUrls ?? const <String>[]) {
      final resolved = await _resolvePrimaryImageUrl(viewUrl);
      if (resolved == null) continue;
      viewImageUrls.add(resolved);
    }

    return AdminProductDetail(
      productId: product.productId,
      productName: product.productName,
      description: product.description,
      price: product.price,
      categoryName: product.categoryName,
      thumbnailUrl: await _resolvePrimaryImageUrl(
        product.thumbnailUrl,
        fallbackUrls: product.viewImageUrls,
      ),
      status: product.status.name,
      isDeleted: product.isDeleted,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      vendorId: product.vendorId.toString(),
      shopName: product.shopName,
      ownerName: product.ownerName,
      vendorEmail: product.vendorEmail,
      complaintCount: product.complaintCount,
      latestComplaintAt: product.latestComplaintAt,
      discountPrice: product.discountPrice,
      viewImageUrls: viewImageUrls,
      removedReason: product.removedReason,
      removedAt: product.removedAt,
      removedByAdminName: product.removedByAdminName,
      complaints: product.complaints
          .map(
            (complaint) => AdminProductComplaintSummary(
              complaintId: complaint.complaintId.toString(),
              reason: complaint.reason,
              description: complaint.description,
              status: complaint.status.name,
              createdAt: complaint.createdAt,
            ),
          )
          .toList(),
    );
  }

  /// Resolves stored `/uploads/...` paths the same way catalog/vendor mappers do.
  static Future<String?> _resolvePrimaryImageUrl(
    String? primary, {
    List<String>? fallbackUrls,
  }) async {
    final candidates = <String>[
      ?primary,
      ...?fallbackUrls,
    ];
    for (final candidate in candidates) {
      final trimmed = candidate.trim();
      if (trimmed.isEmpty) continue;
      final resolved = await resolveMediaUrl(trimmed);
      if (resolved.isNotEmpty) return resolved;
    }
    return null;
  }
}
