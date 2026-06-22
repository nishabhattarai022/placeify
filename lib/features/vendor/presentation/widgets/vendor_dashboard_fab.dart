import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_durations.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_shadows.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/features/vendor/domain/constants/vendor_routes.dart';

class VendorDashboardFab extends StatefulWidget {
  const VendorDashboardFab({super.key});

  @override
  State<VendorDashboardFab> createState() => _VendorDashboardFabState();
}

class _VendorDashboardFabState extends State<VendorDashboardFab>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.mid,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticService.light();
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _collapse() {
    if (!_expanded) return;
    setState(() => _expanded = false);
    _controller.reverse();
  }

  void _onAddProduct() {
    _collapse();
    context.push(VendorRoutes.productsUpload);
  }

  void _onViewOrders() {
    _collapse();
    context.go(VendorRoutes.orders);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: BottomNavTokens.fabBottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizeTransition(
            sizeFactor: _expandAnimation,
            axisAlignment: -1,
            child: FadeTransition(
              opacity: _expandAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _QuickActionChip(
                    label: 'Add Product',
                    iconPath: 'assets/icons/ic_upload.svg',
                    onTap: _onAddProduct,
                  ),
                  const SizedBox(height: 10),
                  _QuickActionChip(
                    label: 'View Orders',
                    iconPath: 'assets/icons/ic_box.svg',
                    onTap: _onViewOrders,
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: _toggle,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _expanded ? AppColors.espresso : AppColors.vendorForest,
                shape: BoxShape.circle,
                boxShadow: AppShadows.soft,
              ),
              child: Center(
                child: AnimatedRotation(
                  turns: _expanded ? 0.125 : 0,
                  duration: AppDurations.mid,
                  curve: Curves.easeOutCubic,
                  child: SvgPicture.asset(
                    _expanded
                        ? 'assets/icons/ic_x.svg'
                        : 'assets/icons/ic_plus.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.warmWhite,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: AppRadii.md,
          boxShadow: AppShadows.soft,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.vendorForestBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.vendorForest,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
