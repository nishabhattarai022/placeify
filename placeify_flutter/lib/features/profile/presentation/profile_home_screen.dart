import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/placeify_bottom_nav.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../vendor/domain/constants/vendor_routes.dart';
import '../../vendor/domain/enums/vendor_status.dart';
import '../../vendor/presentation/widgets/vendor_status_gate_sheets.dart';
import '../data/profile_menu_config.dart';
import '../../home/presentation/providers/wishlist_provider.dart';
import '../../home/presentation/providers/wishlist_count.dart';
import 'widgets/profile_hero.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_orders_tile.dart';
import 'providers/profile_dashboard_provider.dart';

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
      ref.read(profileDashboardProvider.notifier).refresh();
      ref.read(wishlistProvider.notifier).refresh();
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
              leading: const Icon(Icons.settings_outlined),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.pushNamed('profileSettings');
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
        context.pushNamed('profileOrders');
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
        context.pushNamed('profileOrders');
      case ProfileMenuRoute.wishlist:
        context.go('/bookmarks');
      case ProfileMenuRoute.augmentedReality:
        context.pushNamed('profileAugmentedReality');
      case ProfileMenuRoute.refund:
        context.pushNamed('profileRefund');
      case ProfileMenuRoute.notifications:
        context.pushNamed('profileNotifications');
      case ProfileMenuRoute.password:
        context.pushNamed('profilePassword');
      case ProfileMenuRoute.vendor:
        break;
      case ProfileMenuRoute.signOut:
        _signOut();
    }
  }

  void _onVendorTileTap(VendorStatus status) {
    switch (status) {
      case VendorStatus.none:
        context.push(VendorRoutes.register);
      case VendorStatus.pending:
        VendorStatusGateSheets.showPending(context);
      case VendorStatus.approved:
        context.push(VendorRoutes.dashboard);
      case VendorStatus.suspended:
        VendorStatusGateSheets.showSuspended(context);
    }
  }

  Future<void> _signOut() async {
    await ref.read(currentUserProvider.notifier).signOut();
    if (!mounted) return;
    PlaceifyToast.show(context, 'Signed out');
    context.go('/splash');
  }

  ProfileMenuItemData _overviewMenuItem(ProfileMenuItemData item) {
    if (item.route != ProfileMenuRoute.wishlist) return item;

    final count = readWishlistCount(ref);
    final subtitle = count == 0
        ? 'No saved items'
        : '$count saved item${count == 1 ? '' : 's'}';

    return ProfileMenuItemData(
      title: item.title,
      subtitle: subtitle,
      icon: item.icon,
      iconColor: item.iconColor,
      backgroundColor: item.backgroundColor,
      route: item.route,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(wishlistProvider);
    ref.listen(profileDashboardProvider, (previous, next) {
      reconcileWishlistWithDashboard(ref);
    });

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final userAsync = ref.watch(currentUserProvider);
    final vendorStatus = userAsync.value?.vendorStatus ?? VendorStatus.none;
    final vendorTile = ProfileMenuItems.vendorTile(vendorStatus);

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
                        ProfileOrdersTile(
                          onTap: () => _onMenuTap(ProfileMenuRoute.orders),
                        ),
                        for (var i = 0;
                            i < ProfileMenuItems.accountOverview.length;
                            i++) ...[
                          if (i == 3)
                            const Divider(
                              height: 16,
                              color: AppColors.creamDark,
                            ),
                          ProfileMenuTile(
                            item: _overviewMenuItem(
                              ProfileMenuItems.accountOverview[i],
                            ),
                            onTap: () => _onMenuTap(
                              ProfileMenuItems.accountOverview[i].route,
                            ),
                          ),
                        ],
                        const Divider(
                          height: 16,
                          color: AppColors.creamDark,
                        ),
                        ProfileMenuTile(
                          item: vendorTile,
                          onTap: () => _onVendorTileTap(vendorStatus),
                        ),
                        const Divider(
                          height: 16,
                          color: AppColors.creamDark,
                        ),
                        ProfileMenuTile(
                          item: ProfileMenuItems.signOut,
                          onTap: () => _onMenuTap(ProfileMenuRoute.signOut),
                        ),
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
