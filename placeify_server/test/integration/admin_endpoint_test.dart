import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/shared/placeify_exception.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

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

      await endpoints.admin.suspendVendor(
        admin.session,
        applicant.user.id!,
        'Second suspension for test cleanup',
      );

      final rejected = await endpoints.admin.rejectVendor(
        admin.session,
        applicant.user.id!,
      );
      expect(rejected.status, UserAccountStatus.rejected);

      final detail = await endpoints.admin.getVendorApplication(
        admin.session,
        vendor.id!,
      );
      expect(detail?.status, UserAccountStatus.rejected);
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
  });
}
