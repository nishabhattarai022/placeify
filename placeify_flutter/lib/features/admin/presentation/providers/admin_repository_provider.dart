import 'package:placeify_flutter/features/admin/data/serverpod_admin_repository.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/admin_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_repository_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AdminRepository> adminRepository(Ref ref) async {
  return ServerpodAdminRepository(const ServerpodAdminApi());
}
