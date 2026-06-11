import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../chairs_catalog_tokens.dart';

class ChairsCatalogHeader extends StatelessWidget {
  const ChairsCatalogHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: ChairsCatalogTokens.titleStyle),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(
            left: ChairsCatalogTokens.subtitleLeftIndent,
          ),
          child: Text(subtitle, style: ChairsCatalogTokens.subtitleStyle),
        ),
        const SizedBox(height: ChairsCatalogTokens.headerToGridGap),
        Row(
          children: [
            _FilterCircleButton(
              iconAsset: 'assets/icons/ic_search.svg',
              label: 'Search',
              onTap: () => PlaceifyToast.show(context, 'Search'),
            ),
            const SizedBox(width: ChairsCatalogTokens.filterButtonGap),
            _FilterCircleButton(
              iconAsset: 'assets/icons/ic_sliders.svg',
              label: 'Filter',
              onTap: () => PlaceifyToast.show(context, 'Filter'),
            ),
            const SizedBox(width: ChairsCatalogTokens.filterButtonGap),
            _FilterCircleButton(
              icon: Icons.sort,
              label: 'Sort',
              onTap: () => PlaceifyToast.show(context, 'Sort'),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterCircleButton extends StatelessWidget {
  const _FilterCircleButton({
    required this.label,
    required this.onTap,
    this.iconAsset,
    this.icon,
  }) : assert(iconAsset != null || icon != null);

  final String? iconAsset;
  final IconData? icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await HapticService.selection();
        onTap();
      },
      child: Container(
        width: ChairsCatalogTokens.filterButtonSize,
        height: ChairsCatalogTokens.filterButtonSize,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: ChairsCatalogTokens.filterBorder),
        ),
        child: Center(
          child: iconAsset != null
              ? SvgPicture.asset(
                  iconAsset!,
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(icon, size: 22, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
