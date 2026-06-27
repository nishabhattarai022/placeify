import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../data/vendor_3d_model_store.dart';
import '../providers/vendor_products_provider.dart';
import '../vendor_3d_model_access.dart';
import 'vendor_build_3d_module_card.dart';

/// Dashboard reminders for products missing a 3D model.
class VendorDashboard3dReminders extends ConsumerWidget {
  const VendorDashboard3dReminders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(vendorProductsProvider).value ?? const [];
    final needing = Vendor3dModelStore.productsNeedingModel(products);
    if (needing.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('3D Build Reminders', style: _sectionTitle),
        const SizedBox(height: 12),
        const VendorBuild3dModuleCard(),
        const SizedBox(height: 12),
        ...needing.take(3).map(
              (product) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ReminderTile(productId: product.id, name: product.name),
              ),
            ),
        if (needing.length > 3)
          Text(
            '+ ${needing.length - 3} more products need 3D models',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ReminderTile extends ConsumerWidget {
  const _ReminderTile({
    required this.productId,
    required this.name,
  });

  final String productId;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: AppColors.cream,
      borderRadius: AppRadii.md,
      child: InkWell(
        borderRadius: AppRadii.md,
        onTap: () {
          HapticService.light();
          Vendor3dModelAccess.openBuilder(context, ref, productId);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.view_in_ar_outlined,
                color: AppColors.vendorForest,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Build 3D model for: $name',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _sectionTitle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: AppColors.espresso,
);
