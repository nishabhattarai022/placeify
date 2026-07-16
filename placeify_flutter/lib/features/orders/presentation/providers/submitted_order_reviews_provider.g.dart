// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submitted_order_reviews_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Session-local set of order IDs the customer already reviewed (UX only;
/// server still enforces uniqueness).

@ProviderFor(SubmittedOrderReviews)
final submittedOrderReviewsProvider = SubmittedOrderReviewsProvider._();

/// Session-local set of order IDs the customer already reviewed (UX only;
/// server still enforces uniqueness).
final class SubmittedOrderReviewsProvider
    extends $NotifierProvider<SubmittedOrderReviews, Set<String>> {
  /// Session-local set of order IDs the customer already reviewed (UX only;
  /// server still enforces uniqueness).
  SubmittedOrderReviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'submittedOrderReviewsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$submittedOrderReviewsHash();

  @$internal
  @override
  SubmittedOrderReviews create() => SubmittedOrderReviews();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$submittedOrderReviewsHash() =>
    r'9f908a46d398c983d9c5dd1d269c46253b9b7120';

/// Session-local set of order IDs the customer already reviewed (UX only;
/// server still enforces uniqueness).

abstract class _$SubmittedOrderReviews extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
