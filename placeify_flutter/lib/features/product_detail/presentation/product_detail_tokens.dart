import 'package:flutter/material.dart';

/// Design tokens for the product detail screen (matches mockup).
abstract final class ProductDetailTokens {
  static const Color screenBg = Color(0xFFFFFFFF);
  static const Color circleButtonBg = Color(0xFFF7F5F1);
  static const Color thumbPillBg = Color(0xFFF5F2EC);
  static const Color thumbSelectedBg = Color(0xFFFFFFFF);
  static const Color thumbArrowBg = Color(0xFFF5F2EC);
  static const Color infoCardBg = Color(0xFFF6F3EE);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF7A7771);
  static const Color cartBarBg = Color(0xFF0E0E0E);
  static const Color cartBarIconChip = Color(0xFF1F1F1F);

  static const double heroPaddingH = 24;
  static const double heroPaddingTop = 0;
  static const double heroPaddingBottom = 8;
  static const double heroHeightFactor = 0.46;
  static const int maxGalleryThumbs = 8;

  static const double headerSize = 44;
  static const double headerHorizontalPadding = 20;
  static const double headerTopPadding = 8;
  static const double headerIconSize = 20;

  static const double thumbPillHorizontalPadding = 24;
  static const double thumbPillPaddingH = 10;
  static const double thumbPillPaddingV = 8;
  static const double thumbPillRadius = 999;
  static const double thumbSize = 40;
  static const double thumbSelectedHeight = 50;
  static const double thumbSelectedWidth = 60;
  static const double thumbSpacing = 4;
  static const double thumbArrowSize = 36;
  static const double thumbArrowGap = 10;

  static const double infoCardHorizontalPadding = 20;
  static const double infoCardRadius = 20;
  static const double infoCardPadding = 22;
  static const double infoCardTopGap = 20;

  static const double cartBarHorizontalPadding = 20;
  static const double cartBarBottomPadding = 20;
  static const double cartBarHeight = 64;
  static const double cartBarActionHeight = 56;
  static const double cartBarInnerPadding = 8;
  static const double cartBarActionInnerPadding = 10;
  static const double cartBarIconChipSize = 40;
  static const double cartBarActionIconChipSize = 30;
  static const double cartBarActionLeadingIconSize = 16;
  static const double cartBarActionArrowIconSize = 14;
  static const double cartBarTrailingArrowSize = 36;
  static const double cartBarGap = 12;
  static const double cartBarBottomSpacer = 110;
}
