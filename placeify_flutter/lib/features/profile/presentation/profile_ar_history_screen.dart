import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../data/profile_mock_data.dart';
import 'widgets/ar/ar_history_card.dart';
import 'widgets/profile_sub_hero.dart';

class ProfileArHistoryScreen extends StatelessWidget {
  const ProfileArHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(
            title: 'AR History',
            subtitle: '24 tries',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: [
                for (final session in ProfileMockData.arSessions)
                  ArHistoryCard(session: session),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
