import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../profile/presentation/providers/profile_dashboard_provider.dart';
import 'wishlist_provider.dart';

/// Single wishlist count for profile stats, menu subtitles, and badges.
///
/// Prefers the live wishlist list (same source as the bookmarks screen).
/// Falls back to dashboard API count while the list is still loading.
int readWishlistCount(WidgetRef ref) {
  final local = ref.watch(wishlistProvider).length;
  if (local > 0) return local;

  return ref.watch(profileDashboardProvider).maybeWhen(
        data: (dashboard) => dashboard?.wishlistCount ?? 0,
        orElse: () => 0,
      );
}

/// Re-fetches the wishlist when dashboard count and local list disagree.
void reconcileWishlistWithDashboard(WidgetRef ref) {
  final dashboardCount =
      ref.read(profileDashboardProvider).value?.wishlistCount ?? 0;
  final localCount = ref.read(wishlistProvider).length;
  if (dashboardCount > 0 && dashboardCount != localCount) {
    unawaited(ref.read(wishlistProvider.notifier).refresh());
  }
}
