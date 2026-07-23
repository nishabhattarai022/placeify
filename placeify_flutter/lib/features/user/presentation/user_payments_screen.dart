import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../vendor/domain/enums/payment_status.dart';
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

  Future<void> _refresh() async {
    await ref.read(userPaymentsProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return _AuthRequired(onLogin: () => context.push('/login'));
    }

    final paymentsAsync = ref.watch(userPaymentsProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = isDesktop ? AppSpacing.xxl : AppSpacing.lg;

    return paymentsAsync.when(
      loading: () => _PaymentsSkeleton(horizontalPadding: horizontalPadding),
      error: (error, _) => _ErrorState(
        message: error.toString(),
        onRetry: _refresh,
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
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isDesktop ? AppSpacing.xxl : AppSpacing.lg,
                    horizontalPadding,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment history',
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        payments.isEmpty
                            ? 'Track orders, payments, and refunds in one place.'
                            : '${payments.length} payment'
                                '${payments.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (payments.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    AppSpacing.xxl,
                  ),
                  sliver: SliverList.separated(
                    itemCount: payments.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      return _PaymentCard(payment: payments[index]);
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

class _PaymentCard extends StatefulWidget {
  const _PaymentCard({required this.payment});

  final UserPaymentRecord payment;

  @override
  State<_PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<_PaymentCard> {
  bool _expanded = false;

  UserPaymentRecord get payment => widget.payment;

  bool get _hasRefund =>
      payment.refundStatusLabel != null ||
      payment.status == PaymentStatus.refundPending ||
      payment.status == PaymentStatus.refunded;

  @override
  Widget build(BuildContext context) {
    final paymentDate = payment.paymentDate ?? payment.orderDate;

    return Material(
      color: AppColors.warmWhite,
      borderRadius: AppRadii.md,
      child: InkWell(
        borderRadius: AppRadii.md,
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: AppRadii.md,
            border: Border.all(
              color: _expanded ? AppColors.sand : AppColors.creamDark,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProductThumb(url: payment.thumbnailUrl),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
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
                                    payment.vendorName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.espresso,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Order #${payment.orderNumber}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
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
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          Formatters.currencyFull(payment.amount),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.forest,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _MetaChip(
                              icon: payment.paymentMethodLabel == 'COD'
                                  ? Icons.payments_outlined
                                  : Icons.account_balance_wallet_outlined,
                              label: payment.paymentMethodLabel,
                            ),
                            if (paymentDate != null)
                              _MetaChip(
                                icon: Icons.schedule_outlined,
                                label: Formatters.shortDateTime(paymentDate),
                              ),
                            if (_hasRefund &&
                                payment.refundStatusLabel != null)
                              _RefundStatusChip(
                                label: payment.refundStatusLabel!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textMuted.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: _expanded
                    ? _ExpandedDetails(payment: payment)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.payment});

  final UserPaymentRecord payment;

  @override
  Widget build(BuildContext context) {
    final steps = _refundTimelineSteps(payment);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.creamDark),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Order ID', value: '#${payment.orderNumber}'),
          if (payment.transactionId != null &&
              payment.transactionId!.trim().isNotEmpty)
            _DetailRow(label: 'Transaction ID', value: payment.transactionId!),
          if (payment.paymentDate != null)
            _DetailRow(
              label: 'Payment date',
              value: Formatters.shortDateTime(payment.paymentDate!),
            ),
          if (payment.orderDate != null)
            _DetailRow(
              label: 'Order date',
              value: Formatters.shortDateTime(payment.orderDate!),
            ),
          _DetailRow(label: 'Payment method', value: payment.paymentMethodLabel),
          _DetailRow(
            label: 'Payment status',
            value: _compactStatusLabel(payment.status),
          ),
          if (payment.refundStatusLabel != null)
            _DetailRow(
              label: 'Refund status',
              value: payment.refundStatusLabel!,
            ),
          if (payment.refundAmount != null)
            _DetailRow(
              label: 'Refund amount',
              value: Formatters.currencyFull(payment.refundAmount!),
            ),
          if (payment.refundReason != null &&
              payment.refundReason!.trim().isNotEmpty)
            _DetailRow(label: 'Refund reason', value: payment.refundReason!),
          if (payment.deliveryFee != null)
            _DetailRow(
              label: 'Delivery',
              value: Formatters.currencyFull(payment.deliveryFee!),
            ),
          if (payment.discount != null)
            _DetailRow(
              label: 'Discount',
              value: Formatters.currencyFull(payment.discount!),
            ),
          if (steps.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Refund timeline',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _RefundTimeline(steps: steps),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.espresso,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundTimeline extends StatelessWidget {
  const _RefundTimeline({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 3),
                    decoration: const BoxDecoration(
                      color: AppColors.forest,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i < steps.length - 1)
                    Container(
                      width: 2,
                      height: 22,
                      color: AppColors.creamDark,
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: i < steps.length - 1 ? AppSpacing.sm : 0,
                  ),
                  child: Text(
                    steps[i],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

List<String> _refundTimelineSteps(UserPaymentRecord payment) {
  final isRefundRelated = payment.status == PaymentStatus.refundPending ||
      payment.status == PaymentStatus.refunded ||
      (payment.refundStatusLabel?.isNotEmpty ?? false);
  if (!isRefundRelated) return const [];

  final steps = <String>[];
  if (payment.status == PaymentStatus.paid ||
      payment.status == PaymentStatus.refundPending ||
      payment.status == PaymentStatus.refunded ||
      payment.paymentDate != null) {
    steps.add('Order Paid');
  }
  final orderStatus = payment.orderStatus?.toLowerCase() ?? '';
  if (orderStatus.contains('reject')) {
    steps.add('Vendor Rejected');
  }
  if (payment.refundReason != null &&
      payment.refundReason!.trim().isNotEmpty) {
    steps.add('Refund Requested');
  }
  if (payment.status == PaymentStatus.refundPending ||
      (payment.refundStatusLabel?.toLowerCase().contains('pending') ??
          false)) {
    steps.add('Refund Pending');
  }
  if (payment.status == PaymentStatus.refunded ||
      (payment.refundStatusLabel?.toLowerCase().contains('completed') ??
          false) ||
      (payment.refundStatusLabel?.toLowerCase().contains('refunded') ??
          false)) {
    steps.add('Refund Completed');
  }
  return steps;
}

String _compactStatusLabel(PaymentStatus status) => switch (status) {
      PaymentStatus.pending => 'Pending',
      PaymentStatus.paid => 'Paid',
      PaymentStatus.partial => 'Partial',
      PaymentStatus.refundPending => 'Refund Pending',
      PaymentStatus.refunded => 'Refunded',
      PaymentStatus.failed => 'Failed',
    };

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.sm,
      child: Container(
        width: 64,
        height: 64,
        color: AppColors.creamDark,
        child: url == null
            ? const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.textMuted,
                size: 26,
              )
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textMuted,
                ),
              ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadii.pill,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.textSecondary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundStatusChip extends StatelessWidget {
  const _RefundStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final pending = label.toLowerCase().contains('pending');
    final bg = pending ? AppColors.accentBg : AppColors.tealBg;
    final fg = pending ? AppColors.onboardingAmberDark : AppColors.teal;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.creamDark,
                borderRadius: AppRadii.lg,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 34,
                color: AppColors.bark.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'No payment history yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'When you place an order and pay with eSewa or COD, '
              'your payments will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppColors.textSecondary.withValues(alpha: 0.95),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentsSkeleton extends StatelessWidget {
  const _PaymentsSkeleton({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        AppSpacing.lg,
        horizontalPadding,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 180,
            height: 28,
            child: ShimmerLoader(borderRadius: AppRadii.sm),
          ),
          const SizedBox(height: AppSpacing.sm),
          const SizedBox(
            width: 120,
            height: 14,
            child: ShimmerLoader(borderRadius: AppRadii.sm),
          ),
          const SizedBox(height: AppSpacing.xl),
          for (var i = 0; i < 4; i++) ...[
            const SizedBox(
              height: 96,
              child: ShimmerLoader(borderRadius: AppRadii.md),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _AuthRequired extends StatelessWidget {
  const _AuthRequired({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 40,
            color: AppColors.bark.withValues(alpha: 0.55),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Sign in to view your payment history',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onLogin, child: const Text('Sign in')),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColors.rust.withValues(alpha: 0.8),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Could not load payments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
