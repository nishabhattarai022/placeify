import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../ar/data/room_snapshot_store.dart';
import '../../data/profile_mock_data.dart';
import '../providers/profile_dashboard_provider.dart';

class ProfileStatsStrip extends ConsumerStatefulWidget {
  const ProfileStatsStrip({
    required this.onStatTap,
    super.key,
  });

  final void Function(int index) onStatTap;

  @override
  ConsumerState<ProfileStatsStrip> createState() => _ProfileStatsStripState();
}

class _ProfileStatsStripState extends ConsumerState<ProfileStatsStrip> {
  int? _savedRoomCount;

  @override
  void initState() {
    super.initState();
    _loadSavedRoomCount();
  }

  Future<void> _loadSavedRoomCount() async {
    final count = (await RoomSnapshotStore().list()).length;
    if (!mounted) return;
    setState(() => _savedRoomCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(profileDashboardProvider).value;
    final stats = [
      ProfileStat(
        value: '${dashboard?.orderCount ?? 0}',
        label: 'Orders',
      ),
      ProfileStat(
        value: '${dashboard?.wishlistCount ?? 0}',
        label: 'Wishlist',
      ),
      ProfileStat(
        value: _savedRoomCount == null ? '—' : '$_savedRoomCount',
        label: 'Saved Rooms',
      ),
      ProfileStat(
        value: '${dashboard?.refundCount ?? 0}',
        label: 'Refunds',
      ),
    ];

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
                      widget.onStatTap(i);
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
