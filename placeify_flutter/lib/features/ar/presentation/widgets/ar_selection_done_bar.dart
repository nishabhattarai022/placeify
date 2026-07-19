import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/ar/domain/constants/ar_strings.dart';
import 'package:placeify_flutter/features/ar/presentation/ar_selection_room_launcher.dart';
import 'package:placeify_flutter/features/ar/presentation/providers/ar_pending_selection_provider.dart';
import 'package:placeify_flutter/features/ar/presentation/providers/ar_saved_products_provider.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/home/presentation/providers/category_provider.dart';
import 'package:placeify_flutter/features/product_detail/presentation/ar_room_screen.dart';

/// Bottom bar shown while the user is picking products for My AR.
class ArSelectionDoneBar extends ConsumerStatefulWidget {
  const ArSelectionDoneBar({
    required this.showAboveNav,
    super.key,
  });

  final bool showAboveNav;

  @override
  ConsumerState<ArSelectionDoneBar> createState() => _ArSelectionDoneBarState();
}

class _ArSelectionDoneBarState extends ConsumerState<ArSelectionDoneBar> {
  bool _openingArRoom = false;

  Future<void> _saveForNow(Set<String> pending) async {
    HapticService.medium();
    final count = pending.length;
    await ref.read(arSavedProductsProvider.notifier).addAll(pending);
    if (!mounted) return;
    ref.read(arPendingSelectionProvider.notifier).clear();
    PlaceifyToast.show(
      context,
      count == 1 ? '1 item saved to My AR' : '$count items saved to My AR',
    );
    context.go('/my-ar');
  }

  Future<void> _tryInMyRoom(List<Product> selectedProducts) async {
    if (_openingArRoom || selectedProducts.isEmpty) return;
    HapticService.medium();
    setState(() => _openingArRoom = true);
    try {
      final result = await ArSelectionRoomLauncher.open(
        context: context,
        selectedProducts: selectedProducts,
      );
      if (result == ArRoomOpenResult.opened) {
        ref.read(arPendingSelectionProvider.notifier).clear();
      }
    } finally {
      if (mounted) setState(() => _openingArRoom = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(arPendingSelectionProvider);
    if (pending.isEmpty) return const SizedBox.shrink();

    final selectedProducts = pending
        .map((id) => ref.watch(productByIdProvider(id)))
        .nonNulls
        .toList();
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomOffset = widget.showAboveNav
        ? BottomNavTokens.fabBottomPadding + bottomInset
        : 16 + bottomInset;

    return Positioned(
      left: 20,
      right: 20,
      bottom: bottomOffset,
      child: Row(
        children: [
          Expanded(
            child: _SelectionActionButton(
              label: pending.length == 1
                  ? ArStrings.saveForNowSingle
                  : ArStrings.saveForNowMultiple(pending.length),
              onTap: () => _saveForNow(pending),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SelectionActionButton(
              label: _openingArRoom ? 'Opening AR…' : 'Try in my room',
              onTap:
                  !_openingArRoom && selectedProducts.length == pending.length
                  ? () => _tryInMyRoom(selectedProducts)
                  : null,
              icon: Icons.view_in_ar_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionActionButton extends StatelessWidget {
  const _SelectionActionButton({
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(999),
      color: AppColors.charcoal,
      child: Opacity(
        opacity: onTap == null ? 0.55 : 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: Colors.white),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
