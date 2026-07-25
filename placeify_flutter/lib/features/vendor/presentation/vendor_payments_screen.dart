import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/dashboard_chrome.dart';
import '../../../core/widgets/dashboard_kpi_card.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/payment_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/payment_update.dart';
import 'providers/vendor_payments_provider.dart';
import 'widgets/payment_status_chip.dart';

enum _DateFilter { today, last7, last30, custom }

enum _SortOption { newest, oldest, highestAmount }

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
  _SortOption _sort = _SortOption.newest;
  int _page = 0;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

    final q = _query.trim().toLowerCase();
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
      if (q.isNotEmpty) {
        final haystack = [
          payment.customerName,
          payment.orderNumber,
          payment.orderId,
          payment.transactionId,
          payment.paymentMethodLabel,
          payment.note,
        ].whereType<String>().join(' ').toLowerCase();
        if (!haystack.contains(q)) return false;
      }
      return true;
    }).toList();

    rows.sort((a, b) {
      final aDate = a.createdAt ?? a.updatedAt;
      final bDate = b.createdAt ?? b.updatedAt;
      return switch (_sort) {
        _SortOption.newest => bDate.compareTo(aDate),
        _SortOption.oldest => aDate.compareTo(bDate),
        _SortOption.highestAmount => b.amount.compareTo(a.amount),
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
    );
    if (picked == null || !mounted) return;
    setState(() {
      _dateFilter = _DateFilter.custom;
      _customRange = picked;
      _page = 0;
    });
  }

  List<double> _last7DayTotals(List<PaymentUpdate> history) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final next = day.add(const Duration(days: 1));
      return history
          .where((p) {
            final d = p.createdAt ?? p.updatedAt;
            return !d.isBefore(day) && d.isBefore(next);
          })
          .fold<double>(0, (sum, p) => sum + (p.vendorEarnings ?? p.amount));
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(vendorPaymentsProvider);
    final width = MediaQuery.sizeOf(context).width;
    final kpiColumns = width >= 900 ? 3 : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      body: SafeArea(
        child: paymentsAsync.when(
          loading: () => const DashboardSkeleton(cardCount: 3),
          error: (_, _) => const Center(
            child: DashboardEmptyState(
              title: 'Could not load payments',
              message: 'Pull down to try again.',
              icon: Icons.wifi_off_rounded,
            ),
          ),
          data: (data) {
            if (data.paymentHistory.isEmpty &&
                data.totalEarned == 0 &&
                data.pendingPaymentCount == 0) {
              return RefreshIndicator(
                color: AppColors.vendorForest,
                onRefresh: () async {
                  ref.invalidate(vendorPaymentsProvider);
                  await ref.read(vendorPaymentsProvider.future);
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  children: const [
                    SizedBox(height: 80),
                    DashboardEmptyState(
                      title: 'No payouts yet',
                      message:
                          'Earnings will appear here once customers pay for your orders.',
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ],
                ),
              );
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

            final paidCount = data.paymentHistory
                .where((p) => p.status == PaymentStatus.paid)
                .length;
            final pendingCount = data.paymentHistory
                .where((p) => p.status == PaymentStatus.pending)
                .length;
            final processingCount = data.paymentHistory
                .where((p) => p.status == PaymentStatus.partial)
                .length;
            final refundedCount = data.paymentHistory
                .where(
                  (p) =>
                      p.status == PaymentStatus.refunded ||
                      p.status == PaymentStatus.refundPending,
                )
                .length;
            final weekly = _last7DayTotals(data.paymentHistory);

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
                padding: EdgeInsets.fromLTRB(
                  24,
                  16,
                  24,
                  BottomNavTokens.scrollBottomPadding + 24,
                ),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payments',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.espresso,
                                letterSpacing: -0.4,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Earnings and payout history',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go(VendorRoutes.analytics),
                        child: const Text(
                          'Reports',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.vendorForest,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _KpiGrid(
                    columns: kpiColumns,
                    children: [
                      DashboardKpiCard(
                        label: 'Total earnings',
                        value: Formatters.currencyFull(data.totalEarned),
                        icon: Icons.payments_outlined,
                        accent: AppColors.vendorForest,
                      ),
                      DashboardKpiCard(
                        label: 'Available',
                        value: Formatters.currencyFull(data.netEarnings),
                        icon: Icons.account_balance_wallet_outlined,
                        accent: AppColors.sage,
                      ),
                      DashboardKpiCard(
                        label: 'Pending',
                        value: '${data.pendingPaymentCount}',
                        icon: Icons.schedule_outlined,
                        accent: AppColors.accent,
                        subtitle: Formatters.currencyFull(data.todayRevenue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DashboardStatusPipeline(
                    steps: [
                      (
                        label: 'Paid',
                        count: paidCount,
                        color: AppColors.sage,
                      ),
                      (
                        label: 'Pending',
                        count: pendingCount,
                        color: AppColors.accent,
                      ),
                      (
                        label: 'Processing',
                        count: processingCount,
                        color: AppColors.lavender,
                      ),
                      (
                        label: 'Refunded',
                        count: refundedCount,
                        color: AppColors.coral,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'This week',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.espresso,
                                ),
                              ),
                            ),
                            Text(
                              Formatters.currencyFull(data.monthlyRevenue),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const Text(
                              ' this month',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DashboardBarChart(
                          values: weekly,
                          labels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
                          color: AppColors.vendorForest,
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                        _page = 0;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search orders or customers',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.vendorForest,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final entry in {
                          _DateFilter.today: 'Today',
                          _DateFilter.last7: '7 days',
                          _DateFilter.last30: '30 days',
                          _DateFilter.custom: 'Custom',
                        }.entries) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(entry.value),
                              selected: _dateFilter == entry.key,
                              visualDensity: VisualDensity.compact,
                              onSelected: (_) {
                                if (entry.key == _DateFilter.custom) {
                                  _pickCustomRange();
                                } else {
                                  setState(() {
                                    _dateFilter = entry.key;
                                    _page = 0;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                        const SizedBox(width: 4),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<PaymentStatus?>(
                            value: _statusFilter,
                            hint: const Text('Status'),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All statuses'),
                              ),
                              ...PaymentStatus.values.map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(switch (s) {
                                    PaymentStatus.pending => 'Pending',
                                    PaymentStatus.paid => 'Paid',
                                    PaymentStatus.partial => 'Processing',
                                    PaymentStatus.refundPending =>
                                      'Refund pending',
                                    PaymentStatus.refunded => 'Refunded',
                                    PaymentStatus.failed => 'Failed',
                                  }),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _statusFilter = value;
                                _page = 0;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String?>(
                            value: _methodFilter,
                            hint: const Text('Method'),
                            items: const [
                              DropdownMenuItem(
                                value: null,
                                child: Text('All methods'),
                              ),
                              DropdownMenuItem(
                                value: 'COD',
                                child: Text('COD'),
                              ),
                              DropdownMenuItem(
                                value: 'eSewa',
                                child: Text('eSewa'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _methodFilter = value;
                                _page = 0;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<_SortOption>(
                            value: _sort,
                            items: const [
                              DropdownMenuItem(
                                value: _SortOption.newest,
                                child: Text('Newest'),
                              ),
                              DropdownMenuItem(
                                value: _SortOption.oldest,
                                child: Text('Oldest'),
                              ),
                              DropdownMenuItem(
                                value: _SortOption.highestAmount,
                                child: Text('Highest'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _sort = value;
                                _page = 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${filtered.length} result${filtered.length == 1 ? '' : 's'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (pageRows.isEmpty)
                    const DashboardEmptyState(
                      title: 'No matching transactions',
                      message: 'Try adjusting your filters.',
                      icon: Icons.filter_alt_off_outlined,
                    )
                  else
                    for (final payment in pageRows)
                      _TransactionRow(payment: payment),
                  if (filtered.length > _pageSize) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: safePage > 0
                              ? () => setState(() => _page = safePage - 1)
                              : null,
                          icon: const Icon(Icons.chevron_left_rounded),
                        ),
                        Text(
                          '${safePage + 1} / $totalPages',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        IconButton(
                          onPressed: safePage < totalPages - 1
                              ? () => setState(() => _page = safePage + 1)
                              : null,
                          icon: const Icon(Icons.chevron_right_rounded),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.columns, required this.children});

  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final itemWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

class _TransactionRow extends StatefulWidget {
  const _TransactionRow({required this.payment});

  final PaymentUpdate payment;

  @override
  State<_TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<_TransactionRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final payment = widget.payment;
    final customer = payment.customerName?.trim();
    final orderLabel = payment.orderNumber ?? payment.orderId;
    final eventDate = payment.createdAt ?? payment.updatedAt;
    final earnings = payment.vendorEarnings ?? payment.amount;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (customer != null && customer.isNotEmpty)
                                ? customer
                                : 'Customer',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.espresso,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '#$orderLabel · ${Formatters.shortDate(eventDate)}'
                            '${payment.paymentMethodLabel != null ? ' · ${payment.paymentMethodLabel}' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.currencyFull(earnings),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.espresso,
                          ),
                        ),
                        const SizedBox(height: 4),
                        PaymentStatusChip(status: payment.status),
                      ],
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: 12),
                  Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
                  const SizedBox(height: 10),
                  if (payment.transactionId != null)
                    _Detail('Transaction', payment.transactionId!),
                  _Detail('Amount', Formatters.currencyFull(payment.amount)),
                  if (payment.note.trim().isNotEmpty)
                    _Detail('Note', payment.note),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.espresso,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
