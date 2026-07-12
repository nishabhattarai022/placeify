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
          AsyncValue<List<RecommendProduct>>,
          List<RecommendProduct>,
          FutureOr<List<RecommendProduct>>
        >
    with
        $FutureModifier<List<RecommendProduct>>,
        $FutureProvider<List<RecommendProduct>> {
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
  $FutureProviderElement<List<RecommendProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecommendProduct>> create(Ref ref) {
    return recommendedProducts(ref);
  }
}

String _$recommendedProductsHash() =>
    r'83a73522b8aac6982cf0d9fc0625fffbf9ff7b72';
