import 'package:placeify_server/src/generated/protocol.dart';
import 'package:placeify_server/src/modules/vendor/stores/vendor_product_store.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import '../../integration/test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Vendor product lifecycle', (sessionBuilder, endpoints) {
    late VendorProductStore productStore;

    setUp(() {
      productStore = VendorProductStore();
    });

    test('vendor soft delete and restore toggles catalog visibility flags', () async {
      final setup = sessionBuilder.build();
      final auth = await AuthUsers().create(setup);
      final user = await User.db.insertRow(
        setup,
        User(
          authUserId: auth.id,
          email: 'vendor-delete@test.com',
          name: 'Delete Vendor',
          role: UserRole.vendor,
          status: UserAccountStatus.approved,
        ),
      );
      final vendor = await Vendor.db.insertRow(
        setup,
        Vendor(
          userId: user.id!,
          shopName: 'Delete Shop',
          description: 'Test',
          businessAddress: 'Kathmandu',
        ),
      );
      final product = await Product.db.insertRow(
        setup,
        Product(
          vendorId: vendor.id!,
          name: 'Lifecycle Chair',
          description: 'Soft delete test',
          price: 1200,
          materials: 'Wood',
          widthCm: 40,
          depthCm: 40,
          heightCm: 80,
          careInstructions: 'Wipe',
          status: ProductStatus.active,
        ),
      );
      await setup.close();

      final session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          auth.id.toString(),
          {},
        ),
      );

      final deleted = await productStore.deleteProduct(
        session.build(),
        product.id!,
      );
      expect(deleted.isDeleted, isTrue);
      expect(deleted.deletedAt, isNotNull);

      final restored = await productStore.restoreProduct(
        session.build(),
        product.id!,
      );
      expect(restored.isDeleted, isFalse);
      expect(restored.deletedAt, isNull);
      expect(restored.status, ProductStatus.active);
    });
  });
}
