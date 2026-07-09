import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';

/// Visual tokens for the home screen layout.
abstract final class HomeScreenTokens {
  static const Color homeBg = Color(0xFFEFE8DC);
  static const Color cardBg = Color(0xFFFFFBF2);
  static const Color cardBgHover = Color(0xFFFFFFFF);
  static const Color chipsTrackBg = Color(0xFFE6DECD);

  /// Vertical space reserved for the product title (always two lines so
  /// every card in a row ends up the same height regardless of name length).
  static const double productTitleHeight = 48;

  static const double screenPadding = 20;
  static const double sectionSpacing = 20;

  static const double heroHeight = 480;
  static const double heroFadeHeight = 110;
  static const double heroTitleTopGap = 12;
  static const double heroDiscoverAlign = 0.92;

  /// Approved-vendor shortcut on the explore hero (top-left).
  static const double vendorDashboardButtonSize = 40;
  static const double vendorDashboardIconSize = 20;

  static const double cardRadius = 22;
  static const double cardPadding = 10;
  static const double cardImageHeight = 178;
  static const double cardImageRadius = 18;
  static const double productGap = 14;

  // Cart-tag cutout (bottom-right of each product card).
  static const double cartCornerOuter = 70;
  static const double cartCornerInnerRadius = 22;
  static const double cartButtonSize = 56;
  static const double cartButtonRadius = 16;
  static const double cartButtonCornerInset = 6;

  static const String heroAsset = 'assets/images/home/explore_hero.jpg';
  static const String heroFallbackAsset =
      'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg';

  static TextStyle exploreTitle() => AppFonts.cormorantGaramond(
        fontSize: 64,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        color: Colors.black87,
        letterSpacing: -1.0,
        height: 1.0,
      );

  static TextStyle exploreSubtitle() => AppFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: Colors.black54,
        height: 1.4,
        letterSpacing: -0.1,
      );

  static TextStyle sectionTitle() => AppFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        letterSpacing: -0.3,
      );

  static TextStyle productName() => AppFonts.cormorantGaramond(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
        height: 1.15,
        letterSpacing: -0.2,
      );

  static TextStyle productPrice() => AppFonts.dmSans(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
        letterSpacing: -0.4,
      );

  static TextStyle discoverCtaLabel() => AppFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        letterSpacing: -0.15,
      );
}
