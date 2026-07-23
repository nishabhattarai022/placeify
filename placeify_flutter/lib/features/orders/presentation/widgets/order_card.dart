import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/animated_scale_tap.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../home/presentation/chairs_catalog_tokens.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/consumer_order_status.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_item.dart';
import '../providers/orders_provider.dart';
import '../providers/submitted_order_reviews_provider.dart';
import 'consumer_order_status_chip.dart';
import 'leave_review_sheet.dart';

class OrderCard extends ConsumerWidget {
  const OrderCard({
    required this.order,
    this.onLongPress,
    super.key,
  });

  final Order order;
  final VoidCallback? onLongPress;

  OrderItem get _heroItem => order.items.first;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heroItem = _heroItem;
    final extraItems = order.items.length - 1;

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
          decoration: BoxDecoration(
            color: ChairsCatalogTokens.imageWell,
            borderRadius:
                BorderRadius.circular(ChairsCatalogTokens.wideCardRadius),
            boxShadow: ChairsCatalogTokens.cardShadow,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 10,
                    child: ColoredBox(
                      color: AppColors.cream,
                      child: _OrderHeroImage(item: heroItem),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ConsumerOrderStatusChip(status: order.status),
                  ),
                  if (extraItems > 0)
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          OrderStrings.moreItemsLabel(extraItems),
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.espresso,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderNumber,
                                style: GoogleFonts.dmSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                heroItem.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${order.vendorName} · ${Formatters.shortDate(order.placedAt)}',
                                style: AppFonts.dmSerifDisplay(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textMuted,
                                  height: 1.35,
                                ),
                              ),
                              if (order.deliveryAddress.trim().isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  order.deliveryAddress,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.currencyFull(order.total),
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.itemCount == 1
                                  ? '1 item'
                                  : '${order.itemCount} items',
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ..._buildActions(context, ref),
                  ],
                ),
              ),
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
      const SizedBox(height: 14),
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
            label: ref.watch(submittedOrderReviewsProvider).contains(order.id)
                ? OrderStrings.updateReviewAction
                : OrderStrings.leaveReviewAction,
            primary: false,
            onTap: () => LeaveReviewSheet.show(context, ref, order: order),
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

class _OrderHeroImage extends StatelessWidget {
  const _OrderHeroImage({required this.item});

  final OrderItem item;

  bool get _isAsset => item.productImageUrl.trim().startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final url = item.productImageUrl.trim();
    if (url.isEmpty) {
      return _fallbackIcon();
    }

    if (_isAsset) {
      return Image.asset(
        url,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, __) => const ShimmerLoader(),
      errorWidget: (_, __, ___) => _fallbackIcon(),
    );
  }

  Widget _fallbackIcon() {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/ic_chair.svg',
        width: 48,
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
