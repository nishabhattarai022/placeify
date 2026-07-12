import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/core/widgets/placeify_dialog.dart';
import 'package:placeify_flutter/core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/notification_type.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_notifications_provider.dart';

class VendorNotificationsScreen extends ConsumerStatefulWidget {
  const VendorNotificationsScreen({super.key});

  @override
  ConsumerState<VendorNotificationsScreen> createState() =>
      _VendorNotificationsScreenState();
}

class _VendorNotificationsScreenState
    extends ConsumerState<VendorNotificationsScreen> {
  Timer? _undoTimer;
  OverlayEntry? _undoEntry;

  @override
  void dispose() {
    _undoTimer?.cancel();
    _undoEntry?.remove();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref.read(vendorNotificationsProvider.notifier).refresh();
  }

  Future<void> _confirmMarkAllRead() async {
    final confirmed = await PlaceifyDialog.showConfirm(
      context,
      title: 'Mark all as read?',
      message:
          'All notifications will be marked as read. This cannot be undone.',
      confirmLabel: 'Mark all read',
      confirmColor: AppColors.vendorForest,
    );

    if (confirmed != true || !mounted) return;

    HapticService.light();
    ref.read(vendorNotificationsProvider.notifier).markAllRead();
  }

  void _dismissNotification(VendorNotification notification) {
    HapticService.light();
    ref.read(vendorNotificationsProvider.notifier).commitDismiss();
    ref.read(vendorNotificationsProvider.notifier).dismiss(notification.id);
    _showUndoToast();
  }

  void _showUndoToast() {
    _undoTimer?.cancel();
    _undoEntry?.remove();

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _UndoToast(
        onUndo: () {
          HapticService.light();
          ref.read(vendorNotificationsProvider.notifier).undoDismiss();
          _undoTimer?.cancel();
          entry.remove();
          if (_undoEntry == entry) _undoEntry = null;
        },
        onDismissed: () {
          entry.remove();
          if (_undoEntry == entry) _undoEntry = null;
        },
      ),
    );

    _undoEntry = entry;
    overlay.insert(entry);

    _undoTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      ref.read(vendorNotificationsProvider.notifier).commitDismiss();
      entry.remove();
      if (_undoEntry == entry) _undoEntry = null;
    });
  }

  void _onNotificationTap(VendorNotification notification) {
    HapticService.light();
    ref.read(vendorNotificationsProvider.notifier).markRead(notification.id);

    if (notification.type == NotificationType.order &&
        notification.relatedId != null) {
      context.push(VendorRoutes.orderDetail(notification.relatedId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(vendorNotificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _NotificationsHeader(
            onMarkAllRead: notificationsAsync.maybeWhen(
              data: (state) => state.unreadCount > 0 ? _confirmMarkAllRead : null,
              orElse: () => null,
            ),
          ),
          notificationsAsync.when(
            loading: () => const Expanded(child: _NotificationsShimmer()),
            error: (_, _) => Expanded(
              child: _NotificationsError(onRetry: _onRefresh),
            ),
            data: (state) {
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _NotificationTypeFilters(
                      selectedTypes: state.typeFilters,
                      onToggle: (type) => ref
                          .read(vendorNotificationsProvider.notifier)
                          .toggleTypeFilter(type),
                      onClear: state.typeFilters.isEmpty
                          ? null
                          : () => ref
                              .read(vendorNotificationsProvider.notifier)
                              .clearTypeFilters(),
                    ),
                    Expanded(
                      child: state.visible.isEmpty
                          ? RefreshIndicator(
                              color: AppColors.vendorForest,
                              onRefresh: _onRefresh,
                              child: _NotificationsEmptyState(
                                hasFilters: state.typeFilters.isNotEmpty,
                                onClearFilters: state.typeFilters.isEmpty
                                    ? null
                                    : () => ref
                                        .read(vendorNotificationsProvider.notifier)
                                        .clearTypeFilters(),
                              ),
                            )
                          : RefreshIndicator(
                              color: AppColors.vendorForest,
                              onRefresh: _onRefresh,
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  8,
                                  24,
                                  BottomNavTokens.scrollBottomPadding,
                                ),
                                itemCount: state.visible.length,
                                itemBuilder: (context, index) {
                                  final notification = state.visible[index];
                                  return _DismissibleNotificationTile(
                                    key: ValueKey<String>(notification.id),
                                    notification: notification,
                                    onTap: () =>
                                        _onNotificationTap(notification),
                                    onDismissed: () =>
                                        _dismissNotification(notification),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({this.onMarkAllRead});

  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Container(
      color: AppColors.vendorForest,
      padding: EdgeInsets.fromLTRB(22, top + 8, 22, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticService.light();
              context.pop();
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          if (onMarkAllRead != null)
            TextButton(
              onPressed: onMarkAllRead,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationTypeFilters extends StatelessWidget {
  const _NotificationTypeFilters({
    required this.selectedTypes,
    required this.onToggle,
    this.onClear,
  });

  final Set<NotificationType> selectedTypes;
  final ValueChanged<NotificationType> onToggle;
  final VoidCallback? onClear;

  static const _types = NotificationType.values;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          if (onClear != null) ...[
            _TypeFilterChip(
              label: 'All',
              isSelected: false,
              onTap: onClear!,
            ),
            const SizedBox(width: 8),
          ],
          for (final type in _types) ...[
            _TypeFilterChip(
              label: _labelFor(type),
              isSelected: selectedTypes.contains(type),
              onTap: () {
                HapticService.light();
                onToggle(type);
              },
            ),
            if (type != _types.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  static String _labelFor(NotificationType type) {
    return switch (type) {
      NotificationType.order => 'Orders',
      NotificationType.payment => 'Payments',
      NotificationType.product => 'Products',
      NotificationType.system => 'System',
    };
  }
}

class _TypeFilterChip extends StatelessWidget {
  const _TypeFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.vendorForest : AppColors.warmWhite,
          borderRadius: AppRadii.pill,
          border: Border.all(
            color: isSelected ? AppColors.vendorForest : AppColors.creamDark,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _DismissibleNotificationTile extends StatelessWidget {
  const _DismissibleNotificationTile({
    required super.key,
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  final VendorNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey<String>('dismiss-${notification.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDismissed(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.coralBg,
            borderRadius: AppRadii.md,
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.coral,
          ),
        ),
        child: _NotificationTile(
          notification: notification,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final VendorNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Material(
      color: isUnread ? AppColors.vendorForestBg : AppColors.warmWhite,
      borderRadius: AppRadii.md,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.md,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: AppRadii.md,
            border: Border.all(
              color: isUnread ? AppColors.vendorForest : AppColors.creamDark,
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationTypeIcon(type: notification.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.sectionTitle.copyWith(
                              fontSize: 15,
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8, top: 4),
                            decoration: const BoxDecoration(
                              color: AppColors.vendorForest,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: AppTypography.metricLabel.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.shortDate(notification.createdAt),
                      style: AppTypography.metricLabel.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (notification.type == NotificationType.order &&
                  notification.relatedId != null)
                const Padding(
                  padding: EdgeInsets.only(left: 4, top: 2),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationTypeIcon extends StatelessWidget {
  const _NotificationTypeIcon({required this.type});

  final NotificationType type;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      NotificationType.order => Icons.receipt_long_outlined,
      NotificationType.payment => Icons.payments_outlined,
      NotificationType.product => Icons.inventory_2_outlined,
      NotificationType.system => Icons.info_outline_rounded,
    };

    final color = switch (type) {
      NotificationType.order => AppColors.vendorForest,
      NotificationType.payment => AppColors.accent,
      NotificationType.product => AppColors.sage,
      NotificationType.system => AppColors.textSecondary,
    };

    final background = switch (type) {
      NotificationType.order => AppColors.vendorForestBg,
      NotificationType.payment => AppColors.accentBg,
      NotificationType.product => AppColors.sageBg,
      NotificationType.system => AppColors.creamDark,
    };

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.sm,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _NotificationsEmptyState extends StatelessWidget {
  const _NotificationsEmptyState({
    required this.hasFilters,
    this.onClearFilters,
  });

  final bool hasFilters;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.35,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.vendorForestBg,
                      borderRadius: AppRadii.lg,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.notifications_none_outlined,
                      size: 32,
                      color: AppColors.vendorForest,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hasFilters ? 'No matching notifications' : 'All caught up',
                    style: AppTypography.sectionTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasFilters
                        ? 'Try clearing your filters to see more notifications.'
                        : 'New order, payment, and product alerts will appear here.',
                    style: AppTypography.metricLabel.copyWith(
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (onClearFilters != null) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: onClearFilters,
                      child: const Text('Clear filters'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationsShimmer extends StatelessWidget {
  const _NotificationsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => const SizedBox(
        height: 96,
        child: ShimmerLoader(borderRadius: AppRadii.md),
      ),
    );
  }
}

class _NotificationsError extends StatelessWidget {
  const _NotificationsError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Could not load notifications',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _UndoToast extends StatefulWidget {
  const _UndoToast({
    required this.onUndo,
    required this.onDismissed,
  });

  final VoidCallback onUndo;
  final VoidCallback onDismissed;

  @override
  State<_UndoToast> createState() => _UndoToastState();
}

class _UndoToastState extends State<_UndoToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 280),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fade);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 90 + MediaQuery.paddingOf(context).bottom,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.espresso,
                borderRadius: AppRadii.pill,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Notification dismissed',
                      style: AppTypography.toastText,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      widget.onUndo();
                      await _dismiss();
                    },
                    child: const Text(
                      'Undo',
                      style: TextStyle(
                        color: AppColors.accentLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
