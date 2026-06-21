import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/consumer_order_status.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_item.dart';
import '../providers/orders_provider.dart';
import 'consumer_order_status_chip.dart';

class OrderCard extends ConsumerWidget {
  const OrderCard({
    required this.order,
    this.onLongPress,
    super.key,
  });

  final Order order;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: AnimatedScaleTap(
        onTap: () {
          HapticService.light();
          context.pushNamed(
            'profileOrderDetail',
            pathParameters: {'orderId': order.id},
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warmWhite,
            borderRadius: AppRadii.lg,
            border: Border.all(color: AppColors.creamDark, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      order.orderNumber,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.espresso,
                      ),
                    ),
                  ),
                  ConsumerOrderStatusChip(status: order.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${order.vendorName} · ${Formatters.shortDate(order.placedAt)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              _OrderThumbnailRow(items: order.items),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatters.currencyFull(order.total),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.espresso,
                    ),
                  ),
                  Text(
                    order.itemCount == 1
                        ? '1 item'
                        : '${order.itemCount} items',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ..._buildActions(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context, WidgetRef ref) {
    final actions = _contextualActions(context, ref);
    if (actions.isEmpty) return const [];

    return [
      const SizedBox(height: 12),
      Row(
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: actions[i]),
          ],
        ],
      ),
    ];
  }

  List<Widget> _contextualActions(BuildContext context, WidgetRef ref) {
    return switch (order.status) {
      ConsumerOrderStatus.inTransit ||
      ConsumerOrderStatus.outForDelivery ||
      ConsumerOrderStatus.dispatched ||
      ConsumerOrderStatus.packed when order.hasTracking =>
        [
          _OrderActionButton(
            label: OrderStrings.trackAction,
            primary: true,
            onTap: () => _openTracking(context),
          ),
        ],
      ConsumerOrderStatus.delivered => [
          _OrderActionButton(
            label: OrderStrings.reorderAction,
            primary: true,
            onTap: () => ref
                .read(ordersProvider.notifier)
                .reorder(order.id, context: context),
          ),
          _OrderActionButton(
            label: OrderStrings.leaveReviewAction,
            primary: false,
            onTap: () => PlaceifyToast.show(
              context,
              '${OrderStrings.leaveReviewAction} coming soon',
            ),
          ),
        ],
      ConsumerOrderStatus.returnRequested ||
      ConsumerOrderStatus.returned =>
        [
          _OrderActionButton(
            label: OrderStrings.viewReturnAction,
            primary: true,
            onTap: () => context.pushNamed(
              'profileOrderDetail',
              pathParameters: {'orderId': order.id},
            ),
          ),
        ],
      _ => const <Widget>[],
    };
  }

  void _openTracking(BuildContext context) {
    context.pushNamed(
      'profileOrderTracking',
      pathParameters: {'orderId': order.id},
    );
  }
}

class _OrderThumbnailRow extends StatelessWidget {
  const _OrderThumbnailRow({required this.items});

  final List<OrderItem> items;

  static const _thumbSize = 60.0;
  static const _overlap = 14.0;

  @override
  Widget build(BuildContext context) {
    final visible = items.take(3).toList();
    final extra = items.length - visible.length;

    return SizedBox(
      height: _thumbSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (var i = 0; i < visible.length; i++)
            Positioned(
              left: i * (_thumbSize - _overlap),
              child: _OrderItemThumbnail(imageUrl: visible[i].productImageUrl),
            ),
          if (extra > 0)
            Positioned(
              left: visible.length * (_thumbSize - _overlap),
              child: Container(
                width: _thumbSize,
                height: _thumbSize,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.creamDark, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  OrderStrings.moreItemsLabel(extra),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderItemThumbnail extends StatelessWidget {
  const _OrderItemThumbnail({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: _OrderItemImage(imageUrl: imageUrl),
    );
  }
}

class _OrderItemImage extends StatelessWidget {
  const _OrderItemImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final fit =
        imageUrl.startsWith('assets/') ? BoxFit.contain : BoxFit.cover;

    if (imageUrl.startsWith('assets/')) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          imageUrl,
          fit: fit,
          errorBuilder: (_, __, ___) => _fallbackIcon(),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (_, __) => const ShimmerLoader(),
      errorWidget: (_, __, ___) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/ic_chair.svg',
        width: 24,
        colorFilter: const ColorFilter.mode(
          AppColors.bark,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  const _OrderActionButton({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primary ? AppColors.espresso : AppColors.cream,
          borderRadius: AppRadii.pill,
          border: primary
              ? null
              : Border.all(color: AppColors.sand, width: 1.5),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: primary ? Colors.white : AppColors.espresso,
          ),
        ),
      ),
    );
  }
}
