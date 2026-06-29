import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/app_colors.dart';

enum AuthChoiceVariant { proceedLogin, signUp }

class AuthChoiceButton extends StatefulWidget {
  const AuthChoiceButton({
    required this.variant,
    required this.onTap,
    super.key,
  });

  final AuthChoiceVariant variant;
  final VoidCallback onTap;

  static const double height = 58;
  static const double _horizontalPadding = 16;
  static const double _leadingCircleSize = 40;
  static const double _leadingIconSize = 22;
  static const double _trailingArrowSize = 24;

  static const _loginLeadingIcon = 'assets/icons/ic_auth_login_leading.svg';
  static const _signUpLeadingIcon = 'assets/icons/ic_sign_up_user.svg';
  static const _trailingArrowIcon = 'assets/icons/ic_auth_arrow.svg';

  @override
  State<AuthChoiceButton> createState() => _AuthChoiceButtonState();
}

class _AuthChoiceButtonState extends State<AuthChoiceButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scale = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  bool get _isLogin => widget.variant == AuthChoiceVariant.proceedLogin;

  Color get _leadingIconColor =>
      _isLogin ? AppColors.charcoal : AppColors.authCtaSignUpIcon;

  Color get _trailingArrowColor => _isLogin ? AppColors.charcoal : Colors.white;

  String get _leadingIconAsset => _isLogin
      ? AuthChoiceButton._loginLeadingIcon
      : AuthChoiceButton._signUpLeadingIcon;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _isLogin
        ? AppColors.authCtaLoginBg
        : AppColors.authCtaSignUpBg;

    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) {
        _press.reverse();
        widget.onTap();
      },
      onTapCancel: () => _press.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },
        child: Container(
          width: double.infinity,
          height: AuthChoiceButton.height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(999),
            border: _isLogin
                ? Border.all(
                    color: Colors.black.withValues(alpha: 0.06),
                  )
                : null,
            boxShadow: _isLogin
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AuthChoiceButton._horizontalPadding,
            ),
            child: Row(
              children: [
                _LeadingIconCircle(
                  isLogin: _isLogin,
                  iconAsset: _leadingIconAsset,
                  iconColor: _leadingIconColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _isLogin ? _buildLoginLabel() : _buildSignUpLabel(),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  AuthChoiceButton._trailingArrowIcon,
                  width: AuthChoiceButton._trailingArrowSize,
                  height: AuthChoiceButton._trailingArrowSize,
                  colorFilter: ColorFilter.mode(
                    _trailingArrowColor,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLabel() {
    return const Text(
      'Proceed to Login',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.charcoal,
        letterSpacing: -0.1,
      ),
    );
  }

  Widget _buildSignUpLabel() {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 15,
          letterSpacing: -0.1,
        ),
        children: const [
          TextSpan(
            text: 'New User? ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadingIconCircle extends StatelessWidget {
  const _LeadingIconCircle({
    required this.isLogin,
    required this.iconAsset,
    required this.iconColor,
  });

  final bool isLogin;
  final String iconAsset;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AuthChoiceButton._leadingCircleSize,
      height: AuthChoiceButton._leadingCircleSize,
      decoration: BoxDecoration(
        color: isLogin ? AppColors.authCtaLoginIconCircle : Colors.black,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        iconAsset,
        width: AuthChoiceButton._leadingIconSize,
        height: AuthChoiceButton._leadingIconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    );
  }
}
