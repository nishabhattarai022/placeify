import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../profile/presentation/widgets/profile_sub_hero.dart';
import '../../profile/presentation/widgets/shared/profile_submit_button.dart';
import '../domain/constants/vendor_routes.dart';
import '../domain/enums/order_status.dart';
import '../domain/models/delivery_update.dart';
import '../domain/models/vendor_order.dart';
import '../domain/enums/payment_status.dart';
import '../domain/models/payment_update.dart';
import 'providers/vendor_order_detail_provider.dart';
import 'providers/vendor_payments_provider.dart';
import 'providers/vendor_product_image_provider.dart';
import 'widgets/order_action_sheet.dart';
import 'widgets/order_status_chip.dart';
import 'widgets/order_timeline_widget.dart';
import 'widgets/payment_status_chip.dart';
import 'widgets/payment_update_sheet.dart';
import 'widgets/vendor_list_thumbnail.dart';

class VendorOrderDetailScreen extends ConsumerWidget {
  const VendorOrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(vendorOrderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: detailAsync.when(
        loading: () => const _OrderDetailShimmer(),
        error: (_, __) => _OrderDetailError(onRetry: () {
          ref.invalidate(vendorOrderDetailProvider(orderId));
        }),
        data: (detail) {
          if (detail == null) {
            return _OrderDetailError(onRetry: () {
              ref.invalidate(vendorOrderDetailProvider(orderId));
            });
          }

          return _OrderDetailBody(
            order: detail.order,
            deliveryUpdates: detail.deliveryUpdates,
          );
        },
      ),
    );
  }
}

class _OrderDetailBody extends ConsumerWidget {
  const _OrderDetailBody({
    required this.order,
    required this.deliveryUpdates,
  });

  final VendorOrder order;
  final List<DeliveryUpdate> deliveryUpdates;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitPrice = order.quantity > 0
        ? order.totalAmount / order.quantity
        : order.totalAmount;
    final isPending = order.status == OrderStatus.pending;
    final canUpdateDelivery = !isPending &&
        order.status != OrderStatus.rejected &&
        order.status != OrderStatus.cancelled &&
        order.status != OrderStatus.delivered;
    final imageUrl = ref.watch(vendorProductImageUrlProvider(order.productId));

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: ProfileSubHero(
            title: 'Order #${order.orderNumber}',
            bottom: OrderStatusChip(
              status: order.status,
              label: order.statusLabel,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.xxl),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SectionCard(
                title: 'Customer',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: AppTypography.productName,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Placed ${Formatters.shortDate(order.orderedAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Items',
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VendorListThumbnail(
                      label: order.productName,
                      imageUrl: imageUrl,
                      fallbackIconPath: _iconForProduct(order.productName),
                      size: 56,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.productName,
                            style: AppTypography.productName,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty ${order.quantity} · ${Formatters.currencyFull(unitPrice)} each',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Formatters.currencyFull(order.totalAmount),
                      style: AppTypography.productName,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Total',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order total',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      Formatters.currencyFull(order.totalAmount),
                      style: AppTypography.priceFullPrice,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Timeline',
                child: OrderTimelineWidget(
                  status: order.status,
                  deliveryUpdates: deliveryUpdates,
                  vendorEditable: true,
                ),
              ),
              const SizedBox(height: 12),
              _PaymentSection(order: order),
              if (canUpdateDelivery) ...[
                const SizedBox(height: 20),
                ProfileSubmitButton(
                  label: 'Post delivery update',
                  onPressed: () {
                    HapticService.light();
                    context.push(VendorRoutes.deliveryUpdate(order.id));
                  },
                ),
              ],
              if (isPending) ...[
                const SizedBox(height: 20),
                ProfileSubmitButton(
                  label: 'Accept or reject order',
                  onPressed: () {
                    HapticService.light();
                    OrderActionSheet.show(context, ref, order);
                  },
                ),
              ],
            ]),
          ),
        ),
      ],
    );
  }

  static String _iconForProduct(String productName) {
    final lower = productName.toLowerCase();
    if (lower.contains('sofa')) return 'assets/icons/ic_sofa.svg';
    if (lower.contains('table') || lower.contains('desk')) {
      return 'assets/icons/ic_table.svg';
    }
    return 'assets/icons/ic_chair.svg';
  }
}

class _PaymentSection extends ConsumerWidget {
  const _PaymentSection({required this.order});

  final VendorOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(orderPaymentAuditTrailProvider(order.id));

    return _SectionCard(
      title: 'Payment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          auditAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const Text(
              'Could not load payment history.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            data: (updates) {
              if (updates.isEmpty) {
                return const Text(
                  'No payment updates recorded',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                );
              }

              return Column(
                children: [
                  for (var i = 0; i < updates.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _PaymentAuditRow(update: updates[i]),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () async {
              HapticService.light();
              await PaymentUpdateSheet.show(
                context,
                ref,
                orderId: order.id,
                orderLabel: 'Order #${order.orderNumber}',
              );
              ref.invalidate(orderPaymentAuditTrailProvider(order.id));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.vendorForest,
              side: const BorderSide(color: AppColors.vendorForest),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text('Update payment'),
          ),
        ],
      ),
    );
  }
}

class _PaymentAuditRow extends StatelessWidget {
  const _PaymentAuditRow({required this.update});

  final PaymentUpdate update;

  static String _statusLabel(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.pending => 'Pending',
      PaymentStatus.paid => 'Received',
      PaymentStatus.partial => 'Partial',
      PaymentStatus.refunded => 'Refunded',
      PaymentStatus.failed => 'Failed',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PaymentStatusChip(status: update.status),
              const Spacer(),
              Text(
                Formatters.shortDate(update.updatedAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${_statusLabel(update.status)} · ${Formatters.currencyFull(update.amount)}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
          if (update.note.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              update.note,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.lg,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.metricLabel.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _OrderDetailShimmer extends StatelessWidget {
  const _OrderDetailShimmer();

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
              4,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: 100,
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

class _OrderDetailError extends StatelessWidget {
  const _OrderDetailError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileSubHero(title: 'Order'),
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
                    'Could not load this order.',
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
