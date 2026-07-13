import 'package:placeify_flutter/core/providers/shared_preferences_provider.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_registration_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_registration_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<VendorRegistrationRepository> vendorRegistrationRepository(
  Ref ref,
) async {
  return ServerpodVendorRegistrationRepository();
}
