import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../home/domain/models/product.dart';
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
    required this.dimensions,
    required this.scaleMultiplier,
    required this.minMultiplier,
    required this.maxMultiplier,
    required this.onScaleChanged,
    super.key,
  });

  final ProductDimensions dimensions;
  final double scaleMultiplier;
  final double minMultiplier;
  final double maxMultiplier;
  final ValueChanged<double> onScaleChanged;

  @override
  Widget build(BuildContext context) {
    final percentLabel = '${(scaleMultiplier * 100).round()}%';
    final widthCm = dimensions.widthCm * scaleMultiplier;
    final depthCm = dimensions.depthCm * scaleMultiplier;
    final heightCm = dimensions.heightCm * scaleMultiplier;
    final scaledDimensions =
        'W ${_formatCm(widthCm)} × D ${_formatCm(depthCm)} × H ${_formatCm(heightCm)} cm';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
                      inactiveTrackColor: AppColors.warmWhite.withValues(
                        alpha: 0.16,
                      ),
                      thumbColor: AppColors.warmWhite,
                      overlayColor: AppColors.accent.withValues(alpha: 0.12),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
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
                    borderRadius: BorderRadius.circular(
                      ArRoomUiTokens.pillRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
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
            const SizedBox(height: 4),
            Semantics(
              label:
                  'Approximate resized dimensions: width ${_formatCm(widthCm)}, depth ${_formatCm(depthCm)}, height ${_formatCm(heightCm)} centimeters',
              child: Text(
                'Approx. size · $scaledDimensions',
                textAlign: TextAlign.center,
                style: AppFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ArRoomUiTokens.overlayTextSecondary,
                  letterSpacing: -0.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCm(double value) {
    final rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.05) return rounded.toInt().toString();
    return value.toStringAsFixed(1);
  }
}

/// Frosted save-room-shot control (camera icon + label).
///
/// Use [compact] when sharing a row with the product carousel (no outer
/// padding, fixed 56px height to match the carousel).
class ArSaveRoomShotBar extends StatelessWidget {
  const ArSaveRoomShotBar({
    required this.onCapture,
    this.enabled = true,
    this.compact = false,
    super.key,
  });

  final Future<void> Function() onCapture;
  final bool enabled;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bar = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? () => unawaited(onCapture()) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: SizedBox(
          height: compact ? 56 : null,
          width: double.infinity,
          child: ArFrostedSurface(
            strong: true,
            borderRadius: compact
                ? BorderRadius.circular(28)
                : const BorderRadius.all(
                    Radius.circular(ArRoomUiTokens.cardRadius),
                  ),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16,
              vertical: compact ? 0 : 12,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_rounded,
                    size: compact ? 18 : 20,
                    color: ArRoomUiTokens.overlayTextPrimary,
                  ),
                  SizedBox(width: compact ? 6 : 10),
                  Flexible(
                    child: Text(
                      enabled
                          ? (compact ? 'Save' : 'Save room shot')
                          : (compact ? 'Saving…' : 'Saving room shot…'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.dmSans(
                        fontSize: compact ? 13 : 14,
                        fontWeight: FontWeight.w600,
                        color: ArRoomUiTokens.overlayTextPrimary,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (compact) return bar;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ArRoomUiTokens.screenPadding,
        0,
        ArRoomUiTokens.screenPadding,
        8,
      ),
      child: bar,
    );
  }
}
