// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_refunds_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRefundsHash();

  @$internal
  @override
  ProfileRefunds create() => ProfileRefunds();
}

String _$profileRefundsHash() => r'95f811e2a21372670e7e26f9bca361aab21c3222';

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
