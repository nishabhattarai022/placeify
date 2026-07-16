import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'providers/vendor_payments_provider.dart';
import 'widgets/payment_status_chip.dart';

class VendorPaymentsScreen extends ConsumerWidget {
  const VendorPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(vendorPaymentsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: paymentsAsync.when(
          loading: () => const _PaymentsShimmer(),
          error: (_, _) => _PaymentsError(
            onRetry: () => ref.invalidate(vendorPaymentsProvider),
          ),
          data: (data) {
            if (data.paymentHistory.isEmpty &&
                data.totalEarned == 0 &&
                data.pendingPaymentCount == 0) {
              return const _PaymentsEmptyState();
            }

            return RefreshIndicator(
              color: AppColors.vendorForest,
              onRefresh: () async {
                ref.invalidate(vendorPaymentsProvider);
                await ref.read(vendorPaymentsProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                children: [
                  const Text('Payments', style: AppTypography.sectionTitle),
                  const SizedBox(height: 16),
                  _SummaryCards(data: data),
                  const SizedBox(height: 24),
                  const Text(
                    'Payment history',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (data.paymentHistory.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'No completed payments yet. COD and eSewa payments appear here after they are marked paid.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    )
                  else
                    for (final payment in data.paymentHistory)
                      _PaymentHistoryRow(payment: payment),
                  const SizedBox(height: BottomNavTokens.scrollBottomPadding),
                ],
              ),
            );
          },
        ),
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
            label: 'Total revenue',
            value: Formatters.currencyFull(data.totalEarned),
            accent: AppColors.vendorForest,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Pending payments',
            value: '${data.pendingPaymentCount}',
            accent: AppColors.accent,
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

class _PaymentHistoryRow extends StatelessWidget {
  const _PaymentHistoryRow({required this.payment});

  final PaymentUpdate payment;

  @override
  Widget build(BuildContext context) {
    final method = payment.paymentMethodLabel;
    final customer = payment.customerName?.trim();
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
                  'Order #${payment.orderId}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    Formatters.currencyFull(payment.amount),
                    if (customer != null && customer.isNotEmpty) customer,
                  ].join(' · '),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (method != null) ...[
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.creamDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                method,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
            ),
          ],
          PaymentStatusChip(status: payment.status),
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
                  Icons.payments_outlined,
                  size: 48,
                  color: AppColors.bark.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No payments yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Completed COD and eSewa payments will appear here once they are marked paid.',
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
