import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';

/// Home hero: title, profile avatar, and search bar (mockup header).
class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  static const _avatarAsset =
      'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Text(
                'Find Your\nDream Furniture',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  height: 1.1,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                HapticService.light();
                context.go('/profile');
              },
              child: Semantics(
                button: true,
                label: 'Profile',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFF5D4C8),
                  backgroundImage: const AssetImage(_avatarAsset),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _HomeSearchBar(),
      ],
    );
  }
}

class _HomeSearchBar extends StatelessWidget {
  const _HomeSearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      padding: const EdgeInsets.fromLTRB(18, 0, 8, 0),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_search.svg',
            width: 22,
            height: 22,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => PlaceifyToast.show(context, 'Search coming soon'),
              behavior: HitTestBehavior.opaque,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB0B0B0),
                  ),
                ),
              ),
            ),
          ),
          _SearchFilterButton(
            onTap: () => PlaceifyToast.show(context, 'Filters coming soon'),
          ),
        ],
      ),
    );
  }
}

class _SearchFilterButton extends StatelessWidget {
  const _SearchFilterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.selection();
        onTap();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/icons/ic_sliders.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.textPrimary,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
