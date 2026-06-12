// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_pending_badge_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminPendingApplicationsBadge)
final adminPendingApplicationsBadgeProvider =
    AdminPendingApplicationsBadgeProvider._();

final class AdminPendingApplicationsBadgeProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  AdminPendingApplicationsBadgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminPendingApplicationsBadgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminPendingApplicationsBadgeHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return adminPendingApplicationsBadge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$adminPendingApplicationsBadgeHash() =>
    r'48c8ec4d1af43c632b6040227332cf47ed75e591';
