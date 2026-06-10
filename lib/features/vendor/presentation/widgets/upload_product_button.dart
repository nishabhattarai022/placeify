import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/widgets/animated_scale_tap.dart';

class UploadProductButton extends StatelessWidget {
  const UploadProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      pressScale: 0.97,
      onTap: () => context.push(VendorRoutes.productsUpload),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.espresso,
          borderRadius: AppRadii.md,
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/ic_upload.svg',
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.warmWhite,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload New Product',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmWhite,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Images · 3D Model · Pricing',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0x6BFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
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
    );
  }
}
