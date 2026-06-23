import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_mock_data.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/shared/profile_submit_button.dart';
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
    _prefs = ProfileMockData.notificationPrefs
        .map((p) => p.enabled)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Notifications'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: [
                for (var i = 0; i < ProfileMockData.notificationPrefs.length; i++)
                  ProfileToggleRow(
                    title: ProfileMockData.notificationPrefs[i].title,
                    subtitle: ProfileMockData.notificationPrefs[i].subtitle,
                    value: _prefs[i],
                    onChanged: (v) => setState(() => _prefs[i] = v),
                  ),
                ProfileSubmitButton(
                  label: 'Save Preferences',
                  onPressed: () =>
                      PlaceifyToast.show(context, 'Preferences saved ✓'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
