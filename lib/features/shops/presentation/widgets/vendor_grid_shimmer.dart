import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import 'package:placeify/core/constants/app_colors.dart';

/// Sliver shimmer grid that mirrors the real [VendorMasonryGrid] layout.
///
/// Tile distribution follows an AABAB pattern:
///   - Tier A placeholder: banner rect (4:3) + 3 text lines
///   - Tier B placeholder: small square (56×56) + 2 text lines
///
/// Must be used inside a [CustomScrollView].
class VendorGridShimmer extends StatelessWidget {
  const VendorGridShimmer({super.key, this.tileCount = 10});

  final int tileCount;

  // AABAB pattern: index 0,1 → A; index 2 → B; index 3 → A; index 4 → B …
  static bool _isTierA(int index) {
    // Groups of 5: positions 0,1,3 are A; positions 2,4 are B.
    final pos = index % 5;
    return pos != 2 && pos != 4;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final crossCount = w > 600 ? 3 : 2;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemBuilder: (context, index) => _isTierA(index)
            ? const _TierAShimmerTile()
            : const _TierBShimmerTile(),
        childCount: tileCount,
      ),
    );
  }
}

// ── Shared shimmer wrapper ─────────────────────────────────────────────────────

class _ShimmerWrap extends StatelessWidget {
  const _ShimmerWrap({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.creamDark,
      highlightColor: AppColors.cream,
      child: child,
    );
  }
}

// ── Tier A placeholder ─────────────────────────────────────────────────────────

class _TierAShimmerTile extends StatelessWidget {
  const _TierAShimmerTile();

  @override
  Widget build(BuildContext context) {
    return _ShimmerWrap(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner rect (4:3)
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.creamDark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name line
                  _ShimmerBox(width: double.infinity, height: 18),
                  const SizedBox(height: 6),
                  // Second name line (shorter)
                  _ShimmerBox(width: 110, height: 14),
                  const SizedBox(height: 6),
                  // Meta line
                  _ShimmerBox(width: 140, height: 12),
                  const SizedBox(height: 10),
                  // Pill
                  _ShimmerBox(width: 72, height: 24, radius: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tier B placeholder ─────────────────────────────────────────────────────────

class _TierBShimmerTile extends StatelessWidget {
  const _TierBShimmerTile();

  @override
  Widget build(BuildContext context) {
    return _ShimmerWrap(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo square
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.creamDark,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(width: double.infinity, height: 16),
                        const SizedBox(height: 6),
                        _ShimmerBox(width: 90, height: 12),
                        const SizedBox(height: 4),
                        _ShimmerBox(width: 110, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Pill
              _ShimmerBox(width: 72, height: 24, radius: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper ─────────────────────────────────────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
