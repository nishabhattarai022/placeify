import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'submitted_order_reviews_provider.g.dart';

/// Session-local set of order IDs the customer already reviewed (UX only;
/// server still enforces uniqueness).
@Riverpod(keepAlive: true)
class SubmittedOrderReviews extends _$SubmittedOrderReviews {
  @override
  Set<String> build() => {};

  void markReviewed(String orderId) {
    if (state.contains(orderId)) return;
    state = {...state, orderId};
  }

  bool hasReviewed(String orderId) => state.contains(orderId);
}
