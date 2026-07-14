import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';

abstract final class PlaceifyTheme {
  static ThemeData light() {
    final textTheme = GoogleFonts.dmSansTextTheme();
    final fontFamily = GoogleFonts.dmSans().fontFamily;

    final dialogTitleStyle = GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
    final dialogBodyStyle = GoogleFonts.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textMuted,
      height: 1.35,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: AppColors.cream,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      colorScheme: ColorScheme.light(
        primary: AppColors.accent,
        onPrimary: AppColors.warmWhite,
        secondary: AppColors.espresso,
        onSecondary: AppColors.warmWhite,
        surface: AppColors.warmWhite,
        onSurface: AppColors.textPrimary,
        error: AppColors.rust,
        onError: AppColors.warmWhite,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.warmWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
        titleTextStyle: dialogTitleStyle,
        contentTextStyle: dialogBodyStyle,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.warmWhite,
        modalBarrierColor: Colors.black.withValues(alpha: 0.32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: AppRadii.rLg),
        ),
        dragHandleColor: AppColors.creamDark,
        showDragHandle: true,
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbVisibility: WidgetStatePropertyAll(false),
      ),
    );
  }
}
