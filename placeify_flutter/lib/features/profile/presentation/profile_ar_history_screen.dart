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
      body: Column(
        children: [
          sessionsAsync.when(
            data: (sessions) => ProfileSubHero(
              title: ProfileArMapper.formatHeroCount(sessions.length),
            ),
            loading: () => const ProfileSubHero(title: 'AR History'),
            error: (_, __) => const ProfileSubHero(title: 'AR History'),
          ),
          Expanded(
            child: sessionsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _ArErrorState(
                onRetry: () =>
                    ref.read(profileArSessionsProvider.notifier).refresh(),
              ),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const _ArEmptyState();
                }

                final mapped = [
                  for (final session in sessions)
                    ProfileArMapper.fromSummary(session),
                ];

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(profileArSessionsProvider.notifier).refresh(),
                  child: ListView(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ArEmptyState extends StatelessWidget {
  const _ArEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No AR sessions yet.\nTry a product in your room from the product page.',
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

class _ArErrorState extends StatelessWidget {
  const _ArErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Could not load AR history',
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
