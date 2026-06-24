import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../data/profile_ar_session_mapper.dart';
import 'providers/profile_dashboard_provider.dart';
import 'widgets/ar/ar_history_card.dart';
import 'widgets/profile_sub_hero.dart';

class ProfileArHistoryScreen extends ConsumerWidget {
  const ProfileArHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(profileArSessionsProvider);
    final tryCount = sessionsAsync.maybeWhen(
      data: (sessions) => sessions.length,
      orElse: () => 0,
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(title: 'AR History · $tryCount tries'),
          Expanded(
            child: sessionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const _ArHistoryEmpty(),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const _ArHistoryEmpty();
                }

                final cards = [
                  for (final session in sessions)
                    ArHistoryCard(
                      session: ProfileArSessionMapper.fromSummary(session),
                    ),
                ];

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    20,
                    18,
                    BottomNavTokens.scrollBottomPadding,
                  ),
                  children: cards,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArHistoryEmpty extends StatelessWidget {
  const _ArHistoryEmpty();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No AR sessions yet.\nTry a product in AR from the home or product screen.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
