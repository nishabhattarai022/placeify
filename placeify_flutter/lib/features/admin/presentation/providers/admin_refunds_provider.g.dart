// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_refunds_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminRefundsList)
final adminRefundsListProvider = AdminRefundsListProvider._();

final class AdminRefundsListProvider
    extends
        $AsyncNotifierProvider<
          AdminRefundsList,
          List<AdminRefundRequestSummary>
        > {
  AdminRefundsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRefundsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRefundsListHash();

  @$internal
  @override
  AdminRefundsList create() => AdminRefundsList();
}

String _$adminRefundsListHash() => r'0a19e602a7d0018bb5fc76303c4d95a6fda388cb';

abstract class _$AdminRefundsList
    extends $AsyncNotifier<List<AdminRefundRequestSummary>> {
  FutureOr<List<AdminRefundRequestSummary>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AdminRefundRequestSummary>>,
              List<AdminRefundRequestSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminRefundRequestSummary>>,
                List<AdminRefundRequestSummary>
              >,
              AsyncValue<List<AdminRefundRequestSummary>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
