import 'package:placeify/features/admin/data/config/admin_seed_data.dart';
import 'package:placeify/features/vendor/data/config/vendor_mock_config.dart';

/// Maps decorative home-screen supplier chips to real vendor storefront IDs.
abstract final class LocalSupplierVendorMap {
  static const _map = <String, String>{
    'harmony': VendorMockConfig.demoVendorId,
    'furnix': AdminSeedData.approvedVendorId,
    'forma': AdminSeedData.shopVendorNestId,
    'restwell': AdminSeedData.shopVendorNestId,
    'zenspace': AdminSeedData.shopVendorUrbanId,
    'nordic_co': AdminSeedData.shopVendorUrbanId,
    'gather': AdminSeedData.shopVendorCraftsId,
    'stow': AdminSeedData.shopVendorHimalayaId,
  };

  static String? vendorIdForSupplier(String supplierId) => _map[supplierId];
}
