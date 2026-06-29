import 'dart:async';

import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../data/serverpod_profile_repository.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_dashboard_provider.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ServerpodProfileRepository();
}

@Riverpod(keepAlive: true)
class ProfileDashboard extends _$ProfileDashboard {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<UserDashboard?> build() async {
    ref.onDispose(() => _subscription?.cancel());
    if (client.auth.isAuthenticated) {
      unawaited(_attachRealtimeListener());
    }

    if (!client.auth.isAuthenticated) return null;
    final repo = ref.watch(profileRepositoryProvider);
    return repo.getDashboard();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((notification) {
      if (!shouldRefreshOrdersForNotification(notification) &&
          notification.type != InAppNotificationType.refundUpdate) {
        return;
      }
      unawaited(refresh(silent: true));
    });
  }

  Future<void> refresh({bool silent = false}) async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData(null);
      return;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      return repo.getDashboard();
    });
  }
}

@Riverpod(keepAlive: true)
class ProfileOrders extends _$ProfileOrders {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<List<UserOrderSummary>> build() async {
    ref.onDispose(() => _subscription?.cancel());
    if (client.auth.isAuthenticated) {
      unawaited(_attachRealtimeListener());
    }

    if (!client.auth.isAuthenticated) return [];
    final repo = ref.watch(profileRepositoryProvider);
    return repo.listOrders();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((notification) {
      if (!shouldRefreshOrdersForNotification(notification)) return;
      unawaited(refresh(silent: true));
    });
  }

  Future<void> refresh({bool silent = false}) async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData([]);
      return;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      return repo.listOrders();
    });
  }
}

@Riverpod(keepAlive: true)
class ProfileArSessions extends _$ProfileArSessions {
  @override
  Future<List<UserArSessionSummary>> build() async {
    if (!client.auth.isAuthenticated) return [];
    final repo = ref.watch(profileRepositoryProvider);
    return repo.listArSessions();
  }
}
