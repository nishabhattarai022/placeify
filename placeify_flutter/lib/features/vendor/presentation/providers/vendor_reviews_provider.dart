import 'dart:async';

import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_review.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_reviews_provider.g.dart';

@riverpod
class VendorReviews extends _$VendorReviews {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  Future<List<VendorReview>> build() {
    ref.onDispose(() => _subscription?.cancel());
    unawaited(_attachRealtimeListener());
    return _load();
  }

  Future<void> _attachRealtimeListener() async {
    if (_subscription != null) return;
    _subscription = inAppNotificationEvents.listen((notification) {
      if (notification.type != InAppNotificationType.productUpdate) return;
      unawaited(refresh(silent: true));
    });
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
  }

  Future<List<VendorReview>> _load() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return const [];
    }

    final summaries = await client.vendor.listShopReviews(limit: 50, offset: 0);
    return [
      for (final summary in summaries)
        VendorReview(
          id: summary.id.toString(),
          customerName: summary.customerName,
          productName: summary.productName,
          productId: 'p${summary.productId}',
          thumbnailUrl: summary.thumbnailUrl,
          rating: summary.rating,
          comment: summary.comment ?? '',
          createdAt: summary.createdAt,
          updatedAt: summary.updatedAt,
        ),
    ];
  }
}
