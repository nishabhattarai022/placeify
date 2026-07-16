// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_pending_selection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Product ids picked in the current AR session (before tapping Done).

@ProviderFor(ArPendingSelection)
final arPendingSelectionProvider = ArPendingSelectionProvider._();

/// Product ids picked in the current AR session (before tapping Done).
final class ArPendingSelectionProvider
    extends $NotifierProvider<ArPendingSelection, Set<String>> {
  /// Product ids picked in the current AR session (before tapping Done).
  ArPendingSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'arPendingSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$arPendingSelectionHash();

  @$internal
  @override
  ArPendingSelection create() => ArPendingSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$arPendingSelectionHash() =>
    r'dccada0c54088803237232ee7b3df1e161b90dc4';

/// Product ids picked in the current AR session (before tapping Done).

abstract class _$ArPendingSelection extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
