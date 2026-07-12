import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../domain/enums/vendor_application_list_filter.dart';
import '../domain/models/vendor_application.dart';
import '../domain/repositories/vendor_application_repository.dart';
import 'admin_platform_mapper.dart';
import 'serverpod_admin_api.dart';

/// Lists and moderates vendor applications via Serverpod admin APIs.
class ServerpodVendorApplicationRepository
    implements VendorApplicationRepository {
  ServerpodVendorApplicationRepository(this._api);

  final ServerpodAdminApi _api;

  @override
  Future<List<VendorApplication>> listApplications({
    VendorApplicationListFilter? filter,
  }) async {
    try {
      final applications = await client.admin.listVendorApplications(
        status: AdminPlatformMapper.toApiStatus(filter),
      );
      return applications.map(AdminPlatformMapper.toVendorApplication).toList();
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  @override
  Future<VendorApplication?> getByVendorId(String vendorId) async {
    try {
      final detail = await client.admin.getVendorApplication(
        UuidValue.fromString(vendorId),
      );
      if (detail == null) return null;
      return AdminPlatformMapper.toVendorApplicationDetail(detail);
    } catch (error) {
      throw AdminApiException(_mapError(error));
    }
  }

  @override
  Future<void> approve({
    required String userId,
    required String vendorId,
  }) async {
    await _api.approveVendor(userId);
  }

  @override
  Future<void> decline({
    required String userId,
    String? note,
  }) async {
    await _api.rejectVendor(userId);
  }

  String _mapError(Object error) {
    if (error is AdminApiException) return error.message;
    if (error is PlaceifyException) return error.message;
    if (error is ServerpodClientException) return error.message;
    return error.toString();
  }
}
