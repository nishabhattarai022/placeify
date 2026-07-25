import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../vendor/presentation/widgets/payment_status_chip.dart';
import '../domain/models/user_payment_record.dart';
import 'providers/user_payments_provider.dart';

class UserPaymentsScreen extends ConsumerStatefulWidget {
  const UserPaymentsScreen({super.key});

  @override
  ConsumerState<UserPaymentsScreen> createState() => _UserPaymentsScreenState();
}

class _UserPaymentsScreenState extends ConsumerState<UserPaymentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(userPaymentsProvider.notifier).refresh();
    });
  }

  Future<void> _refresh() =>
      ref.read(userPaymentsProvider.notifier).refresh();

  @override
  Widget build(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return Center(
        child: FilledButton(
          onPressed: () => context.push('/login'),
          child: const Text('Sign in'),
        ),
      );
    }

    final paymentsAsync = ref.watch(userPaymentsProvider);
    final pad = MediaQuery.sizeOf(context).width >= 900
        ? AppSpacing.xxl
        : AppSpacing.lg;

    return paymentsAsync.when(
      loading: () => Padding(
        padding: EdgeInsets.all(pad),
        child: Column(
          children: [
            for (var i = 0; i < 5; i++) ...[
              const SizedBox(height: 56, child: ShimmerLoader()),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(onPressed: _refresh, child: const Text('Retry')),
          ],
        ),
      ),
      data: (payments) {
        return RefreshIndicator(
          color: AppColors.forest,
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(pad, AppSpacing.lg, pad, AppSpacing.sm),
                  child: Text(
                    'Payment History',
                    style: AppTypography.sectionTitle,
                  ),
                ),
              ),
              if (payments.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No payment history yet.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(pad, 0, pad, AppSpacing.xxl),
                  sliver: SliverList.separated(
                    itemCount: payments.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.creamDark),
                    itemBuilder: (context, index) {
                      return _TransactionRow(payment: payments[index]);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.payment});

  final UserPaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.currencyFull(payment.amount),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Order #${payment.orderNumber}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${payment.paymentMethodLabel} · ${_date(payment.createdAt)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          PaymentStatusChip(status: payment.status),
        ],
      ),
    );
  }

  static String _date(DateTime date) {
    final local = date.toLocal();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }
}
