import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/enums/consumer_order_status.dart';
import '../../domain/constants/order_strings.dart';

/// Semantic status pill for consumer orders.
class ConsumerOrderStatusChip extends StatefulWidget {
  const ConsumerOrderStatusChip({
    required this.status,
    super.key,
  });

  final ConsumerOrderStatus status;

  @override
  State<ConsumerOrderStatusChip> createState() =>
      _ConsumerOrderStatusChipState();
}

class _ConsumerOrderStatusChipState extends State<ConsumerOrderStatusChip>
    with SingleTickerProviderStateMixin {
  AnimationController? _shimmerController;

  @override
  void initState() {
    super.initState();
    _syncShimmer();
  }

  @override
  void deactivate() {
    _shimmerController?.stop();
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    _syncShimmer();
  }

  void _syncShimmer() {
    if (widget.status == ConsumerOrderStatus.inTransit) {
      _shimmerController ??= AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1800),
      );
      if (!_shimmerController!.isAnimating) {
        _shimmerController!.repeat(reverse: true);
      }
      return;
    }

    _shimmerController?.stop();
  }

  @override
  void didUpdateWidget(ConsumerOrderStatusChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _syncShimmer();
    }
  }

  @override
  void dispose() {
    _shimmerController?.dispose();
    super.dispose();
  }

  (Color bg, Color fg, FontWeight weight) _colors() => switch (widget.status) {
        ConsumerOrderStatus.placed => (
            AppColors.creamDark,
            AppColors.textMuted,
            FontWeight.w600,
          ),
        ConsumerOrderStatus.confirmed || ConsumerOrderStatus.packed => (
            AppColors.accentBg,
            AppColors.accent,
            FontWeight.w600,
          ),
        ConsumerOrderStatus.dispatched => (
            AppColors.tealBg,
            AppColors.teal,
            FontWeight.w600,
          ),
        ConsumerOrderStatus.inTransit => (
            AppColors.accentBg,
            AppColors.accent,
            FontWeight.w700,
          ),
        ConsumerOrderStatus.outForDelivery => (
            AppColors.sageBg,
            AppColors.forest,
            FontWeight.w600,
          ),
        ConsumerOrderStatus.delivered => (
            AppColors.sageBg,
            AppColors.sage,
            FontWeight.w600,
          ),
        ConsumerOrderStatus.cancelled => (
            AppColors.coralBg,
            AppColors.coral,
            FontWeight.w600,
          ),
        ConsumerOrderStatus.returnRequested ||
        ConsumerOrderStatus.returned =>
          (
            AppColors.lavenderBg,
            AppColors.lavender,
            FontWeight.w600,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg, weight) = _colors();
    final label = OrderStrings.statusLabel(widget.status);
    final shimmer = _shimmerController;

    Widget chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: AppTypography.statusPill.copyWith(
          color: fg,
          fontWeight: weight,
        ),
      ),
    );

    if (widget.status == ConsumerOrderStatus.inTransit && shimmer != null) {
      chip = AnimatedBuilder(
        animation: shimmer,
        builder: (context, child) {
          return Opacity(
            opacity: 0.82 + shimmer.value * 0.18,
            child: child,
          );
        },
        child: chip,
      );
    }

    return chip;
  }
}
