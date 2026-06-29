import 'package:flutter/material.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.imageAsset,
    required this.tag,
    required this.headlinePart1,
    required this.headlineItalic,
    required this.headlinePart2,
    required this.body,
    this.imageAlignment = Alignment.center,
  });

  /// Local asset path under [assets/images/splash/].
  final String imageAsset;
  final Alignment imageAlignment;
  final String tag;
  final String headlinePart1;
  final String headlineItalic;
  final String headlinePart2;
  final String body;
}

abstract final class SplashAssets {
  static const String getStartedVideo =
      'assets/video/7281029-uhd_2160_4096_25fps.mp4';

  static const String roomDecor =
      'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg';
  static const String loungeChair =
      'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg';
  static const String vendorSlide =
      'assets/images/splash/pexels-suhailat-35160826.jpg';
  static const String interiorDetail = 'assets/images/splash/462222_1_800.jpg';
}

const List<OnboardingSlide> kOnboardingSlides = [
  OnboardingSlide(
    imageAsset: SplashAssets.roomDecor,
    imageAlignment: Alignment(0, 0.15),
    tag: 'AR Powered',
    headlinePart1: 'Discover furniture\nthat fits your ',
    headlineItalic: 'संसार',
    headlinePart2: '',
    body:
        'Browse thousands of pieces. See them true-to-scale in your room before you buy.',
  ),
  OnboardingSlide(
    imageAsset: SplashAssets.loungeChair,
    imageAlignment: Alignment.bottomCenter,
    tag: 'True to Scale',
    headlinePart1: 'Place it, ',
    headlineItalic: 'सार्नुहोस्',
    headlinePart2: ',\nmake it yours',
    body:
        'Rotate, resize, and reposition any piece in real time. AR that feels like magic.',
  ),
  OnboardingSlide(
    imageAsset: SplashAssets.vendorSlide,
    imageAlignment: Alignment.bottomCenter,
    tag: 'Direct from Vendors',
    headlinePart1: 'Buy with ',
    headlineItalic: 'आत्मविश्वास',
    headlinePart2: ',\nevery time',
    body:
        'Connect directly with verified vendors. No middlemen. Just beautiful furniture.',
  ),
];
