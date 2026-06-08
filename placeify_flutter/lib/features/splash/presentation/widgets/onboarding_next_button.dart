import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({
    required this.isLast,
    required this.arrowBob,
    required this.onTap,
    super.key,
  });

  final bool isLast;
  final Animation<double> arrowBob;
  final VoidCallback onTap;

  static const _pillDecoration = BoxDecoration(
    color: AppColors.onboardingAmber,
    borderRadius: BorderRadius.all(Radius.circular(999)),
    boxShadow: [
      BoxShadow(
        color: Color(0x59E7A265),
        blurRadius: 22,
        offset: Offset(0, 8),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: isLast ? 168 : 58,
        height: 58,
        decoration: _pillDecoration,
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: isLast
              ? const Text(
                  'Get Started',
                  key: ValueKey('get_started'),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onboardingBg,
                    letterSpacing: 0.2,
                  ),
                )
              : AnimatedBuilder(
                  key: const ValueKey('arrow'),
                  animation: arrowBob,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(arrowBob.value * 0.5, 0),
                      child: child,
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icons/ic_arrow_right.svg',
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(
                      AppColors.onboardingBg,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
