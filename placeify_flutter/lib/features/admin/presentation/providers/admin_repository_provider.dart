import 'package:placeify_flutter/core/providers/shared_preferences_provider.dart';
import 'package:placeify_flutter/features/admin/data/mock/mock_admin_repository.dart';
import 'package:placeify_flutter/features/admin/data/resilient_admin_repository.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_repository.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/admin_repository.dart';
import 'package:placeify_flutter/features/auth/data/serverpod_auth_repository.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'vendor_application_repository_provider.dart';

part 'admin_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AdminRepository> adminRepository(Ref ref) async {
  final authRepo = await ref.watch(authRepositoryProvider.future);
  final prefs = ref.watch(sharedPreferencesProvider);
  final applicationRepo = await ref.watch(
    vendorApplicationRepositoryProvider.future,
  );
  final local = MockAdminRepository(authRepo, prefs, applicationRepo);

  if (authRepo is ServerpodAuthRepository) {
    return ResilientAdminRepository(
      remote: ServerpodAdminRepository(const ServerpodAdminApi()),
      local: local,
    );
  }

  return local;
}
