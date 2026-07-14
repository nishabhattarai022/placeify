import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/config/resolve_media_url.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/widgets/orders/order_progress_tracker.dart';
import '../../data/user_order_mappers.dart';

class UserOrderCard extends StatelessWidget {
  const UserOrderCard({required this.order, super.key});

  final UserOrderSummary order;

  @override
  Widget build(BuildContext context) {
    final colors = UserOrderMappers.statusColors(order.status);
    final showProgress = UserOrderMappers.showsDeliveryProgress(order.status);
    final progressStep = UserOrderMappers.progressStep(
      order.status,
      latestStage: order.latestDeliveryStage,
    );
    final latestUpdate = UserOrderMappers.latestUpdateLabel(order);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: _OrderThumbnailImage(url: order.primaryThumbnailUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserOrderMappers.productTitle(order),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      UserOrderMappers.orderMeta(order),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      UserOrderMappers.paymentStatusLabel(
                        order.orderPaymentStatus,
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sage,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  UserOrderMappers.statusLabel(
                    order.status,
                    latestStage: order.latestDeliveryStage,
                  ),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
              ),
            ],
          ),
          if (showProgress)
            OrderProgressTracker(activeStep: progressStep),
          if (latestUpdate != null) ...[
            const SizedBox(height: 8),
            Text(
              latestUpdate,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
          Divider(
            color: AppColors.creamDark,
            height: showProgress || latestUpdate != null ? 12 : 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                UserOrderMappers.totalLabel(order),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.espresso,
                ),
              ),
              Text(
                UserOrderMappers.placedLabel(order),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderThumbnailImage extends StatelessWidget {
  const _OrderThumbnailImage({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolveUrl(),
      builder: (context, snapshot) {
        final resolved = snapshot.data ?? '';
        if (resolved.isEmpty) {
          return const Center(
            child: Icon(
              Icons.inventory_2_outlined,
              size: 28,
              color: AppColors.bark,
            ),
          );
        }

        if (resolved.startsWith('assets/')) {
          return Image.asset(
            resolved,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(
                Icons.inventory_2_outlined,
                size: 28,
                color: AppColors.bark,
              ),
            ),
          );
        }

        return CachedNetworkImage(
          imageUrl: resolved,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => const Center(
            child: Icon(
              Icons.inventory_2_outlined,
              size: 28,
              color: AppColors.bark,
            ),
          ),
        );
      },
    );
  }

  Future<String> _resolveUrl() async {
    final raw = url?.trim();
    if (raw == null || raw.isEmpty) return '';
    if (raw.startsWith('http') || raw.startsWith('assets/')) return raw;
    return resolveMediaUrl(raw);
  }
}
