// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_room_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recommendedProducts)
final recommendedProductsProvider = RecommendedProductsProvider._();

final class RecommendedProductsProvider
    extends
        $FunctionalProvider<
          List<RecommendProduct>,
          List<RecommendProduct>,
          List<RecommendProduct>
        >
    with $Provider<List<RecommendProduct>> {
  RecommendedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recommendedProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recommendedProductsHash();

  @$internal
  @override
  $ProviderElement<List<RecommendProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<RecommendProduct> create(Ref ref) {
    return recommendedProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<RecommendProduct> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<RecommendProduct>>(value),
    );
  }
}

String _$recommendedProductsHash() =>
    r'2b48661a422a856afdc9acd74e54b9f0448352a4';
