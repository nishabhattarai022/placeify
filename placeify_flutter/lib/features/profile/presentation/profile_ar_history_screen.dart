import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../data/profile_ar_mapper.dart';
import 'providers/profile_dashboard_provider.dart';
import 'widgets/ar/ar_history_card.dart';
import 'widgets/profile_sub_hero.dart';

class ProfileArHistoryScreen extends ConsumerStatefulWidget {
  const ProfileArHistoryScreen({super.key});

  @override
  ConsumerState<ProfileArHistoryScreen> createState() =>
      _ProfileArHistoryScreenState();
}

class _ProfileArHistoryScreenState
    extends ConsumerState<ProfileArHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Provider is keepAlive — refresh on open so new AR sessions show up.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.invalidate(profileArSessionsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(profileArSessionsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(
            title: sessionsAsync.maybeWhen(
              data: (sessions) =>
                  ProfileArMapper.formatHeroCount(sessions.length),
              orElse: () => 'AR History',
            ),
          ),
          Expanded(
            child: sessionsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Could not load your AR history.',
                        style: TextStyle(
                          color: AppColors.espresso.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () =>
                            ref.invalidate(profileArSessionsProvider),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (summaries) {
                if (summaries.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Try a product in AR to see it here.',
                        style: TextStyle(
                          color: AppColors.espresso.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    20,
                    18,
                    BottomNavTokens.scrollBottomPadding,
                  ),
                  children: [
                    for (final summary in summaries)
                      ArHistoryCard(
                        session: ProfileArMapper.fromSummary(summary),
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
