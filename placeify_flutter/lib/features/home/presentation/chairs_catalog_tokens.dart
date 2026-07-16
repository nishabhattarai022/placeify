import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Design tokens for the chairs catalog (editorial magazine layout).
abstract final class ChairsCatalogTokens {
  static const int leftFlex = 55;
  static const int rightFlex = 45;
  static const double columnGap = 16;
  static const double screenHorizontalPadding = 20;

  static const double subtitleLeftIndent = 10;
  static const double headerToGridGap = 20;
  static const double filterButtonSize = 48;
  static const double filterButtonGap = 12;

  static const double wideCardRadius = 24;
  static const double compactCardRadius = 20;
  static const double wideCardHeightPrimary = 268;
  static const double wideCardHeightSecondary = 248;
  static const double compactCardHeight = 248;

  static const double wideImageMinHeight = 140;
  static const double catalogBottomBarHeight = 60;
  static const double scrollBottomInset = 88;

  static const Color imageWell = Colors.white;
  static const Color filterBorder = Color(0xFFE0E0E0);
  static const Color salePriceColor = Color(0xFFD32F2F);
  static const Color skuMuted = Color(0xFF9E9E9E);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F2C1810),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 42,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.textPrimary,
    letterSpacing: 1,
    height: 1.0,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: skuMuted,
    height: 1.5,
  );

  static const TextStyle wideNameStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  static const TextStyle wideSkuStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: skuMuted,
  );

  static const TextStyle compactNameStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
  );
}
