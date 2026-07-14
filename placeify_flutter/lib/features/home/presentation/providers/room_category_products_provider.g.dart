// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_category_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomCategoryProducts)
final roomCategoryProductsProvider = RoomCategoryProductsFamily._();

final class RoomCategoryProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  RoomCategoryProductsProvider._({
    required RoomCategoryProductsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'roomCategoryProductsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$roomCategoryProductsHash();

  @override
  String toString() {
    return r'roomCategoryProductsProvider'
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
    return roomCategoryProducts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomCategoryProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$roomCategoryProductsHash() =>
    r'4caefe687853394a1259a87d49ef82770608a8be';

final class RoomCategoryProductsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  RoomCategoryProductsFamily._()
    : super(
        retry: null,
        name: r'roomCategoryProductsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RoomCategoryProductsProvider call(String category) =>
      RoomCategoryProductsProvider._(argument: category, from: this);

  @override
  String toString() => r'roomCategoryProductsProvider';
}
