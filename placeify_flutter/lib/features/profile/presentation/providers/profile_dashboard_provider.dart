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
  @override
  Future<UserDashboard?> build() async {
    if (!client.auth.isAuthenticated) return null;
    final repo = ref.watch(profileRepositoryProvider);
    return repo.getDashboard();
  }

  Future<void> refresh() async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData(null);
      return;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      return repo.getDashboard();
    });
  }
}

@Riverpod(keepAlive: true)
class ProfileOrders extends _$ProfileOrders {
  @override
  Future<List<UserOrderSummary>> build() async {
    if (!client.auth.isAuthenticated) return [];
    final repo = ref.watch(profileRepositoryProvider);
    return repo.listOrders();
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
