import 'package:flutter/material.dart';

/// Staggered fade + slide entrance for order list rows on first load.
class OrderListEntry extends StatefulWidget {
  const OrderListEntry({
    required this.index,
    required this.child,
    required this.enabled,
    super.key,
  });

  final int index;
  final Widget child;
  final bool enabled;

  @override
  State<OrderListEntry> createState() => _OrderListEntryState();
}

class _OrderListEntryState extends State<OrderListEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(_fade);

    if (widget.enabled) {
      Future<void>.delayed(Duration(milliseconds: widget.index * 50), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
