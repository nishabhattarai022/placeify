import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import 'onboarding/animated_slide_in.dart';
import 'onboarding/feature_pill.dart';
import 'onboarding/auth_choice_button.dart';
import 'splash_video_background.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({
    required this.onCreateAccount,
    required this.onLogin,
    super.key,
  });

  final VoidCallback onCreateAccount;
  final VoidCallback onLogin;

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoOp;
  late final Animation<double> _taglineOp;
  late final Animation<double> _btn1Op;
  late final Animation<double> _btn2Op;
  late final Animation<Offset> _logoSlide;
  late final Animation<Offset> _btn1Slide;
  late final Animation<Offset> _btn2Slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _logoOp = _interval(0.0, 0.50);
    _logoSlide = _intervalOffset(0.0, 0.55);
    _taglineOp = _interval(0.20, 0.65);
    _btn1Op = _interval(0.40, 0.80);
    _btn1Slide = _intervalOffset(0.40, 0.82);
    _btn2Op = _interval(0.55, 1.00);
    _btn2Slide = _intervalOffset(0.55, 1.00);
  }

  Animation<double> _interval(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ).drive(Tween<double>(begin: 0, end: 1));
  }

  Animation<Offset> _intervalOffset(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ).drive(
      Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final topPadding = MediaQuery.paddingOf(context).top;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 700;

    return Stack(
      fit: StackFit.expand,
      children: [
        const SplashVideoBackground(),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.35, 0.65, 1.0],
              colors: [
                AppColors.onboardingBg.withValues(alpha: 0.55),
                AppColors.onboardingBg.withValues(alpha: 0.72),
                AppColors.onboardingBg.withValues(alpha: 0.88),
                AppColors.onboardingBg.withValues(alpha: 0.94),
              ],
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              28,
              topPadding > 0 ? 8 : 16,
              28,
              bottomPadding + 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - topPadding - bottomPadding - 32,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    AnimatedSlideIn(
                      opacity: _logoOp,
                      slide: _logoSlide,
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Place',
                                  style: AppFonts.poppins(
                                    fontSize: compact ? 48 : 58,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onboardingTextHead,
                                    letterSpacing: -1.5,
                                    height: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: 'ify',
                                  style: AppFonts.poppins(
                                    fontSize: compact ? 48 : 58,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onboardingAmber,
                                    letterSpacing: -1.5,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'AR Furniture Marketplace',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.onboardingTextBody,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 12 : 18),
                    FadeTransition(
                      opacity: _taglineOp,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '"See it in your space before it\'s in your home."',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Fraunces',
                            fontSize: compact ? 16 : 18,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                            color: AppColors.onboardingTextHead.withValues(
                              alpha: 0.55,
                            ),
                            height: 1.45,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    FadeTransition(
                      opacity: _btn1Op,
                      child: const Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FeaturePill(
                            iconPath: 'assets/icons/ic_box.svg',
                            label: 'AR View',
                          ),
                          FeaturePill(
                            iconPath: 'assets/icons/ic_package.svg',
                            label: 'Vendors',
                          ),
                          FeaturePill(
                            iconPath: 'assets/icons/ic_ruler.svg',
                            label: 'True Scale',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compact ? 20 : 28),
                    AnimatedSlideIn(
                      opacity: _btn1Op,
                      slide: _btn1Slide,
                      child: AuthChoiceButton(
                        variant: AuthChoiceVariant.proceedLogin,
                        onTap: widget.onLogin,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSlideIn(
                      opacity: _btn2Op,
                      slide: _btn2Slide,
                      child: AuthChoiceButton(
                        variant: AuthChoiceVariant.signUp,
                        onTap: widget.onCreateAccount,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _btn2Op,
                      child: Text(
                        'By continuing you agree to our Terms & Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onboardingTextBody.withValues(
                            alpha: 0.45,
                          ),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
