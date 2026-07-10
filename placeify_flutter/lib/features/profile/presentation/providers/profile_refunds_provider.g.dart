// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_refunds_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(refundRepository)
final refundRepositoryProvider = RefundRepositoryProvider._();

final class RefundRepositoryProvider
    extends
        $FunctionalProvider<
          ServerpodRefundRepository,
          ServerpodRefundRepository,
          ServerpodRefundRepository
        >
    with $Provider<ServerpodRefundRepository> {
  RefundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refundRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refundRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerpodRefundRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerpodRefundRepository create(Ref ref) {
    return refundRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerpodRefundRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerpodRefundRepository>(value),
    );
  }
}

String _$refundRepositoryHash() => r'edb0f1190f2e41fa02239dd01263f13ff1e8977f';

@ProviderFor(ProfileRefunds)
final profileRefundsProvider = ProfileRefundsProvider._();

final class ProfileRefundsProvider
    extends $AsyncNotifierProvider<ProfileRefunds, ProfileRefundsState> {
  ProfileRefundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRefundsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRefundsHash();

  @$internal
  @override
  ProfileRefunds create() => ProfileRefunds();
}

String _$profileRefundsHash() => r'6eaf8b53302c408e31117f7689c85baf708eede9';

abstract class _$ProfileRefunds extends $AsyncNotifier<ProfileRefundsState> {
  FutureOr<ProfileRefundsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ProfileRefundsState>, ProfileRefundsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProfileRefundsState>, ProfileRefundsState>,
              AsyncValue<ProfileRefundsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
