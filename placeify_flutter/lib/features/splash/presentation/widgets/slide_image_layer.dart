import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/cover_fit_box.dart';
import '../models/onboarding_slide.dart';
import 'onboarding/room_illustration.dart';

class SlideImageLayer extends StatelessWidget {
  const SlideImageLayer({
    required this.slide,
    required this.slideIndex,
    super.key,
  });

  final OnboardingSlide slide;
  final int slideIndex;

  @override
  Widget build(BuildContext context) {
    return CoverAssetImage(
      asset: slide.imageAsset,
      alignment: slide.imageAlignment,
      errorBuilder: (_, _, _) => ColoredBox(
        color: AppColors.onboardingBgCard,
        child: Center(
          child: RoomIllustration(slideIndex: slideIndex),
        ),
      ),
    );
  }
}
