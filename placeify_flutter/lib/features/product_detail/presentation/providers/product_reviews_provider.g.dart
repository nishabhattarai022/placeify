// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_reviews_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reviewRepository)
final reviewRepositoryProvider = ReviewRepositoryProvider._();

final class ReviewRepositoryProvider
    extends
        $FunctionalProvider<
          ServerpodReviewRepository,
          ServerpodReviewRepository,
          ServerpodReviewRepository
        >
    with $Provider<ServerpodReviewRepository> {
  ReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerpodReviewRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerpodReviewRepository create(Ref ref) {
    return reviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerpodReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerpodReviewRepository>(value),
    );
  }
}

String _$reviewRepositoryHash() => r'9bc88c7551ef68e3b138c84df05d983c0007d61d';

@ProviderFor(ProductReviews)
final productReviewsProvider = ProductReviewsFamily._();

final class ProductReviewsProvider
    extends $AsyncNotifierProvider<ProductReviews, List<Review>> {
  ProductReviewsProvider._({
    required ProductReviewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productReviewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productReviewsHash();

  @override
  String toString() {
    return r'productReviewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProductReviews create() => ProductReviews();

  @override
  bool operator ==(Object other) {
    return other is ProductReviewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productReviewsHash() => r'41376f045465de1eb8fa55138e0657434cdbe653';

final class ProductReviewsFamily extends $Family
    with
        $ClassFamilyOverride<
          ProductReviews,
          AsyncValue<List<Review>>,
          List<Review>,
          FutureOr<List<Review>>,
          String
        > {
  ProductReviewsFamily._()
    : super(
        retry: null,
        name: r'productReviewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductReviewsProvider call(String productId) =>
      ProductReviewsProvider._(argument: productId, from: this);

  @override
  String toString() => r'productReviewsProvider';
}

abstract class _$ProductReviews extends $AsyncNotifier<List<Review>> {
  late final _$args = ref.$arg as String;
  String get productId => _$args;

  FutureOr<List<Review>> build(String productId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Review>>, List<Review>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Review>>, List<Review>>,
              AsyncValue<List<Review>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
