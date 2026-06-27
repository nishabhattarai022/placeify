import 'dart:async';

import 'package:placeify_client/placeify_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../data/serverpod_profile_repository.dart';
import '../../domain/repositories/profile_repository.dart';

part 'profile_dashboard_provider.g.dart';

const _dashboardPollInterval = Duration(seconds: 30);

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ServerpodProfileRepository();
}

@Riverpod(keepAlive: true)
class ProfileDashboard extends _$ProfileDashboard {
  Timer? _pollTimer;

  @override
  Future<UserDashboard?> build() async {
    ref.onDispose(() => _pollTimer?.cancel());
    _pollTimer = Timer.periodic(_dashboardPollInterval, (_) {
      unawaited(refresh(silent: true));
    });

    if (!client.auth.isAuthenticated) return null;
    final repo = ref.watch(profileRepositoryProvider);
    return repo.getDashboard();
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
  Timer? _pollTimer;

  @override
  Future<List<UserOrderSummary>> build() async {
    ref.onDispose(() => _pollTimer?.cancel());
    _pollTimer = Timer.periodic(_dashboardPollInterval, (_) {
      unawaited(refresh(silent: true));
    });

    if (!client.auth.isAuthenticated) return [];
    final repo = ref.watch(profileRepositoryProvider);
    return repo.listOrders();
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
