import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/profile/presentation/widgets/profile_sub_hero.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';

class _FunnelStep {
  const _FunnelStep({
    required this.label,
    required this.count,
    required this.rate,
    required this.color,
  });

  final String label;
  final int count;
  final double rate;
  final Color color;
}

const _funnelSteps = [
  _FunnelStep(
    label: 'Product views',
    count: 1280,
    rate: 1,
    color: AppColors.bark,
  ),
  _FunnelStep(
    label: 'Add to cart',
    count: 186,
    rate: 0.145,
    color: AppColors.accent,
  ),
  _FunnelStep(
    label: 'Checkout started',
    count: 92,
    rate: 0.072,
    color: AppColors.sage,
  ),
  _FunnelStep(
    label: 'Orders placed',
    count: 47,
    rate: 0.037,
    color: AppColors.teal,
  ),
];

class VendorAnalyticsScreen extends StatelessWidget {
  const VendorAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          const SliverToBoxAdapter(
            child: ProfileSubHero(
              title: 'Analytics',
              subtitle: 'insights & trends',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.xxl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Product conversion funnel',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Last 30 days · mock data',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
                ..._funnelSteps.map((step) => _FunnelStepCard(step: step)),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warmWhite,
                    borderRadius: AppRadii.lg,
                    border: Border.all(color: AppColors.creamDark, width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall conversion',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '3.7%',
                        style: GoogleFonts.dmSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.espresso,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Views to completed orders',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FunnelStepCard extends StatelessWidget {
  const _FunnelStepCard({required this.step});

  final _FunnelStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: AppRadii.md,
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    step.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  step.count.toString(),
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espresso,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: AppRadii.pill,
              child: LinearProgressIndicator(
                value: step.rate,
                minHeight: 8,
                backgroundColor: AppColors.cream,
                color: step.color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(step.rate * 100).toStringAsFixed(1)}% of views',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
