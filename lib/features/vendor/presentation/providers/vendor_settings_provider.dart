import 'package:placeify/core/providers/shared_preferences_provider.dart';
import 'package:placeify/features/vendor/domain/enums/notification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_settings_provider.g.dart';

class VendorSettingsState {
  const VendorSettingsState({
    this.notifications = const {},
    this.storeVisible = true,
    this.deactivateRequestedAt,
  });

  final Map<NotificationType, bool> notifications;
  final bool storeVisible;
  final DateTime? deactivateRequestedAt;

  static const deactivateCooldown = Duration(hours: 24);

  bool get isDeactivateCooldownActive {
    final requestedAt = deactivateRequestedAt;
    if (requestedAt == null) return false;
    return DateTime.now().difference(requestedAt) < deactivateCooldown;
  }

  Duration? get deactivateCooldownRemaining {
    final requestedAt = deactivateRequestedAt;
    if (requestedAt == null) return null;
    final elapsed = DateTime.now().difference(requestedAt);
    if (elapsed >= deactivateCooldown) return null;
    return deactivateCooldown - elapsed;
  }

  VendorSettingsState copyWith({
    Map<NotificationType, bool>? notifications,
    bool? storeVisible,
    DateTime? deactivateRequestedAt,
    bool clearDeactivateRequestedAt = false,
  }) {
    return VendorSettingsState(
      notifications: notifications ?? this.notifications,
      storeVisible: storeVisible ?? this.storeVisible,
      deactivateRequestedAt: clearDeactivateRequestedAt
          ? null
          : (deactivateRequestedAt ?? this.deactivateRequestedAt),
    );
  }
}

String _notificationKey(NotificationType type) => 'vendor_notify_${type.name}';

const _storeVisibleKey = 'vendor_store_visible';
const _deactivateRequestedAtKey = 'vendor_deactivate_requested_at';

@Riverpod(keepAlive: true)
class VendorSettings extends _$VendorSettings {
  @override
  VendorSettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final notifications = <NotificationType, bool>{};
    for (final type in NotificationType.values) {
      notifications[type] = prefs.getBool(_notificationKey(type)) ?? true;
    }

    final storeVisible = prefs.getBool(_storeVisibleKey) ?? true;
    final deactivateRaw = prefs.getString(_deactivateRequestedAtKey);
    final deactivateRequestedAt = deactivateRaw == null
        ? null
        : DateTime.tryParse(deactivateRaw);

    return VendorSettingsState(
      notifications: notifications,
      storeVisible: storeVisible,
      deactivateRequestedAt: deactivateRequestedAt,
    );
  }

  Future<void> setNotification(NotificationType type, bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_notificationKey(type), enabled);
    state = state.copyWith(
      notifications: {...state.notifications, type: enabled},
    );
  }

  Future<void> setStoreVisible(bool visible) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_storeVisibleKey, visible);
    state = state.copyWith(storeVisible: visible);
  }

  Future<void> requestDeactivateStore() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final now = DateTime.now();
    await prefs.setString(_deactivateRequestedAtKey, now.toIso8601String());
    state = state.copyWith(deactivateRequestedAt: now);
  }

  Future<void> cancelDeactivateRequest() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_deactivateRequestedAtKey);
    state = state.copyWith(clearDeactivateRequestedAt: true);
  }

  Future<void> completeDeactivateStore() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_storeVisibleKey, false);
    await prefs.remove(_deactivateRequestedAtKey);
    state = state.copyWith(
      storeVisible: false,
      clearDeactivateRequestedAt: true,
    );
  }
}
