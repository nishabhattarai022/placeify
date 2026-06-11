import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/presentation/providers/catalog_provider.dart';
import '../../data/serverpod_vendor_repository.dart';
import '../../domain/repositories/vendor_repository.dart';

part 'vendor_dashboard_provider.g.dart';

@Riverpod(keepAlive: true)
VendorRepository vendorRepository(Ref ref) {
  return ServerpodVendorRepository();
}

final vendorProductsProvider = FutureProvider.autoDispose<List<Product>>((
  ref,
) async {
  final dashboard = await ref.watch(vendorDashboardStateProvider.future);
  if (dashboard == null) return [];
  final repo = ref.read(vendorRepositoryProvider);
  return repo.listMyProducts();
});

@Riverpod(keepAlive: true)
class VendorDashboardState extends _$VendorDashboardState {
  @override
  Future<VendorDashboard?> build() async {
    if (!client.auth.isAuthenticated) return null;

    ref.listen(currentUserProvider, (previous, next) {
      if (!client.auth.isAuthenticated) {
        state = const AsyncData(null);
        return;
      }

      final previousShop = previous?.value?.hasVendorShop;
      final nextShop = next.value?.hasVendorShop;
      if (previousShop != nextShop && next.hasValue) {
        refresh();
      }
    });

    return _loadDashboard();
  }

  Future<VendorDashboard?> _loadDashboard() async {
    if (!client.auth.isAuthenticated) return null;
    final repo = ref.read(vendorRepositoryProvider);
    try {
      return await repo.getDashboard();
    } on VendorRepositoryException catch (error) {
      if (error.isShopNotFound) return null;
      rethrow;
    }
  }

  Future<void> refresh() async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData(null);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadDashboard);
  }

  Future<void> createShop({
    required String shopName,
    required String description,
    required String phone,
    required String address,
  }) async {
    final repo = ref.read(vendorRepositoryProvider);
    await repo.createShop(
      shopName,
      description: description,
      phone: phone,
      address: address,
    );
    await ref.read(currentUserProvider.notifier).refresh();
    try {
      final dashboard = await repo.getDashboard();
      state = AsyncData(dashboard);
    } on VendorRepositoryException catch (error) {
      if (error.isShopNotFound) {
        state = const AsyncData(null);
      } else {
        rethrow;
      }
    }
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String materials,
    required double widthCm,
    required double depthCm,
    required double heightCm,
    required String careInstructions,
    required List<int> imageBytes,
    required String imageFileName,
    double? weightKg,
    String? assemblyNote,
    String? warranty,
  }) async {
    final repo = ref.read(vendorRepositoryProvider);
    await repo.createProduct(
      name: name,
      description: description,
      price: price,
      materials: materials,
      widthCm: widthCm,
      depthCm: depthCm,
      heightCm: heightCm,
      careInstructions: careInstructions,
      imageBytes: imageBytes,
      imageFileName: imageFileName,
      weightKg: weightKg,
      assemblyNote: assemblyNote,
      warranty: warranty,
    );
    await ref.read(catalogIndexProvider.notifier).refresh();
    await refresh();
  }
}
