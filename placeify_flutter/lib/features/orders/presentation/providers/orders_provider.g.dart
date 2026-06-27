// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderRepository)
final orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider
    extends
        $FunctionalProvider<OrderRepository, OrderRepository, OrderRepository>
    with $Provider<OrderRepository> {
  OrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'02d34d0396fb43ebe969d7baa013a889aa338f2e';

@ProviderFor(ordersUserId)
final ordersUserIdProvider = OrdersUserIdProvider._();

final class OrdersUserIdProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  OrdersUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersUserIdHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return ordersUserId(ref);
  }
}

String _$ordersUserIdHash() => r'db0eaba9e9c078d0ae8e92f25f24da838f11de52';

@ProviderFor(Orders)
final ordersProvider = OrdersProvider._();

final class OrdersProvider extends $AsyncNotifierProvider<Orders, List<Order>> {
  OrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersHash();

  @$internal
  @override
  Orders create() => Orders();
}

String _$ordersHash() => r'2da2fa3128db05f885e770e3779e3051bb4c4bd8';

abstract class _$Orders extends $AsyncNotifier<List<Order>> {
  FutureOr<List<Order>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Order>>, List<Order>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Order>>, List<Order>>,
              AsyncValue<List<Order>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ordersCount)
final ordersCountProvider = OrdersCountProvider._();

final class OrdersCountProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  OrdersCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return ordersCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$ordersCountHash() => r'9d5f0a6d59db8d93be9c45bb6c215a075f5ebedf';

@ProviderFor(inTransitOrderCount)
final inTransitOrderCountProvider = InTransitOrderCountProvider._();

final class InTransitOrderCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  InTransitOrderCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inTransitOrderCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inTransitOrderCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return inTransitOrderCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$inTransitOrderCountHash() =>
    r'bb0ed0ef5e570c22625fa571748da175c1d0a678';

@ProviderFor(activeOrders)
final activeOrdersProvider = ActiveOrdersProvider._();

final class ActiveOrdersProvider
    extends $FunctionalProvider<List<Order>, List<Order>, List<Order>>
    with $Provider<List<Order>> {
  ActiveOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeOrdersHash();

  @$internal
  @override
  $ProviderElement<List<Order>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Order> create(Ref ref) {
    return activeOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Order> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Order>>(value),
    );
  }
}

String _$activeOrdersHash() => r'48918dd6bc8b6e3e33c7264447639a622c113e8f';

@ProviderFor(deliveredOrders)
final deliveredOrdersProvider = DeliveredOrdersProvider._();

final class DeliveredOrdersProvider
    extends $FunctionalProvider<List<Order>, List<Order>, List<Order>>
    with $Provider<List<Order>> {
  DeliveredOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliveredOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliveredOrdersHash();

  @$internal
  @override
  $ProviderElement<List<Order>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Order> create(Ref ref) {
    return deliveredOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Order> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Order>>(value),
    );
  }
}

String _$deliveredOrdersHash() => r'61ea15f356d4d36c7ec9f1118c875fe635110b5e';

@ProviderFor(cancelledOrders)
final cancelledOrdersProvider = CancelledOrdersProvider._();

final class CancelledOrdersProvider
    extends $FunctionalProvider<List<Order>, List<Order>, List<Order>>
    with $Provider<List<Order>> {
  CancelledOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelledOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelledOrdersHash();

  @$internal
  @override
  $ProviderElement<List<Order>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Order> create(Ref ref) {
    return cancelledOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Order> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Order>>(value),
    );
  }
}

String _$cancelledOrdersHash() => r'1e8c2d17fdaf5b1060bc5032f8ce3e6f0db4cbc9';

@ProviderFor(returnOrders)
final returnOrdersProvider = ReturnOrdersProvider._();

final class ReturnOrdersProvider
    extends $FunctionalProvider<List<Order>, List<Order>, List<Order>>
    with $Provider<List<Order>> {
  ReturnOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'returnOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$returnOrdersHash();

  @$internal
  @override
  $ProviderElement<List<Order>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Order> create(Ref ref) {
    return returnOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Order> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Order>>(value),
    );
  }
}

String _$returnOrdersHash() => r'a5274d88c8c34e2a998b3450c823ee5424e29c2f';

@ProviderFor(orderById)
final orderByIdProvider = OrderByIdFamily._();

final class OrderByIdProvider
    extends $FunctionalProvider<AsyncValue<Order?>, Order?, FutureOr<Order?>>
    with $FutureModifier<Order?>, $FutureProvider<Order?> {
  OrderByIdProvider._({
    required OrderByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderByIdHash();

  @override
  String toString() {
    return r'orderByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Order?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Order?> create(Ref ref) {
    final argument = this.argument as String;
    return orderById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderByIdHash() => r'8cc771237ba7a3356ea79fb3349c9618d654f4fc';

final class OrderByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Order?>, String> {
  OrderByIdFamily._()
    : super(
        retry: null,
        name: r'orderByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderByIdProvider call(String orderId) =>
      OrderByIdProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderByIdProvider';
}

@ProviderFor(filteredOrders)
final filteredOrdersProvider = FilteredOrdersFamily._();

final class FilteredOrdersProvider
    extends $FunctionalProvider<List<Order>, List<Order>, List<Order>>
    with $Provider<List<Order>> {
  FilteredOrdersProvider._({
    required FilteredOrdersFamily super.from,
    required OrderListFilter super.argument,
  }) : super(
         retry: null,
         name: r'filteredOrdersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredOrdersHash();

  @override
  String toString() {
    return r'filteredOrdersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Order>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Order> create(Ref ref) {
    final argument = this.argument as OrderListFilter;
    return filteredOrders(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Order> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Order>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredOrdersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredOrdersHash() => r'd1f467c7919b5ff14a58c46dc523913266cd80e3';

final class FilteredOrdersFamily extends $Family
    with $FunctionalFamilyOverride<List<Order>, OrderListFilter> {
  FilteredOrdersFamily._()
    : super(
        retry: null,
        name: r'filteredOrdersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredOrdersProvider call(OrderListFilter filter) =>
      FilteredOrdersProvider._(argument: filter, from: this);

  @override
  String toString() => r'filteredOrdersProvider';
}
