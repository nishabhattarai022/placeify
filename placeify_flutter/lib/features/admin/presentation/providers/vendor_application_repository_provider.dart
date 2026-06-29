import 'package:placeify_flutter/core/providers/shared_preferences_provider.dart';
import 'package:placeify_flutter/features/admin/data/mock/mock_vendor_application_repository.dart';
import 'package:placeify_flutter/features/admin/data/resilient_admin_repository.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_vendor_application_repository.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/vendor_application_repository.dart';
import 'package:placeify_flutter/features/auth/data/serverpod_auth_repository.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_application_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<VendorApplicationRepository> vendorApplicationRepository(
  Ref ref,
) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  final prefs = ref.watch(sharedPreferencesProvider);
  final local = MockVendorApplicationRepository(authRepo, prefs);

  if (authRepo is ServerpodAuthRepository) {
    return ResilientVendorApplicationRepository(
      remote: ServerpodVendorApplicationRepository(const ServerpodAdminApi()),
      local: local,
    );
  }

  return local;
}
