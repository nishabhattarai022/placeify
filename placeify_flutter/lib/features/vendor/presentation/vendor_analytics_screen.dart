import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/profile_sub_hero.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

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
            padding: const EdgeInsets.fromLTRB(24, 48, 24, AppSpacing.xxl),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    'No analytics yet',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Conversion insights will appear here once your shop '
                    'has enough product views and orders.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
