import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/local_suppliers_config.dart';
import '../theme/home_screen_tokens.dart';

/// Auto-scrolling horizontal showcase of local supplier names.
class SuppliersNameMarquee extends StatefulWidget {
  const SuppliersNameMarquee({
    required this.suppliers,
    super.key,
  });

  final List<LocalSupplier> suppliers;

  @override
  State<SuppliersNameMarquee> createState() => _SuppliersNameMarqueeState();
}

class _SuppliersNameMarqueeState extends State<SuppliersNameMarquee>
    with SingleTickerProviderStateMixin {
  static const double _marqueeHeight = 80;
  static const double _fadeWidth = 40;
  static const double _chipGap = 12;

  final GlobalKey _loopMeasureKey = GlobalKey();
  late AnimationController _controller;
  double _loopWidth = 0;

  List<LocalSupplier> get _items => widget.suppliers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureLoop());
  }

  void _measureLoop() {
    if (!mounted || _items.isEmpty) return;

    final box =
        _loopMeasureKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.width <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureLoop());
      return;
    }

    setState(() {
      _loopWidth = box.size.width;
    });
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _supplierLoop({Key? key}) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < _items.length; i++) ...[
          if (i > 0) const SizedBox(width: _chipGap),
          _SupplierNameChip(supplier: _items[i]),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox(height: _marqueeHeight);
    }

    final fadeColor = HomeScreenTokens.homeBg;

    return SizedBox(
      height: _marqueeHeight,
      child: Stack(
        children: [
          ClipRect(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = _loopWidth > 0
                    ? -_controller.value * _loopWidth
                    : 0.0;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: child,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _supplierLoop(key: _loopMeasureKey),
                  const SizedBox(width: _chipGap),
                  _supplierLoop(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                width: _fadeWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [fadeColor, fadeColor.withValues(alpha: 0)],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                width: _fadeWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [fadeColor, fadeColor.withValues(alpha: 0)],
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

class _SupplierNameChip extends StatelessWidget {
  const _SupplierNameChip({required this.supplier});

  final LocalSupplier supplier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: HomeScreenTokens.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            supplier.name,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${supplier.locality} · ${supplier.capability}',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
