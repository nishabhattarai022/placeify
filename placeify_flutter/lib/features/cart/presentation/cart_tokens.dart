import 'package:flutter/material.dart';

/// Design tokens for the My Cart screen (matches reference mockup).
abstract final class CartTokens {
  // ── Colors ──────────────────────────────────────────────────
  static const Color background = Color(0xFFF2F1EE);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textMuted = Color(0xFFB8B5AF);
  static const Color black = Color(0xFF111111);
  static const Color iconBackground = Color(0xFFFFFFFF);
  static const Color imageWell = Color(0xFFF5F3EF);
  static const Color divider = Color(0xFFE6E3DD);

  // Delete-mode (edit) pink strip — matches the reference's dusty-rose hue.
  static const Color deleteBg = Color(0xFFEFC9C3);
  static const Color deleteIcon = Color(0xFFB5564E);
  static const double deleteStripWidth = 64;

  // Summary frosted-glass (translucent so cards bleed through).
  static const Color summaryGlassTop = Color(0x80FFFFFF);
  static const Color summaryGlassBottom = Color(0xA6FFFFFF);
  static const Color summaryBorder = Color(0x40FFFFFF);
  static const Color summaryHighlight = Color(0xB3FFFFFF);
  static const double summaryBlurSigma = 30;

  // Quantity pill (soft cream container around +/qty/-).
  static const Color qtyPillBg = Color(0xFFF1EEEA);
  static const double qtyPillRadius = 18;
  static const double qtyPillWidth = 40;
  static const double qtyPillVerticalPadding = 12;

  // ── Spacing & sizing ──────────────────────────────────────
  static const double screenPadding = 16;
  static const double cardRadius = 22;
  static const double cardImageRadius = 16;
  static const double cardImageSize = 84;
  static const double cardVerticalPadding = 10;
  static const double cardHorizontalPadding = 10;
  static const double cardContentRightPadding = 18;
  static const double cardSpacing = 12;
  static const double qtyColumnWidth = 32;
  static const double qtyTapHeight = 26;
  static const double deleteButtonSize = 50;
  static const double deleteButtonRadius = 14;
  static const double headerIconSize = 42;
  static const double summaryTopRadius = 28;
  static const double checkoutRadius = 999;
  static const double checkoutHeight = 60;
  static const double summaryOuterBottomPadding = 24;
  static const double summaryInnerPadding = 22;
  static const double summaryOverlayHeight = 280;
  static const double summaryScrollUnderlap = 12;

  // ── Shadows ─────────────────────────────────────────────────
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 14,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> headerIconShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> summaryShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 28,
      offset: Offset(0, -6),
    ),
  ];

  static const List<BoxShadow> checkoutShadow = [
    BoxShadow(
      color: Color(0x33111111),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  // ── Typography ─────────────────────────────
  static const TextStyle headerTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle productName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    letterSpacing: -0.1,
  );

  static const TextStyle productPrice = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle rowLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle rowValue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.1,
  );

  static const TextStyle totalLabel = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle totalValue = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: -0.4,
  );

  static const TextStyle checkoutText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: -0.2,
  );

  static const TextStyle qtyValue = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle qtySymbol = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1,
  );
}
