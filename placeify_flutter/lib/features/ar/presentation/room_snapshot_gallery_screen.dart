import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../profile/presentation/widgets/profile_sub_hero.dart';
import '../data/room_snapshot_store.dart';

class RoomSnapshotGalleryScreen extends StatefulWidget {
  const RoomSnapshotGalleryScreen({super.key});

  @override
  State<RoomSnapshotGalleryScreen> createState() =>
      _RoomSnapshotGalleryScreenState();
}

class _RoomSnapshotGalleryScreenState extends State<RoomSnapshotGalleryScreen> {
  final _store = RoomSnapshotStore();

  List<RoomSnapshot> _snapshots = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSnapshots();
  }

  Future<void> _loadSnapshots() async {
    setState(() => _loading = true);
    final snapshots = await _store.list();
    if (!mounted) return;
    setState(() {
      _snapshots = snapshots;
      _loading = false;
    });
  }

  Future<void> _confirmDelete(RoomSnapshot snapshot) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete room shot?',
          style: AppFonts.dmSans(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'This removes the saved snapshot from your device.',
          style: AppFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppFonts.dmSans(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: AppFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: AppColors.rust,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    HapticService.medium();
    await _store.delete(snapshot);
    await _loadSnapshots();
  }

  void _openViewer(RoomSnapshot snapshot) {
    HapticService.light();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _RoomSnapshotViewerScreen(
          snapshot: snapshot,
          onDelete: () => _confirmDelete(snapshot),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countLabel =
        _loading ? '…' : '${_snapshots.length} saved shot${_snapshots.length == 1 ? '' : 's'}';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(title: 'Room Shots · $countLabel'),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _snapshots.isEmpty
                    ? _EmptyState(onRefresh: _loadSnapshots)
                    : RefreshIndicator(
                        onRefresh: _loadSnapshots,
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            18,
                            20,
                            18,
                            BottomNavTokens.scrollBottomPadding,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: _snapshots.length,
                          itemBuilder: (context, index) {
                            final snapshot = _snapshots[index];
                            return _SnapshotThumbnail(
                              snapshot: snapshot,
                              onTap: () => _openViewer(snapshot),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_camera_outlined,
              size: 56,
              color: AppColors.textMuted.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No room shots yet',
              style: AppFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Place furniture in AR and tap the camera button to save a snapshot here.',
              textAlign: TextAlign.center,
              style: AppFonts.dmSans(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRefresh,
              child: Text(
                'Refresh',
                style: AppFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SnapshotThumbnail extends StatelessWidget {
  const _SnapshotThumbnail({
    required this.snapshot,
    required this.onTap,
  });

  final RoomSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.creamDark),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F2C1810),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Hero(
                  tag: snapshot.filePath,
                  child: Image.file(
                    File(snapshot.filePath),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => ColoredBox(
                      color: AppColors.creamDark,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.textMuted.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatCapturedAt(snapshot.capturedAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.dmSans(
                      fontSize: 11,
                      color: AppColors.textMuted,
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

class _RoomSnapshotViewerScreen extends StatelessWidget {
  const _RoomSnapshotViewerScreen({
    required this.snapshot,
    required this.onDelete,
  });

  final RoomSnapshot snapshot;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          snapshot.productName,
          style: AppFonts.dmSans(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Delete',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: snapshot.filePath,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.file(
                  File(snapshot.filePath),
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Text(
                _formatCapturedAt(snapshot.capturedAt),
                textAlign: TextAlign.center,
                style: AppFonts.dmSans(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCapturedAt(DateTime capturedAt) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final hour = capturedAt.hour % 12 == 0 ? 12 : capturedAt.hour % 12;
  final minute = capturedAt.minute.toString().padLeft(2, '0');
  final period = capturedAt.hour >= 12 ? 'PM' : 'AM';
  return '${months[capturedAt.month - 1]} ${capturedAt.day}, ${capturedAt.year} · $hour:$minute $period';
}
