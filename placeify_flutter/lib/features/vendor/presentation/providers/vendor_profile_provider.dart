import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/auth/domain/models/app_user.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/hybrid_vendor_repository.dart';
import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_product_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart'
    as models;
import 'package:placeify_flutter/features/vendor/domain/models/vendor_social_links.dart';
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
    final user = ref.watch(currentUserProvider).value;
    if (user == null || !user.canLoadVendorPortal) {
      return null;
    }

    if (user.isVendorAccount) {
      try {
        return await _loadServerShopProfile();
      } catch (_) {
        return _fallbackProfile(user);
      }
    }

    final vendorId = user.vendorId;
    if (vendorId == null) return null;

    final repo = ref.watch(vendorRepositoryProvider);
    return repo.getProfile(vendorId);
  }

  Future<models.VendorProfile> _loadServerShopProfile() async {
    final detail = await client.vendor.getMyProfile();
    return models.VendorProfile(
      id: detail.id.toString(),
      businessName: detail.businessName,
      email: detail.email,
      phone: detail.phone,
      address: detail.address,
      logoUrl: detail.logoUrl,
      bio: detail.bio,
      bannerUrl: detail.bannerUrl,
      tags: detail.category.trim().isEmpty ? const [] : [detail.category],
      socialLinks: VendorSocialLinks(
        instagram: detail.instagramHandle,
        facebook: detail.facebookHandle,
      ),
      createdAt: detail.createdAt,
    );
  }

  models.VendorProfile _fallbackProfile(AppUser user) {
    return models.VendorProfile(
      id: user.vendorId ?? user.id,
      businessName: user.fullName,
      email: user.email,
      phone: user.phone ?? '',
      address: user.address ?? '',
      createdAt: DateTime.now(),
    );
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
