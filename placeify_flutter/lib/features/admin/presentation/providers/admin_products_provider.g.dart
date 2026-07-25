// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_products_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminProductsList)
final adminProductsListProvider = AdminProductsListFamily._();

final class AdminProductsListProvider
    extends
        $AsyncNotifierProvider<AdminProductsList, List<AdminProductSummary>> {
  AdminProductsListProvider._({
    required AdminProductsListFamily super.from,
    required AdminProductListQuery super.argument,
  }) : super(
         retry: null,
         name: r'adminProductsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminProductsListHash();

  @override
  String toString() {
    return r'adminProductsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminProductsList create() => AdminProductsList();

  @override
  bool operator ==(Object other) {
    return other is AdminProductsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminProductsListHash() => r'e723e42435b922d9d08db27b416b8f646e22f789';

final class AdminProductsListFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminProductsList,
          AsyncValue<List<AdminProductSummary>>,
          List<AdminProductSummary>,
          FutureOr<List<AdminProductSummary>>,
          AdminProductListQuery
        > {
  AdminProductsListFamily._()
    : super(
        retry: null,
        name: r'adminProductsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminProductsListProvider call(AdminProductListQuery query) =>
      AdminProductsListProvider._(argument: query, from: this);

  @override
  String toString() => r'adminProductsListProvider';
}

abstract class _$AdminProductsList
    extends $AsyncNotifier<List<AdminProductSummary>> {
  late final _$args = ref.$arg as AdminProductListQuery;
  AdminProductListQuery get query => _$args;

  FutureOr<List<AdminProductSummary>> build(AdminProductListQuery query);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AdminProductSummary>>,
              List<AdminProductSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminProductSummary>>,
                List<AdminProductSummary>
              >,
              AsyncValue<List<AdminProductSummary>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(adminProductDetail)
final adminProductDetailProvider = AdminProductDetailFamily._();

final class AdminProductDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminProductDetail?>,
          AdminProductDetail?,
          FutureOr<AdminProductDetail?>
        >
    with
        $FutureModifier<AdminProductDetail?>,
        $FutureProvider<AdminProductDetail?> {
  AdminProductDetailProvider._({
    required AdminProductDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'adminProductDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminProductDetailHash();

  @override
  String toString() {
    return r'adminProductDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AdminProductDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminProductDetail?> create(Ref ref) {
    final argument = this.argument as int;
    return adminProductDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminProductDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminProductDetailHash() =>
    r'2b9c86afe1268e96fb388b86bbceb69e60b74181';

final class AdminProductDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AdminProductDetail?>, int> {
  AdminProductDetailFamily._()
    : super(
        retry: null,
        name: r'adminProductDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminProductDetailProvider call(int productId) =>
      AdminProductDetailProvider._(argument: productId, from: this);

  @override
  String toString() => r'adminProductDetailProvider';
}

@ProviderFor(AdminProductActions)
final adminProductActionsProvider = AdminProductActionsProvider._();

final class AdminProductActionsProvider
    extends $AsyncNotifierProvider<AdminProductActions, void> {
  AdminProductActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminProductActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminProductActionsHash();

  @$internal
  @override
  AdminProductActions create() => AdminProductActions();
}

String _$adminProductActionsHash() =>
    r'8cd36f5994952f5b8a36db9be2a47db0299734a0';

abstract class _$AdminProductActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
