import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';

class MiniBarChart extends StatelessWidget {
  const MiniBarChart({
    required this.heights,
    super.key,
  });

  final List<double> heights;

  @override
  Widget build(BuildContext context) {
    if (heights.isEmpty) {
      return const SizedBox(height: 50);
    }

    final maxHeight = heights.reduce((a, b) => a > b ? a : b);
    // Avoid a flat stub "line" when there is no revenue data yet.
    if (maxHeight <= 0) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(heights.length, (i) {
          return Expanded(
            child: _MiniBar(
              heightFraction: heights[i] / maxHeight,
              isActive: i == heights.length - 1,
              delay: Duration(milliseconds: 100 + i * 60),
            ),
          );
        }),
      ),
    );
  }
}

class _MiniBar extends StatefulWidget {
  const _MiniBar({
    required this.heightFraction,
    required this.isActive,
    required this.delay,
  });

  final double heightFraction;
  final bool isActive;
  final Duration delay;

  @override
  State<_MiniBar> createState() => _MiniBarState();
}

class _MiniBarState extends State<_MiniBar> {
  bool _started = false;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _started = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.heightFraction > 0 ? widget.heightFraction : 0.08;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _started ? target : 0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: value,
            widthFactor: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.accentLight
                    : Colors.white.withValues(alpha: 0.14),
                borderRadius: AppRadii.sm,
              ),
            ),
          ),
        );
      },
    );
  }
}
