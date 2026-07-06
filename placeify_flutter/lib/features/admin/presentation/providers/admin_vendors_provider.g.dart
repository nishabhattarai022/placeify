// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_vendors_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminVendorsList)
final adminVendorsListProvider = AdminVendorsListFamily._();

final class AdminVendorsListProvider
    extends $AsyncNotifierProvider<AdminVendorsList, List<VendorApplication>> {
  AdminVendorsListProvider._({
    required AdminVendorsListFamily super.from,
    required AdminVendorListFilter super.argument,
  }) : super(
         retry: null,
         name: r'adminVendorsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminVendorsListHash();

  @override
  String toString() {
    return r'adminVendorsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AdminVendorsList create() => AdminVendorsList();

  @override
  bool operator ==(Object other) {
    return other is AdminVendorsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminVendorsListHash() => r'1ad0815836fa7f180f7da47671d63c6738305107';

final class AdminVendorsListFamily extends $Family
    with
        $ClassFamilyOverride<
          AdminVendorsList,
          AsyncValue<List<VendorApplication>>,
          List<VendorApplication>,
          FutureOr<List<VendorApplication>>,
          AdminVendorListFilter
        > {
  AdminVendorsListFamily._()
    : super(
        retry: null,
        name: r'adminVendorsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminVendorsListProvider call(AdminVendorListFilter filter) =>
      AdminVendorsListProvider._(argument: filter, from: this);

  @override
  String toString() => r'adminVendorsListProvider';
}

abstract class _$AdminVendorsList
    extends $AsyncNotifier<List<VendorApplication>> {
  late final _$args = ref.$arg as AdminVendorListFilter;
  AdminVendorListFilter get filter => _$args;

  FutureOr<List<VendorApplication>> build(AdminVendorListFilter filter);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<VendorApplication>>,
              List<VendorApplication>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<VendorApplication>>,
                List<VendorApplication>
              >,
              AsyncValue<List<VendorApplication>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(AdminVendorActions)
final adminVendorActionsProvider = AdminVendorActionsProvider._();

final class AdminVendorActionsProvider
    extends $AsyncNotifierProvider<AdminVendorActions, void> {
  AdminVendorActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminVendorActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminVendorActionsHash();

  @$internal
  @override
  AdminVendorActions create() => AdminVendorActions();
}

String _$adminVendorActionsHash() =>
    r'0da41b435cb2f9b3c3dfe103af7164259b7a1a4b';

abstract class _$AdminVendorActions extends $AsyncNotifier<void> {
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
