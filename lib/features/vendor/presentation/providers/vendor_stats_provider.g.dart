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

String _$vendorStatsHash() => r'88179ade8bf6c0c6991e952ccdd0523250a6949e';

abstract class _$VendorStats extends $AsyncNotifier<VendorDashboardData> {
  FutureOr<VendorDashboardData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<VendorDashboardData>, VendorDashboardData>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<VendorDashboardData>, VendorDashboardData>,
        AsyncValue<VendorDashboardData>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
