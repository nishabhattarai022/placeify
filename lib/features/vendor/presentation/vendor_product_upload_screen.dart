import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

/// Placeholder until Phase 5 ships the full product upload form.
class VendorProductUploadScreen extends StatelessWidget {
  const VendorProductUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: AppColors.espresso,
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Upload Product',
          style: AppTypography.sectionTitle,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Product upload form coming in the next phase.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLight.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
