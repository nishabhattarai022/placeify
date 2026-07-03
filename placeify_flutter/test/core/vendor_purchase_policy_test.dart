import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/core/utils/vendor_purchase_policy.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

void main() {
  group('VendorPurchasePolicy', () {
    const vendorUser = AppUser(
      id: 'user-1',
      fullName: 'Vendor',
      email: 'vendor@example.com',
      role: UserRole.vendor,
      vendorStatus: VendorStatus.approved,
      vendorId: 'shop-a',
    );

    test('allows regular customers to purchase any product', () {
      expect(
        VendorPurchasePolicy.canPurchase(
          user: const AppUser(
            id: 'c1',
            fullName: 'Customer',
            email: 'c@example.com',
            role: UserRole.customer,
            vendorId: 'shop-a',
          ),
          productVendorId: 'shop-a',
        ),
        isTrue,
      );
    });

    test('blocks vendors from buying their own shop products', () {
      expect(
        VendorPurchasePolicy.isOwnShopProduct(
          buyerVendorId: 'shop-a',
          productVendorId: 'shop-a',
        ),
        isTrue,
      );
      expect(
        VendorPurchasePolicy.canPurchase(
          user: vendorUser,
          productVendorId: 'shop-a',
        ),
        isFalse,
      );
    });

    test('allows vendors to buy from other shops', () {
      expect(
        VendorPurchasePolicy.canPurchase(
          user: vendorUser,
          productVendorId: 'shop-b',
        ),
        isTrue,
      );
    });
  });
}
