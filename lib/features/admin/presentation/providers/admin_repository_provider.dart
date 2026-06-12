import 'package:placeify/core/providers/shared_preferences_provider.dart';
import 'package:placeify/features/admin/data/mock/mock_admin_repository.dart';
import 'package:placeify/features/admin/domain/repositories/admin_repository.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'vendor_application_repository_provider.dart';

part 'admin_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AdminRepository> adminRepository(Ref ref) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  final prefs = ref.watch(sharedPreferencesProvider);
  final applicationRepo =
      await ref.watch(vendorApplicationRepositoryProvider.future);
  return MockAdminRepository(authRepo, prefs, applicationRepo);
}
