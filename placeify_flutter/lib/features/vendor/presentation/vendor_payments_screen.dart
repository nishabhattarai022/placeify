import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart' show OrderPaymentStatus;

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_order.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_payout.dart';
import 'providers/vendor_orders_provider.dart';
import 'providers/vendor_payments_provider.dart';
import 'widgets/payment_status_chip.dart';

class VendorPaymentsScreen extends ConsumerWidget {
  const VendorPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(vendorPaymentsProvider);
    final orders = ref.watch(vendorOrdersProvider).value ?? const <VendorOrder>[];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: paymentsAsync.when(
          loading: () => const _PaymentsShimmer(),
          error: (_, __) => _PaymentsError(
            onRetry: () => ref.invalidate(vendorPaymentsProvider),
          ),
          data: (data) {
            if (data.payouts.isEmpty &&
                data.totalEarned == 0 &&
                orders.isEmpty) {
              return const _PaymentsEmptyState();
            }

            return RefreshIndicator(
              color: AppColors.vendorForest,
              onRefresh: () async {
                ref.invalidate(vendorPaymentsProvider);
                ref.invalidate(vendorOrdersProvider);
                await Future.wait([
                  ref.read(vendorPaymentsProvider.future),
                  ref.read(vendorOrdersProvider.future),
                ]);
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                itemCount: data.payouts.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payments', style: AppTypography.sectionTitle),
                        const SizedBox(height: 16),
                        _SummaryCards(data: data),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Payout history',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.espresso,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: data.canRequestPayout
                                  ? () => _requestPayout(context, ref)
                                  : null,
                              child: Text(
                                data.isRequestingPayout
                                    ? 'Processing…'
                                    : 'Request payout',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }

                  if (index == 1) {
                    return const _OrderPaymentHistoryList();
                  }

                  final payout = data.payouts[index - 2];
                  return _PayoutRow(payout: payout);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _requestPayout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Request payout?'),
        content: const Text(
          'Your pending balance will be queued for transfer within 2–3 business days.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final error = await ref.read(vendorPaymentsProvider.notifier).requestPayout();
    if (!context.mounted) return;
    if (error != null) {
      PlaceifyToast.show(context, error);
    } else {
      PlaceifyToast.show(context, 'Payout request submitted');
    }
  }
}

class _OrderPaymentHistoryList extends ConsumerWidget {
  const _OrderPaymentHistoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(vendorOrdersProvider);

    return ordersAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (orders) {
        if (orders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            for (var i = 0; i < orders.length; i++)
              _OrderPaymentHistoryBlock(
                order: orders[i],
                isLast: i == orders.length - 1,
              ),
          ],
        );
      },
    );
  }
}

class _OrderPaymentHistoryBlock extends ConsumerWidget {
  const _OrderPaymentHistoryBlock({
    required this.order,
    required this.isLast,
  });

  final VendorOrder order;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auditAsync = ref.watch(orderPaymentAuditTrailProvider(order.id));

    return auditAsync.when(
      loading: () => Padding(
        padding: EdgeInsets.only(bottom: isLast ? 12 : 10),
        child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (updates) {
        if (updates.isEmpty) {
          return _PaymentHistoryRow(
            amount: order.totalAmount,
            reference: 'Order #${order.orderNumber} · ${order.customerName}',
            date: order.orderedAt,
            status: _mapOrderPaymentStatus(order.orderPaymentStatus),
            marginBottom: isLast ? 12 : 10,
          );
        }

        return Column(
          children: [
            for (var i = 0; i < updates.length; i++)
              _PaymentHistoryRow(
                amount: updates[i].amount,
                reference: _referenceForUpdate(order, updates[i]),
                date: updates[i].updatedAt,
                status: updates[i].status,
                marginBottom: i == updates.length - 1
                    ? (isLast ? 12 : 10)
                    : 10,
              ),
          ],
        );
      },
    );
  }

  String _referenceForUpdate(VendorOrder order, PaymentUpdate update) {
    final orderLabel = 'Order #${order.orderNumber}';
    if (update.note.isEmpty) return orderLabel;
    return '$orderLabel · ${update.note}';
  }

  PaymentStatus _mapOrderPaymentStatus(OrderPaymentStatus status) {
    return switch (status) {
      OrderPaymentStatus.unpaid => PaymentStatus.pending,
      OrderPaymentStatus.paymentReceived => PaymentStatus.paid,
      OrderPaymentStatus.paymentConfirmed => PaymentStatus.paid,
    };
  }
}

class _PaymentHistoryRow extends StatelessWidget {
  const _PaymentHistoryRow({
    required this.amount,
    required this.reference,
    required this.date,
    required this.status,
    required this.marginBottom,
  });

  final double amount;
  final String reference;
  final DateTime date;
  final PaymentStatus status;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.currencyFull(amount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reference,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.shortDate(date),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          PaymentStatusChip(status: status),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.data});

  final VendorPaymentsData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Pending payout',
            value: Formatters.currencyFull(data.pendingBalance),
            accent: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Total earned',
            value: Formatters.currencyFull(data.totalEarned),
            accent: AppColors.vendorForest,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.lg,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayoutRow extends StatelessWidget {
  const _PayoutRow({required this.payout});

  final VendorPayout payout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.currencyFull(payout.amount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payout.reference,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                if (payout.paidAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    Formatters.shortDate(payout.paidAt!),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PaymentStatusChip(status: payout.status),
        ],
      ),
    );
  }
}

class _PaymentsEmptyState extends StatelessWidget {
  const _PaymentsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payments', style: AppTypography.sectionTitle),
          const Spacer(),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 48,
                  color: AppColors.bark.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No payouts yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete your first sale to start earning. Payouts appear here once orders are fulfilled.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const SizedBox(height: BottomNavTokens.scrollBottomPadding),
        ],
      ),
    );
  }
}

class _PaymentsShimmer extends StatelessWidget {
  const _PaymentsShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(borderRadius: AppRadii.sm),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: ShimmerLoader(borderRadius: AppRadii.lg),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 90,
                  child: ShimmerLoader(borderRadius: AppRadii.lg),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentsError extends StatelessWidget {
  const _PaymentsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Could not load payments'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
