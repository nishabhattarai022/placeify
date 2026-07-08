import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';
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
    final isSaved =
        ref.watch(arSavedProductsProvider).containsKey(widget.product.id);

    return Semantics(
      button: true,
      label: isSaved ? 'Remove from My AR' : 'Save to My AR',
      child: GestureDetector(
        onTap: () {
          HapticService.medium();
          ref.read(arSavedProductsProvider.notifier).toggle(widget.product.id);
          final nowSaved =
              ref.read(arSavedProductsProvider).containsKey(widget.product.id);
          _popController.forward(from: 0);
          PlaceifyToast.show(
            context,
            nowSaved ? 'Added to My AR' : 'Removed from My AR',
          );
        },
        child: ScaleTransition(
          scale: _popScale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              shape: BoxShape.circle,
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
                isSaved ? Icons.view_in_ar : Icons.view_in_ar_outlined,
                size: 18,
                color: isSaved ? AppColors.accent : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
