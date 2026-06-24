import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_constants.dart';
import '../data/profile_notification_mapper.dart';
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

  void _syncDraft(NotificationPreference prefs) {
    _draft ??= prefs;
  }

  Future<void> _save() async {
    final draft = _draft;
    if (draft == null) return;

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
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ),
              data: (prefs) {
                _syncDraft(prefs);
                final draft = _draft ?? prefs;

                return ListView(
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
                        value: ProfileNotificationMapper.valueFor(
                          draft,
                          row.field,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _draft = ProfileNotificationMapper.apply(
                              draft,
                              row.field,
                              value,
                            );
                          });
                        },
                      ),
                    ProfileSubmitButton(
                      label: _saving ? 'Saving…' : 'Save Preferences',
                      onPressed: () {
                        if (_saving) return;
                        _save();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
