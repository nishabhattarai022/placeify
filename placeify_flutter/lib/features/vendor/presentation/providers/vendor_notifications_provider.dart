import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/notification_type.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_notification.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_notifications_provider.g.dart';

/// Opens a vendor shop order from a notification, leaving the inbox route first.
void openVendorOrderFromNotification(BuildContext context, String orderId) {
  final destination = VendorRoutes.orderDetail(orderId);
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
  }
  StatefulNavigationShell.maybeOf(context)?.goBranch(1, initialLocation: false);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    GoRouter.of(context).go(destination);
  });
}

bool isVendorFacingNotification(VendorNotification notification) {
  if (notification.title == 'Order placed' ||
      notification.title == 'Order accepted' ||
      notification.title == 'Order update') {
    return false;
  }
  if (notification.body.contains('has been placed successfully') ||
      notification.body.contains('has been accepted by the vendor') ||
      notification.body.contains('has been automatically cancelled')) {
    return false;
  }
  return true;
}

class VendorNotificationsState {
  const VendorNotificationsState({
    required this.notifications,
    this.typeFilters = const {},
    this.dismissedIds = const {},
    this.pendingDismiss,
  });

  final List<VendorNotification> notifications;
  final Set<NotificationType> typeFilters;
  final Set<String> dismissedIds;
  final VendorNotification? pendingDismiss;

  int get unreadCount => notifications
      .where(
        (notification) =>
            !notification.isRead &&
            !dismissedIds.contains(notification.id) &&
            notification.id != pendingDismiss?.id,
      )
      .length;

  int get orderUnreadCount => notifications
      .where(
        (notification) =>
            !notification.isRead &&
            notification.type == NotificationType.order &&
            !dismissedIds.contains(notification.id) &&
            notification.id != pendingDismiss?.id,
      )
      .length;

  List<VendorNotification> get orderAlerts {
    return notifications
        .where(
          (notification) =>
              !notification.isRead &&
              notification.type == NotificationType.order &&
              !dismissedIds.contains(notification.id) &&
              notification.id != pendingDismiss?.id,
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<VendorNotification> get visible {
    return notifications
        .where((notification) => !dismissedIds.contains(notification.id))
        .where((notification) => notification.id != pendingDismiss?.id)
        .where(
          (notification) =>
              typeFilters.isEmpty || typeFilters.contains(notification.type),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  VendorNotificationsState copyWith({
    List<VendorNotification>? notifications,
    Set<NotificationType>? typeFilters,
    Set<String>? dismissedIds,
    VendorNotification? pendingDismiss,
    bool clearPendingDismiss = false,
  }) {
    return VendorNotificationsState(
      notifications: notifications ?? this.notifications,
      typeFilters: typeFilters ?? this.typeFilters,
      dismissedIds: dismissedIds ?? this.dismissedIds,
      pendingDismiss:
          clearPendingDismiss ? null : pendingDismiss ?? this.pendingDismiss,
    );
  }
}

@riverpod
class VendorNotifications extends _$VendorNotifications {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<VendorNotificationsState> build() {
    ref.onDispose(() => _subscription?.cancel());
    unawaited(_attachRealtimeListener());
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((_) {
      unawaited(refresh());
    });
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<VendorNotificationsState> _load() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return const VendorNotificationsState(notifications: []);
    }

    final repo = ref.watch(vendorRepositoryProvider);
    final notifications = await repo.getNotifications(user!.vendorId!);
    final vendorFacing = notifications.where(isVendorFacingNotification).toList();
    return VendorNotificationsState(notifications: vendorFacing);
  }

  void toggleTypeFilter(NotificationType type) {
    final current = state.value;
    if (current == null) return;

    final filters = Set<NotificationType>.from(current.typeFilters);
    if (filters.contains(type)) {
      filters.remove(type);
    } else {
      filters.add(type);
    }

    state = AsyncData(current.copyWith(typeFilters: filters));
  }

  void clearTypeFilters() {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(typeFilters: {}));
  }

  void markRead(String id) {
    final current = state.value;
    if (current == null) return;

    final index = current.notifications.indexWhere(
      (notification) => notification.id == id,
    );
    if (index < 0) return;

    final notification = current.notifications[index];
    if (notification.isRead) return;

    final updated = [...current.notifications];
    updated[index] = notification.copyWith(isRead: true);
    state = AsyncData(current.copyWith(notifications: updated));

    final repo = ref.read(vendorRepositoryProvider);
    unawaited(repo.markNotificationRead(id));
  }

  /// Marks unread order notifications as read once the vendor has seen those
  /// orders on the orders list or detail screen.
  void markOrderNotificationsReadForOrderIds(Set<String> orderIds) {
    if (orderIds.isEmpty) return;

    final current = state.value;
    if (current == null) return;

    final idsToMark = <String>{};
    for (final notification in current.notifications) {
      if (notification.isRead) continue;
      if (notification.type != NotificationType.order) continue;
      final relatedId = notification.relatedId;
      if (relatedId != null && orderIds.contains(relatedId)) {
        idsToMark.add(notification.id);
      }
    }
    if (idsToMark.isEmpty) return;

    final updated = [
      for (final notification in current.notifications)
        idsToMark.contains(notification.id)
            ? notification.copyWith(isRead: true)
            : notification,
    ];
    state = AsyncData(current.copyWith(notifications: updated));

    final repo = ref.read(vendorRepositoryProvider);
    for (final id in idsToMark) {
      unawaited(repo.markNotificationRead(id));
    }
  }

  void markOrderNotificationReadForOrderId(String orderId) {
    markOrderNotificationsReadForOrderIds({orderId});
  }

  void markAllRead() {
    final current = state.value;
    if (current == null) return;

    final updated = current.notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
    state = AsyncData(current.copyWith(notifications: updated));

    final repo = ref.read(vendorRepositoryProvider);
    unawaited(repo.markAllNotificationsRead());
  }

  VendorNotification? dismiss(String id) {
    final current = state.value;
    if (current == null) return null;

    VendorNotification? notification;
    for (final item in current.notifications) {
      if (item.id == id) {
        notification = item;
        break;
      }
    }
    if (notification == null) return null;

    state = AsyncData(current.copyWith(pendingDismiss: notification));
    return notification;
  }

  void undoDismiss() {
    final current = state.value;
    if (current == null || current.pendingDismiss == null) return;

    state = AsyncData(current.copyWith(clearPendingDismiss: true));
  }

  void commitDismiss() {
    final current = state.value;
    if (current == null || current.pendingDismiss == null) return;

    final dismissedIds = {...current.dismissedIds, current.pendingDismiss!.id};
    state = AsyncData(
      current.copyWith(
        dismissedIds: dismissedIds,
        clearPendingDismiss: true,
      ),
    );
  }
}
