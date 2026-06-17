import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/features/admin/data/mock/mock_vendor_application_repository.dart';
import 'package:placeify_flutter/features/auth/data/mock_auth_repository.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_registration_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify_flutter/features/vendor/presentation/guards/vendor_auth_guard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('admin vendor approval loop', () {
    late SharedPreferences prefs;
    late MockAuthRepository authRepo;
    late MockVendorRegistrationRepository registrationRepo;
    late MockVendorApplicationRepository applicationRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      authRepo = MockAuthRepository(prefs);
      registrationRepo = MockVendorRegistrationRepository(authRepo, prefs);
      applicationRepo = MockVendorApplicationRepository(authRepo, prefs);
    });

    Future<AppUser> registerAndApply() async {
      final user = await authRepo.register(
        fullName: 'Test Vendor',
        email: 'vendor.flow@test.com',
        password: 'test1234',
      );
      await authRepo.signIn(email: user.email, password: 'test1234');

      await registrationRepo.submitRegistration(
        const VendorRegistration(
          business: VendorBusinessInfo(
            businessName: 'Flow Test Store',
            contactName: 'Test Vendor',
            email: 'vendor.flow@test.com',
            phone: '+977 9800000001',
          ),
          address: VendorAddress(
            street: 'Thamel',
            city: 'Kathmandu',
            state: 'Bagmati',
            postalCode: '44600',
            country: 'Nepal',
          ),
          category: VendorCategoryInfo(
            category: 'Furniture',
            description: 'Test furniture store',
          ),
          documents: VendorDocuments(),
          bank: VendorBankDetails(
            accountHolderName: 'Test Vendor',
            bankName: 'Nabil Bank',
            accountNumber: '1234567890',
            routingNumber: 'NARBNPKA',
          ),
        ),
      );

      final sessionUser = await authRepo.getCurrentUser();
      expect(sessionUser?.vendorStatus, VendorStatus.pending);
      expect(sessionUser?.vendorId, isNotNull);
      return sessionUser!;
    }

    test('approve sets vendorStatus approved and unlocks vendor routes', () async {
      final user = await registerAndApply();
      final vendorId = user.vendorId!;

      await authRepo.updateVendorStatusForUser(
        userId: user.id,
        status: VendorStatus.approved,
        vendorId: vendorId,
      );
      await applicationRepo.approve(userId: user.id, vendorId: vendorId);

      final approved = (await authRepo.getAllUsers())
          .firstWhere((u) => u.id == user.id);
      expect(approved.vendorStatus, VendorStatus.approved);
      expect(approved.vendorId, vendorId);

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: approved,
      );
      expect(guard, isNull);
    });

    test('decline resets vendorStatus none so user can re-register', () async {
      final user = await registerAndApply();

      await authRepo.updateVendorStatusForUser(
        userId: user.id,
        status: VendorStatus.none,
        vendorId: null,
      );
      await applicationRepo.decline(
        userId: user.id,
        note: 'Incomplete documents',
      );

      final declined = (await authRepo.getAllUsers())
          .firstWhere((u) => u.id == user.id);
      expect(declined.vendorStatus, VendorStatus.none);
      expect(declined.vendorId, isNull);

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: declined,
      );
      expect(guard?.location, '/vendor/register');
    });

    test('vendor role with approved status can open dashboard', () {
      const user = AppUser(
        id: '1',
        fullName: 'Shop Owner',
        email: 'shop@test.com',
        role: UserRole.vendor,
        registeredVendorStatus: VendorStatus.approved,
      );

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: user,
      );
      expect(guard, isNull);
    });

    test('pending vendor with shop can open dashboard', () {
      const user = AppUser(
        id: '1',
        fullName: 'Shop Owner',
        email: 'shop@test.com',
        role: UserRole.consumer,
        hasVendorShop: true,
        registeredVendorStatus: VendorStatus.pending,
        registeredVendorId: '42',
      );

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: user,
      );
      expect(guard, isNull);
    });

    test('pending vendor without shop stays blocked', () {
      const user = AppUser(
        id: '1',
        fullName: 'Applicant',
        email: 'apply@test.com',
        role: UserRole.consumer,
        registeredVendorStatus: VendorStatus.pending,
        registeredVendorId: 'mock-vendor',
      );

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: user,
      );
      expect(guard?.location, VendorRoutes.profileFallback);
    });
  });
}
