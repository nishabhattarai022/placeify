import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../vendor/vendor_shop_category_codec.dart';
import 'admin_repository.dart';

/// Read-side admin platform queries backed by PostgreSQL.
class AdminPlatformStore {
  AdminPlatformStore({AdminStore? adminStore})
      : _adminStore = adminStore ?? AdminStore();

  final AdminStore _adminStore;

  Future<void> _requireAdmin(Session session) {
    return _adminStore.requireAdminProfile(session).then((_) {});
  }

  Future<AdminPlatformStats> getPlatformStats(Session session) async {
    await _requireAdmin(session);

    final users = await User.db.find(
      session,
      where: (row) => row.deletedAt.equals(null),
    );

    final vendorUsers = users.where((user) => user.role == UserRole.vendor);
    final approvedCount =
        vendorUsers.where((user) => user.status == UserAccountStatus.approved).length;

    final pendingApplications = await listVendorApplications(
      session,
      status: UserAccountStatus.pending,
    );
    final pendingCount = pendingApplications.length;
    final declinedCount =
        vendorUsers.where((user) => user.status == UserAccountStatus.rejected).length;
    final suspendedCount =
        vendorUsers.where((user) => user.status == UserAccountStatus.suspended).length;

    final gmvResult = await session.db.unsafeQuery(
      'SELECT COALESCE(SUM("totalAmount"), 0) AS gmv FROM "order" WHERE "status" = @status',
      parameters: QueryParameters.named({
        'status': OrderStatus.delivered.name,
      }),
    );
    final platformGmv = gmvResult.isEmpty
        ? 0.0
        : (gmvResult.first.toColumnMap()['gmv'] as num?)?.toDouble() ?? 0.0;

    final recentApplications = await listVendorApplications(
      session,
      status: UserAccountStatus.pending,
      limit: 5,
    );
    final recentActivity = await getAuditLog(session, limit: 10);

    return AdminPlatformStats(
      totalVendors: approvedCount,
      pendingCount: pendingCount,
      totalUsers: users.length,
      platformGmv: platformGmv,
      approvedCount: approvedCount,
      declinedCount: declinedCount,
      suspendedCount: suspendedCount,
      recentActivity: recentActivity,
      signupSeries: _signupSeriesFor(users),
      recentApplications: recentApplications,
    );
  }

  Future<List<PlatformUserSummary>> listUsers(
    Session session, {
    String? query,
    UserRole? role,
  }) async {
    await _requireAdmin(session);

    final normalizedQuery = query?.trim().toLowerCase();
    final users = await User.db.find(
      session,
      where: (row) => row.deletedAt.equals(null),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    final vendorByUserId = <UuidValue, Vendor>{};
    final vendors = await Vendor.db.find(session);
    for (final vendor in vendors) {
      vendorByUserId[vendor.userId] = vendor;
    }

    final summaries = <PlatformUserSummary>[];
    for (final user in users) {
      if (user.id == null) continue;
      if (role != null && user.role != role) continue;

      final email = user.email ?? '';
      final name = user.name;
      if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
        final haystack = '$name $email'.toLowerCase();
        if (!haystack.contains(normalizedQuery)) continue;
      }

      summaries.add(
        PlatformUserSummary(
          id: user.id!,
          name: name,
          email: email,
          role: user.role,
          status: user.status,
          vendorId: vendorByUserId[user.id!]?.id,
          createdAt: user.createdAt,
        ),
      );
    }

    return summaries;
  }

  Future<List<VendorApplicationSummary>> listVendorApplications(
    Session session, {
    UserAccountStatus? status,
    int? limit,
  }) async {
    await _requireAdmin(session);

    final vendors = await Vendor.db.find(
      session,
      include: Vendor.include(user: User.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
    );

    final applications = <VendorApplicationSummary>[];
    for (final vendor in vendors) {
      final user = vendor.user;
      final vendorId = vendor.id;
      if (user == null || vendorId == null) continue;
      if (status != null && user.status != status) continue;

      applications.add(
        VendorApplicationSummary(
          vendorId: vendorId,
          userId: user.id!,
          businessName: vendor.shopName,
          contactEmail: vendor.contactEmail ?? user.email ?? '',
          submittedAt: vendor.createdAt,
          status: user.status,
        ),
      );
    }

    if (limit != null && applications.length > limit) {
      return applications.take(limit).toList(growable: false);
    }
    return applications;
  }

  Future<VendorApplicationDetail?> getVendorApplication(
    Session session,
    UuidValue vendorId,
  ) async {
    await _requireAdmin(session);

    final vendor = await Vendor.db.findById(
      session,
      vendorId,
      include: Vendor.include(user: User.include()),
    );
    if (vendor == null) return null;

    final user = vendor.user;
    if (user == null) return null;

    final documents = await VendorDocument.db.find(
      session,
      where: (row) => row.vendorId.equals(vendorId),
    );

    String? documentUrl(VendorDocumentType type) {
      for (final document in documents) {
        if (document.documentType == type) return document.fileUrl;
      }
      return null;
    }

    final addressParts = _parseAddress(vendor.businessAddress);

    return VendorApplicationDetail(
      vendorId: vendorId,
      userId: user.id!,
      status: user.status,
      submittedAt: vendor.createdAt,
      businessName: vendor.shopName,
      contactName: user.name,
      contactEmail: vendor.contactEmail ?? user.email ?? '',
      phone: user.phone ?? '',
      taxId: null,
      street: addressParts.street,
      city: vendor.city ?? addressParts.city,
      state: addressParts.state,
      postalCode: addressParts.postalCode,
      country: vendor.country ?? addressParts.country,
      category: VendorShopCategoryCodec.decode(vendor.shopCategory ?? '').join(', '),
      description: vendor.description ?? '',
      businessLicenseUrl: documentUrl(VendorDocumentType.businessLicense),
      governmentIdUrl: documentUrl(VendorDocumentType.governmentId),
      taxCertificateUrl: documentUrl(VendorDocumentType.taxCertificate),
    );
  }

  Future<List<AdminAuditLogSummary>> getAuditLog(
    Session session, {
    int limit = 50,
  }) async {
    await _requireAdmin(session);

    final allUsers = await User.db.find(
      session,
      orderBy: (row) => row.updatedAt,
      orderDescending: true,
      limit: limit * 4,
    );
    final users = allUsers
        .where((user) => user.statusChangedById != null)
        .take(limit)
        .toList();

    return [
      for (final user in users)
        if (user.id != null && user.statusChangedById != null)
          AdminAuditLogSummary(
            id: 'user-status-${user.id}',
            actionType: _auditActionType(user.status),
            actorAdminId: user.statusChangedById!,
            targetUserId: user.id!,
            timestamp: user.updatedAt,
            note: null,
          ),
    ];
  }

  List<double> _signupSeriesFor(List<User> users) {
    final now = DateTime.now();
    final counts = List<int>.filled(7, 0);

    for (final user in users) {
      final dayDiff = now.difference(user.createdAt).inDays;
      if (dayDiff >= 0 && dayDiff < 7) {
        counts[6 - dayDiff]++;
      }
    }

    final max = counts.reduce((a, b) => a > b ? a : b);
    if (max == 0) return List<double>.filled(7, 0.15);
    return counts.map((count) => count / max).toList();
  }

  String _auditActionType(UserAccountStatus status) {
    return switch (status) {
      UserAccountStatus.approved => 'application_approved',
      UserAccountStatus.rejected => 'application_declined',
      UserAccountStatus.suspended => 'vendor_suspended',
      UserAccountStatus.pending => 'vendor_pending',
    };
  }

  ({String street, String city, String state, String postalCode, String country})
      _parseAddress(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return (
        street: '',
        city: '',
        state: '',
        postalCode: '',
        country: '',
      );
    }

    final parts = raw.split(',').map((part) => part.trim()).toList();
    if (parts.length == 1) {
      return (
        street: parts.first,
        city: '',
        state: '',
        postalCode: '',
        country: '',
      );
    }

    final country = parts.length >= 2 ? parts.last : '';
    final city = parts.length >= 3 ? parts[parts.length - 2] : '';
    final street = parts.first;
    final middle = parts.length > 3
        ? parts.sublist(1, parts.length - 2).join(', ')
        : (parts.length == 2 ? '' : parts[1]);

    return (
      street: street,
      city: city.isNotEmpty ? city : middle,
      state: '',
      postalCode: '',
      country: country,
    );
  }
}
