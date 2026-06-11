import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../cart_tokens.dart';

/// Vertical +/qty/- column inside a soft cream pill.
class CartQuantityControls extends StatelessWidget {
  const CartQuantityControls({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final label = quantity.toString().padLeft(2, '0');

    return Container(
      width: CartTokens.qtyPillWidth,
      padding: const EdgeInsets.symmetric(
        vertical: CartTokens.qtyPillVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: CartTokens.qtyPillBg,
        borderRadius: BorderRadius.circular(CartTokens.qtyPillRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyTap(
            onTap: () {
              HapticService.light();
              onIncrement();
            },
            child: const Icon(
              Icons.add,
              size: 16,
              color: CartTokens.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Text(
              label,
              key: ValueKey<String>(label),
              style: CartTokens.qtyValue,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          _QtyTap(
            onTap: () {
              HapticService.light();
              onDecrement();
            },
            child: const Icon(
              Icons.remove,
              size: 16,
              color: CartTokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyTap extends StatefulWidget {
  const _QtyTap({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_QtyTap> createState() => _QtyTapState();
}

class _QtyTapState extends State<_QtyTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.85 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: SizedBox(
          width: CartTokens.qtyPillWidth - 8,
          height: 22,
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
