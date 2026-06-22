// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminRepository)
final adminRepositoryProvider = AdminRepositoryProvider._();

final class AdminRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminRepository>,
          AdminRepository,
          FutureOr<AdminRepository>
        >
    with $FutureModifier<AdminRepository>, $FutureProvider<AdminRepository> {
  AdminRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<AdminRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminRepository> create(Ref ref) {
    return adminRepository(ref);
  }
}

String _$adminRepositoryHash() => r'd970d4e787768858f6e331617e253d37b2ff4a38';
