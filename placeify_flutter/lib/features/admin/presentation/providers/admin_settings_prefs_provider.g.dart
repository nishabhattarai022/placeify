// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settings_prefs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminSettingsPrefs)
final adminSettingsPrefsProvider = AdminSettingsPrefsProvider._();

final class AdminSettingsPrefsProvider
    extends $NotifierProvider<AdminSettingsPrefs, AdminNotificationPrefs> {
  AdminSettingsPrefsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'adminSettingsPrefsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$adminSettingsPrefsHash();

  @$internal
  @override
  AdminSettingsPrefs create() => AdminSettingsPrefs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminNotificationPrefs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminNotificationPrefs>(value),
    );
  }
}

String _$adminSettingsPrefsHash() =>
    r'45eaa9e9af6caa9cb7f744abb8a360af15514c80';

abstract class _$AdminSettingsPrefs extends $Notifier<AdminNotificationPrefs> {
  AdminNotificationPrefs build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AdminNotificationPrefs, AdminNotificationPrefs>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AdminNotificationPrefs, AdminNotificationPrefs>,
        AdminNotificationPrefs,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
