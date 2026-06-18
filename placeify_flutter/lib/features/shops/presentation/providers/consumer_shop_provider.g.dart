// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer_shop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(consumerShopRepository)
final consumerShopRepositoryProvider = ConsumerShopRepositoryProvider._();

final class ConsumerShopRepositoryProvider
    extends
        $FunctionalProvider<
          ConsumerShopRepository,
          ConsumerShopRepository,
          ConsumerShopRepository
        >
    with $Provider<ConsumerShopRepository> {
  ConsumerShopRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consumerShopRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consumerShopRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConsumerShopRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConsumerShopRepository create(Ref ref) {
    return consumerShopRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsumerShopRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsumerShopRepository>(value),
    );
  }
}

String _$consumerShopRepositoryHash() =>
    r'20cb35fae1e73d5b22bcd9e7f40b73cef80d6207';

@ProviderFor(consumerShops)
final consumerShopsProvider = ConsumerShopsFamily._();

final class ConsumerShopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShopListing>>,
          List<ShopListing>,
          FutureOr<List<ShopListing>>
        >
    with
        $FutureModifier<List<ShopListing>>,
        $FutureProvider<List<ShopListing>> {
  ConsumerShopsProvider._({
    required ConsumerShopsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'consumerShopsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$consumerShopsHash();

  @override
  String toString() {
    return r'consumerShopsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ShopListing>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShopListing>> create(Ref ref) {
    final argument = this.argument as String;
    return consumerShops(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsumerShopsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$consumerShopsHash() => r'7fe67b133b95c0794de1b547019249f3f33cd55b';

final class ConsumerShopsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ShopListing>>, String> {
  ConsumerShopsFamily._()
    : super(
        retry: null,
        name: r'consumerShopsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConsumerShopsProvider call(String query) =>
      ConsumerShopsProvider._(argument: query, from: this);

  @override
  String toString() => r'consumerShopsProvider';
}

@ProviderFor(shopListing)
final shopListingProvider = ShopListingFamily._();

final class ShopListingProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShopListing?>,
          ShopListing?,
          FutureOr<ShopListing?>
        >
    with $FutureModifier<ShopListing?>, $FutureProvider<ShopListing?> {
  ShopListingProvider._({
    required ShopListingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shopListingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopListingHash();

  @override
  String toString() {
    return r'shopListingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ShopListing?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShopListing?> create(Ref ref) {
    final argument = this.argument as String;
    return shopListing(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopListingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopListingHash() => r'516c5d07184a82988a57300edd3b962383a64f45';

final class ShopListingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShopListing?>, String> {
  ShopListingFamily._()
    : super(
        retry: null,
        name: r'shopListingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShopListingProvider call(String vendorId) =>
      ShopListingProvider._(argument: vendorId, from: this);

  @override
  String toString() => r'shopListingProvider';
}

@ProviderFor(shopProducts)
final shopProductsProvider = ShopProductsFamily._();

final class ShopProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  ShopProductsProvider._({
    required ShopProductsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'shopProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shopProductsHash();

  @override
  String toString() {
    return r'shopProductsProvider'
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
    return shopProducts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShopProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shopProductsHash() => r'6142386580aa3bd8e9075ddb4cbd5611ff0002ad';

final class ShopProductsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  ShopProductsFamily._()
    : super(
        retry: null,
        name: r'shopProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShopProductsProvider call(String vendorId) =>
      ShopProductsProvider._(argument: vendorId, from: this);

  @override
  String toString() => r'shopProductsProvider';
}
