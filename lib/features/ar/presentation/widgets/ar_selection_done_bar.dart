import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/features/ar/domain/constants/ar_strings.dart';
import 'package:placeify/features/ar/presentation/providers/ar_pending_selection_provider.dart';
import 'package:placeify/features/ar/presentation/providers/ar_saved_products_provider.dart';

/// Bottom bar shown while the user is picking products for My AR.
class ArSelectionDoneBar extends ConsumerWidget {
  const ArSelectionDoneBar({
    required this.showAboveNav,
    super.key,
  });

  final bool showAboveNav;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(arPendingSelectionProvider);
    if (pending.isEmpty) return const SizedBox.shrink();

    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomOffset = showAboveNav
        ? BottomNavTokens.fabBottomPadding + bottomInset
        : 16 + bottomInset;

    return Positioned(
      left: 20,
      right: 20,
      bottom: bottomOffset,
      child: Material(
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        color: AppColors.charcoal,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () {
            HapticService.medium();
            final count = pending.length;
            ref.read(arSavedProductsProvider.notifier).addAll(pending);
            ref.read(arPendingSelectionProvider.notifier).clear();
            PlaceifyToast.show(
              context,
              count == 1
                  ? '1 item saved to My AR'
                  : '$count items saved to My AR',
            );
            context.go('/my-ar');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                pending.length == 1
                    ? ArStrings.doneSingle
                    : ArStrings.doneMultiple(pending.length),
                style: AppFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
