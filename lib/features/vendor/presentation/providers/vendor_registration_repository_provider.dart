import 'package:placeify/core/providers/shared_preferences_provider.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/vendor/data/mock_vendor_registration_repository.dart';
import 'package:placeify/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_registration_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<VendorRegistrationRepository> vendorRegistrationRepository(
  Ref ref,
) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  final prefs = ref.watch(sharedPreferencesProvider);
  return MockVendorRegistrationRepository(authRepo, prefs);
}
