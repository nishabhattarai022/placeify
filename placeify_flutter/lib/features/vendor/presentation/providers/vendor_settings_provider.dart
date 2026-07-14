import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/providers/shared_preferences_provider.dart';
import 'package:placeify_flutter/features/profile/data/serverpod_notification_repository.dart';
import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_profile_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/notification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_settings_provider.g.dart';

class VendorSettingsState {
  const VendorSettingsState({
    this.notifications = const {},
    this.storeVisible = true,
    this.deactivateRequestedAt,
    this.bankName,
    this.accountHolderName,
    this.maskedAccountNumber,
  });

  final Map<NotificationType, bool> notifications;
  final bool storeVisible;
  final DateTime? deactivateRequestedAt;
  final String? bankName;
  final String? accountHolderName;
  final String? maskedAccountNumber;

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

  bool get hasBankDetails =>
      bankName != null &&
      bankName!.isNotEmpty &&
      maskedAccountNumber != null &&
      maskedAccountNumber!.isNotEmpty;

  VendorSettingsState copyWith({
    Map<NotificationType, bool>? notifications,
    bool? storeVisible,
    DateTime? deactivateRequestedAt,
    String? bankName,
    String? accountHolderName,
    String? maskedAccountNumber,
    bool clearDeactivateRequestedAt = false,
    bool clearBankDetails = false,
  }) {
    return VendorSettingsState(
      notifications: notifications ?? this.notifications,
      storeVisible: storeVisible ?? this.storeVisible,
      deactivateRequestedAt: clearDeactivateRequestedAt
          ? null
          : (deactivateRequestedAt ?? this.deactivateRequestedAt),
      bankName: clearBankDetails ? null : (bankName ?? this.bankName),
      accountHolderName: clearBankDetails
          ? null
          : (accountHolderName ?? this.accountHolderName),
      maskedAccountNumber: clearBankDetails
          ? null
          : (maskedAccountNumber ?? this.maskedAccountNumber),
    );
  }
}

const _deactivateRequestedAtKey = 'vendor_deactivate_requested_at';

const _profileRepo = ServerpodVendorProfileRepository();
const _notificationRepo = ServerpodNotificationRepository();

@Riverpod(keepAlive: true)
class VendorSettings extends _$VendorSettings {
  @override
  Future<VendorSettingsState> build() async {
    return _loadFromServer();
  }

  Future<VendorSettingsState> _loadFromServer() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final deactivateRaw = prefs.getString(_deactivateRequestedAtKey);
    final deactivateRequestedAt = deactivateRaw == null
        ? null
        : DateTime.tryParse(deactivateRaw);

    try {
      final loaded = await _profileRepo.loadStoreSettings();
      final notifications = _mapNotificationPrefs(loaded.notificationPreferences);
      var storeVisible = loaded.isOpen;

      if (deactivateRequestedAt != null &&
          DateTime.now().difference(deactivateRequestedAt) >=
              VendorSettingsState.deactivateCooldown) {
        storeVisible = await _profileRepo.updateStoreOpen(isOpen: false);
        await prefs.remove(_deactivateRequestedAtKey);
        return VendorSettingsState(
          notifications: notifications,
          storeVisible: storeVisible,
          bankName: loaded.bankName,
          accountHolderName: loaded.accountHolderName,
          maskedAccountNumber: loaded.maskedAccountNumber,
        );
      }

      return VendorSettingsState(
        notifications: notifications,
        storeVisible: storeVisible,
        deactivateRequestedAt: deactivateRequestedAt,
        bankName: loaded.bankName,
        accountHolderName: loaded.accountHolderName,
        maskedAccountNumber: loaded.maskedAccountNumber,
      );
    } catch (_) {
      return VendorSettingsState(
        notifications: {
          for (final type in NotificationType.values) type: true,
        },
        deactivateRequestedAt: deactivateRequestedAt,
      );
    }
  }

  Future<void> setNotification(NotificationType type, bool enabled) async {
    final current = state.value;
    if (current == null) return;

    final updatedNotifications = {...current.notifications, type: enabled};
    state = AsyncData(current.copyWith(notifications: updatedNotifications));

    try {
      final existing = await _notificationRepo.getPreferences();
      final saved = await _notificationRepo.updatePreferences(
        orderUpdates: type == NotificationType.order
            ? enabled
            : existing.orderUpdates,
        refundStatus: existing.refundStatus,
        arReminders: existing.arReminders,
        priceDropAlerts: type == NotificationType.product
            ? enabled
            : existing.priceDropAlerts,
        vendorMessages: type == NotificationType.system
            ? enabled
            : existing.vendorMessages,
        promotions: type == NotificationType.payment
            ? enabled
            : existing.promotions,
      );
      state = AsyncData(
        current.copyWith(notifications: _mapNotificationPrefs(saved)),
      );
    } catch (error) {
      state = AsyncData(current);
      rethrow;
    }
  }

  Future<void> setStoreVisible(bool visible) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(storeVisible: visible));

    try {
      final savedOpen = await _profileRepo.updateStoreOpen(isOpen: visible);
      final prefs = ref.read(sharedPreferencesProvider);
      if (visible) {
        await prefs.remove(_deactivateRequestedAtKey);
      }
      state = AsyncData(
        current.copyWith(
          storeVisible: savedOpen,
          clearDeactivateRequestedAt: visible,
        ),
      );
    } catch (error) {
      state = AsyncData(current);
      rethrow;
    }
  }

  Future<void> requestDeactivateStore() async {
    final current = state.value;
    if (current == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    final now = DateTime.now();
    await prefs.setString(_deactivateRequestedAtKey, now.toIso8601String());
    state = AsyncData(current.copyWith(deactivateRequestedAt: now));
  }

  Future<void> cancelDeactivateRequest() async {
    final current = state.value;
    if (current == null) return;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_deactivateRequestedAtKey);
    state = AsyncData(current.copyWith(clearDeactivateRequestedAt: true));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadFromServer);
  }
}

Map<NotificationType, bool> _mapNotificationPrefs(
  NotificationPreference? prefs,
) {
  if (prefs == null) {
    return {for (final type in NotificationType.values) type: true};
  }
  return {
    NotificationType.order: prefs.orderUpdates,
    NotificationType.payment: prefs.promotions,
    NotificationType.product: prefs.priceDropAlerts,
    NotificationType.system: prefs.vendorMessages,
  };
}
