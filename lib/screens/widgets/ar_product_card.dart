import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/core/widgets/placeify_image.dart';
import 'package:placeify/data/furniture_categories.dart';
import 'package:placeify/features/ar/domain/constants/ar_strings.dart';
import 'package:placeify/features/ar/presentation/utils/ar_relative_time.dart';
import 'package:placeify/features/home/domain/models/product.dart';

const _kAccent = Color(0xFFB5654B);
const _kCardRadius = 22.0;

/// Masonry tile for a saved AR product — mirrors [VendorCardFull] layout.
class ArProductCard extends StatefulWidget {
  const ArProductCard({
    required this.product,
    required this.savedAt,
    required this.onTap,
    this.selectionMode = false,
    this.isSelected = false,
    super.key,
  });

  final Product product;
  final DateTime savedAt;
  final VoidCallback onTap;
  final bool selectionMode;
  final bool isSelected;

  @override
  State<ArProductCard> createState() => _ArProductCardState();
}

class _ArProductCardState extends State<ArProductCard> {
  bool _pressed = false;

  String get _categoryLabel {
    final category = furnitureCategoryById(widget.product.categoryId);
    return category?.name ?? widget.product.brand;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Semantics(
      label: '${product.name}, $_categoryLabel, saved for AR',
      button: true,
      selected: widget.isSelected,
      excludeSemantics: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          HapticService.light();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_kCardRadius + 2),
              border: widget.selectionMode && widget.isSelected
                  ? Border.all(color: AppColors.accent, width: 2.5)
                  : null,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: BorderRadius.circular(_kCardRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_kCardRadius),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(
                          color: const Color(0xFFF3EFE8),
                          child: PlaceifyImage(
                            source: product.imageUrl,
                            fit: product.imageUrl.startsWith('assets/')
                                ? BoxFit.contain
                                : BoxFit.cover,
                            error: Center(
                              child: SvgPicture.asset(
                                product.svgIconPath,
                                width: 44,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.bark,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.selectionMode)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: widget.isSelected
                                    ? AppColors.accent
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.isSelected
                                      ? AppColors.accent
                                      : Colors.black26,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.10),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: widget.isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.cormorantGaramond(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: AppColors.charcoal,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _categoryLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.charcoal.withValues(alpha: 0.55),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _kAccent.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${ArStrings.savedPillPrefix} · '
                            '${arRelativeSavedLabel(widget.savedAt)}',
                            style: AppFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _kAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
