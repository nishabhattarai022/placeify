import 'package:placeify/core/providers/shared_preferences_provider.dart';
import 'package:placeify/features/admin/data/mock/mock_vendor_application_repository.dart';
import 'package:placeify/features/admin/domain/repositories/vendor_application_repository.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_application_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<VendorApplicationRepository> vendorApplicationRepository(
  Ref ref,
) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  final prefs = ref.watch(sharedPreferencesProvider);
  return MockVendorApplicationRepository(authRepo, prefs);
}
