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
  VideoPlayerController? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final controller = VideoPlayerController.asset(SplashAssets.getStartedVideo);
    _controller = controller;
    try {
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.initialize();
      if (!mounted) return;
      setState(() {});
      await controller.play();
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
      await controller.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || _controller == null || !_controller!.value.isInitialized) {
      return const _SplashGradientFallback();
    }

    final aspectRatio = _controller!.value.aspectRatio;
    if (aspectRatio <= 0) {
      return const _SplashGradientFallback();
    }

    return SizedBox.expand(
      child: CoverFitBox(
        aspectRatio: aspectRatio,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}

class _SplashGradientFallback extends StatelessWidget {
  const _SplashGradientFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1410),
            AppColors.onboardingBg,
            Color(0xFF2A2218),
          ],
        ),
      ),
    );
  }
}
