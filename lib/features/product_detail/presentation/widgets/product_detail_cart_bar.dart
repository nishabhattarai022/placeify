import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/theme/app_fonts.dart';
import '../product_detail_tokens.dart';

class ProductDetailPillButton extends StatefulWidget {
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
  State<ProductDetailPillButton> createState() => _ProductDetailPillButtonState();
}

class _ProductDetailPillButtonState extends State<ProductDetailPillButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticService.medium();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 140),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ProductDetailTokens.cartBarActionIconChipSize,
                height: ProductDetailTokens.cartBarActionIconChipSize,
                decoration: const BoxDecoration(
                  color: ProductDetailTokens.cartBarIconChip,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.leadingIcon,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
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
