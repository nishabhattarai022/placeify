import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/services/haptic_service.dart';
import '../data/home_categories_config.dart';
import '../providers/home_room_provider.dart';

const _kActiveChipTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 14,
  height: 1.0,
  letterSpacing: -0.2,
);

/// Horizontal room quick-access: black pill (active) + outlined circles (inactive).
class HomeRoomChipRow extends ConsumerStatefulWidget {
  const HomeRoomChipRow({super.key});

  static const double chipSize = 52;
  static const double chipGap = 14;

  @override
  ConsumerState<HomeRoomChipRow> createState() => _HomeRoomChipRowState();
}

class _HomeRoomChipRowState extends ConsumerState<HomeRoomChipRow> {
  final _scrollController = ScrollController();
  int _scrollToken = 0;

  @override
  void dispose() {
    _scrollToken++;
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleEndScroll(int index) {
    if (index < HomeCategoriesConfig.quickBrowseRooms.length - 2) return;

    final token = ++_scrollToken;
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (!mounted || token != _scrollToken) return;
        if (!_scrollController.hasClients) return;

        final position = _scrollController.position;
        if (!position.hasPixels || !position.hasContentDimensions) return;

        final target = position.maxScrollExtent;
        if (target <= 0) return;

        _scrollController.jumpTo(target);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedRoomProvider);
    final rooms = HomeCategoriesConfig.quickBrowseRooms;

    return SizedBox(
      height: HomeRoomChipRow.chipSize,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 32),
        itemCount: rooms.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: HomeRoomChipRow.chipGap),
        itemBuilder: (context, index) {
          final room = rooms[index];
          final isSelected = room.id == selectedId;

          return _RoomChip(
            room: room,
            isSelected: isSelected,
            onTap: () async {
              await HapticService.selection();
              if (!mounted) return;
              ref.read(selectedRoomProvider.notifier).state = room.id;
              _scheduleEndScroll(index);
            },
          );
        },
      ),
    );
  }
}

class _RoomChip extends StatelessWidget {
  const _RoomChip({
    required this.room,
    required this.isSelected,
    required this.onTap,
  });

  final RoomCategory room;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _size = HomeRoomChipRow.chipSize;
  static const Color _borderColor = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    final chipBody = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      height: _size,
      constraints: const BoxConstraints(
        minWidth: _size,
        minHeight: _size,
        maxHeight: _size,
      ),
      padding: isSelected
          ? const EdgeInsets.symmetric(horizontal: 18)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(_size / 2),
        border: isSelected ? null : Border.all(color: _borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: isSelected
          ? _ActiveContent(room: room)
          : _InactiveContent(room: room),
    );

    final chip = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_size / 2),
        ),
        child: isSelected ? IntrinsicWidth(child: chipBody) : chipBody,
      ),
    );

    return isSelected
        ? chip
        : SizedBox(width: _size, height: _size, child: chip);
  }
}

class _ActiveContent extends StatelessWidget {
  const _ActiveContent({required this.room});

  final RoomCategory room;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoomIcon(room: room, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(
          room.name,
          maxLines: 1,
          style: _kActiveChipTextStyle.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _InactiveContent extends StatelessWidget {
  const _InactiveContent({required this.room});

  final RoomCategory room;

  @override
  Widget build(BuildContext context) {
    return _RoomIcon(room: room, color: Colors.black, size: 20);
  }
}

class _RoomIcon extends StatelessWidget {
  const _RoomIcon({
    required this.room,
    required this.color,
    required this.size,
  });

  final RoomCategory room;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (room.iconAsset != null) {
      return SvgPicture.asset(
        room.iconAsset!,
        width: size,
        height: size,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return Icon(room.icon, color: color, size: size);
  }
}
