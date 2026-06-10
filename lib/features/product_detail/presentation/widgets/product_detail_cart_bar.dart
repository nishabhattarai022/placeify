import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/utils/formatters.dart';
import '../product_detail_tokens.dart';

class ProductDetailPillButton extends StatefulWidget {
  const ProductDetailPillButton({
    required this.label,
    required this.leadingIcon,
    required this.onTap,
    this.trailingText,
    this.compact = false,
    super.key,
  });

  final String label;
  final IconData leadingIcon;
  final VoidCallback onTap;
  final String? trailingText;
  final bool compact;

  @override
  State<ProductDetailPillButton> createState() => _ProductDetailPillButtonState();
}

class _ProductDetailPillButtonState extends State<ProductDetailPillButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;
    final height = compact
        ? ProductDetailTokens.cartBarActionHeight
        : ProductDetailTokens.cartBarHeight;
    final horizontalPadding = compact
        ? ProductDetailTokens.cartBarActionInnerPadding
        : ProductDetailTokens.cartBarInnerPadding;
    final iconChipSize = compact
        ? ProductDetailTokens.cartBarActionIconChipSize
        : ProductDetailTokens.cartBarIconChipSize;
    final iconSize = compact ? 16.0 : 18.0;
    final labelFontSize = compact ? 14.0 : 15.0;

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
          height: height,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
            mainAxisAlignment:
                compact ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                width: iconChipSize,
                height: iconChipSize,
                decoration: const BoxDecoration(
                  color: ProductDetailTokens.cartBarIconChip,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.leadingIcon,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              if (compact)
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.dmSans(
                      fontSize: labelFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                )
              else ...[
                Text(
                  widget.label,
                  style: AppFonts.dmSans(
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const Spacer(),
                if (widget.trailingText != null) ...[
                  Text(
                    widget.trailingText!,
                    style: AppFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Container(
                  width: ProductDetailTokens.cartBarTrailingArrowSize,
                  height: ProductDetailTokens.cartBarTrailingArrowSize,
                  decoration: const BoxDecoration(
                    color: ProductDetailTokens.cartBarIconChip,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailCartBar extends StatelessWidget {
  const ProductDetailCartBar({
    required this.totalPrice,
    required this.onTryInMyRoom,
    required this.onAddToCart,
    super.key,
  });

  final double totalPrice;
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProductDetailPillButton(
            label: 'Try in my room',
            leadingIcon: Icons.view_in_ar_outlined,
            onTap: onTryInMyRoom,
          ),
          const SizedBox(height: ProductDetailTokens.cartBarGap),
          ProductDetailPillButton(
            label: 'Add To Cart',
            leadingIcon: Icons.shopping_bag_outlined,
            trailingText: Formatters.currencyDecimal(totalPrice),
            onTap: onAddToCart,
          ),
        ],
      ),
    );
  }
}
