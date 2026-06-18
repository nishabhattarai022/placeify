import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'widgets/profile_sub_hero.dart';

class ProfileSettingsScreen extends ConsumerWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Settings'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: const [
                Text(
                  'Account settings are managed from your profile and vendor dashboard.',
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 15,
                    color: AppColors.espresso,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
