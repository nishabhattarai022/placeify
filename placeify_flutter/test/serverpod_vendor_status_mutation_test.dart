import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/auth/data/serverpod_auth_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Serverpod auth rejects local vendor status mutation before admin API',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repo = ServerpodAuthRepository(prefs);

      expect(
        () => repo.updateVendorStatusForUser(
          userId: 'any-user-id',
          status: VendorStatus.approved,
          vendorId: 'vendor-id',
        ),
        throwsA(isA<UnsupportedError>()),
      );
    },
  );
}
