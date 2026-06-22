import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/admin/data/mock/mock_vendor_application_repository.dart';
import 'package:placeify_flutter/features/auth/data/mock_auth_repository.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_registration_repository.dart';
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
            categories: ['Furniture'],
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
  });
}
