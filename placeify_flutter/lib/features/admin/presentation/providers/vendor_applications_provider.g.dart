// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_applications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorApplicationsList)
final vendorApplicationsListProvider = VendorApplicationsListFamily._();

final class VendorApplicationsListProvider
    extends
        $AsyncNotifierProvider<
          VendorApplicationsList,
          List<VendorApplication>
        > {
  VendorApplicationsListProvider._({
    required VendorApplicationsListFamily super.from,
    required VendorApplicationListFilter super.argument,
  }) : super(
         retry: null,
         name: r'vendorApplicationsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vendorApplicationsListHash();

  @override
  String toString() {
    return r'vendorApplicationsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VendorApplicationsList create() => VendorApplicationsList();

  @override
  bool operator ==(Object other) {
    return other is VendorApplicationsListProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vendorApplicationsListHash() =>
    r'ef1fb524c8ad1e5e08964e1d143f3266718ba68c';

final class VendorApplicationsListFamily extends $Family
    with
        $ClassFamilyOverride<
          VendorApplicationsList,
          AsyncValue<List<VendorApplication>>,
          List<VendorApplication>,
          FutureOr<List<VendorApplication>>,
          VendorApplicationListFilter
        > {
  VendorApplicationsListFamily._()
    : super(
        retry: null,
        name: r'vendorApplicationsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VendorApplicationsListProvider call(VendorApplicationListFilter filter) =>
      VendorApplicationsListProvider._(argument: filter, from: this);

  @override
  String toString() => r'vendorApplicationsListProvider';
}

abstract class _$VendorApplicationsList
    extends $AsyncNotifier<List<VendorApplication>> {
  late final _$args = ref.$arg as VendorApplicationListFilter;
  VendorApplicationListFilter get filter => _$args;

  FutureOr<List<VendorApplication>> build(VendorApplicationListFilter filter);
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

@ProviderFor(vendorApplicationDetail)
final vendorApplicationDetailProvider = VendorApplicationDetailFamily._();

final class VendorApplicationDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<VendorApplication?>,
          VendorApplication?,
          FutureOr<VendorApplication?>
        >
    with
        $FutureModifier<VendorApplication?>,
        $FutureProvider<VendorApplication?> {
  VendorApplicationDetailProvider._({
    required VendorApplicationDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'vendorApplicationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vendorApplicationDetailHash();

  @override
  String toString() {
    return r'vendorApplicationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VendorApplication?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VendorApplication?> create(Ref ref) {
    final argument = this.argument as String;
    return vendorApplicationDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VendorApplicationDetailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vendorApplicationDetailHash() =>
    r'e76d7310601c3130f4172fe28f40e975b03cf0e3';

final class VendorApplicationDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VendorApplication?>, String> {
  VendorApplicationDetailFamily._()
    : super(
        retry: null,
        name: r'vendorApplicationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VendorApplicationDetailProvider call(String vendorId) =>
      VendorApplicationDetailProvider._(argument: vendorId, from: this);

  @override
  String toString() => r'vendorApplicationDetailProvider';
}

/// Long-lived action channel for admin approve/decline flows.

@ProviderFor(VendorApplicationActions)
final vendorApplicationActionsProvider = VendorApplicationActionsProvider._();

/// Long-lived action channel for admin approve/decline flows.
final class VendorApplicationActionsProvider
    extends $AsyncNotifierProvider<VendorApplicationActions, void> {
  /// Long-lived action channel for admin approve/decline flows.
  VendorApplicationActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorApplicationActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorApplicationActionsHash();

  @$internal
  @override
  VendorApplicationActions create() => VendorApplicationActions();
}

String _$vendorApplicationActionsHash() =>
    r'f844bb6a7a8406eeb43c583fc8999a753e91c7bd';

/// Long-lived action channel for admin approve/decline flows.

abstract class _$VendorApplicationActions extends $AsyncNotifier<void> {
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
