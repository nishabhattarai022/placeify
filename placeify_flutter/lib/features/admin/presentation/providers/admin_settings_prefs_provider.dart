import 'package:placeify_flutter/features/admin/data/serverpod_admin_repository.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_repository_provider.dart';
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
  @override
  AdminNotificationPrefs build() {
    Future.microtask(_loadFromServer);
    return const AdminNotificationPrefs(
      newApplicationAlerts: true,
      systemAlerts: true,
    );
  }

  Future<void> _loadFromServer() async {
    try {
      final repo = await ref.read(adminRepositoryProvider.future);
      if (repo is! ServerpodAdminRepository) return;
      final prefs = await repo.getNotificationPreferences();
      if (!ref.mounted) return;
      state = AdminNotificationPrefs(
        newApplicationAlerts: prefs.newApplicationAlerts,
        systemAlerts: prefs.systemAlerts,
      );
    } catch (_) {}
  }

  Future<void> setNewApplicationAlerts(bool value) async {
    final previous = state;
    state = state.copyWith(newApplicationAlerts: value);
    try {
      final repo = await ref.read(adminRepositoryProvider.future);
      if (repo is! ServerpodAdminRepository) return;
      final prefs = await repo.updateNotificationPreferences(
        newApplicationAlerts: value,
        systemAlerts: state.systemAlerts,
      );
      state = AdminNotificationPrefs(
        newApplicationAlerts: prefs.newApplicationAlerts,
        systemAlerts: prefs.systemAlerts,
      );
    } catch (_) {
      state = previous;
    }
  }

  Future<void> setSystemAlerts(bool value) async {
    final previous = state;
    state = state.copyWith(systemAlerts: value);
    try {
      final repo = await ref.read(adminRepositoryProvider.future);
      if (repo is! ServerpodAdminRepository) return;
      final prefs = await repo.updateNotificationPreferences(
        newApplicationAlerts: state.newApplicationAlerts,
        systemAlerts: value,
      );
      state = AdminNotificationPrefs(
        newApplicationAlerts: prefs.newApplicationAlerts,
        systemAlerts: prefs.systemAlerts,
      );
    } catch (_) {
      state = previous;
    }
  }
}
