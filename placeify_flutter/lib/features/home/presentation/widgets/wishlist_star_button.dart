import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/product.dart';
import '../providers/wishlist_provider.dart';

class WishlistStarButton extends ConsumerStatefulWidget {
  const WishlistStarButton({required this.product, super.key});

  final Product product;

  @override
  ConsumerState<WishlistStarButton> createState() => _WishlistStarButtonState();
}

class _WishlistStarButtonState extends ConsumerState<WishlistStarButton>
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
    ref.watch(wishlistProvider);
    final isSaved =
        ref.read(wishlistProvider.notifier).isLiked(widget.product.id);

    return Semantics(
      button: true,
      label: isSaved ? 'Remove from wishlist' : 'Save to wishlist',
      child: GestureDetector(
        onTap: () async {
          if (ref.read(currentUserProvider).value == null) {
            PlaceifyToast.show(context, 'Sign in to save items to your wishlist');
            context.push('/login');
            return;
          }

          HapticService.medium();
          await ref.read(wishlistProvider.notifier).toggle(widget.product.id);
          if (!context.mounted) return;
          final nowSaved =
              ref.read(wishlistProvider.notifier).isLiked(widget.product.id);
          _popController.forward(from: 0);
          PlaceifyToast.show(
            context,
            nowSaved ? 'Added to wishlist' : 'Removed from wishlist',
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
              child: SvgPicture.asset(
                isSaved
                    ? 'assets/icons/ic_star.svg'
                    : 'assets/icons/ic_star_outline.svg',
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  isSaved ? AppColors.rust : AppColors.textMuted,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
