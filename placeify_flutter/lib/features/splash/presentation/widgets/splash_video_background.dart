import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/cover_fit_box.dart';
import '../models/onboarding_slide.dart';

class SplashVideoBackground extends StatefulWidget {
  const SplashVideoBackground({super.key});

  @override
  State<SplashVideoBackground> createState() => _SplashVideoBackgroundState();
}

class _SplashVideoBackgroundState extends State<SplashVideoBackground> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(SplashAssets.getStartedVideo)
      ..setLooping(true)
      ..setVolume(0);
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _controller.play();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const ColoredBox(color: AppColors.onboardingBg);
    }

    final aspectRatio = _controller.value.aspectRatio;
    if (aspectRatio <= 0) {
      return const ColoredBox(color: AppColors.onboardingBg);
    }

    return SizedBox.expand(
      child: CoverFitBox(
        aspectRatio: aspectRatio,
        child: VideoPlayer(_controller),
      ),
    );
  }
}
