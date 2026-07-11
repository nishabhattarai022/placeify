import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_mock_data.dart';
import '../domain/constants/notification_strings.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/shared/profile_action_button.dart';
import 'widgets/shared/profile_toggle_row.dart';

class ProfileNotificationsScreen extends StatefulWidget {
  const ProfileNotificationsScreen({super.key});

  @override
  State<ProfileNotificationsScreen> createState() =>
      _ProfileNotificationsScreenState();
}

class _ProfileNotificationsScreenState
    extends State<ProfileNotificationsScreen> {
  late List<bool> _prefs;

  @override
  void initState() {
    super.initState();
    _prefs =
        ProfileMockData.notificationPrefs.map((pref) => pref.enabled).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final prefs = ProfileMockData.notificationPrefs;
    final enabledCount = _prefs.where((enabled) => enabled).length;

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
              count: enabledCount,
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
                  for (var i = 0; i < prefs.length; i++)
                    ProfileToggleRow(
                      title: prefs[i].title,
                      subtitle: prefs[i].subtitle,
                      value: _prefs[i],
                      onChanged: (value) => setState(() => _prefs[i] = value),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ProfileActionButton(
                      label: NotificationStrings.savePreferences,
                      onTap: () => PlaceifyToast.show(
                        context,
                        NotificationStrings.savedToast,
                      ),
                    ),
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
