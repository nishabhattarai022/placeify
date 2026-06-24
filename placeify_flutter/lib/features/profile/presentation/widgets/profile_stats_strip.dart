import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/haptic_service.dart';
import '../../data/profile_dashboard_mapper.dart';
import '../../data/profile_mock_data.dart';
import '../providers/profile_dashboard_provider.dart';

class ProfileStatsStrip extends ConsumerWidget {
  const ProfileStatsStrip({
    required this.onStatTap,
    super.key,
  });

  final void Function(int index) onStatTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(profileDashboardProvider);
    final stats = dashboardAsync.maybeWhen(
      data: (dashboard) => dashboard != null
          ? ProfileDashboardMapper.stats(dashboard)
          : ProfileDashboardMapper.emptyStats,
      orElse: () => ProfileDashboardMapper.emptyStats,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0)
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                Expanded(
                  child: _StatCell(
                    stat: stats[i],
                    onTap: () {
                      HapticService.light();
                      onStatTap(i);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.stat, required this.onTap});

  final ProfileStat stat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(
            children: [
              Text(
                stat.value,
                style: const TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
