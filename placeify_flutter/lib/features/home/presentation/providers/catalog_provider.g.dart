// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(catalogRepository)
final catalogRepositoryProvider = CatalogRepositoryProvider._();

final class CatalogRepositoryProvider
    extends
        $FunctionalProvider<
          ServerpodProductRepository,
          ServerpodProductRepository,
          ServerpodProductRepository
        >
    with $Provider<ServerpodProductRepository> {
  CatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerpodProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerpodProductRepository create(Ref ref) {
    return catalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerpodProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerpodProductRepository>(value),
    );
  }
}

String _$catalogRepositoryHash() => r'25530064bfca6d2bb4ab348c3fbf16b556cd493e';

/// All active marketplace products (seed + vendor listings).

@ProviderFor(CatalogIndex)
final catalogIndexProvider = CatalogIndexProvider._();

/// All active marketplace products (seed + vendor listings).
final class CatalogIndexProvider
    extends $AsyncNotifierProvider<CatalogIndex, Map<String, Product>> {
  /// All active marketplace products (seed + vendor listings).
  CatalogIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogIndexProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogIndexHash();

  @$internal
  @override
  CatalogIndex create() => CatalogIndex();
}

String _$catalogIndexHash() => r'798cf6443bb6f5a365c55872663ebf051c06bbde';

/// All active marketplace products (seed + vendor listings).

abstract class _$CatalogIndex extends $AsyncNotifier<Map<String, Product>> {
  FutureOr<Map<String, Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, Product>>, Map<String, Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, Product>>,
                Map<String, Product>
              >,
              AsyncValue<Map<String, Product>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(catalogProducts)
final catalogProductsProvider = CatalogProductsProvider._();

final class CatalogProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  CatalogProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return catalogProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$catalogProductsHash() => r'556e262b0a75cc7700d80152588aef53744c6401';

@ProviderFor(catalogProductsByCategory)
final catalogProductsByCategoryProvider = CatalogProductsByCategoryFamily._();

final class CatalogProductsByCategoryProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  CatalogProductsByCategoryProvider._({
    required CatalogProductsByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'catalogProductsByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogProductsByCategoryHash();

  @override
  String toString() {
    return r'catalogProductsByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    final argument = this.argument as String;
    return catalogProductsByCategory(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogProductsByCategoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogProductsByCategoryHash() =>
    r'a7f6ca6f23f83bc7e14cb6a97bd3df6eefd397ad';

final class CatalogProductsByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<List<Product>, String> {
  CatalogProductsByCategoryFamily._()
    : super(
        retry: null,
        name: r'catalogProductsByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatalogProductsByCategoryProvider call(String categoryId) =>
      CatalogProductsByCategoryProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'catalogProductsByCategoryProvider';
}

/// Nisha browse category list: live catalog first, mock expansion as fallback.

@ProviderFor(browseCategoryProducts)
final browseCategoryProductsProvider = BrowseCategoryProductsFamily._();

/// Nisha browse category list: live catalog first, mock expansion as fallback.

final class BrowseCategoryProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  /// Nisha browse category list: live catalog first, mock expansion as fallback.
  BrowseCategoryProductsProvider._({
    required BrowseCategoryProductsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'browseCategoryProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$browseCategoryProductsHash();

  @override
  String toString() {
    return r'browseCategoryProductsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    final argument = this.argument as String;
    return browseCategoryProducts(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrowseCategoryProductsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$browseCategoryProductsHash() =>
    r'f562f0e42a2745bdf870a2686d4c7456f35d74f4';

/// Nisha browse category list: live catalog first, mock expansion as fallback.

final class BrowseCategoryProductsFamily extends $Family
    with $FunctionalFamilyOverride<List<Product>, String> {
  BrowseCategoryProductsFamily._()
    : super(
        retry: null,
        name: r'browseCategoryProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Nisha browse category list: live catalog first, mock expansion as fallback.

  BrowseCategoryProductsProvider call(String uiCategoryId) =>
      BrowseCategoryProductsProvider._(argument: uiCategoryId, from: this);

  @override
  String toString() => r'browseCategoryProductsProvider';
}

@ProviderFor(categoryProductCount)
final categoryProductCountProvider = CategoryProductCountFamily._();

final class CategoryProductCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  CategoryProductCountProvider._({
    required CategoryProductCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'categoryProductCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$categoryProductCountHash();

  @override
  String toString() {
    return r'categoryProductCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as String;
    return categoryProductCount(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryProductCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$categoryProductCountHash() =>
    r'59156ea5158677a90eba775a596a10cc33afa617';

final class CategoryProductCountFamily extends $Family
    with $FunctionalFamilyOverride<int, String> {
  CategoryProductCountFamily._()
    : super(
        retry: null,
        name: r'categoryProductCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CategoryProductCountProvider call(String categoryId) =>
      CategoryProductCountProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'categoryProductCountProvider';
}

@ProviderFor(catalogDiscountedProducts)
final catalogDiscountedProductsProvider = CatalogDiscountedProductsProvider._();

final class CatalogDiscountedProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  CatalogDiscountedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogDiscountedProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogDiscountedProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return catalogDiscountedProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$catalogDiscountedProductsHash() =>
    r'b4e796b105423be4f249dd26249c818361619d32';

@ProviderFor(catalogNewestProducts)
final catalogNewestProductsProvider = CatalogNewestProductsFamily._();

final class CatalogNewestProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  CatalogNewestProductsProvider._({
    required CatalogNewestProductsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'catalogNewestProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catalogNewestProductsHash();

  @override
  String toString() {
    return r'catalogNewestProductsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    final argument = this.argument as int;
    return catalogNewestProducts(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CatalogNewestProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catalogNewestProductsHash() =>
    r'e52e37fbf14442bdba278f305afaf12865dd4e86';

final class CatalogNewestProductsFamily extends $Family
    with $FunctionalFamilyOverride<List<Product>, int> {
  CatalogNewestProductsFamily._()
    : super(
        retry: null,
        name: r'catalogNewestProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatalogNewestProductsProvider call(int count) =>
      CatalogNewestProductsProvider._(argument: count, from: this);

  @override
  String toString() => r'catalogNewestProductsProvider';
}

@ProviderFor(homeFeaturedProducts)
final homeFeaturedProductsProvider = HomeFeaturedProductsProvider._();

final class HomeFeaturedProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  HomeFeaturedProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeFeaturedProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeFeaturedProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return homeFeaturedProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$homeFeaturedProductsHash() =>
    r'be55448a19e04c6d13d9cd0503d0173b69cd4b7d';

@ProviderFor(productDetail)
final productDetailProvider = ProductDetailFamily._();

final class ProductDetailProvider
    extends
        $FunctionalProvider<AsyncValue<Product?>, Product?, FutureOr<Product?>>
    with $FutureModifier<Product?>, $FutureProvider<Product?> {
  ProductDetailProvider._({
    required ProductDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailHash();

  @override
  String toString() {
    return r'productDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product?> create(Ref ref) {
    final argument = this.argument as String;
    return productDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailHash() => r'db68fa4bafa619270b08eb3aee766b9fd27ee896';

final class ProductDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product?>, String> {
  ProductDetailFamily._()
    : super(
        retry: null,
        name: r'productDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductDetailProvider call(String id) =>
      ProductDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'productDetailProvider';
}

@ProviderFor(homeRecommendedProducts)
final homeRecommendedProductsProvider = HomeRecommendedProductsFamily._();

final class HomeRecommendedProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  HomeRecommendedProductsProvider._({
    required HomeRecommendedProductsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'homeRecommendedProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$homeRecommendedProductsHash();

  @override
  String toString() {
    return r'homeRecommendedProductsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    final argument = this.argument as String;
    return homeRecommendedProducts(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HomeRecommendedProductsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$homeRecommendedProductsHash() =>
    r'bf10eab6afdaee89c6c69879a9b24dc87d0cb543';

final class HomeRecommendedProductsFamily extends $Family
    with $FunctionalFamilyOverride<List<Product>, String> {
  HomeRecommendedProductsFamily._()
    : super(
        retry: null,
        name: r'homeRecommendedProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HomeRecommendedProductsProvider call(String roomId) =>
      HomeRecommendedProductsProvider._(argument: roomId, from: this);

  @override
  String toString() => r'homeRecommendedProductsProvider';
}

@ProviderFor(catalogProductCount)
final catalogProductCountProvider = CatalogProductCountProvider._();

final class CatalogProductCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  CatalogProductCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogProductCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogProductCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return catalogProductCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$catalogProductCountHash() =>
    r'a9da1dcc7cd061684cfd07e89297fc3167917696';
