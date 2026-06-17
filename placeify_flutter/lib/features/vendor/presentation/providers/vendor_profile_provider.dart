import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/hybrid_vendor_repository.dart';
import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_product_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart'
    as models;
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_product_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_profile_provider.g.dart';

@Riverpod(keepAlive: true)
VendorRepository vendorRepository(Ref ref) {
  return HybridVendorRepository();
}

@Riverpod(keepAlive: true)
VendorProductRepository vendorProductRepository(Ref ref) {
  return const ServerpodVendorProductRepository();
}

@riverpod
class VendorProfile extends _$VendorProfile {
  @override
  Future<models.VendorProfile?> build() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return null;
    }
    final repo = ref.watch(vendorRepositoryProvider);
    return repo.getProfile(user!.vendorId!);
  }

  Future<void> updateProfile(models.VendorProfile updated) async {
    final previous = state;
    final current = state.value;
    if (current == null) {
      throw Exception('No vendor profile loaded.');
    }

    state = AsyncData(updated);

    try {
      final repo = ref.read(vendorRepositoryProvider);
      final saved = await repo.updateProfile(updated);
      state = AsyncData(saved);
    } catch (error) {
      state = previous;
      rethrow;
    }
  }

  Future<void> updateLogo(String localPath) async {
    final previous = state;
    final current = state.value;
    if (current == null) {
      throw Exception('No vendor profile loaded.');
    }

    final optimistic = current.copyWith(logoUrl: localPath);
    state = AsyncData(optimistic);

    try {
      final repo = ref.read(vendorRepositoryProvider);
      final saved = await repo.updateProfile(optimistic);
      state = AsyncData(saved);
    } catch (error) {
      state = previous;
      rethrow;
    }
  }

  Future<void> updateBanner(String localPath) async {
    final previous = state;
    final current = state.value;
    if (current == null) {
      throw Exception('No vendor profile loaded.');
    }

    final optimistic = current.copyWith(bannerUrl: localPath);
    state = AsyncData(optimistic);

    try {
      final repo = ref.read(vendorRepositoryProvider);
      final saved = await repo.updateProfile(optimistic);
      state = AsyncData(saved);
    } catch (error) {
      state = previous;
      rethrow;
    }
  }
}
