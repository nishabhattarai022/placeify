import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../vendor/domain/constants/vendor_routes.dart';
import '../../../vendor/domain/enums/vendor_status.dart';
import '../theme/home_screen_tokens.dart';

/// Hero with full-bleed image, overlaid title/subtitle, linen fade, and Discover More CTA.
class HomeExploreHero extends ConsumerWidget {
  const HomeExploreHero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorStatus =
        ref.watch(currentUserProvider).value?.vendorStatus ?? VendorStatus.none;
    final showVendorDashboard = vendorStatus == VendorStatus.approved;
    final topInset =
        MediaQuery.paddingOf(context).top + HomeScreenTokens.heroTitleTopGap;

    return SizedBox(
      height: HomeScreenTokens.heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _HeroImage(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: HomeScreenTokens.heroFadeHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    HomeScreenTokens.homeBg.withValues(alpha: 0),
                    HomeScreenTokens.homeBg,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: topInset,
              left: HomeScreenTokens.screenPadding,
              right: HomeScreenTokens.screenPadding,
            ),
            child: Text(
              'explore',
              textAlign: TextAlign.center,
              style: HomeScreenTokens.exploreTitle(),
            ),
          ),
          if (showVendorDashboard)
            Positioned(
              top: topInset,
              left: HomeScreenTokens.screenPadding,
              child: const _VendorDashboardButton(),
            ),
          Align(
            alignment: const Alignment(
              0,
              HomeScreenTokens.heroDiscoverAlign,
            ),
            child: _DiscoverMoreButton(
              onTap: () {
                HapticService.light();
                context.go('/browse');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorDashboardButton extends StatelessWidget {
  const _VendorDashboardButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open vendor dashboard',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticService.light();
            context.go(VendorRoutes.dashboard);
          },
          customBorder: const CircleBorder(),
          child: Ink(
            width: HomeScreenTokens.vendorDashboardButtonSize,
            height: HomeScreenTokens.vendorDashboardButtonSize,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dashboard_outlined,
              size: HomeScreenTokens.vendorDashboardIconSize,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      HomeScreenTokens.heroAsset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => Image.asset(
        HomeScreenTokens.heroFallbackAsset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => ColoredBox(
          color: HomeScreenTokens.homeBg,
          child: Center(
            child: Icon(
              Icons.chair_outlined,
              size: 64,
              color: Colors.black.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscoverMoreButton extends StatelessWidget {
  const _DiscoverMoreButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/ic_compass.svg',
                width: 13,
                height: 13,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Discover More',
              style: HomeScreenTokens.discoverCtaLabel(),
            ),
          ],
        ),
      ),
    );
  }
}
