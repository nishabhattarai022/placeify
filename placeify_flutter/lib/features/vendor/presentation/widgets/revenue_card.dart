import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../vendor/data/mock_vendor_repository.dart';
import 'mini_bar_chart.dart';

class RevenueCard extends StatefulWidget {
  const RevenueCard({super.key});

  @override
  State<RevenueCard> createState() => _RevenueCardState();
}

class _RevenueCardState extends State<RevenueCard> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.espresso,
        borderRadius: AppRadii.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REVENUE',
            style: AppTypography.metricLabel.copyWith(
              color: Colors.white.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _animate ? MockVendorRepository.revenue : 0),
            duration: AppDurations.countUp,
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Text(
                Formatters.currency(value),
                style: AppTypography.metricValueLarge,
              );
            },
          ),
          const SizedBox(height: 6),
          _TrendRow(
            iconPath: 'assets/icons/ic_trending_up.svg',
            label: '+18% this week',
            color: AppColors.accentLight,
          ),
          const SizedBox(height: 12),
          const MiniBarChart(),
        ],
      ),
    );
  }
}

class _TrendRow extends StatelessWidget {
  const _TrendRow({
    required this.iconPath,
    required this.label,
    required this.color,
  });

  final String iconPath;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 14,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.trendText.copyWith(color: color),
        ),
      ],
    );
  }
}
