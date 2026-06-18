import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_vendor_application_repository.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/vendor_application_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_application_repository_provider.g.dart';

@Riverpod(keepAlive: true)
VendorApplicationRepository vendorApplicationRepository(Ref ref) {
  return ServerpodVendorApplicationRepository(const ServerpodAdminApi());
}
