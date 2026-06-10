import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../splash/presentation/models/onboarding_slide.dart';

/// "See It In Motion" video showcase with an Apple-style expanding pill
/// toggle that morphs between a 60px circle (paused) and a 330px now-playing
/// pill (playing). Tapping the pill plays/pauses the embedded video.
class HomeShowcaseSection extends StatefulWidget {
  const HomeShowcaseSection({super.key});

  @override
  State<HomeShowcaseSection> createState() => _HomeShowcaseSectionState();
}

class _HomeShowcaseSectionState extends State<HomeShowcaseSection> {
  static const String _videoAsset = SplashAssets.getStartedVideo;

  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(_videoAsset)
      ..setLooping(true)
      ..setVolume(0);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _initialized = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (!_initialized) return;
    HapticService.light();
    setState(() {
      _playing = !_playing;
      _playing ? _controller.play() : _controller.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'See It In Motion',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: AspectRatio(
            aspectRatio: 16 / 11,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: const Color(0xFF1A1A1A),
                  child: _initialized
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        )
                      : const Center(
                          child: SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x00000000),
                        Color(0x66000000),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 18,
                  child: Center(
                    child: _ApplePlayPill(
                      playing: _playing,
                      enabled: _initialized,
                      onTap: _togglePlayback,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ApplePlayPill extends StatelessWidget {
  const _ApplePlayPill({
    required this.playing,
    required this.enabled,
    required this.onTap,
  });

  final bool playing;
  final bool enabled;
  final VoidCallback onTap;

  static const double _height = 56;
  static const double _collapsedWidth = 60;
  static const double _expandedWidth = 330;
  static const Duration _duration = Duration(milliseconds: 520);
  static const Curve _curve = Curves.easeOutBack;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_height),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: AnimatedContainer(
            duration: _duration,
            curve: _curve,
            height: _height,
            width: playing ? _expandedWidth : _collapsedWidth,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(_height),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: playing ? 0 : 1,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeOutCubic,
                    opacity: playing ? 1 : 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _trackBar(60),
                        const SizedBox(width: 10),
                        _trackDot(),
                        const SizedBox(width: 10),
                        _trackDot(),
                        const SizedBox(width: 10),
                        _trackDot(),
                        const SizedBox(width: 10),
                        _trackDot(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 60,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 360),
                    curve: Curves.easeOutCubic,
                    opacity: playing ? 1 : 0,
                    child: AnimatedScale(
                      scale: playing ? 1 : 0.6,
                      duration: const Duration(milliseconds: 360),
                      curve: Curves.easeOutBack,
                      child: const Center(
                        child: Icon(
                          Icons.pause_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _trackBar(double width) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _trackDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        shape: BoxShape.circle,
      ),
    );
  }
}
