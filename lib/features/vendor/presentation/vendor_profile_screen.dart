import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';

class VendorProfileScreen extends StatelessWidget {
  const VendorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Store Profile', style: AppTypography.sectionTitle),
              const SizedBox(height: 8),
              Text(
                'Vendor profile editor coming in a later phase.',
                style: AppTypography.bodyLight.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              const SizedBox(height: BottomNavTokens.scrollBottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
