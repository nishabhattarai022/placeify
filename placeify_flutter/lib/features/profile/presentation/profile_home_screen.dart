import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/placeify_bottom_nav.dart';
import '../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../orders/presentation/providers/customer_in_app_notifications_provider.dart';
import '../../orders/presentation/providers/orders_provider.dart';
import '../../vendor/domain/constants/vendor_routes.dart';
import '../../vendor/domain/enums/vendor_status.dart';
import '../../vendor/presentation/widgets/vendor_status_gate_sheets.dart';
import '../data/profile_menu_config.dart';
import 'providers/profile_dashboard_provider.dart';
import 'widgets/profile_hero.dart';
import 'widgets/profile_menu_tile.dart';
import 'widgets/profile_orders_tile.dart';

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
    PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(title: 'More'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.settings_outlined,
                color: AppColors.textSecondary,
              ),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                context.pushNamed('profileSettings');
              },
            ),
          ],
        );
      },
    );
  }

  void _onStatTap(int index) {
    switch (index) {
      case 0:
        context.pushNamed('profileOrders');
      case 1:
        context.go('/bookmarks');
      case 2:
        context.pushNamed('profileRoomSnapshots');
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
      case ProfileMenuRoute.savedRooms:
        context.pushNamed('profileRoomSnapshots');
      case ProfileMenuRoute.augmentedReality:
        context.pushNamed('profileArHistory');
      case ProfileMenuRoute.refund:
        context.pushNamed('profileRefund');
      case ProfileMenuRoute.notifications:
        context.pushNamed('profileNotifications');
      case ProfileMenuRoute.password:
        context.pushNamed('profilePassword');
      case ProfileMenuRoute.editProfile:
        context.pushNamed('profileEdit');
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
        context.pushNamed('profileApplicationPending');
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

  @override
  Widget build(BuildContext context) {
    // Keep customer order/notification streams alive on the main profile shell.
    ref.watch(customerInAppNotificationsProvider);
    ref.watch(ordersProvider);
    ref.watch(profileDashboardProvider);

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
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
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
                          if (i == 2)
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
