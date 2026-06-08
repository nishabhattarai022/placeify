import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

/// Visual and motion tokens for the cinematic intro splash.
abstract final class CinematicSplashTokens {
  static const Color background = AppColors.onboardingBg;
  static const Color foreground = AppColors.onboardingTextHead;
  static const Color foregroundMuted = AppColors.onboardingTextBody;
  static const Color accent = AppColors.onboardingAmber;
  static const Color accentGlow = AppColors.onboardingTeal;

  static const Color cardGradientStart = Color(0xFF162C6D);
  static const Color cardGradientEnd = Color(0xFF0A101D);
  static const Color phoneBezel = Color(0xFF111111);
  static const Color phoneScreen = Color(0xFF050914);
  static const Color phoneBorder = Color(0xFF52525B);

  static const String heroLine1 = 'See it in your space,';
  static const String heroLine2 = "before it's in your home.";
  static const String brandSubline = 'AR furniture for real rooms';

  static const Duration introDuration = Duration(milliseconds: 3600);
  static const Duration splashHoldDuration = Duration(milliseconds: 4000);

  static const double cardRadius = 40;
  static const double phoneWidth = 232;
  static const double phoneHeight = 468;

  static const Curve heroEase = Curves.easeOutCubic;
  static const Curve stageEase = Curves.easeInOutCubic;
  static const Curve deviceEase = Curves.easeOutBack;
}
