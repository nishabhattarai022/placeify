import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/core/utils/relative_time.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/core/widgets/dashboard_chrome.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_stats.dart'
    as models;
import 'package:placeify_flutter/features/admin/presentation/providers/admin_audit_log_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_notification_badge_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_notifications_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/widgets/admin_application_row.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool _hasLoaded = false;
  models.AdminStats? _cachedStats;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(adminStatsProvider.notifier).refresh(),
      ref.read(adminNotificationsProvider.notifier).refresh(),
      ref.read(adminAuditLogProvider.notifier).refresh(),
    ]);
  }

  String _timeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _greetingName(String? fullName) {
    if (fullName == null || fullName.isEmpty) return 'there';
    return fullName.split(' ').first;
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(adminStatsProvider);

    statsAsync.whenData((stats) {
      _cachedStats = stats;
      if (!_hasLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasLoaded = true);
        });
      }
    });

    final showShimmer = statsAsync.isLoading && !_hasLoaded;
    final stats = statsAsync.value ?? _cachedStats;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F1ED),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 20, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_timeGreeting()}, ${_greetingName(userAsync.value?.fullName)}',
                          style: AppTypography.vendorGreeting.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.espresso,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const _NotificationButton(),
                ],
              ),
            ),
            Expanded(
              child: showShimmer
                  ? const DashboardSkeleton(cardCount: 4)
                  : statsAsync.hasError && stats == null
                      ? _ErrorState(onRetry: _onRefresh)
                      : stats == null
                          ? const DashboardSkeleton(cardCount: 4)
                          : RefreshIndicator(
                              color: AppColors.adminSlate,
                              onRefresh: _onRefresh,
                              child: _Body(
                                stats: stats,
                                scrollController: _scrollController,
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.stats,
    required this.scrollController,
  });

  final models.AdminStats stats;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 920;
    final applications = stats.recentApplications.take(3).toList();
    final activity = stats.recentActivity.take(8).toList();

    return ListView(
      key: const PageStorageKey<String>('admin_dashboard_scroll'),
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        BottomNavTokens.scrollBottomPadding + 20,
      ),
      children: [
        _RevenueHero(
          gmv: stats.platformGmv,
          daily: stats.dailyRevenue,
          monthly: stats.monthlyRevenue,
          successRate: stats.paymentSuccessRate,
        ),
        const SizedBox(height: 14),
        _MetricGrid(
          isWide: isWide,
          children: [
            _MetricTile(
              label: 'Users',
              value: '${stats.totalUsers}',
              icon: Icons.people_outline_rounded,
              accent: AppColors.bark,
            ),
            _MetricTile(
              label: 'Vendors',
              value: '${stats.totalVendors}',
              icon: Icons.storefront_outlined,
              accent: AppColors.vendorForest,
              hint: '${stats.approvedCount} live',
            ),
            _MetricTile(
              label: 'Pending',
              value: '${stats.pendingCount}',
              icon: Icons.hourglass_empty_rounded,
              accent: AppColors.accent,
              highlighted: stats.pendingCount > 0,
              onTap: () {
                HapticService.light();
                context.go(AdminRoutes.approvals);
              },
            ),
            _MetricTile(
              label: 'Refunds',
              value: '${stats.pendingRefundCount}',
              icon: Icons.undo_rounded,
              accent: AppColors.coral,
              hint: '${stats.refundCount} done',
              onTap: () {
                HapticService.light();
                context.push(AdminRoutes.refunds);
              },
            ),
          ],
        ),
        if (stats.pendingCount > 0) ...[
          const SizedBox(height: 14),
          _AttentionBanner(count: stats.pendingCount),
        ],
        const SizedBox(height: 22),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _PaymentSnapshot(stats: stats),
              ),
              const SizedBox(width: 14),
              const Expanded(flex: 4, child: _NavPanel()),
            ],
          )
        else ...[
          _PaymentSnapshot(stats: stats),
          const SizedBox(height: 14),
          const _NavPanel(),
        ],
        if (applications.isNotEmpty) ...[
          const SizedBox(height: 28),
          _SectionTitle(
            title: 'Approval queue',
            action: 'See all',
            onAction: () {
              HapticService.light();
              context.go(AdminRoutes.approvals);
            },
          ),
          const SizedBox(height: 10),
          ...applications.map(
            (app) => AdminApplicationRow(application: app),
          ),
        ],
        const SizedBox(height: 28),
        _SectionTitle(
          title: 'Recent activity',
          action: activity.isEmpty ? null : 'Audit log',
          onAction: activity.isEmpty
              ? null
              : () {
                  HapticService.light();
                  context.push(AdminRoutes.auditLog);
                },
        ),
        const SizedBox(height: 10),
        if (activity.isEmpty)
          const _SoftEmpty(
            title: 'No recent activity',
            message: 'Admin actions will show up here.',
          )
        else
          _ActivityCard(entries: activity),
      ],
    );
  }
}

class _RevenueHero extends StatelessWidget {
  const _RevenueHero({
    required this.gmv,
    required this.daily,
    required this.monthly,
    required this.successRate,
  });

  final double gmv;
  final double daily;
  final double monthly;
  final double successRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.adminSlate,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.payments_outlined,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Platform revenue',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            Formatters.currencyFull(gmv),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Gross merchandise volume',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Today',
                  value: Formatters.currencyFull(daily),
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              Expanded(
                child: _HeroStat(
                  label: 'This month',
                  value: Formatters.currencyFull(monthly),
                ),
              ),
              Container(
                width: 1,
                height: 32,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              Expanded(
                child: _HeroStat(
                  label: 'Success',
                  value: '${successRate.toStringAsFixed(0)}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.isWide, required this.children});

  final bool isWide;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final columns = isWide ? 4 : 2;
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final w = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children) SizedBox(width: w, child: child),
          ],
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    this.hint,
    this.highlighted = false,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final String? hint;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = highlighted ? accent.withValues(alpha: 0.08) : Colors.white;
    final border = highlighted
        ? accent.withValues(alpha: 0.28)
        : Colors.black.withValues(alpha: 0.06);

    final child = Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: accent),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.espresso,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(
              hint!,
              style: TextStyle(
                fontSize: 11,
                color: accent.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: child,
      ),
    );
  }
}

class _AttentionBanner extends StatelessWidget {
  const _AttentionBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticService.light();
          context.go(AdminRoutes.approvals);
        },
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.22)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.priority_high_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count vendor${count == 1 ? '' : 's'} awaiting review',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Review applications to keep the marketplace moving',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentSnapshot extends StatelessWidget {
  const _PaymentSnapshot({required this.stats});

  final models.AdminStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payments',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 14),
          _PaymentRow(
            label: 'Transactions',
            value: '${stats.totalTransactions}',
          ),
          _PaymentRow(
            label: 'COD',
            value: '${stats.codCount}',
          ),
          _PaymentRow(
            label: 'eSewa',
            value: '${stats.esewaCount}',
          ),
          _PaymentRow(
            label: 'Refund value',
            value: Formatters.currencyFull(stats.refundValue),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavPanel extends StatelessWidget {
  const _NavPanel();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.fact_check_outlined,
        'Approvals',
        'Review vendors',
        () => context.go(AdminRoutes.approvals),
      ),
      (
        Icons.inventory_2_outlined,
        'Products',
        'Catalog & removals',
        () => context.push(AdminRoutes.products),
      ),
      (
        Icons.people_outline_rounded,
        'Users',
        'Accounts & roles',
        () => context.push(AdminRoutes.users),
      ),
      (
        Icons.settings_outlined,
        'Settings',
        'Platform controls',
        () => context.go(AdminRoutes.settings),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 52,
                color: Colors.black.withValues(alpha: 0.05),
              ),
            _NavRow(
              icon: items[i].$1,
              title: items[i].$2,
              subtitle: items[i].$3,
              onTap: () {
                HapticService.light();
                items[i].$4();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.adminSlate.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.adminSlate),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textMuted.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (action != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.adminSlate,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              action!,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.entries});

  final List<AdminAuditLogEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 56,
                color: Colors.black.withValues(alpha: 0.05),
              ),
            _ActivityRow(entry: entries[i]),
          ],
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry});

  final AdminAuditLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final label = AdminStrings.auditActionLabel(entry.action);
    final icon = label.toLowerCase().contains('approv')
        ? Icons.check_circle_outline
        : label.toLowerCase().contains('declin')
            ? Icons.cancel_outlined
            : label.toLowerCase().contains('suspend')
                ? Icons.pause_circle_outline
                : Icons.history_rounded;
    final color = label.toLowerCase().contains('approv')
        ? AppColors.sage
        : label.toLowerCase().contains('declin') ||
                label.toLowerCase().contains('suspend')
            ? AppColors.coral
            : AppColors.adminSlate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.espresso,
                  ),
                ),
                if (entry.note != null && entry.note!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    entry.note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            RelativeTime.format(entry.timestamp),
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _SoftEmpty extends StatelessWidget {
  const _SoftEmpty({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_outlined,
            size: 24,
            color: AppColors.textMuted.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DashboardEmptyState(
              title: AdminStrings.dashboardLoadError,
              message: 'Check your connection and try again.',
              icon: Icons.wifi_off_rounded,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.adminSlate,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(AdminStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationButton extends ConsumerWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgeCount = ref.watch(adminNotificationBadgeCountProvider);

    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticService.light();
          context.push(AdminRoutes.notifications);
        },
        child: Ink(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.notifications_outlined,
                size: 20,
                color: AppColors.adminSlate,
              ),
              if (badgeCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 15),
                    height: 15,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.coral,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeCount > 9 ? '9+' : '$badgeCount',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
