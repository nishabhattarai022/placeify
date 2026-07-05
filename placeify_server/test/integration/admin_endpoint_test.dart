import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/shared/placeify_exception.dart';
import 'package:serverpod/serverpod.dart' hide Order;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_tools/user_test_helpers.dart';

Future<({TestSessionBuilder session, User user})> _authUser(
  TestSessionBuilder sessionBuilder,
  Session setupSession, {
  required String email,
  required String name,
  UserRole role = UserRole.consumer,
  UserAccountStatus status = UserAccountStatus.approved,
}) async {
  final authUser = await AuthUsers().create(setupSession);
  final user = await User.db.insertRow(
    setupSession,
    User(
      authUserId: authUser.id,
      email: email,
      name: name,
      role: role,
      status: status,
      phone: '9800000001',
      address: 'Kathmandu',
    ),
  );
  await setupSession.close();

  return (
    session: sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        authUser.id.toString(),
        {},
      ),
    ),
    user: user,
  );
}

Future<({TestSessionBuilder session, User user, Vendor vendor})> _pendingVendor(
  TestSessionBuilder sessionBuilder,
  Session setupSession, {
  required String email,
  required String shopName,
}) async {
  final authUser = await AuthUsers().create(setupSession);
  final user = await User.db.insertRow(
    setupSession,
    User(
      authUserId: authUser.id,
      email: email,
      name: shopName,
      role: UserRole.consumer,
      status: UserAccountStatus.pending,
    ),
  );
  final vendor = await Vendor.db.insertRow(
    setupSession,
    Vendor(
      userId: user.id!,
      shopName: shopName,
      description: 'Test vendor',
      businessAddress: 'Kathmandu',
    ),
  );
  await setupSession.close();

  return (
    session: sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        authUser.id.toString(),
        {},
      ),
    ),
    user: user,
    vendor: vendor,
  );
}

void main() {
  withServerpod('Admin endpoint', (sessionBuilder, endpoints) {
    test('consumer is forbidden from admin platform stats', () async {
      final setup = sessionBuilder.build();
      final consumer = await _authUser(
        sessionBuilder,
        setup,
        email: 'shopper@example.com',
        name: 'Shopper',
      );

      await expectLater(
        endpoints.admin.getPlatformStats(consumer.session),
        throwsA(isA<PlaceifyException>()),
      );
    });

    test('admin can load dashboard data and list users', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'panel-admin@example.com',
        name: 'Panel Admin',
        role: UserRole.admin,
      );

      final profile = await endpoints.admin.getMyProfile(admin.session);
      expect(profile.email, 'panel-admin@example.com');
      expect(await endpoints.admin.hasAdminProfile(admin.session), isTrue);

      final stats = await endpoints.admin.getPlatformStats(admin.session);
      expect(stats.totalUsers, greaterThanOrEqualTo(1));

      final users = await endpoints.admin.listUsers(admin.session);
      expect(users.any((user) => user.email == 'panel-admin@example.com'), isTrue);
    });

    test('ensureDemoAdmin promotes demo account and creates admin profile', () async {
      final setup = sessionBuilder.build();
      final authUser = await AuthUsers().create(setup);
      await User.db.insertRow(
        setup,
        User(
          authUserId: authUser.id,
          email: 'admin@placeify.com',
          name: 'Demo Admin',
          role: UserRole.consumer,
          status: UserAccountStatus.approved,
        ),
      );
      await setup.close();

      final session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          authUser.id.toString(),
          {},
        ),
      );

      final promoted = await endpoints.user.ensureDemoAdmin(session);
      expect(promoted.role, UserRole.admin);
      expect(await endpoints.admin.hasAdminProfile(session), isTrue);

      final stats = await endpoints.admin.getPlatformStats(session);
      expect(stats.totalUsers, greaterThanOrEqualTo(1));
    });

    test('admin can list vendor applications', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'apps-admin@example.com',
        name: 'Apps Admin',
        role: UserRole.admin,
      );

      await endpoints.admin.getMyProfile(admin.session);

      final pending = await endpoints.admin.listVendorApplications(
        admin.session,
        status: UserAccountStatus.pending,
      );
      expect(pending, isA<List<VendorApplicationSummary>>());
    });

    test('admin vendor approval lifecycle', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'lifecycle-admin@example.com',
        name: 'Lifecycle Admin',
        role: UserRole.admin,
      );

      final vendorSetup = sessionBuilder.build();
      final applicant = await _authUser(
        sessionBuilder,
        vendorSetup,
        email: 'vendor-applicant@example.com',
        name: 'Vendor Applicant',
        status: UserAccountStatus.pending,
      );

      final vendorDb = sessionBuilder.build();
      final vendor = await Vendor.db.insertRow(
        vendorDb,
        Vendor(
          userId: applicant.user.id!,
          shopName: 'Test Shop',
          description: 'Test vendor shop',
          businessAddress: 'Kathmandu',
        ),
      );
      await vendorDb.close();

      final approved = await endpoints.admin.approveVendor(
        admin.session,
        applicant.user.id!,
      );
      expect(approved.shopName, 'Test Shop');

      final approvedUser = await endpoints.admin.getUserDetail(
        admin.session,
        applicant.user.id!,
      );
      expect(approvedUser?.role, UserRole.vendor);
      expect(approvedUser?.status, UserAccountStatus.approved);

      final suspended = await endpoints.admin.suspendVendor(
        admin.session,
        applicant.user.id!,
        'Policy violation: repeated late shipments',
      );
      expect(suspended.status, UserAccountStatus.suspended);
      expect(suspended.message, 'Vendor has been suspended.');
      expect(suspended.moderationNote, 'Policy violation: repeated late shipments');

      final suspendedList = await endpoints.admin.listVendorApplications(
        admin.session,
        status: UserAccountStatus.suspended,
      );
      expect(
        suspendedList.any((item) => item.userId == applicant.user.id),
        isTrue,
      );
      final suspendedSummary = suspendedList.firstWhere(
        (item) => item.userId == applicant.user.id,
      );
      expect(suspendedSummary.moderationNote, 'Policy violation: repeated late shipments');

      final reactivated = await endpoints.admin.reactivateVendor(
        admin.session,
        applicant.user.id!,
        termsAccepted: true,
      );
      expect(reactivated.status, UserAccountStatus.approved);
      expect(reactivated.message, 'Vendor has been reinstated.');

      final terms = await endpoints.admin.getVendorReinstateTerms(admin.session);
      expect(terms, isNotEmpty);

      final auditLog = await endpoints.admin.getAuditLog(admin.session, limit: 20);
      expect(
        auditLog.any((entry) => entry.actionType == 'suspendVendor'),
        isTrue,
      );
      expect(
        auditLog.any((entry) => entry.actionType == 'reinstateVendor'),
        isTrue,
      );

      final detail = await endpoints.admin.getVendorApplication(
        admin.session,
        vendor.id!,
      );
      expect(detail?.status, UserAccountStatus.approved);
    });

    test('reject vendor only allowed for pending applications', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'reject-admin@example.com',
        name: 'Reject Admin',
        role: UserRole.admin,
      );

      final pendingSetup = sessionBuilder.build();
      final pending = await _pendingVendor(
        sessionBuilder,
        pendingSetup,
        email: 'pending-reject@example.com',
        shopName: 'Pending Shop',
      );

      final rejected = await endpoints.admin.rejectVendor(
        admin.session,
        pending.user.id!,
      );
      expect(rejected.status, UserAccountStatus.rejected);

      await expectLater(
        endpoints.admin.rejectVendor(admin.session, pending.user.id!),
        completion(isA<User>()),
      );

      final approvedSetup = sessionBuilder.build();
      final approvedApplicant = await _pendingVendor(
        sessionBuilder,
        approvedSetup,
        email: 'approved-reject@example.com',
        shopName: 'Approved Shop',
      );
      await endpoints.admin.approveVendor(
        admin.session,
        approvedApplicant.user.id!,
      );

      await expectLater(
        endpoints.admin.rejectVendor(
          admin.session,
          approvedApplicant.user.id!,
        ),
        throwsA(isA<PlaceifyException>()),
      );
    });

    test('duplicate approval is idempotent', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'dup-approve-admin@example.com',
        name: 'Dup Approve Admin',
        role: UserRole.admin,
      );

      final pendingSetup = sessionBuilder.build();
      final pending = await _pendingVendor(
        sessionBuilder,
        pendingSetup,
        email: 'dup-approve@example.com',
        shopName: 'Dup Shop',
      );

      await endpoints.admin.approveVendor(admin.session, pending.user.id!);
      final second = await endpoints.admin.approveVendor(
        admin.session,
        pending.user.id!,
      );
      expect(second.shopName, 'Dup Shop');
    });

    test('duplicate suspension returns existing state', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'dup-suspend-admin@example.com',
        name: 'Dup Suspend Admin',
        role: UserRole.admin,
      );

      final pendingSetup = sessionBuilder.build();
      final pending = await _pendingVendor(
        sessionBuilder,
        pendingSetup,
        email: 'dup-suspend@example.com',
        shopName: 'Suspend Shop',
      );

      await endpoints.admin.approveVendor(admin.session, pending.user.id!);
      await endpoints.admin.suspendVendor(
        admin.session,
        pending.user.id!,
        'First suspension',
      );

      final second = await endpoints.admin.suspendVendor(
        admin.session,
        pending.user.id!,
        'Second suspension attempt',
      );
      expect(second.status, UserAccountStatus.suspended);
      expect(second.message, 'Vendor is already suspended.');
    });

    test('admin user suspend and activate lifecycle', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'users-admin@example.com',
        name: 'Users Admin',
        role: UserRole.admin,
      );

      final customerSetup = sessionBuilder.build();
      final customer = await _authUser(
        sessionBuilder,
        customerSetup,
        email: 'managed-customer@example.com',
        name: 'Managed Customer',
      );

      final suspended = await endpoints.admin.suspendUser(
        admin.session,
        customer.user.id!,
      );
      expect(suspended.status, UserAccountStatus.suspended);
      expect(suspended.isActive, isFalse);
      expect(suspended.deletedAt, isNull);

      final activated = await endpoints.admin.activateUser(
        admin.session,
        customer.user.id!,
      );
      expect(activated.status, UserAccountStatus.approved);
      expect(activated.isActive, isTrue);
      expect(activated.deletedAt, isNull);

      final detail = await endpoints.admin.getUserDetail(
        admin.session,
        customer.user.id!,
      );
      expect(detail?.email, 'managed-customer@example.com');
      expect(detail?.vendorId, isNull);
    });

    test('cannot suspend admin accounts', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'protect-admin@example.com',
        name: 'Protect Admin',
        role: UserRole.admin,
      );
      await endpoints.admin.getMyProfile(admin.session);

      final otherAdminSetup = sessionBuilder.build();
      final otherAdmin = await _authUser(
        sessionBuilder,
        otherAdminSetup,
        email: 'other-admin@example.com',
        name: 'Other Admin',
        role: UserRole.admin,
      );

      await expectLater(
        endpoints.admin.suspendUser(admin.session, otherAdmin.user.id!),
        throwsA(isA<PlaceifyException>()),
      );

      await expectLater(
        endpoints.admin.updateUserStatus(
          admin.session,
          otherAdmin.user.id!,
          UserAccountStatus.suspended,
        ),
        throwsA(isA<PlaceifyException>()),
      );
    });

    test('dashboard stats include totalCustomers', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'stats-admin@example.com',
        name: 'Stats Admin',
        role: UserRole.admin,
      );

      final stats = await endpoints.admin.getPlatformStats(admin.session);
      expect(stats.totalCustomers, greaterThanOrEqualTo(0));
      expect(stats.totalUsers, greaterThanOrEqualTo(stats.totalCustomers));
    });

    test('can suspend vendor with vendor role even if status drifted', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'drift-admin@example.com',
        name: 'Drift Admin',
        role: UserRole.admin,
      );

      final vendorSetup = sessionBuilder.build();
      final applicant = await _authUser(
        sessionBuilder,
        vendorSetup,
        email: 'drift-vendor@example.com',
        name: 'Drift Vendor',
        role: UserRole.vendor,
        status: UserAccountStatus.pending,
      );

      final vendorDb = sessionBuilder.build();
      final vendor = await Vendor.db.insertRow(
        vendorDb,
        Vendor(
          userId: applicant.user.id!,
          shopName: 'Drift Shop',
          description: 'Approved shop with stale status',
          businessAddress: 'Kathmandu',
          approvedAt: DateTime.now(),
        ),
      );
      await vendorDb.close();

      final suspended = await endpoints.admin.suspendVendor(
        admin.session,
        applicant.user.id!,
        'Status drift suspension test',
      );

      expect(suspended.status, UserAccountStatus.suspended);
      expect(suspended.message, 'Vendor has been suspended.');

      final listed = await endpoints.admin.listVendorApplications(
        admin.session,
        status: UserAccountStatus.suspended,
      );
      expect(
        listed.any((item) => item.vendorId == vendor.id),
        isTrue,
      );
    });

    test('reactivate requires accepted terms', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'terms-admin@example.com',
        name: 'Terms Admin',
        role: UserRole.admin,
      );

      final vendorSetup = sessionBuilder.build();
      final applicant = await _authUser(
        sessionBuilder,
        vendorSetup,
        email: 'terms-vendor@example.com',
        name: 'Terms Vendor',
        status: UserAccountStatus.pending,
      );

      final vendorDb = sessionBuilder.build();
      await Vendor.db.insertRow(
        vendorDb,
        Vendor(
          userId: applicant.user.id!,
          shopName: 'Terms Shop',
          description: 'Test',
          businessAddress: 'Kathmandu',
        ),
      );
      await vendorDb.close();

      await endpoints.admin.approveVendor(admin.session, applicant.user.id!);
      await endpoints.admin.suspendVendor(
        admin.session,
        applicant.user.id!,
        'Missing documents',
      );

      await expectLater(
        endpoints.admin.reactivateVendor(
          admin.session,
          applicant.user.id!,
          termsAccepted: false,
        ),
        throwsA(isA<PlaceifyException>()),
      );
    });

    test('product moderation actions are audited', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'product-admin@example.com',
        name: 'Product Admin',
        role: UserRole.admin,
      );

      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Product Vendor',
      );
      final seedSession = sessionBuilder.build();
      final seeded = await seedProductForUser(seedSession, vendorAuth.profile);
      await seedSession.close();

      final flagged = await endpoints.admin.flagProduct(
        admin.session,
        seeded.product.id!,
      );
      expect(flagged.status, ProductStatus.flagged);

      final removed = await endpoints.admin.removeProduct(
        admin.session,
        seeded.product.id!,
        'Policy violation',
      );
      expect(removed.status, ProductStatus.removed);

      final restored = await endpoints.admin.restoreProduct(
        admin.session,
        seeded.product.id!,
      );
      expect(restored.status, ProductStatus.active);

      final featured = await endpoints.admin.setProductFeatured(
        admin.session,
        seeded.product.id!,
        featured: true,
      );
      expect(featured.featured, isTrue);

      final auditLog = await endpoints.admin.getAuditLog(admin.session, limit: 20);
      expect(auditLog.any((entry) => entry.actionType == 'removeProduct'), isTrue);
      expect(auditLog.any((entry) => entry.actionType == 'restoreProduct'), isTrue);
    });

    test('complaint assign and resolve lifecycle', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'complaint-admin@example.com',
        name: 'Complaint Admin',
        role: UserRole.admin,
      );

      final reporterAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Reporter',
      );
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Complaint Vendor',
      );
      final seedSession = sessionBuilder.build();
      final seeded = await seedProductForUser(seedSession, vendorAuth.profile);
      await seedSession.close();

      final complaint = await endpoints.admin.fileComplaint(
        reporterAuth.session,
        seeded.product.id!,
        'Damaged item',
        'Product arrived broken',
      );

      final assigned = await endpoints.admin.assignComplaint(
        admin.session,
        complaint.id!,
        internalNote: 'Reviewing photos',
      );
      expect(assigned.status, ComplaintStatus.reviewed);

      final resolved = await endpoints.admin.resolveComplaint(
        admin.session,
        complaint.id!,
      );
      expect(resolved.status, ComplaintStatus.resolved);

      final reopened = await endpoints.admin.reopenComplaint(
        admin.session,
        complaint.id!,
        internalNote: 'Customer provided more evidence',
      );
      expect(reopened.status, ComplaintStatus.pending);
    });

    test('payout approval and failure lifecycle', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'payout-admin@example.com',
        name: 'Payout Admin',
        role: UserRole.admin,
      );

      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Payout Vendor',
      );
      final seedSession = sessionBuilder.build();
      final seeded = await seedProductForUser(seedSession, vendorAuth.profile);
      final payout = await VendorPayout.db.insertRow(
        seedSession,
        VendorPayout(
          vendorId: seeded.vendor.id!,
          amount: 500,
          payoutMethod: 'bank_transfer',
          reference: 'payout-${DateTime.now().microsecondsSinceEpoch}',
        ),
      );
      await seedSession.close();

      final approved = await endpoints.admin.approveVendorPayout(
        admin.session,
        payout.id!,
      );
      expect(approved.status, VendorPayoutStatus.paid);

      final failSeed = sessionBuilder.build();
      final failPayout = await VendorPayout.db.insertRow(
        failSeed,
        VendorPayout(
          vendorId: seeded.vendor.id!,
          amount: 250,
          payoutMethod: 'bank_transfer',
          reference: 'payout-fail-${DateTime.now().microsecondsSinceEpoch}',
        ),
      );
      await failSeed.close();

      final failed = await endpoints.admin.failVendorPayout(
        admin.session,
        failPayout.id!,
        reason: 'Invalid bank details',
      );
      expect(failed.status, VendorPayoutStatus.failed);
    });

    test('refund approval and rejection lifecycle', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'refund-admin@example.com',
        name: 'Refund Admin',
        role: UserRole.admin,
      );

      final customerAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Refund Customer',
      );
      final vendorAuth = await createAuthenticatedUser(
        sessionBuilder,
        endpoints,
        name: 'Refund Vendor',
      );
      final seedSession = sessionBuilder.build();
      final seeded = await seedProductForUser(seedSession, vendorAuth.profile);
      final order = await seedOrderForUser(
        seedSession,
        customerAuth.profile,
        seeded.product,
      );
      final approveRefund = await RefundRequest.db.insertRow(
        seedSession,
        RefundRequest(
          userId: customerAuth.profile.id!,
          orderId: order.id!,
          reason: 'Damaged delivery',
          refundAmount: order.totalAmount,
        ),
      );
      final rejectRefund = await RefundRequest.db.insertRow(
        seedSession,
        RefundRequest(
          userId: customerAuth.profile.id!,
          orderId: order.id!,
          reason: 'Changed mind',
          refundAmount: 50,
        ),
      );
      await seedSession.close();

      final approved = await endpoints.admin.approveRefundRequest(
        admin.session,
        approveRefund.id!,
      );
      expect(approved.status, RequestStatus.completed);

      final rejected = await endpoints.admin.rejectRefundRequest(
        admin.session,
        rejectRefund.id!,
      );
      expect(rejected.status, RequestStatus.rejected);
    });

    test('list users supports pagination and search', () async {
      final setup = sessionBuilder.build();
      final admin = await _authUser(
        sessionBuilder,
        setup,
        email: 'page-admin@example.com',
        name: 'Page Admin',
        role: UserRole.admin,
      );

      final page = await endpoints.admin.listUsers(
        admin.session,
        pagination: PaginationInput(page: 1, pageSize: 1),
      );
      expect(page.length, lessThanOrEqualTo(1));

      final searched = await endpoints.admin.listUsers(
        admin.session,
        query: 'Page Admin',
      );
      expect(searched.any((user) => user.name == 'Page Admin'), isTrue);
    });
  });
}
