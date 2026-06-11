import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/onboarding_slide.dart';
import 'onboarding/animated_slide_in.dart';
import 'onboarding_headline.dart';
import 'onboarding/swipe_get_started_button.dart';
import 'onboarding_next_button.dart';
import 'onboarding_page_dots.dart';
import 'onboarding_skip_button.dart';
import 'onboarding_tag_chip.dart';
import 'slide_image_layer.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({
    required this.pageController,
    required this.currentPage,
    required this.slides,
    required this.onPageChanged,
    required this.onNext,
    required this.tagOpacity,
    required this.tagSlide,
    required this.headlineOpacity,
    required this.headlineSlide,
    required this.bodyOpacity,
    required this.bodySlide,
    required this.dotsOpacity,
    required this.ctaOpacity,
    required this.ctaSlide,
    required this.arrowBob,
    super.key,
  });

  final PageController pageController;
  final int currentPage;
  final List<OnboardingSlide> slides;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;

  final Animation<double> tagOpacity;
  final Animation<Offset> tagSlide;
  final Animation<double> headlineOpacity;
  final Animation<Offset> headlineSlide;
  final Animation<double> bodyOpacity;
  final Animation<Offset> bodySlide;
  final Animation<double> dotsOpacity;
  final Animation<double> ctaOpacity;
  final Animation<Offset> ctaSlide;
  final Animation<double> arrowBob;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final topPadding = MediaQuery.paddingOf(context).top;
    final slide = slides[currentPage];

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const BouncingScrollPhysics(),
          itemCount: slides.length,
          itemBuilder: (context, index) {
            return SlideImageLayer(
              slide: slides[index],
              slideIndex: index,
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: const [0.0, 0.45, 0.75, 1.0],
                colors: [
                  AppColors.onboardingBg,
                  AppColors.onboardingBg.withValues(alpha: 0.97),
                  AppColors.onboardingBg.withValues(alpha: 0.82),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: topPadding + 120,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.onboardingBg.withValues(alpha: 0.65),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.only(
              left: 28,
              right: 28,
              bottom: bottomPadding + 24,
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSlideIn(
                  opacity: tagOpacity,
                  slide: tagSlide,
                  child: OnboardingTagChip(label: slide.tag),
                ),
                const SizedBox(height: 20),
                AnimatedSlideIn(
                  opacity: headlineOpacity,
                  slide: headlineSlide,
                  child: OnboardingHeadline(slide: slide),
                ),
                const SizedBox(height: 16),
                AnimatedSlideIn(
                  opacity: bodyOpacity,
                  slide: bodySlide,
                  child: Text(
                    slide.body,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: AppColors.onboardingTextBody,
                      height: 1.70,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                AnimatedSlideIn(
                  opacity: ctaOpacity,
                  slide: ctaSlide,
                  child: currentPage == slides.length - 1
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FadeTransition(
                              opacity: dotsOpacity,
                              child: Center(
                                child: OnboardingPageDots(
                                  count: slides.length,
                                  active: currentPage,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SwipeGetStartedButton(onComplete: onNext),
                          ],
                        )
                      : Row(
                          children: [
                            FadeTransition(
                              opacity: dotsOpacity,
                              child: OnboardingPageDots(
                                count: slides.length,
                                active: currentPage,
                              ),
                            ),
                            const Spacer(),
                            OnboardingNextButton(
                              isLast: false,
                              arrowBob: arrowBob,
                              onTap: onNext,
                            ),
                          ],
                        ),
                ),
              ],
              ),
            ),
          ),
        ),
        if (currentPage < slides.length - 1)
          Positioned(
            top: topPadding + 16,
            right: 24,
            child: FadeTransition(
              opacity: tagOpacity,
              child: OnboardingSkipButton(
                onTap: () {
                  pageController.animateToPage(
                    slides.length - 1,
                    duration: const Duration(milliseconds: 480),
                    curve: Curves.easeInOutCubic,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
