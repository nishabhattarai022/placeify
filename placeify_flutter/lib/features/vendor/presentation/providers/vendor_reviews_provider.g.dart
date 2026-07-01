// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_reviews_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorReviews)
final vendorReviewsProvider = VendorReviewsProvider._();

final class VendorReviewsProvider
    extends $AsyncNotifierProvider<VendorReviews, List<VendorReview>> {
  VendorReviewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorReviewsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorReviewsHash();

  @$internal
  @override
  VendorReviews create() => VendorReviews();
}

String _$vendorReviewsHash() => r'0b97e3a4af34589afe5f8d08160d197243dcbe53';

abstract class _$VendorReviews extends $AsyncNotifier<List<VendorReview>> {
  FutureOr<List<VendorReview>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<VendorReview>>, List<VendorReview>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<VendorReview>>, List<VendorReview>>,
              AsyncValue<List<VendorReview>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
