import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_constants.dart';
import 'providers/profile_notifications_provider.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/shared/profile_submit_button.dart';
import 'widgets/shared/profile_toggle_row.dart';

class ProfileNotificationsScreen extends ConsumerStatefulWidget {
  const ProfileNotificationsScreen({super.key});

  @override
  ConsumerState<ProfileNotificationsScreen> createState() =>
      _ProfileNotificationsScreenState();
}

class _ProfileNotificationsScreenState
    extends ConsumerState<ProfileNotificationsScreen> {
  NotificationPreference? _draft;
  bool _saving = false;

  bool _valueFor(NotificationPreference prefs, String field) {
    return switch (field) {
      'orderUpdates' => prefs.orderUpdates,
      'refundStatus' => prefs.refundStatus,
      'arReminders' => prefs.arReminders,
      'priceDropAlerts' => prefs.priceDropAlerts,
      'vendorMessages' => prefs.vendorMessages,
      'promotions' => prefs.promotions,
      _ => false,
    };
  }

  NotificationPreference _copyWithField(
    NotificationPreference prefs,
    String field,
    bool value,
  ) {
    return switch (field) {
      'orderUpdates' => prefs.copyWith(orderUpdates: value),
      'refundStatus' => prefs.copyWith(refundStatus: value),
      'arReminders' => prefs.copyWith(arReminders: value),
      'priceDropAlerts' => prefs.copyWith(priceDropAlerts: value),
      'vendorMessages' => prefs.copyWith(vendorMessages: value),
      'promotions' => prefs.copyWith(promotions: value),
      _ => prefs,
    };
  }

  Future<void> _save() async {
    final draft = _draft;
    if (draft == null || _saving) return;

    setState(() => _saving = true);
    final error =
        await ref.read(profileNotificationsProvider.notifier).save(draft);
    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      PlaceifyToast.show(context, error);
      return;
    }
    PlaceifyToast.show(context, 'Preferences saved ✓');
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(profileNotificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Notifications'),
          Expanded(
            child: prefsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _NotificationsErrorState(
                onRetry: () =>
                    ref.read(profileNotificationsProvider.notifier).refresh(),
              ),
              data: (prefs) {
                _draft ??= prefs;
                final draft = _draft!;

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() => _draft = null);
                    await ref
                        .read(profileNotificationsProvider.notifier)
                        .refresh();
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      BottomNavTokens.scrollBottomPadding,
                    ),
                    children: [
                      for (final row in ProfileNotificationFields.rows)
                        ProfileToggleRow(
                          title: row.title,
                          subtitle: row.subtitle,
                          value: _valueFor(draft, row.field),
                          onChanged: (value) => setState(() {
                            _draft = _copyWithField(draft, row.field, value);
                          }),
                        ),
                      ProfileSubmitButton(
                        label: _saving ? 'Saving…' : 'Save Preferences',
                        onPressed: _save,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsErrorState extends StatelessWidget {
  const _NotificationsErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Could not load notification settings',
            style: TextStyle(color: AppColors.espresso),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
