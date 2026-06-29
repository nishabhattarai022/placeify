import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../profile/presentation/widgets/profile_sub_hero.dart';
import '../domain/constants/order_strings.dart';
import '../domain/models/order.dart';
import '../domain/models/order_status_update.dart';
import 'providers/orders_provider.dart';
import 'widgets/consumer_order_status_chip.dart';
import 'widgets/order_section_card.dart';
import 'widgets/order_timeline.dart';

class OrderTrackingScreen extends ConsumerWidget {
  const OrderTrackingScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: orderAsync.when(
        loading: () => const _TrackingShimmer(),
        error: (_, __) => _TrackingError(
          onRetry: () => ref.invalidate(orderByIdProvider(orderId)),
        ),
        data: (order) {
          if (order == null) {
            return _TrackingError(
              onRetry: () => ref.invalidate(orderByIdProvider(orderId)),
            );
          }
          return _TrackingBody(order: order);
        },
      ),
    );
  }
}

class _TrackingBody extends StatelessWidget {
  const _TrackingBody({required this.order});

  final Order order;

  OrderStatusUpdate? get _latestUpdate {
    if (order.statusHistory.isEmpty) return null;
    return order.statusHistory.last;
  }

  @override
  Widget build(BuildContext context) {
    final latest = _latestUpdate;

    return Column(
      children: [
        ProfileSubHero(
          title: OrderStrings.trackingTitle,
          bottom: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    order.orderNumber,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ),
                ConsumerOrderStatusChip(status: order.status),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (order.estimatedDelivery != null)
                  OrderSectionCard(
                    title: OrderStrings.estimatedDeliveryLabel,
                    child: Text(
                      _formatEstimatedDelivery(order.estimatedDelivery!),
                      style: AppTypography.metricValueMedium.copyWith(
                        fontSize: 26,
                      ),
                    ),
                  ),
                if (order.estimatedDelivery != null) const SizedBox(height: 12),
                if (order.trackingNumber != null &&
                    order.trackingNumber!.isNotEmpty)
                  OrderSectionCard(
                    title: OrderStrings.trackingNumberLabel,
                    child: _TrackingNumberRow(
                      trackingNumber: order.trackingNumber!,
                    ),
                  ),
                if (order.trackingNumber != null &&
                    order.trackingNumber!.isNotEmpty)
                  const SizedBox(height: 12),
                OrderSectionCard(
                  title: OrderStrings.timelineSectionTitle,
                  child: OrderTimeline(order: order),
                ),
                if (latest != null) ...[
                  const SizedBox(height: 12),
                  OrderSectionCard(
                    title: OrderStrings.lastUpdatedLabel,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          OrderStrings.statusLabel(latest.status),
                          style: AppTypography.productName,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.shortDate(latest.timestamp),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                        if (latest.note != null && latest.note!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            latest.note!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {
                    HapticService.light();
                    PlaceifyToast.show(
                      context,
                      OrderStrings.contactCourierToast,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.espresso,
                    side: const BorderSide(color: AppColors.sand, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    OrderStrings.contactCourierAction,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    HapticService.light();
                    PlaceifyToast.show(
                      context,
                      OrderStrings.contactVendorToast,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.espresso,
                    side: const BorderSide(color: AppColors.sand, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    OrderStrings.contactVendorAction,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatEstimatedDelivery(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _TrackingNumberRow extends StatelessWidget {
  const _TrackingNumberRow({required this.trackingNumber});

  final String trackingNumber;

  Future<void> _copy(BuildContext context) async {
    HapticService.light();
    await Clipboard.setData(ClipboardData(text: trackingNumber));
    if (context.mounted) {
      PlaceifyToast.show(context, OrderStrings.trackingCopiedToast);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            trackingNumber,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
              letterSpacing: 0.3,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _copy(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: AppRadii.pill,
              border: Border.all(color: AppColors.creamDark),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.copy_rounded, size: 16, color: AppColors.bark),
                SizedBox(width: 6),
                Text(
                  'Copy',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackingShimmer extends StatelessWidget {
  const _TrackingShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 120,
          child: ShimmerLoader(),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: 140,
                  child: ShimmerLoader(borderRadius: AppRadii.lg),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackingError extends StatelessWidget {
  const _TrackingError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileSubHero(title: OrderStrings.trackingTitle),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 40,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Could not load tracking for this order.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onRetry,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
