import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../core/widgets/placeify_bottom_nav.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/presentation/account_mode_actions.dart';
import '../data/profile_menu_config.dart';
import 'widgets/account_mode_card.dart';
import 'widgets/profile_hero.dart';
import 'widgets/profile_menu_tile.dart';

class ProfileHomeScreen extends ConsumerStatefulWidget {
  const ProfileHomeScreen({super.key});

  @override
  ConsumerState<ProfileHomeScreen> createState() => _ProfileHomeScreenState();
}

class _ProfileHomeScreenState extends ConsumerState<ProfileHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentUserProvider.notifier).refresh();
    });
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.storefront_outlined),
              title: Text(
                ref.watch(currentUserProvider).value?.hasVendorShop == true
                    ? 'Vendor dashboard'
                    : 'Register as vendor',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                openVendorExperience(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                PlaceifyToast.show(context, 'Settings');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onStatTap(int index) {
    switch (index) {
      case 0:
        context.pushNamed('cart');
      case 1:
        context.go('/bookmarks');
      case 2:
        context.pushNamed('profileAugmentedReality');
      case 3:
        context.pushNamed('profileRefund');
    }
  }

  void _onMenuTap(ProfileMenuRoute route) {
    switch (route) {
      case ProfileMenuRoute.orders:
        context.pushNamed('cart');
      case ProfileMenuRoute.wishlist:
        context.pushNamed('profileWishlist');
      case ProfileMenuRoute.augmentedReality:
        context.pushNamed('profileAugmentedReality');
      case ProfileMenuRoute.refund:
        context.pushNamed('profileRefund');
      case ProfileMenuRoute.notifications:
        context.pushNamed('profileNotifications');
      case ProfileMenuRoute.password:
        context.pushNamed('profilePassword');
      case ProfileMenuRoute.signOut:
        _signOut();
    }
  }

  Future<void> _signOut() async {
    await ref.read(currentUserProvider.notifier).signOut();
    if (!mounted) return;
    PlaceifyToast.show(context, 'Signed out');
    context.go('/splash');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileHero(
            onMoreTap: _showMoreMenu,
            onStatTap: _onStatTap,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.warmWhite,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ProfileMenuConfig.sheetTopRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Text(
                      'Account Overview',
                      style: TextStyle(
                        fontFamily: 'Fraunces',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        BottomNavTokens.scrollBottomPadding + bottomInset,
                      ),
                      children: [
                        const AccountModeCard(),
                        for (var i = 0;
                            i < ProfileMenuItems.accountOverview.length;
                            i++) ...[
                          if (i == 4 || i == 6)
                            const Divider(
                              height: 16,
                              color: AppColors.creamDark,
                            ),
                          ProfileMenuTile(
                            item: ProfileMenuItems.accountOverview[i],
                            onTap: () => _onMenuTap(
                              ProfileMenuItems.accountOverview[i].route,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
