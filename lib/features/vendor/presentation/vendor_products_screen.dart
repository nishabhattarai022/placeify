import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';

class VendorProductsScreen extends StatelessWidget {
  const VendorProductsScreen({super.key});

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
              const Text('Products', style: AppTypography.sectionTitle),
              const SizedBox(height: 8),
              Text(
                'Product catalog management coming in the next phase.',
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
