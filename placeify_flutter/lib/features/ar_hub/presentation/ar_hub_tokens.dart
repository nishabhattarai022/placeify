import 'package:flutter/material.dart';

/// Visual tokens for the AR-powered hub (white minimal reference UI).
abstract final class ArHubTokens {
  static const Color background = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color ctaBlack = Color(0xFF111111);
  static const Color border = Color(0x14000000);

  static const double screenPadding = 24;
  static const double headerButtonSize = 40;
  static const double headerButtonRadius = 12;
  static const double heroTopSpacing = 28;
  static const double ctaHorizontalPadding = 32;
  static const double ctaHeight = 48;
  static const double featureTagRadius = 20;

  static const String chairAsset = 'assets/images/ar/ar_feature_chair.png';
  static const String defaultArProductId = 'p4';

  static const String appBarTitle = 'AR-powered';
  static const String headlineLine1 = 'Find the perfect furniture';
  static const String headlineLine2 = 'For your space with AR';
  static const String body =
      'Get Instant AR-Powered Previews, Compare Styles, Materials, And '
      'Dimensions, And Find The Perfect Furniture For Your Space, Budget, '
      'And Lifestyle.';
  static const String ctaLabel = 'Try AR Assistant';

  static List<BoxShadow> softShadow({double alpha = 0.06}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: alpha),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ];

  static BoxDecoration headerButtonDecoration = BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(headerButtonRadius),
    border: Border.all(color: border),
    boxShadow: softShadow(),
  );

  static BoxDecoration featureTagDecoration = BoxDecoration(
    color: background,
    borderRadius: BorderRadius.circular(featureTagRadius),
    border: Border.all(color: border),
    boxShadow: softShadow(alpha: 0.07),
  );
}
