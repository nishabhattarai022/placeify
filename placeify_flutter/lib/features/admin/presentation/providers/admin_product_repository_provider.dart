import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_product_repository.dart';
import 'package:placeify_flutter/features/admin/domain/repositories/admin_product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_product_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AdminProductRepository adminProductRepository(Ref ref) {
  return ServerpodAdminProductRepository(const ServerpodAdminApi());
}
