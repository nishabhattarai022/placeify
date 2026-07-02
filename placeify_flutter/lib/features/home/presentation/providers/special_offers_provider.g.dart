// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_offers_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(specialOffers)
final specialOffersProvider = SpecialOffersProvider._();

final class SpecialOffersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DiscountedProduct>>,
          List<DiscountedProduct>,
          FutureOr<List<DiscountedProduct>>
        >
    with
        $FutureModifier<List<DiscountedProduct>>,
        $FutureProvider<List<DiscountedProduct>> {
  SpecialOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'specialOffersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$specialOffersHash();

  @$internal
  @override
  $FutureProviderElement<List<DiscountedProduct>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DiscountedProduct>> create(Ref ref) {
    return specialOffers(ref);
  }
}

String _$specialOffersHash() => r'aca67253f3bb350f8bd53b826a2b6f559e4ccdc6';
