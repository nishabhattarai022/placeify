import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../product_detail_tokens.dart';

class _ActionIconChip extends StatelessWidget {
  const _ActionIconChip({
    required this.icon,
    required this.size,
    required this.iconSize,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: ProductDetailTokens.cartBarIconChip,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: iconSize,
        color: Colors.white,
      ),
    );
  }
}

class ProductDetailPillButton extends StatelessWidget {
  const ProductDetailPillButton({
    required this.label,
    required this.leadingIcon,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData leadingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: AnimatedScaleTap(
        pressScale: 0.98,
        onTap: () {
          HapticService.medium();
          onTap();
        },
        child: Container(
          height: ProductDetailTokens.cartBarActionHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: ProductDetailTokens.cartBarActionInnerPadding,
          ),
          decoration: BoxDecoration(
            color: ProductDetailTokens.cartBarBg,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              _ActionIconChip(
                icon: leadingIcon,
                size: ProductDetailTokens.cartBarActionIconChipSize,
                iconSize: 16,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
              _ActionIconChip(
                icon: Icons.arrow_forward,
                size: ProductDetailTokens.cartBarActionIconChipSize,
                iconSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailCartBar extends StatelessWidget {
  const ProductDetailCartBar({
    required this.onTryInMyRoom,
    required this.onAddToCart,
    super.key,
  });

  final VoidCallback onTryInMyRoom;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ProductDetailTokens.cartBarHorizontalPadding,
        0,
        ProductDetailTokens.cartBarHorizontalPadding,
        bottom + ProductDetailTokens.cartBarBottomPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: ProductDetailPillButton(
              label: 'Try in my room',
              leadingIcon: Icons.view_in_ar_outlined,
              onTap: onTryInMyRoom,
            ),
          ),
          const SizedBox(width: ProductDetailTokens.cartBarGap),
          Expanded(
            child: ProductDetailPillButton(
              label: 'Add to cart',
              leadingIcon: Icons.shopping_bag_outlined,
              onTap: onAddToCart,
            ),
          ),
        ],
      ),
    );
  }
}
