import 'package:placeify/core/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_settings_prefs_provider.g.dart';

class AdminNotificationPrefs {
  const AdminNotificationPrefs({
    required this.newApplicationAlerts,
    required this.systemAlerts,
  });

  final bool newApplicationAlerts;
  final bool systemAlerts;

  AdminNotificationPrefs copyWith({
    bool? newApplicationAlerts,
    bool? systemAlerts,
  }) {
    return AdminNotificationPrefs(
      newApplicationAlerts: newApplicationAlerts ?? this.newApplicationAlerts,
      systemAlerts: systemAlerts ?? this.systemAlerts,
    );
  }
}

@riverpod
class AdminSettingsPrefs extends _$AdminSettingsPrefs {
  static const _newAppKey = 'admin_pref_new_application_alerts';
  static const _systemKey = 'admin_pref_system_alerts';

  @override
  AdminNotificationPrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AdminNotificationPrefs(
      newApplicationAlerts: prefs.getBool(_newAppKey) ?? true,
      systemAlerts: prefs.getBool(_systemKey) ?? true,
    );
  }

  Future<void> setNewApplicationAlerts(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_newAppKey, value);
    state = state.copyWith(newApplicationAlerts: value);
  }

  Future<void> setSystemAlerts(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_systemKey, value);
    state = state.copyWith(systemAlerts: value);
  }
}
