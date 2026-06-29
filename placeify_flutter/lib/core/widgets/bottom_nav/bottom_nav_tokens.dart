import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';

/// Dimensions and colors for the consumer/vendor/admin bottom navigation bars.
abstract final class BottomNavTokens {
  static const double horizontalPadding = 24;
  static const double bottomPadding = 16;

  static const double navBarHeight = 72;
  static const double pillHeight = 56;
  static const double pillRadius = 40;
  static const double pillHorizontalPadding = 6;
  static const double pillVerticalPadding = 6;
  static const double navItemGap = 6;

  static const double homeChipHeight = 44;
  static const double homeChipHorizontalPadding = 16;
  static const double iconCircleSize = 44;
  static const double iconSize = 20;

  static const Color pillColor = Color(0xFF0E0E0E);
  static const Color iconCircleColor = Color(0xFF222222);
  static const Color homeChipFill = Colors.white;
  static const Color homeChipForeground = Colors.black;

  static const Color pillIconActive = Colors.white;
  static const Color pillIconInactive = Color(0xFFE6E6E6);

  static const Color vendorLabelInactive = Color(0x61FFFFFF);
  static const Color vendorLabelActive = Color(0xD1FFFFFF);

  static const double iconSizeVendor = 22;
  static const double vendorLabelSize = 10;

  static const double scrollBottomPadding = 100;

  // Admin pill — navy slate palette (distinct from vendor forest green).
  static const Color adminPillColor = AppColors.adminSlate;
  static const Color adminIconActive = AppColors.warmWhite;
  static const Color adminIconInactive = Color(0x99FEFCF8);
  static const Color adminLabelActive = Color(0xD1FEFCF8);
  static const Color adminLabelInactive = Color(0x61FEFCF8);
}
