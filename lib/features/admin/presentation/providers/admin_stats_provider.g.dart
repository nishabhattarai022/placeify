// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminStats)
final adminStatsProvider = AdminStatsProvider._();

final class AdminStatsProvider
    extends $AsyncNotifierProvider<AdminStats, models.AdminStats> {
  AdminStatsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'adminStatsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adminStatsHash();

  @$internal
  @override
  AdminStats create() => AdminStats();
}

String _$adminStatsHash() => r'1ef35cad2859abf4625109080cce454fa5e5c8f9';

abstract class _$AdminStats extends $AsyncNotifier<models.AdminStats> {
  FutureOr<models.AdminStats> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<models.AdminStats>, models.AdminStats>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<models.AdminStats>, models.AdminStats>,
        AsyncValue<models.AdminStats>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
