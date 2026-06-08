import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../../../../core/widgets/toast_overlay.dart';

class VendorShowroomBanner extends StatelessWidget {
  const VendorShowroomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: AnimatedScaleTap(
        pressScale: 0.98,
        onTap: () => PlaceifyToast.show(context, 'Opening Showroom…'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.charcoal,
            borderRadius: AppRadii.md,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'V',
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warmWhite,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Showroom',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warmWhite,
                      ),
                    ),
                    Text(
                      '124 Design District, Portland',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warmWhite.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/ic_arrow_right.svg',
                    width: 16,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withValues(alpha: 0.65),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
