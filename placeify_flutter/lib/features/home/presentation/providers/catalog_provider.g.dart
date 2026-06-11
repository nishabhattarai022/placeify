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

String _$catalogIndexHash() => r'b3d33623518c37634f8563dcdba7074d49391571';

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
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
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
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return catalogProductsByCategory(ref, argument);
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
    r'0e8871a7ccd243e82a2a812374de87dde85c8e7a';

final class CatalogProductsByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
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
