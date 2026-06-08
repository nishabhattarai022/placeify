import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../vendor/data/mock_vendor_repository.dart';

class MiniBarChart extends StatelessWidget {
  const MiniBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final heights = MockVendorRepository.barHeights;

    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(heights.length, (i) {
          return Expanded(
            child: _MiniBar(
              heightFraction: heights[i],
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
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: _started ? widget.heightFraction : 0),
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
