import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/presentation/guards/vendor_auth_guard.dart';

void main() {
  group('vendor auth guard after approval decisions', () {
    AppUser user({
      required VendorStatus status,
      String? vendorId,
    }) {
      return AppUser(
        id: 'user-1',
        fullName: 'Test Vendor',
        email: 'vendor.flow@test.com',
        role: UserRole.customer,
        vendorStatus: status,
        vendorId: vendorId,
      );
    }

    test('approved vendor can open vendor shell routes', () {
      final approved = user(
        status: VendorStatus.approved,
        vendorId: 'vendor-1',
      );

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: approved,
      );
      expect(guard, isNull);
    });

    test('declined vendor is redirected to re-register', () {
      final declined = user(status: VendorStatus.none);

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: declined,
      );
      expect(guard?.location, '/vendor/register');
    });

    test('pending vendor is redirected away from vendor shell', () {
      final pending = user(
        status: VendorStatus.pending,
        vendorId: 'vendor-1',
      );

      final guard = VendorAuthGuard.evaluate(
        location: '/vendor',
        user: pending,
      );
      expect(guard?.location, isNotNull);
      expect(guard?.location, isNot(equals('/vendor')));
    });
  });
}
