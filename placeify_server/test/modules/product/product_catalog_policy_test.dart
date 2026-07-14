import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/product/product_catalog_policy.dart';
import 'package:placeify_server/src/modules/product/product_pricing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  group('ProductCatalogPolicy', () {
    test('approved vendor user requires vendor role and approved status', () {
      expect(
        ProductCatalogPolicy.isApprovedVendorUser(
          User(
            authUserId: UuidValue.fromString(
              '00000000-0000-0000-0000-000000000001',
            ),
            name: 'Vendor',
            role: UserRole.vendor,
            status: UserAccountStatus.approved,
          ),
        ),
        isTrue,
      );

      expect(
        ProductCatalogPolicy.isApprovedVendorUser(
          User(
            authUserId: UuidValue.fromString(
              '00000000-0000-0000-0000-000000000002',
            ),
            name: 'Pending',
            role: UserRole.consumer,
            status: UserAccountStatus.pending,
          ),
        ),
        isFalse,
      );
    });

    test('consumer-visible product requires active status and approved vendor', () {
      final vendorId = UuidValue.fromString('00000000-0000-0000-0000-000000000010');
      final product = Product(
        vendorId: vendorId,
        name: 'Chair',
        description: 'Test',
        price: 1000,
        status: ProductStatus.active,
      );
      final userId = UuidValue.fromString('00000000-0000-0000-0000-000000000003');
      final approvedUser = User(
        id: userId,
        authUserId: userId,
        name: 'Approved Vendor',
        role: UserRole.vendor,
        status: UserAccountStatus.approved,
      );
      final openVendor = Vendor(
        id: vendorId,
        userId: userId,
        shopName: 'Open Shop',
        isOpen: true,
      );

      expect(
        ProductCatalogPolicy.isConsumerVisibleProduct(
          product,
          vendorUser: approvedUser,
          vendor: openVendor,
        ),
        isTrue,
      );

      expect(
        ProductCatalogPolicy.isConsumerVisibleProduct(
          product,
          vendorUser: approvedUser,
          vendor: openVendor.copyWith(isOpen: false),
        ),
        isFalse,
      );

      expect(
        ProductCatalogPolicy.isConsumerVisibleProduct(
          product.copyWith(isDeleted: true),
          vendorUser: User(
            authUserId: UuidValue.fromString(
              '00000000-0000-0000-0000-000000000005',
            ),
            name: 'Approved Vendor',
            role: UserRole.vendor,
            status: UserAccountStatus.approved,
          ),
        ),
        isFalse,
      );

      expect(
        ProductCatalogPolicy.isConsumerVisibleProduct(
          product.copyWith(status: ProductStatus.removed),
          vendorUser: User(
            authUserId: UuidValue.fromString(
              '00000000-0000-0000-0000-000000000004',
            ),
            name: 'Approved Vendor',
            role: UserRole.vendor,
            status: UserAccountStatus.approved,
          ),
        ),
        isFalse,
      );
    });
  });

  group('ProductPricing offer detection for dashboard feeds', () {
    test('marks percentage discount as active offer', () {
      final product = Product(
        vendorId: UuidValue.fromString('00000000-0000-0000-0000-000000000010'),
        name: 'Offer chair',
        description: 'Test',
        price: 1000,
        discountPercentage: 20,
        isOffer: true,
      );

      expect(ProductPricing.hasActiveOffer(product), isTrue);
      expect(ProductPricing.effectiveUnitPrice(product), 800);
    });
  });
}
