import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/mock_vendor_repository.dart';
import '../../domain/models/vendor_metric.dart';

class TopProductsChart extends StatelessWidget {
  const TopProductsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final products = MockVendorRepository.topProducts;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
        borderRadius: AppRadii.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOP PRODUCTS',
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(products.length, (i) {
            final p = products[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i < products.length - 1 ? 14 : 0),
              child: _ProductRow(
                stat: p,
                delay: Duration(milliseconds: 200 + i * 150),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ProductRow extends StatefulWidget {
  const _ProductRow({required this.stat, required this.delay});
  final TopProductStat stat;
  final Duration delay;

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
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
    return Row(
      children: [
        SvgPicture.asset(
          widget.stat.iconPath,
          width: 20,
          colorFilter: const ColorFilter.mode(AppColors.bark, BlendMode.srcIn),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.stat.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              _ProgressBar(
                target: widget.stat.progressFraction,
                color: widget.stat.barColor,
                animate: _started,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          widget.stat.revenue,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.espresso,
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.target,
    required this.color,
    required this.animate,
  });

  final double target;
  final Color color;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: animate ? target : 0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Container(
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.creamDark,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
