// Triggers catalog seed and prints shop listing from the running server.
//
// From placeify_flutter:
//   dart run tool/seed_catalog.dart

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

Future<void> main() async {
  final storage = _Mem();
  final client = Client('http://127.0.0.1:8080/')
    ..authSessionManager = ClientAuthSessionManager(storage: storage);

  final cats = await client.product.listCategories();
  print('categories=${cats.length}');

  final shops = await client.product.listApprovedShops();
  print(
    'shops=${shops.length} names=${shops.map((s) => s.businessName).join(", ")}',
  );

  final page = await client.product.searchProducts(
    ProductSearchInput(pagination: PaginationInput(page: 1, pageSize: 50)),
  );
  print('products=${page.total}');
}

class _Mem implements ClientAuthSuccessStorage {
  AuthSuccess? a;

  @override
  Future<AuthSuccess?> get() async => a;

  @override
  Future<void> set(AuthSuccess? authSuccess) async => a = authSuccess;

  @override
  Future<void> delete() async => a = null;
}
