import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/services/haptic_service.dart';
import '../cart_tokens.dart';

const String _kPenSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none">
  <g>
    <path d="M13.26 3.59924L5.04997 12.2892C4.73997 12.6192 4.43997 13.2692 4.37997 13.7192L4.00997 16.9592C3.87997 18.1292 4.71997 18.9292 5.87997 18.7292L9.09997 18.1792C9.54997 18.0992 10.18 17.7692 10.49 17.4292L18.7 8.73924C20.12 7.23924 20.76 5.52924 18.55 3.43924C16.35 1.36924 14.68 2.09924 13.26 3.59924Z" stroke="currentColor" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M11.89 5.05078C12.32 7.81078 14.56 9.92078 17.34 10.2008" stroke="currentColor" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round" />
    <path d="M3 22H21" stroke="currentColor" stroke-width="1.5" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round" />
  </g>
</svg>
''';

class CartHeader extends StatelessWidget {
  const CartHeader({
    required this.editMode,
    required this.onEdit,
    required this.onClose,
    super.key,
  });

  final bool editMode;
  final VoidCallback onEdit;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CartTokens.screenPadding,
        vertical: 14,
      ),
      child: Row(
        children: [
          _HeaderIconButton(
            onTap: () {
              HapticService.light();
              onEdit();
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.6, end: 1).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: editMode
                  ? const Icon(
                      Icons.check,
                      key: ValueKey<String>('edit-check'),
                      size: 20,
                      color: CartTokens.textPrimary,
                    )
                  : SvgPicture.string(
                      _kPenSvg,
                      key: const ValueKey<String>('edit-pen'),
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        CartTokens.textPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('My Cart', style: CartTokens.headerTitle),
            ),
          ),
          _HeaderIconButton(
            onTap: () {
              HapticService.light();
              onClose();
            },
            child: const Icon(
              Icons.close,
              size: 20,
              color: CartTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatefulWidget {
  const _HeaderIconButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<_HeaderIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 140),
        child: Container(
          width: CartTokens.headerIconSize,
          height: CartTokens.headerIconSize,
          decoration: const BoxDecoration(
            color: CartTokens.iconBackground,
            shape: BoxShape.circle,
            boxShadow: CartTokens.headerIconShadow,
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}
