import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import 'models/onboarding_slide.dart';
import 'widgets/get_started_view.dart';
import 'widgets/onboarding_view.dart';
import 'widgets/cinematic_splash/cinematic_splash_tokens.dart';
import 'widgets/cinematic_splash/cinematic_splash_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _logoController;
  late final AnimationController _contentController;
  late final AnimationController _arrowController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  late final Animation<double> _tagOpacity;
  late final Animation<Offset> _tagSlide;
  late final Animation<double> _headlineOpacity;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _bodyOpacity;
  late final Animation<Offset> _bodySlide;
  late final Animation<double> _dotsOpacity;
  late final Animation<double> _ctaOpacity;
  late final Animation<Offset> _ctaSlide;
  late final Animation<double> _arrowBob;

  int _currentPage = 0;
  bool _showLogo = true;
  bool _showGetStarted = false;

  static const _logoSplashDuration = CinematicSplashTokens.splashHoldDuration;
  static const _slideTransitionDuration = Duration(milliseconds: 520);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.onboardingBg,
      ),
    );

    _pageController = PageController();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _tagOpacity = _intervalCurved(0.00, 0.35);
    _tagSlide = _intervalSlide(0.00, 0.40);
    _headlineOpacity = _intervalCurved(0.15, 0.55);
    _headlineSlide = _intervalSlide(0.15, 0.60);
    _bodyOpacity = _intervalCurved(0.30, 0.75);
    _bodySlide = _intervalSlide(0.30, 0.80);
    _dotsOpacity = _intervalCurved(0.45, 0.85);
    _ctaOpacity = _intervalCurved(0.55, 1.00);
    _ctaSlide = _intervalSlide(0.55, 1.00);

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _arrowBob = Tween<double>(begin: 0, end: -7).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _logoController.forward();
    Future<void>.delayed(
      _logoSplashDuration - const Duration(milliseconds: 520),
      () {
        if (mounted) _logoController.reverse();
      },
    );
    Future<void>.delayed(_logoSplashDuration, _transitionToOnboarding);
  }

  Animation<double> _intervalCurved(double start, double end) {
    return CurvedAnimation(
      parent: _contentController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ).drive(Tween<double>(begin: 0, end: 1));
  }

  Animation<Offset> _intervalSlide(double start, double end) {
    return CurvedAnimation(
      parent: _contentController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ).drive(
      Tween<Offset>(
        begin: const Offset(0, 0.035),
        end: Offset.zero,
      ),
    );
  }

  void _transitionToOnboarding() {
    if (!mounted) return;
    setState(() => _showLogo = false);
    _contentController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _logoController.dispose();
    _contentController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _contentController
      ..reset()
      ..forward();
  }

  void _nextSlide() {
    if (_currentPage < kOnboardingSlides.length - 1) {
      _pageController.nextPage(
        duration: _slideTransitionDuration,
        curve: Curves.easeInOutCubic,
      );
    } else {
      setState(() => _showGetStarted = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _showLogo
            ? CinematicSplashView(
                key: const ValueKey('cinematicSplash'),
                opacityAnim: _logoOpacity,
                scaleAnim: _logoScale,
              )
            : _showGetStarted
            ? GetStartedView(
                key: const ValueKey('getStarted'),
                onCreateAccount: () {
                  HapticService.heavy();
                  context.push('/register');
                },
                onLogin: () {
                  HapticService.light();
                  context.push('/login');
                },
              )
            : OnboardingView(
                key: const ValueKey('onboarding'),
                pageController: _pageController,
                currentPage: _currentPage,
                slides: kOnboardingSlides,
                onPageChanged: _onPageChanged,
                onNext: _nextSlide,
                tagOpacity: _tagOpacity,
                tagSlide: _tagSlide,
                headlineOpacity: _headlineOpacity,
                headlineSlide: _headlineSlide,
                bodyOpacity: _bodyOpacity,
                bodySlide: _bodySlide,
                dotsOpacity: _dotsOpacity,
                ctaOpacity: _ctaOpacity,
                ctaSlide: _ctaSlide,
                arrowBob: _arrowBob,
              ),
      ),
    );
  }
}
