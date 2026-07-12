import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/theme/app_fonts.dart';
import '../data/home_categories_config.dart';
import '../providers/home_room_provider.dart';
import '../theme/home_screen_tokens.dart';

/// Segmented control of room categories with a sliding white selector pill.
class HomeCategoryFilterChips extends ConsumerStatefulWidget {
  const HomeCategoryFilterChips({super.key});

  @override
  ConsumerState<HomeCategoryFilterChips> createState() =>
      _HomeCategoryFilterChipsState();
}

class _HomeCategoryFilterChipsState
    extends ConsumerState<HomeCategoryFilterChips> {
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final selectedId = ref.watch(selectedRoomProvider);
    final rooms = HomeCategoriesConfig.rooms;
    final selectedIndex = rooms
        .indexWhere((r) => r.id == selectedId)
        .clamp(0, rooms.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        const trackPadding = 4.0;
        final trackInner = totalWidth - trackPadding * 2;
        final tabWidth = trackInner / rooms.length;

        return Container(
          height: 48,
          padding: const EdgeInsets.all(trackPadding),
          decoration: BoxDecoration(
            color: HomeScreenTokens.chipsTrackBg,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                left: selectedIndex * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < rooms.length; i++)
                    Expanded(
                      child: _ChipTab(
                        label: rooms[i].name,
                        isSelected: i == selectedIndex,
                        isHovered: i == _hoveredIndex,
                        onHover: (hovered) => setState(
                          () => _hoveredIndex = hovered ? i : -1,
                        ),
                        onTap: () {
                          HapticService.light();
                          final room = rooms[i];
                          ref.read(selectedRoomProvider.notifier).state =
                              room.id;
                          context.push(
                            '/products?category=${Uri.encodeQueryComponent(room.name)}',
                          );
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChipTab extends StatefulWidget {
  const _ChipTab({
    required this.label,
    required this.isSelected,
    required this.isHovered,
    required this.onHover,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isHovered;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  @override
  State<_ChipTab> createState() => _ChipTabState();
}

class _ChipTabState extends State<_ChipTab> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isHovered = widget.isHovered;
    final showHoverTint = !isSelected && (isHovered || _pressed);

    return MouseRegion(
      onEnter: (_) => widget.onHover(true),
      onExit: (_) => widget.onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: showHoverTint
                  ? Colors.black.withValues(alpha: 0.03)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(40),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: AppFonts.dmSans(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? Colors.black87
                    : Color.lerp(
                        Colors.black54,
                        Colors.black87,
                        isHovered ? 0.4 : 0,
                      ),
                letterSpacing: -0.1,
              ),
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
