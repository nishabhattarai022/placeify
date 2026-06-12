import 'package:placeify/features/admin/domain/models/vendor_application.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';

/// Vendor application listing and approval workflow contract.
abstract interface class VendorApplicationRepository {
  Future<List<VendorApplication>> listApplications({VendorStatus? filter});

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
