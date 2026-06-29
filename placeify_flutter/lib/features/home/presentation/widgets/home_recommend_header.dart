import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../theme/home_screen_tokens.dart';

/// "Recommend for you" row with trailing arrow.
class HomeRecommendHeader extends StatefulWidget {
  const HomeRecommendHeader({super.key});

  @override
  State<HomeRecommendHeader> createState() => _HomeRecommendHeaderState();
}

class _HomeRecommendHeaderState extends State<HomeRecommendHeader> {
  bool _arrowHovered = false;
  bool _arrowPressed = false;

  void _onArrowTap() {
    HapticService.light();
    context.go('/browse');
  }

  @override
  Widget build(BuildContext context) {
    final arrowActive = _arrowHovered || _arrowPressed;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Recommend for you',
            style: HomeScreenTokens.sectionTitle(),
          ),
        ),
        MouseRegion(
          onEnter: (_) => setState(() => _arrowHovered = true),
          onExit: (_) => setState(() => _arrowHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _arrowPressed = true),
            onTapUp: (_) => setState(() => _arrowPressed = false),
            onTapCancel: () => setState(() => _arrowPressed = false),
            onTap: _onArrowTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: arrowActive
                    ? Colors.black.withValues(
                        alpha: _arrowPressed ? 0.08 : 0.05,
                      )
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: AnimatedSlide(
                offset: arrowActive ? const Offset(0.06, 0) : Offset.zero,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                child: SvgPicture.asset(
                  'assets/icons/ic_arrow_right.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    Color.lerp(
                      const Color(0xFF1A1A1A),
                      Colors.black,
                      arrowActive ? 0.15 : 0,
                    )!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
