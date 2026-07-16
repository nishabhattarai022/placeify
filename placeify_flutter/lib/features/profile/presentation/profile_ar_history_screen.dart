import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../data/profile_ar_mapper.dart';
import 'providers/profile_dashboard_provider.dart';
import 'widgets/ar/ar_history_card.dart';
import 'widgets/profile_sub_hero.dart';

class ProfileArHistoryScreen extends ConsumerWidget {
  const ProfileArHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(profileArSessionsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: sessionsAsync.when(
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
        data: (sessions) {
          final mapped = sessions.map(ProfileArMapper.fromSummary).toList();
          return Column(
            children: [
              ProfileSubHero(
                title: 'AR History',
                subtitle: mapped.isEmpty
                    ? 'No sessions yet'
                    : mapped.length == 1
                        ? '1 try'
                        : '${mapped.length} tries',
              ),
              Expanded(
                child: mapped.isEmpty
                    ? const Center(
                        child: Text(
                          'No AR sessions yet.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          20,
                          18,
                          BottomNavTokens.scrollBottomPadding,
                        ),
                        children: [
                          for (final session in mapped)
                            ArHistoryCard(session: session),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
