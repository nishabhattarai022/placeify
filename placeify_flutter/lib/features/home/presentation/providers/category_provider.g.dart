// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, String> {
  SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedCategoryHash() => r'bd52410f512c596746a2dc038532b9531736b1aa';

abstract class _$SelectedCategory extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          List<ProductCategory>,
          List<ProductCategory>,
          List<ProductCategory>
        >
    with $Provider<List<ProductCategory>> {
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $ProviderElement<List<ProductCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<ProductCategory> create(Ref ref) {
    return categories(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ProductCategory> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ProductCategory>>(value),
    );
  }
}

String _$categoriesHash() => r'bfc61276d2b5d05757dc27f9dc43b0d9990f20d3';

@ProviderFor(filteredProducts)
final filteredProductsProvider = FilteredProductsProvider._();

final class FilteredProductsProvider
    extends $FunctionalProvider<List<Product>, List<Product>, List<Product>>
    with $Provider<List<Product>> {
  FilteredProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredProductsHash();

  @$internal
  @override
  $ProviderElement<List<Product>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Product> create(Ref ref) {
    return filteredProducts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Product> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Product>>(value),
    );
  }
}

String _$filteredProductsHash() => r'd6770eaa0026d864b3d0a59c208527d95b6133b9';

@ProviderFor(productById)
final productByIdProvider = ProductByIdFamily._();

final class ProductByIdProvider
    extends $FunctionalProvider<Product?, Product?, Product?>
    with $Provider<Product?> {
  ProductByIdProvider._({
    required ProductByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productByIdHash();

  @override
  String toString() {
    return r'productByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Product?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Product? create(Ref ref) {
    final argument = this.argument as String;
    return productById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Product? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Product?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productByIdHash() => r'cdda4518d0e30e2d9283c79e068667defa2daaff';

final class ProductByIdFamily extends $Family
    with $FunctionalFamilyOverride<Product?, String> {
  ProductByIdFamily._()
    : super(
        retry: null,
        name: r'productByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductByIdProvider call(String id) =>
      ProductByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'productByIdProvider';
}
