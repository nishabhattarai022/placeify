import 'package:placeify_flutter/features/admin/data/mock/mock_vendor_application_repository.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:placeify_flutter/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/vendor_application_repository.dart';

/// Uses live admin APIs for approve/reject while listing still reads local seed
/// data until a server-side application list endpoint exists.
class ServerpodVendorApplicationRepository
    implements VendorApplicationRepository {
  ServerpodVendorApplicationRepository(
    this._fallback,
    this._api,
  );

  final VendorApplicationRepository _fallback;
  final ServerpodAdminApi _api;

  @override
  Future<List<VendorApplication>> listApplications({
    VendorApplicationListFilter? filter,
  }) =>
      _fallback.listApplications(filter: filter);

  @override
  Future<VendorApplication?> getByVendorId(String vendorId) =>
      _fallback.getByVendorId(vendorId);

  @override
  Future<void> approve({
    required String userId,
    required String vendorId,
  }) async {
    await _api.approveVendor(userId);
    await _fallback.approve(userId: userId, vendorId: vendorId);
  }

  @override
  Future<void> decline({
    required String userId,
    String? note,
  }) async {
    await _api.rejectVendor(userId);
    await _fallback.decline(userId: userId, note: note);
  }
}
