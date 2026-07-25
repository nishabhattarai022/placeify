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
import '../../../core/widgets/toast_overlay.dart';
import '../../profile/presentation/widgets/profile_sub_hero.dart';
import '../../profile/presentation/widgets/shared/profile_submit_button.dart';
import '../domain/constants/order_strings.dart';
import '../domain/enums/consumer_order_status.dart';
import '../domain/models/order.dart';
import 'providers/orders_provider.dart';
import 'widgets/consumer_order_status_chip.dart';
import 'widgets/consumer_payment_status_chip.dart';
import 'widgets/order_item_row.dart';
import 'widgets/order_reason_sheets.dart';
import 'widgets/order_section_card.dart';
import 'widgets/order_timeline.dart';
import 'widgets/payment_lifecycle_timeline.dart';
import 'widgets/leave_review_sheet.dart';
import 'providers/submitted_order_reviews_provider.dart';
import 'package:placeify_flutter/features/messaging/presentation/conversations_screen.dart';

class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderByIdProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: orderAsync.when(
        loading: () => const _OrderDetailShimmer(),
        error: (_, __) => _OrderDetailError(
          onRetry: () => ref.invalidate(orderByIdProvider(orderId)),
        ),
        data: (order) {
          if (order == null) {
            return _OrderDetailError(
              onRetry: () => ref.invalidate(orderByIdProvider(orderId)),
            );
          }
          return _OrderDetailBody(order: order);
        },
      ),
    );
  }
}

class _OrderDetailBody extends ConsumerWidget {
  const _OrderDetailBody({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: ProfileSubHero(
            title: order.orderNumber,
            subtitle:
                '${OrderStrings.placedOnPrefix} ${Formatters.shortDate(order.placedAt)}',
            bottom: Align(
              alignment: Alignment.centerLeft,
              child: ConsumerPaymentStatusChip(status: order.paymentStatus),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.xxl),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              OrderSectionCard(
                title: OrderStrings.vendorSectionTitle,
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.creamDark),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.storefront_outlined,
                        size: 22,
                        color: AppColors.bark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.vendorName,
                            style: AppTypography.productName,
                          ),
                          const SizedBox(height: 4),
                          ConsumerOrderStatusChip(status: order.status),
                        ],
                      ),
                    ),
                    if (order.vendorId.trim().isNotEmpty &&
                        order.vendorId != '0')
                      TextButton.icon(
                        onPressed: () => openChatWithVendor(
                          context,
                          ref,
                          order.vendorId,
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 16),
                        label: const Text('Chat'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OrderSectionCard(
                title: OrderStrings.timelineSectionTitle,
                child: OrderTimeline(order: order),
              ),
              const SizedBox(height: 12),
              OrderSectionCard(
                title: 'Payment timeline',
                child: PaymentLifecycleTimeline(orderId: order.id),
              ),
              const SizedBox(height: 12),
              OrderSectionCard(
                title: OrderStrings.itemsSectionTitle,
                child: Column(
                  children: [
                    for (final item in order.items)
                      OrderItemRow(
                        item: item,
                        showAddToCart: order.isDelivered,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OrderSectionCard(
                title: OrderStrings.summarySectionTitle,
                child: Column(
                  children: [
                    _SummaryRow(
                      label: OrderStrings.subtotalLabel,
                      value: Formatters.currencyFull(order.subtotal),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: OrderStrings.deliveryFeeLabel,
                      value: Formatters.currencyFull(order.deliveryFee),
                    ),
                    if (order.discount > 0) ...[
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: OrderStrings.discountLabel,
                        value: Formatters.currencyDecimalDiscount(order.discount),
                        valueColor: AppColors.rust,
                      ),
                    ],
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.creamDark, height: 1),
                    ),
                    _SummaryRow(
                      label: OrderStrings.totalLabel,
                      value: Formatters.currencyFull(order.total),
                      bold: true,
                    ),
                    const SizedBox(height: 12),
                    _SummaryRow(
                      label: OrderStrings.paymentMethodLabel,
                      value: order.paymentMethod,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment status',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        ConsumerPaymentStatusChip(status: order.paymentStatus),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OrderSectionCard(
                title: OrderStrings.deliveryDetailsTitle,
                child: Column(
                  children: [
                    _SummaryRow(
                      label: OrderStrings.orderDateLabel,
                      value: Formatters.shortDate(order.placedAt),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          OrderStrings.deliveryStatusLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        ConsumerOrderStatusChip(status: order.status),
                      ],
                    ),
                    if (order.customerName != null &&
                        order.customerName!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: OrderStrings.customerNameLabel,
                        value: order.customerName!.trim(),
                      ),
                    ],
                    if (order.customerPhone != null &&
                        order.customerPhone!.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _SummaryRow(
                        label: OrderStrings.customerPhoneLabel,
                        value: order.customerPhone!.trim(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OrderSectionCard(
                title: OrderStrings.addressSectionTitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        order.deliveryAddress.trim().isEmpty
                            ? '—'
                            : order.deliveryAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ..._buildActions(context, ref),
            ]),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context, WidgetRef ref) {
    final buttons = <Widget>[];

    void addButton(Widget button) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(height: 12));
      }
      buttons.add(button);
    }

    if (order.needsEsewaPayment) {
      final orderId = int.tryParse(order.id);
      if (orderId != null) {
        addButton(
          ProfileSubmitButton(
            label: 'Pay with eSewa',
            onPressed: () {
              HapticService.medium();
              context.push('/cart/checkout/esewa/$orderId');
            },
          ),
        );
      }
    }

    if (order.hasTracking && order.isActive) {
      addButton(
        ProfileSubmitButton(
          label: OrderStrings.trackAction,
          onPressed: () {
            HapticService.light();
            context.pushNamed(
              'profileOrderTracking',
              pathParameters: {'orderId': order.id},
            );
          },
        ),
      );
    }

    if (order.isCancellable) {
      addButton(
        ProfileSubmitButton(
          label: OrderStrings.cancelAction,
          onPressed: () => OrderCancelSheet.show(context, ref, order),
        ),
      );
    }

    if (order.isDelivered) {
      addButton(
        ProfileSubmitButton(
          label: OrderStrings.reorderAction,
          onPressed: () {
            ref.read(ordersProvider.notifier).reorder(order.id, context: context);
          },
        ),
      );
      addButton(
        ProfileSubmitButton(
          label: OrderStrings.requestReturnAction,
          onPressed: () => OrderReturnSheet.show(context, ref, order),
        ),
      );
      final alreadyReviewed =
          ref.watch(submittedOrderReviewsProvider).contains(order.id);
      // #region agent log
      // Detail used to disable this button when alreadyReviewed — that blocked edits.
      // #endregion
      addButton(
        OutlinedButton(
          onPressed: () => LeaveReviewSheet.show(context, ref, order: order),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.espresso,
            disabledForegroundColor: AppColors.textMuted,
            side: const BorderSide(color: AppColors.sand, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              alreadyReviewed
                  ? OrderStrings.updateReviewAction
                  : OrderStrings.leaveReviewAction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    if (order.isActive &&
        order.status.index >= ConsumerOrderStatus.packed.index) {
      addButton(
        OutlinedButton(
          onPressed: () {
            HapticService.light();
            PlaceifyToast.show(
              context,
              '${OrderStrings.contactSupportAction} coming soon',
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
          child: SizedBox(
            width: double.infinity,
            child: Text(
              OrderStrings.contactSupportAction,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const [];

    return [
      const SizedBox(height: 20),
      ...buttons,
    ];
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: bold ? 16 : 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
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
          height: 140,
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
                  height: 120,
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
        const ProfileSubHero(title: OrderStrings.orderDetailTitle),
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
