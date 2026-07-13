import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/home/data/mock_product_repository.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';
import 'package:placeify/features/vendor/data/vendor_3d_model_store.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_3d_builder_strings.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_product_3d_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_products_provider.dart';
import 'package:placeify/features/vendor/presentation/widgets/vendor_list_thumbnail.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../../core/widgets/toast_overlay.dart';

class VendorBuild3dScreen extends ConsumerStatefulWidget {
  const VendorBuild3dScreen({this.productId, super.key});

  final String? productId;

  @override
  ConsumerState<VendorBuild3dScreen> createState() =>
      _VendorBuild3dScreenState();
}

class _VendorBuild3dScreenState extends ConsumerState<VendorBuild3dScreen> {
  String? _selectedProductId;
  bool _isGenerating = false;
  double _generateProgress = 0;
  bool _modelReady = false;

  @override
  void initState() {
    super.initState();
    _selectedProductId = widget.productId;
  }

  VendorProduct? _selectedProduct(List<VendorProduct> products) {
    final id = _selectedProductId;
    if (id == null) return null;
    for (final product in products) {
      if (product.id == id) return product;
    }
    return null;
  }

  Vendor3dModelRecord? get _record {
    final id = _selectedProductId;
    if (id == null) return null;
    return Vendor3dModelStore.recordFor(id);
  }

  bool get _hasEnoughPhotos =>
      (_record?.capturedAngles.length ?? 0) >= 2;

  bool get _hasDimensions {
    final product = _selectedProduct(ref.read(vendorProductsProvider).value ?? []);
    if (product == null) return false;
    return product.widthCm > 0 && product.depthCm > 0 && product.heightCm > 0;
  }

  Future<void> _generateModel() async {
    final productId = _selectedProductId;
    if (productId == null) {
      PlaceifyToast.show(context, Vendor3dBuilderStrings.selectProductFirst);
      return;
    }
    if (!_hasEnoughPhotos) {
      PlaceifyToast.show(context, Vendor3dBuilderStrings.addPhotosFirst);
      return;
    }
    if (!_hasDimensions) {
      PlaceifyToast.show(context, Vendor3dBuilderStrings.dimensionsRequired);
      return;
    }

    HapticService.medium();
    setState(() {
      _isGenerating = true;
      _generateProgress = 0;
      _modelReady = false;
    });
    Vendor3dModelStore.markProcessing(productId);

    const steps = 24;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 90));
      if (!mounted) return;
      setState(() => _generateProgress = i / steps);
    }

    final fileName = 'model_${productId}_${DateTime.now().millisecondsSinceEpoch}.glb';
    Vendor3dModelStore.markReady(productId, modelFileName: fileName);

    if (!mounted) return;
    setState(() {
      _isGenerating = false;
      _modelReady = true;
    });
    HapticService.heavy();
    PlaceifyToast.show(context, Vendor3dBuilderStrings.modelReady);
  }

  Future<void> _attachToProduct() async {
    final products = ref.read(vendorProductsProvider).value ?? [];
    final product = _selectedProduct(products);
    if (product == null) return;

    HapticService.medium();
    final error = await ref.read(vendorProductsProvider.notifier).updateProduct(
          product.copyWith(hasArView: true),
        );

    if (!mounted) return;
    if (error != null) {
      PlaceifyToast.show(context, error);
      return;
    }

    HapticService.heavy();
    PlaceifyToast.show(context, Vendor3dBuilderStrings.modelAttached);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(vendorProductsProvider);
    final products = productsAsync.value ?? const [];
    final selected = _selectedProduct(products);
    final record = _record;
    final status = selected == null
        ? VendorProduct3dStatus.none
        : Vendor3dModelStore.statusFor(selected);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(
            title: Vendor3dBuilderStrings.screenTitle,
            subtitle: Vendor3dBuilderStrings.screenSubtitle,
          ),
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
              error: (_, __) => _EmptyState(
                message: Vendor3dBuilderStrings.noProducts,
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const _EmptyState(
                    message: Vendor3dBuilderStrings.noProducts,
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    20,
                    AppSpacing.screenPadding,
                    BottomNavTokens.scrollBottomPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionCard(
                        title: Vendor3dBuilderStrings.productSectionTitle,
                        subtitle: Vendor3dBuilderStrings.productSectionHint,
                        child: _ProductSelector(
                          products: items,
                          selectedId: _selectedProductId,
                          onSelected: (id) {
                            HapticService.selection();
                            setState(() {
                              _selectedProductId = id;
                              _modelReady = Vendor3dModelStore.statusFor(
                                items.firstWhere((p) => p.id == id),
                              ).isReady;
                            });
                          },
                          expansionFor: (product) {
                            if (product.id != _selectedProductId) {
                              return null;
                            }
                            return _SelectedProductBuildPanel(
                              product: product,
                              record: record,
                              status: status,
                              isGenerating: _isGenerating,
                              progress: _generateProgress,
                              modelReady: _modelReady || status.isReady,
                              onToggleAngle: (angle) {
                                HapticService.light();
                                setState(() {
                                  Vendor3dModelStore.toggleCapture(
                                    product.id,
                                    angle,
                                  );
                                });
                              },
                              onGenerate: _generateModel,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (selected != null &&
              (_modelReady || status.isReady) &&
              !selected.hasArView)
            _BottomAttachBar(onAttach: _attachToProduct),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _ProductSelector extends StatelessWidget {
  const _ProductSelector({
    required this.products,
    required this.selectedId,
    required this.onSelected,
    required this.expansionFor,
  });

  final List<VendorProduct> products;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final Widget? Function(VendorProduct product) expansionFor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < products.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _ProductOptionTile(
            product: products[i],
            selected: products[i].id == selectedId,
            onTap: () => onSelected(products[i].id),
          ),
          if (expansionFor(products[i]) case final expansion?) ...[
            const SizedBox(height: 12),
            expansion,
          ],
        ],
      ],
    );
  }
}

/// Build flow sections rendered directly under the selected product tile.
class _SelectedProductBuildPanel extends StatelessWidget {
  const _SelectedProductBuildPanel({
    required this.product,
    required this.record,
    required this.status,
    required this.isGenerating,
    required this.progress,
    required this.modelReady,
    required this.onToggleAngle,
    required this.onGenerate,
  });

  final VendorProduct product;
  final Vendor3dModelRecord? record;
  final VendorProduct3dStatus status;
  final bool isGenerating;
  final double progress;
  final bool modelReady;
  final ValueChanged<String> onToggleAngle;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SelectedProductPreview(product: product),
        const SizedBox(height: 12),
        _NestedSectionCard(
          title: Vendor3dBuilderStrings.captureSectionTitle,
          subtitle: Vendor3dBuilderStrings.captureSectionHint,
          child: _CaptureAngleGrid(
            captured: record?.capturedAngles ?? const {},
            onToggle: onToggleAngle,
          ),
        ),
        const SizedBox(height: 12),
        _NestedSectionCard(
          title: Vendor3dBuilderStrings.dimensionsSectionTitle,
          subtitle: Vendor3dBuilderStrings.dimensionsSectionHint,
          child: _DimensionsPanel(product: product),
        ),
        const SizedBox(height: 12),
        _NestedSectionCard(
          title: Vendor3dBuilderStrings.generateSectionTitle,
          subtitle: Vendor3dBuilderStrings.generateSectionHint,
          child: _GeneratePanel(
            status: status,
            isGenerating: isGenerating,
            progress: progress,
            modelReady: modelReady,
            modelFileName: record?.modelFileName,
            onGenerate: onGenerate,
          ),
        ),
      ],
    );
  }
}

class _NestedSectionCard extends StatelessWidget {
  const _NestedSectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.55),
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ProductOptionTile extends StatelessWidget {
  const _ProductOptionTile({
    required this.product,
    required this.selected,
    required this.onTap,
  });

  final VendorProduct product;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = Vendor3dModelStore.statusFor(product);
    final iconPath = _iconForCategory(product.categoryId);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.vendorForestBg
              : AppColors.cream.withValues(alpha: 0.35),
          borderRadius: AppRadii.md,
          border: Border.all(
            color: selected ? AppColors.vendorForest : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            VendorListThumbnail(
              label: product.name,
              imageUrl: product.primaryImageUrl,
              fallbackIconPath: iconPath,
              size: 44,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.sku,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            _StatusPill(status: status),
          ],
        ),
      ),
    );
  }

  static String _iconForCategory(String categoryId) {
    for (final category in MockProductRepository.categories) {
      if (category.id == categoryId) return category.svgIconAssetPath;
    }
    return 'assets/icons/ic_chair.svg';
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final VendorProduct3dStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      VendorProduct3dStatus.ready => (
          'AR ready',
          AppColors.sage.withValues(alpha: 0.16),
          AppColors.sage,
        ),
      VendorProduct3dStatus.processing => (
          'Processing',
          AppColors.accentBg,
          AppColors.accent,
        ),
      VendorProduct3dStatus.draft => (
          'Draft',
          AppColors.creamDark.withValues(alpha: 0.45),
          AppColors.textSecondary,
        ),
      VendorProduct3dStatus.failed => (
          'Retry',
          AppColors.coralBg,
          AppColors.coral,
        ),
      VendorProduct3dStatus.none => (
          'No model',
          AppColors.creamDark.withValues(alpha: 0.35),
          AppColors.textMuted,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _SelectedProductPreview extends StatelessWidget {
  const _SelectedProductPreview({required this.product});

  final VendorProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.vendorForestBg,
        borderRadius: AppRadii.md,
        border: Border.all(
          color: AppColors.vendorForest.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.layers_rounded,
            color: AppColors.vendorForest,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Building 3D model for ${product.name}',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.vendorForest,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptureAngleGrid extends StatelessWidget {
  const _CaptureAngleGrid({
    required this.captured,
    required this.onToggle,
  });

  final Set<String> captured;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final tileWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final angle in Vendor3dCaptureAngles.all)
              SizedBox(
                width: tileWidth,
                child: _CaptureTile(
                  angle: angle,
                  captured: captured.contains(angle),
                  onTap: () => onToggle(angle),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CaptureTile extends StatelessWidget {
  const _CaptureTile({
    required this.angle,
    required this.captured,
    required this.onTap,
  });

  final String angle;
  final bool captured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        decoration: BoxDecoration(
          color: captured ? AppColors.accentBg : AppColors.cream,
          borderRadius: AppRadii.md,
          border: Border.all(
            color: captured ? AppColors.accent : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  captured
                      ? Icons.check_circle_rounded
                      : Icons.add_a_photo_outlined,
                  size: 18,
                  color: captured ? AppColors.accent : AppColors.textSecondary,
                ),
                const Spacer(),
                if (captured)
                  Text(
                    'Added',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              Vendor3dCaptureAngles.labelFor(angle),
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Vendor3dCaptureAngles.hintFor(angle),
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AppColors.textMuted,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DimensionsPanel extends StatelessWidget {
  const _DimensionsPanel({required this.product});

  final VendorProduct product;

  @override
  Widget build(BuildContext context) {
    final hasAll =
        product.widthCm > 0 && product.depthCm > 0 && product.heightCm > 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _DimensionStat(
                label: 'Width',
                value: product.widthCm > 0 ? '${product.widthCm.round()} cm' : '—',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DimensionStat(
                label: 'Depth',
                value: product.depthCm > 0 ? '${product.depthCm.round()} cm' : '—',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _DimensionStat(
                label: 'Height',
                value:
                    product.heightCm > 0 ? '${product.heightCm.round()} cm' : '—',
              ),
            ),
          ],
        ),
        if (!hasAll) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.coralBg,
              borderRadius: AppRadii.md,
            ),
            child: Text(
              'Add width, depth, and height on the product edit screen before generating.',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.coral,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _DimensionStat extends StatelessWidget {
  const _DimensionStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneratePanel extends StatelessWidget {
  const _GeneratePanel({
    required this.status,
    required this.isGenerating,
    required this.progress,
    required this.modelReady,
    required this.onGenerate,
    this.modelFileName,
  });

  final VendorProduct3dStatus status;
  final bool isGenerating;
  final double progress;
  final bool modelReady;
  final String? modelFileName;
  final VoidCallback onGenerate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isGenerating) ...[
          ClipRRect(
            borderRadius: AppRadii.pill,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.creamDark,
              color: AppColors.vendorForest,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            Vendor3dBuilderStrings.modelProcessing,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.vendorForest,
            ),
          ),
        ] else if (modelReady) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.12),
              borderRadius: AppRadii.md,
              border: Border.all(
                color: AppColors.sage.withValues(alpha: 0.28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.sage,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        Vendor3dBuilderStrings.modelReady,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.sage,
                        ),
                      ),
                    ),
                  ],
                ),
                if (modelFileName != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    modelFileName!,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _PrimaryActionButton(
            label: Vendor3dBuilderStrings.regenerateCta,
            onTap: onGenerate,
            muted: false,
          ),
        ] else ...[
          if (status == VendorProduct3dStatus.failed)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                Vendor3dBuilderStrings.modelFailed,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.coral,
                  height: 1.4,
                ),
              ),
            ),
          _PrimaryActionButton(
            label: Vendor3dBuilderStrings.generateCta,
            onTap: onGenerate,
            muted: false,
          ),
        ],
      ],
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.onTap,
    required this.muted,
  });

  final String label;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: muted ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: muted
              ? Colors.black.withValues(alpha: 0.35)
              : Colors.black,
          borderRadius: AppRadii.pill,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.warmWhite,
          ),
        ),
      ),
    );
  }
}

class _BottomAttachBar extends StatelessWidget {
  const _BottomAttachBar({required this.onAttach});

  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 14, 24, 14 + bottom),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        border: Border(top: BorderSide(color: AppColors.creamDark, width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onAttach,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.vendorForest,
            borderRadius: AppRadii.pill,
          ),
          alignment: Alignment.center,
          child: Text(
            Vendor3dBuilderStrings.attachCta,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.warmWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.textMuted,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}
