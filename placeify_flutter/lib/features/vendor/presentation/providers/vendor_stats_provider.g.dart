// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VendorStats)
final vendorStatsProvider = VendorStatsProvider._();

final class VendorStatsProvider
    extends $AsyncNotifierProvider<VendorStats, VendorDashboardData> {
  VendorStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vendorStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vendorStatsHash();

  @$internal
  @override
  VendorStats create() => VendorStats();
}

String _$vendorStatsHash() => r'a0219b9a58e09c44019b64e7d3cc335d3bceb8b5';

abstract class _$VendorStats extends $AsyncNotifier<VendorDashboardData> {
  FutureOr<VendorDashboardData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<VendorDashboardData>, VendorDashboardData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VendorDashboardData>, VendorDashboardData>,
              AsyncValue<VendorDashboardData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
