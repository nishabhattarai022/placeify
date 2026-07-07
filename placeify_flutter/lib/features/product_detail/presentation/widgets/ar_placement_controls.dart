import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../ar_room_ui_tokens.dart';
import 'ar_frosted_surface.dart';

/// Persistent Done action — pill with an accent check badge.
class ArDoneButton extends StatelessWidget {
  const ArDoneButton({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDone,
        borderRadius: BorderRadius.circular(ArRoomUiTokens.pillRadius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.warmWhite.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(ArRoomUiTokens.pillRadius),
            border: Border.all(color: ArRoomUiTokens.glassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.14),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: AppColors.warmWhite,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Done',
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Scale slider — thin track with a floating accent percent badge.
class ArScaleControlBar extends StatelessWidget {
  const ArScaleControlBar({
    required this.scaleMultiplier,
    required this.minMultiplier,
    required this.maxMultiplier,
    required this.onScaleChanged,
    super.key,
  });

  final double scaleMultiplier;
  final double minMultiplier;
  final double maxMultiplier;
  final ValueChanged<double> onScaleChanged;

  @override
  Widget build(BuildContext context) {
    final percentLabel = '${(scaleMultiplier * 100).round()}%';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ArRoomUiTokens.screenPadding,
        0,
        ArRoomUiTokens.screenPadding,
        8,
      ),
      child: ArFrostedSurface(
        strong: true,
        padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
        child: Row(
          children: [
            Icon(
              Icons.straighten_rounded,
              size: 16,
              color: ArRoomUiTokens.overlayTextSecondary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 1.5,
                  activeTrackColor: AppColors.accent.withValues(alpha: 0.9),
                  inactiveTrackColor:
                      AppColors.warmWhite.withValues(alpha: 0.16),
                  thumbColor: AppColors.warmWhite,
                  overlayColor: AppColors.accent.withValues(alpha: 0.12),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  value: scaleMultiplier,
                  min: minMultiplier,
                  max: maxMultiplier,
                  divisions: 15,
                  onChanged: onScaleChanged,
                ),
              ),
            ),
            const SizedBox(width: 10),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(ArRoomUiTokens.pillRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  percentLabel,
                  style: AppFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warmWhite,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Always-visible save action at the bottom of the AR screen.
///
/// Placed here (not top-right) because Android full-screen [AndroidView]
/// platform views often swallow touches over the upper overlay region.
class ArSaveRoomShotBar extends StatelessWidget {
  const ArSaveRoomShotBar({
    required this.onCapture,
    this.enabled = true,
    super.key,
  });

  final Future<void> Function() onCapture;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ArRoomUiTokens.screenPadding,
        0,
        ArRoomUiTokens.screenPadding,
        8,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => unawaited(onCapture()) : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.5,
          child: ArFrostedSurface(
            strong: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: 20,
                  color: ArRoomUiTokens.overlayTextPrimary,
                ),
                const SizedBox(width: 10),
                Text(
                  enabled ? 'Save room shot' : 'Saving room shot…',
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ArRoomUiTokens.overlayTextPrimary,
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reset and secondary actions — auto-hide when idle.
class ArEditingActionsBar extends StatelessWidget {
  const ArEditingActionsBar({
    required this.visible,
    required this.onReset,
    super.key,
  });

  final bool visible;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: ArRoomUiTokens.motionStandard,
      curve: visible ? ArRoomUiTokens.motionEnterCurve : ArRoomUiTokens.motionExitCurve,
      offset: visible ? Offset.zero : const Offset(0, 0.25),
      child: AnimatedOpacity(
        duration: ArRoomUiTokens.motionStandard,
        curve: visible ? ArRoomUiTokens.motionEnterCurve : ArRoomUiTokens.motionExitCurve,
        opacity: visible ? 1 : 0,
        child: IgnorePointer(
          ignoring: !visible,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              ArRoomUiTokens.screenPadding,
              0,
              ArRoomUiTokens.screenPadding,
              4,
            ),
            child: ArFrostedSurface(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: _ToolbarAction(
                icon: Icons.restart_alt_rounded,
                label: 'Reset',
                onTap: onReset,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarAction extends StatelessWidget {
  const _ToolbarAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: ArRoomUiTokens.overlayTextPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppFonts.dmSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: ArRoomUiTokens.overlayTextSecondary,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: content,
      ),
    );
  }
}
