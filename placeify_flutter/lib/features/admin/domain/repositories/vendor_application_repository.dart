import 'package:placeify_flutter/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';

/// Vendor application listing and approval workflow contract.
abstract interface class VendorApplicationRepository {
  /// When [filter] is null, returns all active applications (excludes declined).
  Future<List<VendorApplication>> listApplications({
    VendorApplicationListFilter? filter,
  });

  Future<VendorApplication?> getByVendorId(String vendorId);

  Future<void> approve({
    required String userId,
    required String vendorId,
  });

  Future<void> decline({
    required String userId,
    String? note,
  });
}
