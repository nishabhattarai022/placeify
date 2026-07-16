import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_constants.dart';
import '../data/profile_notification_mapper.dart';
import '../domain/constants/notification_strings.dart';
import 'providers/profile_in_app_notifications_provider.dart';
import 'providers/profile_notifications_provider.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/profile_notifications_inbox_section.dart';
import 'widgets/shared/profile_action_button.dart';
import 'widgets/shared/profile_toggle_row.dart';

class ProfileNotificationsScreen extends ConsumerWidget {
  const ProfileNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final prefsAsync = ref.watch(profileNotificationsProvider);
    final inboxUnread = ref
            .watch(profileInAppNotificationsProvider)
            .value
            ?.unreadCount ??
        0;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileListScreenHeader(
              title: NotificationStrings.title,
              subtitle: NotificationStrings.italicLine,
              count: inboxUnread,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  12,
                  AppSpacing.screenPadding,
                  BottomNavTokens.scrollBottomPadding + bottomInset,
                ),
                children: [
                  const ProfileNotificationsInboxSection(),
                  prefsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        error.toString(),
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    data: (prefs) {
                      final rows = ProfileNotificationFields.rows;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final row in rows)
                            ProfileToggleRow(
                              title: row.title,
                              subtitle: row.subtitle,
                              value: ProfileNotificationMapper.valueFor(
                                prefs,
                                row.field,
                              ),
                              onChanged: (value) {
                                ref
                                    .read(
                                      profileNotificationsProvider.notifier,
                                    )
                                    .save(
                                      ProfileNotificationMapper.apply(
                                        prefs,
                                        row.field,
                                        value,
                                      ),
                                    );
                              },
                            ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ProfileActionButton(
                              label: NotificationStrings.savePreferences,
                              onTap: () async {
                                final message = await ref
                                    .read(
                                      profileNotificationsProvider.notifier,
                                    )
                                    .save(prefs);
                                if (!context.mounted) return;
                                PlaceifyToast.show(
                                  context,
                                  message ?? NotificationStrings.savedToast,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
