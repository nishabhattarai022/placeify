import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/product/product_repository.dart';
import 'package:placeify_server/src/modules/product/product_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

Future<({TestSessionBuilder session, User user})> _seedApprovedVendor(
  TestSessionBuilder sessionBuilder,
  Session setup,
  String suffix,
) async {
  final auth = await AuthUsers().create(setup);
  final user = await User.db.insertRow(
    setup,
    User(
      authUserId: auth.id,
      email: 'vendor-$suffix@example.com',
      name: 'Vendor $suffix',
      role: UserRole.vendor,
      status: UserAccountStatus.approved,
    ),
  );
  final vendor = await Vendor.db.insertRow(
    setup,
    Vendor(
      userId: user.id!,
      shopName: 'Shop $suffix',
      description: 'Test shop',
      businessAddress: 'Kathmandu',
    ),
  );
  await setup.close();

  return (
    session: sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        auth.id.toString(),
        {},
      ),
    ),
    user: user,
  );
}

void main() {
  withServerpod('Marketplace highlights', (sessionBuilder, endpoints) {
    test('includes vendor uploads in global consumer feeds', () async {
      final setup = sessionBuilder.build();
      final vendor = await _seedApprovedVendor(sessionBuilder, setup, 'highlights');

      final category = await Category.db.insertRow(
        vendor.session.build(),
        Category(name: 'chairs-${DateTime.now().microsecondsSinceEpoch}'),
      );

      final catalog = CatalogRepository();
      final session = vendor.session.build();

      final standard = await Product.db.insertRow(
        session,
        Product(
          vendorId: (await Vendor.db.findFirstRow(
            session,
            where: (row) => row.userId.equals(vendor.user.id!),
          ))!
              .id!,
          categoryId: category.id,
          name: 'Standard Chair',
          description: 'New listing',
          price: 2500,
          materials: 'Wood',
          widthCm: 50,
          depthCm: 50,
          heightCm: 90,
          careInstructions: 'Wipe clean',
          status: ProductStatus.active,
          thumbnailUrl: '/uploads/test-chair.jpg',
        ),
      );

      final offer = await Product.db.insertRow(
        session,
        Product(
          vendorId: standard.vendorId,
          categoryId: category.id,
          name: 'Offer Sofa',
          description: 'Discounted listing',
          price: 5000,
          discountPrice: 4000,
          featured: true,
          isOffer: true,
          materials: 'Fabric',
          widthCm: 180,
          depthCm: 90,
          heightCm: 85,
          careInstructions: 'Vacuum',
          status: ProductStatus.active,
          thumbnailUrl: '/uploads/test-sofa.jpg',
        ),
      );

      final highlights = await catalog.marketplaceHighlights(session);
      expect(highlights.recentProducts.map((p) => p.id), contains(standard.id));
      expect(highlights.recentProducts.map((p) => p.id), contains(offer.id));
      expect(highlights.featuredProducts.map((p) => p.id), contains(offer.id));
      expect(highlights.offerProducts.map((p) => p.id), contains(offer.id));
      expect(highlights.offerProducts.first.discountPrice, 4000);

      final offersPage = await catalog.searchProducts(
        session,
        ProductSearchInput(offersOnly: true),
      );
      expect(offersPage.items.map((p) => p.id), contains(offer.id));
      expect(offersPage.items.map((p) => p.id), isNot(contains(standard.id)));

      final service = ProductService(repository: catalog);
      final apiHighlights = await service.getMarketplaceHighlights(session);
      expect(apiHighlights.offerProducts, isNotEmpty);
    });

    test('excludes products from unapproved vendors', () async {
      final setup = sessionBuilder.build();
      final auth = await AuthUsers().create(setup);
      final pendingUser = await User.db.insertRow(
        setup,
        User(
          authUserId: auth.id,
          email: 'pending@example.com',
          name: 'Pending Vendor',
          role: UserRole.consumer,
          status: UserAccountStatus.pending,
        ),
      );
      final pendingVendor = await Vendor.db.insertRow(
        setup,
        Vendor(
          userId: pendingUser.id!,
          shopName: 'Pending Shop',
          description: 'Should not appear',
          businessAddress: 'Kathmandu',
        ),
      );
      await Product.db.insertRow(
        setup,
        Product(
          vendorId: pendingVendor.id!,
          name: 'Hidden Chair',
          description: 'Pending vendor product',
          price: 1000,
          materials: 'Wood',
          widthCm: 50,
          depthCm: 50,
          heightCm: 90,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );
      await setup.close();

      final catalog = CatalogRepository();
      final highlights = await catalog.marketplaceHighlights(
        sessionBuilder.build(),
      );
      expect(highlights.recentProducts, isEmpty);
      expect(highlights.offerProducts, isEmpty);
    });
  });
}
