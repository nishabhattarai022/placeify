// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumer_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(consumerProfileRepository)
final consumerProfileRepositoryProvider = ConsumerProfileRepositoryProvider._();

final class ConsumerProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ServerpodConsumerProfileRepository,
          ServerpodConsumerProfileRepository,
          ServerpodConsumerProfileRepository
        >
    with $Provider<ServerpodConsumerProfileRepository> {
  ConsumerProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consumerProfileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consumerProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ServerpodConsumerProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ServerpodConsumerProfileRepository create(Ref ref) {
    return consumerProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerpodConsumerProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerpodConsumerProfileRepository>(
        value,
      ),
    );
  }
}

String _$consumerProfileRepositoryHash() =>
    r'd6e44535a817bc3dccc9b282b4dafe73a7dd52d9';

@ProviderFor(ConsumerProfile)
final consumerProfileProvider = ConsumerProfileProvider._();

final class ConsumerProfileProvider
    extends $AsyncNotifierProvider<ConsumerProfile, User?> {
  ConsumerProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consumerProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consumerProfileHash();

  @$internal
  @override
  ConsumerProfile create() => ConsumerProfile();
}

String _$consumerProfileHash() => r'af3adcfdd70fdcd0a6d3fac810128b3a7e1cfa5a';

abstract class _$ConsumerProfile extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
