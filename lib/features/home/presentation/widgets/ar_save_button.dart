import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../ar/presentation/providers/ar_pending_selection_provider.dart';
import '../../../ar/presentation/providers/ar_saved_products_provider.dart';
import '../../domain/models/product.dart';

class ArSaveButton extends ConsumerStatefulWidget {
  const ArSaveButton({required this.product, super.key});

  final Product product;

  @override
  ConsumerState<ArSaveButton> createState() => _ArSaveButtonState();
}

class _ArSaveButtonState extends ConsumerState<ArSaveButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _popController;
  late final Animation<double> _popScale;

  @override
  void initState() {
    super.initState();
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 460),
    );
    _popScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.45), weight: 180),
      TweenSequenceItem(
        tween: Tween(begin: 1.45, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 280,
      ),
    ]).animate(_popController);
  }

  @override
  void dispose() {
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(arPendingSelectionProvider);
    final saved = ref.watch(arSavedProductsProvider);
    final isPending = pending.contains(widget.product.id);
    final isSaved = saved.containsKey(widget.product.id);
    final isHighlighted = isPending || isSaved;

    return Semantics(
      button: true,
      label: isPending
          ? 'Remove from AR selection'
          : isSaved
              ? 'Add to AR selection again'
              : 'Add to AR selection',
      child: GestureDetector(
        onTap: () {
          HapticService.medium();
          ref.read(arPendingSelectionProvider.notifier).toggle(widget.product.id);
          _popController.forward(from: 0);
        },
        child: ScaleTransition(
          scale: _popScale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isPending
                  ? AppColors.accent.withValues(alpha: 0.14)
                  : AppColors.warmWhite,
              shape: BoxShape.circle,
              border: isHighlighted
                  ? Border.all(
                      color: AppColors.accent.withValues(
                        alpha: isPending ? 0.9 : 0.45,
                      ),
                      width: 1.5,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.espresso.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isHighlighted ? Icons.view_in_ar : Icons.view_in_ar_outlined,
                size: 18,
                color: isHighlighted ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
