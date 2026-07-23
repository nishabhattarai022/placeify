import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'providers/vendor_payments_provider.dart';
import 'widgets/payment_status_chip.dart';

enum _DateFilter { today, last7, last30, custom }

enum _RefundFilter { all, none, pending, completed }

enum _SortOption { newest, oldest, highestAmount, lowestAmount }

const _pageSize = 20;

class VendorPaymentsScreen extends ConsumerStatefulWidget {
  const VendorPaymentsScreen({super.key});

  @override
  ConsumerState<VendorPaymentsScreen> createState() =>
      _VendorPaymentsScreenState();
}

class _VendorPaymentsScreenState extends ConsumerState<VendorPaymentsScreen> {
  _DateFilter _dateFilter = _DateFilter.last30;
  DateTimeRange? _customRange;
  String? _methodFilter;
  PaymentStatus? _statusFilter;
  _RefundFilter _refundFilter = _RefundFilter.all;
  _SortOption _sort = _SortOption.newest;
  int _page = 0;

  List<PaymentUpdate> _applyFilters(List<PaymentUpdate> history) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    DateTime? rangeStart;
    DateTime? rangeEnd;
    switch (_dateFilter) {
      case _DateFilter.today:
        rangeStart = todayStart;
        rangeEnd = todayStart.add(const Duration(days: 1));
      case _DateFilter.last7:
        rangeStart = todayStart.subtract(const Duration(days: 6));
        rangeEnd = todayStart.add(const Duration(days: 1));
      case _DateFilter.last30:
        rangeStart = todayStart.subtract(const Duration(days: 29));
        rangeEnd = todayStart.add(const Duration(days: 1));
      case _DateFilter.custom:
        if (_customRange != null) {
          rangeStart = DateTime(
            _customRange!.start.year,
            _customRange!.start.month,
            _customRange!.start.day,
          );
          rangeEnd = DateTime(
            _customRange!.end.year,
            _customRange!.end.month,
            _customRange!.end.day,
          ).add(const Duration(days: 1));
        }
    }

    var rows = history.where((payment) {
      final eventDate = payment.createdAt ?? payment.updatedAt;
      if (rangeStart != null &&
          rangeEnd != null &&
          (eventDate.isBefore(rangeStart) || !eventDate.isBefore(rangeEnd))) {
        return false;
      }
      if (_methodFilter != null &&
          (payment.paymentMethodLabel ?? '').toLowerCase() !=
              _methodFilter!.toLowerCase()) {
        return false;
      }
      if (_statusFilter != null && payment.status != _statusFilter) {
        return false;
      }
      final refund = (payment.refundStatus ?? '').toLowerCase();
      return switch (_refundFilter) {
        _RefundFilter.all => true,
        _RefundFilter.none => refund.isEmpty,
        _RefundFilter.pending =>
          refund.contains('pending') ||
              payment.status == PaymentStatus.refundPending,
        _RefundFilter.completed =>
          refund.contains('completed') ||
              refund.contains('refunded') ||
              payment.status == PaymentStatus.refunded,
      };
    }).toList();

    rows.sort((a, b) {
      final aDate = a.createdAt ?? a.updatedAt;
      final bDate = b.createdAt ?? b.updatedAt;
      return switch (_sort) {
        _SortOption.newest => bDate.compareTo(aDate),
        _SortOption.oldest => aDate.compareTo(bDate),
        _SortOption.highestAmount => b.amount.compareTo(a.amount),
        _SortOption.lowestAmount => a.amount.compareTo(b.amount),
      };
    });

    return rows;
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 3),
      lastDate: now,
      initialDateRange: _customRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.vendorForest,
              onPrimary: Colors.white,
              surface: AppColors.warmWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() {
      _dateFilter = _DateFilter.custom;
      _customRange = picked;
      _page = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
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

            final filtered = _applyFilters(data.paymentHistory);
            final totalPages = filtered.isEmpty
                ? 1
                : ((filtered.length + _pageSize - 1) / _pageSize).ceil();
            final safePage = _page.clamp(0, totalPages - 1);
            if (safePage != _page) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _page = safePage);
              });
            }
            final pageRows = filtered
                .skip(safePage * _pageSize)
                .take(_pageSize)
                .toList();

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
                  const SizedBox(height: AppSpacing.md),
                  _SummarySection(data: data),
                  const SizedBox(height: AppSpacing.lg),
                  _FilterBar(
                    dateFilter: _dateFilter,
                    customRange: _customRange,
                    methodFilter: _methodFilter,
                    statusFilter: _statusFilter,
                    refundFilter: _refundFilter,
                    sort: _sort,
                    onDateFilterChanged: (value) {
                      setState(() {
                        _dateFilter = value;
                        _page = 0;
                      });
                    },
                    onCustomRangeTap: _pickCustomRange,
                    onMethodChanged: (value) {
                      setState(() {
                        _methodFilter = value;
                        _page = 0;
                      });
                    },
                    onStatusChanged: (value) {
                      setState(() {
                        _statusFilter = value;
                        _page = 0;
                      });
                    },
                    onRefundFilterChanged: (value) {
                      setState(() {
                        _refundFilter = value;
                        _page = 0;
                      });
                    },
                    onSortChanged: (value) {
                      setState(() {
                        _sort = value;
                        _page = 0;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.espresso,
                          ),
                        ),
                      ),
                      Text(
                        '${filtered.length} record'
                        '${filtered.length == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (pageRows.isEmpty)
                    const _FilterEmptyHint()
                  else
                    for (final payment in pageRows)
                      _PaymentHistoryRow(payment: payment),
                  if (filtered.length > _pageSize) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _PaginationBar(
                      page: safePage,
                      totalPages: totalPages,
                      onPrevious: safePage > 0
                          ? () => setState(() => _page = safePage - 1)
                          : null,
                      onNext: safePage < totalPages - 1
                          ? () => setState(() => _page = safePage + 1)
                          : null,
                    ),
                  ],
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

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.data});

  final VendorPaymentsData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Total revenue',
                value: Formatters.currencyFull(data.totalEarned),
                accent: AppColors.vendorForest,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _SummaryCard(
                label: "Today's revenue",
                value: Formatters.currencyFull(data.todayRevenue),
                accent: AppColors.sage,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Monthly',
                value: Formatters.currencyFull(data.monthlyRevenue),
                accent: AppColors.forest,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _SummaryCard(
                label: 'Pending',
                value: '${data.pendingPaymentCount}',
                accent: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Refunds',
                value:
                    '${Formatters.currencyFull(data.refundAmount)} · ${data.refundCount}',
                accent: AppColors.coral,
                compact: true,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _SummaryCard(
                label: 'Net earnings',
                value: Formatters.currencyFull(data.netEarnings),
                accent: AppColors.vendorForest,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'COD / eSewa',
                value: '${data.codPaymentCount} / ${data.esewaPaymentCount}',
                accent: AppColors.bark,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _SummaryCard(
                label: 'AOV',
                value: Formatters.currencyFull(data.averageOrderValue),
                accent: AppColors.adminSlate,
              ),
            ),
          ],
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
    this.compact = false,
  });

  final String label;
  final String value;
  final Color accent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: compact ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: compact ? 14 : 16,
              fontWeight: FontWeight.w700,
              color: accent,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.dateFilter,
    required this.customRange,
    required this.methodFilter,
    required this.statusFilter,
    required this.refundFilter,
    required this.sort,
    required this.onDateFilterChanged,
    required this.onCustomRangeTap,
    required this.onMethodChanged,
    required this.onStatusChanged,
    required this.onRefundFilterChanged,
    required this.onSortChanged,
  });

  final _DateFilter dateFilter;
  final DateTimeRange? customRange;
  final String? methodFilter;
  final PaymentStatus? statusFilter;
  final _RefundFilter refundFilter;
  final _SortOption sort;
  final ValueChanged<_DateFilter> onDateFilterChanged;
  final VoidCallback onCustomRangeTap;
  final ValueChanged<String?> onMethodChanged;
  final ValueChanged<PaymentStatus?> onStatusChanged;
  final ValueChanged<_RefundFilter> onRefundFilterChanged;
  final ValueChanged<_SortOption> onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, size: 16, color: AppColors.textMuted),
              SizedBox(width: 6),
              Text(
                'Filters',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.espresso,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _FilterChip(
                label: 'Today',
                selected: dateFilter == _DateFilter.today,
                onTap: () => onDateFilterChanged(_DateFilter.today),
              ),
              _FilterChip(
                label: 'Last 7 days',
                selected: dateFilter == _DateFilter.last7,
                onTap: () => onDateFilterChanged(_DateFilter.last7),
              ),
              _FilterChip(
                label: 'Last 30 days',
                selected: dateFilter == _DateFilter.last30,
                onTap: () => onDateFilterChanged(_DateFilter.last30),
              ),
              _FilterChip(
                label: customRange == null
                    ? 'Custom'
                    : '${Formatters.shortDate(customRange!.start)} – ${Formatters.shortDate(customRange!.end)}',
                selected: dateFilter == _DateFilter.custom,
                onTap: onCustomRangeTap,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _DropdownRow<String?>(
            label: 'Method',
            value: methodFilter,
            items: const {
              null: 'All methods',
              'COD': 'COD',
              'eSewa': 'eSewa',
              'Khalti': 'Khalti',
              'Online': 'Online',
            },
            onChanged: onMethodChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          _DropdownRow<PaymentStatus?>(
            label: 'Status',
            value: statusFilter,
            items: {
              null: 'All statuses',
              for (final status in PaymentStatus.values)
                status: _statusLabel(status),
            },
            onChanged: onStatusChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          _DropdownRow<_RefundFilter>(
            label: 'Refund',
            value: refundFilter,
            items: const {
              _RefundFilter.all: 'All refunds',
              _RefundFilter.none: 'No refund',
              _RefundFilter.pending: 'Refund pending',
              _RefundFilter.completed: 'Refund completed',
            },
            onChanged: (value) {
              if (value != null) onRefundFilterChanged(value);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          _DropdownRow<_SortOption>(
            label: 'Sort',
            value: sort,
            items: const {
              _SortOption.newest: 'Newest',
              _SortOption.oldest: 'Oldest',
              _SortOption.highestAmount: 'Highest amount',
              _SortOption.lowestAmount: 'Lowest amount',
            },
            onChanged: (value) {
              if (value != null) onSortChanged(value);
            },
          ),
        ],
      ),
    );
  }

  static String _statusLabel(PaymentStatus status) => switch (status) {
        PaymentStatus.pending => 'Pending',
        PaymentStatus.paid => 'Paid',
        PaymentStatus.partial => 'Partial',
        PaymentStatus.refundPending => 'Refund pending',
        PaymentStatus.refunded => 'Refunded',
        PaymentStatus.failed => 'Failed',
      };
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.sageBg,
      checkmarkColor: AppColors.vendorForest,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: selected ? AppColors.vendorForest : AppColors.textSecondary,
      ),
      side: BorderSide(
        color: selected ? AppColors.vendorForest : AppColors.creamDark,
      ),
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: AppRadii.sm,
              border: Border.all(color: AppColors.creamDark),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                borderRadius: AppRadii.sm,
                items: items.entries
                    .map(
                      (entry) => DropdownMenuItem<T>(
                        value: entry.key,
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentHistoryRow extends StatefulWidget {
  const _PaymentHistoryRow({required this.payment});

  final PaymentUpdate payment;

  @override
  State<_PaymentHistoryRow> createState() => _PaymentHistoryRowState();
}

class _PaymentHistoryRowState extends State<_PaymentHistoryRow> {
  bool _expanded = false;

  PaymentUpdate get payment => widget.payment;

  bool get _hasRefund =>
      (payment.refundStatus?.trim().isNotEmpty ?? false) ||
      payment.status == PaymentStatus.refundPending ||
      payment.status == PaymentStatus.refunded;

  @override
  Widget build(BuildContext context) {
    final method = payment.paymentMethodLabel;
    final customer = payment.customerName?.trim();
    final orderLabel = payment.orderNumber ?? payment.orderId;
    final eventDate = payment.createdAt ?? payment.updatedAt;
    final earnings = payment.vendorEarnings ?? payment.amount;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (customer != null && customer.isNotEmpty)
                                ? customer
                                : 'Customer',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.espresso,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Order #$orderLabel',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    PaymentStatusChip(status: payment.status),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 22,
                        color: AppColors.textMuted.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      Formatters.currencyFull(payment.amount),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.vendorForest,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Earn ${Formatters.currencyFull(earnings)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (method != null)
                      _MetaChip(
                        icon: method == 'COD'
                            ? Icons.payments_outlined
                            : Icons.account_balance_wallet_outlined,
                        label: method,
                      ),
                    _MetaChip(
                      icon: Icons.schedule_outlined,
                      label: _formatDateTime(eventDate),
                    ),
                    if (_hasRefund)
                      _RefundBadge(
                        status: payment.refundStatus ??
                            (payment.status == PaymentStatus.refunded
                                ? 'completed'
                                : 'pending'),
                        date: payment.refundDate,
                      ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: _expanded
                      ? _VendorExpandedDetails(payment: payment)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime date) {
    return Formatters.shortDateTime(date);
  }
}

class _VendorExpandedDetails extends StatelessWidget {
  const _VendorExpandedDetails({required this.payment});

  final PaymentUpdate payment;

  @override
  Widget build(BuildContext context) {
    final email = payment.customerEmail?.trim();
    final steps = _vendorRefundTimelineSteps(payment);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: AppColors.creamDark),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Order ID',
            value: '#${payment.orderNumber ?? payment.orderId}',
          ),
          if (email != null && email.isNotEmpty)
            _DetailRow(label: 'Customer email', value: email),
          _DetailRow(
            label: 'Date & time',
            value: Formatters.shortDateTime(
              payment.createdAt ?? payment.updatedAt,
            ),
          ),
          if (payment.paymentMethodLabel != null)
            _DetailRow(
              label: 'Payment method',
              value: payment.paymentMethodLabel!,
            ),
          _DetailRow(
            label: 'Payment status',
            value: _compactStatusLabel(payment.status),
          ),
          if (payment.refundStatus != null &&
              payment.refundStatus!.trim().isNotEmpty)
            _DetailRow(label: 'Refund status', value: payment.refundStatus!),
          if (payment.note.trim().isNotEmpty)
            _DetailRow(label: 'Note', value: payment.note),
          if (payment.transactionId != null ||
              payment.providerTransactionId != null)
            _DetailRow(
              label: 'Transaction ID',
              value: [
                if (payment.transactionId != null) payment.transactionId!,
                if (payment.providerTransactionId != null)
                  payment.providerTransactionId!,
              ].join(' · '),
            ),
          if (payment.orderStatus != null &&
              payment.orderStatus!.trim().isNotEmpty)
            _DetailRow(label: 'Order status', value: payment.orderStatus!),
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
                      color: AppColors.vendorForest,
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

List<String> _vendorRefundTimelineSteps(PaymentUpdate payment) {
  final isRefundRelated = payment.status == PaymentStatus.refundPending ||
      payment.status == PaymentStatus.refunded ||
      (payment.refundStatus?.isNotEmpty ?? false);
  if (!isRefundRelated) return const [];

  final steps = <String>['Order Paid'];
  final orderStatus = payment.orderStatus?.toLowerCase() ?? '';
  if (orderStatus.contains('reject')) {
    steps.add('Vendor Rejected');
  }
  if (payment.note.toLowerCase().contains('refund') ||
      (payment.refundStatus?.isNotEmpty ?? false)) {
    steps.add('Refund Requested');
  }
  if (payment.status == PaymentStatus.refundPending ||
      (payment.refundStatus?.toLowerCase().contains('pending') ?? false)) {
    steps.add('Refund Pending');
  }
  if (payment.status == PaymentStatus.refunded ||
      (payment.refundStatus?.toLowerCase().contains('completed') ?? false) ||
      (payment.refundStatus?.toLowerCase().contains('refunded') ?? false)) {
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

class _RefundBadge extends StatelessWidget {
  const _RefundBadge({required this.status, this.date});

  final String status;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final pending = normalized.contains('pending');
    final (bg, fg, label) = pending
        ? (
            AppColors.accentBg,
            AppColors.onboardingAmberDark,
            'Refund Pending',
          )
        : (
            AppColors.tealBg,
            AppColors.teal,
            'Refunded',
          );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        date == null ? label : '$label · ${Formatters.shortDate(date!)}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.page,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  final int page;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.vendorForest,
        ),
        Text(
          'Page ${page + 1} of $totalPages',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.espresso,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          color: AppColors.vendorForest,
        ),
      ],
    );
  }
}

class _FilterEmptyHint extends StatelessWidget {
  const _FilterEmptyHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: const Column(
        children: [
          Icon(Icons.filter_alt_off_outlined, color: AppColors.textMuted),
          SizedBox(height: AppSpacing.sm),
          Text(
            'No payments match the current filters.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
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
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.creamDark,
                    borderRadius: AppRadii.lg,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 34,
                    color: AppColors.bark.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'No payment history yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'COD and eSewa payments will appear here once they are confirmed.',
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
          const SizedBox(
            width: 140,
            height: 28,
            child: ShimmerLoader(borderRadius: AppRadii.sm),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              const Expanded(
                child: SizedBox(
                  height: 72,
                  child: ShimmerLoader(borderRadius: AppRadii.md),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Expanded(
                child: SizedBox(
                  height: 72,
                  child: ShimmerLoader(borderRadius: AppRadii.md),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < 4; i++) ...[
            const SizedBox(
              height: 88,
              child: ShimmerLoader(borderRadius: AppRadii.md),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
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
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
