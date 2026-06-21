// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_room_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recommendedProducts)
final recommendedProductsProvider = RecommendedProductsProvider._();

final class RecommendedProductsProvider extends $FunctionalProvider<
    List<RecommendProduct>,
    List<RecommendProduct>,
    List<RecommendProduct>> with $Provider<List<RecommendProduct>> {
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
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

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
    r'c3f8a1b2d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9';
