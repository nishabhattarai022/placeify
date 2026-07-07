import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Visual and motion tokens for the AR room screen — aligned with Placeify palette.
abstract final class ArRoomUiTokens {
  // Motion
  static const Duration motionStandard = Duration(milliseconds: 320);
  static const Duration motionSlow = Duration(milliseconds: 520);
  static const Duration motionHint = Duration(milliseconds: 380);
  static const Duration scanPulse = Duration(milliseconds: 2200);
  static const Duration scanLine = Duration(milliseconds: 2800);
  static const Duration reticlePulse = Duration(milliseconds: 1600);
  static const Duration placementReveal = Duration(milliseconds: 950);
  static const Duration captureFlash = Duration(milliseconds: 175);

  static const Curve motionCurve = Curves.easeOutCubic;
  static const Curve motionEnterCurve = Curves.easeOutCubic;
  static const Curve motionExitCurve = Curves.easeInCubic;
  static const Curve placementSettleCurve = Curves.easeOutBack;

  // Shape
  static const double pillRadius = 999;
  static const double cardRadius = 20;
  static const double iconButtonSize = 44;
  static const double iconButtonRadius = 14;
  static const double screenPadding = 16;

  // Frosted surfaces (dark glass over camera feed)
  static const double blurSigma = 22;
  static const Color glassFill = Color(0x38FEFCF8);
  static const Color glassFillStrong = Color(0x52FEFCF8);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x1AFFFFFF);

  static const Color overlayTextPrimary = AppColors.warmWhite;
  static const Color overlayTextSecondary = Color(0xCCFEFCF8);
  static const Color overlayTextMuted = Color(0x99FEFCF8);

  static const Color accentGlow = AppColors.accent;
  static const Color scanSurfaceFill = Color(0x1FC17F3C);
  static const Color scanLineColor = Color(0x66C17F3C);

  static List<BoxShadow> softGlow({Color? color, double blur = 16}) => [
        BoxShadow(
          color: (color ?? accentGlow).withValues(alpha: 0.35),
          blurRadius: blur,
          spreadRadius: 0,
        ),
      ];
}
