import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTypography {
  static const TextStyle heroHeadline = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 50,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.warmWhite,
    height: 1.0,
    letterSpacing: -0.5,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: Colors.black,
  );

  static const TextStyle bannerHeadline = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 28,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: AppColors.warmWhite,
    height: 1.1,
  );

  static const TextStyle arProductTitle = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 30,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.warmWhite,
  );

  static const TextStyle arProductSubtitle = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 26,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.italic,
    color: Color(0xADFFFFFF),
  );

  static const TextStyle logoWordmark = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    color: AppColors.espresso,
    letterSpacing: -0.5,
  );

  static const TextStyle metricValueLarge = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 34,
    fontWeight: FontWeight.w600,
    color: AppColors.warmWhite,
    height: 1.0,
  );

  static const TextStyle metricValueMedium = TextStyle(
    fontFamily: 'Fraunces',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.black,
    height: 1.0,
  );

  static const TextStyle ctaLabel = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle ctaLabelSecondary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0xD1FFFFFF),
  );

  static const TextStyle productName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle brandName = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.9,
  );

  static const TextStyle skuCode = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle priceFullPrice = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.espresso,
  );

  static const TextStyle priceSale = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.rust,
  );

  static const TextStyle priceStrikethrough = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppColors.textMuted,
  );

  static const TextStyle badgeLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.accentLight,
    letterSpacing: 0.99,
  );

  static const TextStyle arBadge = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w700,
    color: AppColors.warmWhite,
    letterSpacing: 0.9,
  );

  static const TextStyle bodyLight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: Color(0x85FFFFFF),
    height: 1.65,
  );

  static const TextStyle toastText = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.warmWhite,
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle seeAll = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
  );

  static const TextStyle statusPill = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle metricLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.88,
  );

  static const TextStyle newCollectionTag = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.accentLight,
    letterSpacing: 1.0,
  );

  static const TextStyle trendText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle searchText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle vendorGreeting = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}
