import 'package:flutter/material.dart';

/// Press feedback for bottom nav icon targets.
class NavIconTap extends StatefulWidget {
  const NavIconTap({
    required this.child,
    required this.onTap,
    this.pressScale = 0.88,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final double pressScale;

  @override
  State<NavIconTap> createState() => _NavIconTapState();
}

class _NavIconTapState extends State<NavIconTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? widget.pressScale : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
