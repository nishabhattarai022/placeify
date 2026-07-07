import 'package:serverpod/serverpod.dart' hide Order;

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../vendor/vendor_shop_category_codec.dart';
import 'admin_action_audit_log.dart';
import 'admin_repository.dart';
import 'admin_vendor_lifecycle.dart';

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

    final totalUsers = await User.db.count(
      session,
      where: (row) => row.deletedAt.equals(null),
    );

    final totalCustomers = await User.db.count(
      session,
      where: (row) =>
          row.deletedAt.equals(null) & row.role.equals(UserRole.consumer),
    );

    final pendingCount = await User.db.count(
      session,
      where: (row) =>
          row.deletedAt.equals(null) &
          row.status.equals(UserAccountStatus.pending),
    );

    final declinedCount = await User.db.count(
      session,
      where: (row) =>
          row.deletedAt.equals(null) &
          row.status.equals(UserAccountStatus.rejected),
    );

    final suspendedCount = await User.db.count(
      session,
      where: (row) =>
          row.deletedAt.equals(null) &
          row.status.equals(UserAccountStatus.suspended),
    );

    final approvedCount = await User.db.count(
      session,
      where: (row) =>
          row.deletedAt.equals(null) &
          row.role.equals(UserRole.vendor) &
          row.status.equals(UserAccountStatus.approved),
    );

    final gmvResult = await session.db.unsafeQuery(
      'SELECT COALESCE(SUM("totalAmount"), 0) AS gmv FROM "order" WHERE "status" = @status',
      parameters: QueryParameters.named({
        'status': OrderStatus.delivered.name,
      }),
    );
    final platformGmv = gmvResult.isEmpty
        ? 0.0
        : (gmvResult.first.toColumnMap()['gmv'] as num?)?.toDouble() ?? 0.0;

    final signupSeries = await _signupSeriesFromDb(session);

    final recentApplications = await listVendorApplications(
      session,
      status: UserAccountStatus.pending,
      pagination: PaginationInput(page: 1, pageSize: 5),
    );
    final recentActivity = await getAuditLog(session, limit: 10);

    return AdminPlatformStats(
      totalVendors: approvedCount,
      totalCustomers: totalCustomers,
      pendingCount: pendingCount,
      totalUsers: totalUsers,
      platformGmv: platformGmv,
      approvedCount: approvedCount,
      declinedCount: declinedCount,
      suspendedCount: suspendedCount,
      recentActivity: recentActivity,
      signupSeries: signupSeries,
      recentApplications: recentApplications,
    );
  }

  Future<PlatformUserDetail?> getUserDetail(
    Session session,
    UuidValue userId,
  ) async {
    await _requireAdmin(session);

    final user = await User.db.findById(session, userId);
    if (user == null || user.id == null) return null;

    final vendor = await Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
    );

    return PlatformUserDetail(
      id: user.id!,
      name: user.name,
      email: user.email ?? '',
      role: user.role,
      status: user.status,
      isActive: user.isActive,
      phone: user.phone,
      address: user.address,
      vendorId: vendor?.id,
      vendorShopName: vendor?.shopName,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  Future<List<PlatformUserSummary>> listUsers(
    Session session, {
    String? query,
    UserRole? role,
    PaginationInput? pagination,
  }) async {
    await _requireAdmin(session);

    final paging = PaginationHelper.resolve(pagination);
    final normalizedQuery = query?.trim().toLowerCase();

    final users = await User.db.find(
      session,
      where: (row) {
        var expression = row.deletedAt.equals(null);
        if (role != null) {
          expression = expression & row.role.equals(role);
        }
        if (normalizedQuery != null && normalizedQuery.isNotEmpty) {
          final pattern = '%$normalizedQuery%';
          expression =
              expression & (row.name.ilike(pattern) | row.email.ilike(pattern));
        }
        return expression;
      },
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: pagination == null ? null : paging.pageSize,
      offset: pagination == null ? null : paging.offset,
    );

    if (users.isEmpty) return const [];

    final userIds = users.map((user) => user.id!).toList(growable: false);
    final vendors = await Vendor.db.find(
      session,
      where: (row) {
        var expression = row.userId.equals(userIds.first);
        for (final userId in userIds.skip(1)) {
          expression = expression | row.userId.equals(userId);
        }
        return expression;
      },
    );
    final vendorByUserId = {for (final vendor in vendors) vendor.userId: vendor};

    return [
      for (final user in users)
        if (user.id != null)
          PlatformUserSummary(
            id: user.id!,
            name: user.name,
            email: user.email ?? '',
            role: user.role,
            status: user.status,
            vendorId: vendorByUserId[user.id!]?.id,
            createdAt: user.createdAt,
          ),
    ];
  }

  Future<List<VendorApplicationSummary>> listVendorApplications(
    Session session, {
    UserAccountStatus? status,
    PaginationInput? pagination,
  }) async {
    await _requireAdmin(session);
    final paging = PaginationHelper.resolve(pagination);

    final vendors = await Vendor.db.find(
      session,
      include: Vendor.include(user: User.include()),
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: pagination == null ? null : paging.pageSize * 4,
      offset: pagination == null ? null : paging.offset,
    );

    final applications = <VendorApplicationSummary>[];
    for (final vendor in vendors) {
      final user = vendor.user;
      final vendorId = vendor.id;
      if (user == null || vendorId == null) continue;
      if (status != null &&
          !AdminVendorLifecycle.matchesListFilter(user, vendor, status)) {
        continue;
      }

      applications.add(
        VendorApplicationSummary(
          vendorId: vendorId,
          userId: user.id!,
          businessName: vendor.shopName,
          contactEmail: vendor.contactEmail ?? user.email ?? '',
          submittedAt: vendor.createdAt,
          status: AdminVendorLifecycle.effectiveAccountStatus(user, vendor),
          moderationNote: vendor.moderationNote,
          moderatedAt: vendor.moderatedAt,
          appealMessage: vendor.appealMessage,
          appealSubmittedAt: vendor.appealSubmittedAt,
        ),
      );

      if (pagination != null && applications.length >= paging.pageSize) {
        break;
      }
    }

    if (status == UserAccountStatus.suspended) {
      applications.sort((a, b) {
        final aHasAppeal = a.appealSubmittedAt != null;
        final bHasAppeal = b.appealSubmittedAt != null;
        if (aHasAppeal != bHasAppeal) {
          return aHasAppeal ? -1 : 1;
        }
        final aTime = a.moderatedAt ?? a.submittedAt;
        final bTime = b.moderatedAt ?? b.submittedAt;
        return bTime.compareTo(aTime);
      });
    }

    if (pagination != null && applications.length > paging.pageSize) {
      return applications.take(paging.pageSize).toList(growable: false);
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
      status: AdminVendorLifecycle.effectiveAccountStatus(user, vendor),
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
      moderationNote: vendor.moderationNote,
      moderatedAt: vendor.moderatedAt,
      appealMessage: vendor.appealMessage,
      appealSubmittedAt: vendor.appealSubmittedAt,
    );
  }

  Future<List<AdminAuditLogSummary>> getAuditLog(
    Session session, {
    int limit = 50,
    PaginationInput? pagination,
  }) async {
    await _requireAdmin(session);

    final paging = PaginationHelper.resolve(
      pagination ?? PaginationInput(page: 1, pageSize: limit.clamp(1, 100)),
    );

    final entries = await AdminAuditLog.db.find(
      session,
      orderBy: (row) => row.createdAt,
      orderDescending: true,
      limit: paging.pageSize,
      offset: paging.offset,
    );

    return entries
        .map(AdminActionAuditLog.toSummary)
        .toList(growable: false);
  }

  Future<List<double>> _signupSeriesFromDb(Session session) async {
    final now = DateTime.now();
    final counts = List<int>.filled(7, 0);

    for (var dayOffset = 0; dayOffset < 7; dayOffset++) {
      final dayStart = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - dayOffset));
      final dayEnd = dayStart.add(const Duration(days: 1));

      final result = await session.db.unsafeQuery(
        'SELECT COUNT(*) AS count FROM "user" '
        'WHERE "createdAt" >= @start AND "createdAt" < @end',
        parameters: QueryParameters.named({
          'start': dayStart,
          'end': dayEnd,
        }),
      );
      counts[dayOffset] = result.isEmpty
          ? 0
          : (result.first.toColumnMap()['count'] as num?)?.toInt() ?? 0;
    }

    final max = counts.reduce((a, b) => a > b ? a : b);
    if (max == 0) return List<double>.filled(7, 0.15);
    return counts.map((count) => count / max).toList();
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
