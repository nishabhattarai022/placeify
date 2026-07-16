import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../home/domain/models/product.dart';
import '../../../home/presentation/providers/wishlist_provider.dart';
import '../product_detail_tokens.dart';

class ProductDetailHeader extends ConsumerWidget {
  const ProductDetailHeader({
    required this.product,
    required this.onBack,
    super.key,
  });

  final Product product;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(wishlistProvider).containsKey(product.id);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ProductDetailTokens.headerHorizontalPadding,
      ),
      child: Row(
        children: [
          _HeaderCircleButton(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back,
              size: ProductDetailTokens.headerIconSize,
              color: ProductDetailTokens.textPrimary,
            ),
          ),
          const Spacer(),
          _HeaderCircleButton(
            onTap: () async {
              HapticService.light();
              await ref.read(wishlistProvider.notifier).toggle(product.id);
            },
            child: _StarSwitcher(isSaved: isSaved),
          ),
        ],
      ),
    );
  }
}

class _StarSwitcher extends StatelessWidget {
  const _StarSwitcher({required this.isSaved});

  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.6, end: 1).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Icon(
        isSaved ? Icons.star_rounded : Icons.star_border_rounded,
        key: ValueKey<bool>(isSaved),
        size: ProductDetailTokens.headerIconSize + 4,
        color: ProductDetailTokens.textPrimary,
      ),
    );
  }
}

class _HeaderCircleButton extends StatefulWidget {
  const _HeaderCircleButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_HeaderCircleButton> createState() => _HeaderCircleButtonState();
}

class _HeaderCircleButtonState extends State<_HeaderCircleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 140),
        child: Container(
          width: ProductDetailTokens.headerSize,
          height: ProductDetailTokens.headerSize,
          decoration: BoxDecoration(
            color: ProductDetailTokens.circleButtonBg,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
