import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/services/haptic_service.dart';
import '../providers/category_provider.dart';

class CategoryChipRow extends ConsumerWidget {
  const CategoryChipRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 106,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isActive = category.id == selected;

          return Padding(
            padding: EdgeInsets.only(right: index < categories.length - 1 ? 14 : 0),
            child: GestureDetector(
              onTap: () async {
                await HapticService.selection();
                ref.read(selectedCategoryProvider.notifier).select(category.id);
                if (context.mounted) {
                  final routeId = switch (category.id) {
                    'lights' => 'lighting',
                    'decor' => 'storage',
                    _ => category.id,
                  };
                  context.push('/browse/category/$routeId');
                }
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    transform: Matrix4.translationValues(0, isActive ? -3 : 0, 0),
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.accent.withValues(alpha: 0.10)
                          : AppColors.warmWhite,
                      borderRadius: AppRadii.md,
                      border: Border.all(
                        color: isActive ? AppColors.accent : AppColors.sand,
                        width: 1.5,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.18),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        category.svgIconAssetPath,
                        width: 28,
                        height: 28,
                        colorFilter: ColorFilter.mode(
                          isActive ? AppColors.accent : AppColors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: isActive
                        ? AppTypography.chipLabel.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          )
                        : AppTypography.chipLabel,
                    child: Text(category.label),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
