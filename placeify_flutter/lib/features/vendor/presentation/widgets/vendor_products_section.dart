import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/config/resolve_media_url.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../home/presentation/providers/catalog_provider.dart';
import '../../domain/repositories/vendor_repository.dart';
import '../providers/vendor_dashboard_provider.dart';

class VendorProductsSection extends ConsumerWidget {
  const VendorProductsSection({
    required this.products,
    super.key,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your products', style: AppTypography.sectionTitle),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _ProductCard(
                product: products[index],
                onBuild3d: products[index].id == null
                    ? null
                    : () => _build3dPreview(
                          context,
                          ref,
                          products[index].id!,
                        ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _build3dPreview(
    BuildContext context,
    WidgetRef ref,
    int productId,
  ) async {
    try {
      final repo = ref.read(vendorRepositoryProvider);
      final product = await repo.regenerateProductModel3d(productId);
      final modelUrl = product.model3dUrl?.trim();
      if (modelUrl == null || modelUrl.isEmpty) {
        throw VendorRepositoryException(
          '3D preview was not created. Re-upload the product photo and try again.',
          code: 'MODEL3D_GENERATION_FAILED',
        );
      }

      if (context.mounted) {
        try {
          ref.invalidate(vendorProductsProvider);
          ref.read(catalogIndexProvider.notifier).refresh();
        } catch (_) {
          // Provider may already be rebuilding; 3D is saved on the server.
        }
        PlaceifyToast.show(
          context,
          '3D preview generated — buyers can view it on the product page',
        );
      }
    } on VendorRepositoryException catch (error) {
      if (context.mounted) {
        PlaceifyToast.show(context, error.message);
      }
    } catch (error) {
      if (context.mounted) {
        PlaceifyToast.show(
          context,
          _build3dErrorMessage(error),
        );
      }
    }
  }

  String _build3dErrorMessage(Object error) {
    final text = error.toString();
    if (text.contains('NoSuchMethodError') &&
        text.contains('regenerateProductModel3d')) {
      return 'App is out of date. Stop Flutter and run `flutter run` again (not hot reload).';
    }
    if (text.contains('SocketException') ||
        text.contains('Connection refused') ||
        text.contains('Failed host lookup')) {
      return 'Cannot reach the server. Start Docker and placeify_server, then try again.';
    }
    if (text.contains('Not found') || text.contains('No method')) {
      return 'Server is missing Build 3D. Run `serverpod generate` in placeify_server, then restart the server.';
    }
    return 'Could not build 3D preview: $text';
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    this.onBuild3d,
  });

  final Product product;
  final Future<void> Function()? onBuild3d;

  bool get _hasModel3d {
    final url = product.model3dUrl?.trim();
    return url != null && url.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: resolveMediaUrl(product.thumbnailUrl),
      builder: (context, snapshot) {
        final imageUrl = snapshot.data ?? '';
        return Container(
          width: 168,
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: AppRadii.md,
            border: Border.all(color: AppColors.creamDark),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: imageUrl.isEmpty
                    ? Container(
                        color: AppColors.cream,
                        child: const Center(
                          child: Icon(
                            Icons.chair_outlined,
                            color: AppColors.bark,
                            size: 36,
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.cream,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.currencyDecimal(product.price),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.espresso,
                      ),
                    ),
                    if (onBuild3d != null) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: onBuild3d,
                          icon: Icon(
                            _hasModel3d
                                ? Icons.view_in_ar
                                : Icons.view_in_ar_outlined,
                            size: 16,
                          ),
                          label: Text(
                            _hasModel3d ? 'Regenerate 3D' : 'Build 3D',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
