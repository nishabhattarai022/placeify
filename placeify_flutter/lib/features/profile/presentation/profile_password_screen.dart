import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../home/presentation/chairs_catalog_tokens.dart';
import '../domain/constants/password_strings.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/shared/password_strength_panel.dart';
import 'widgets/shared/profile_action_button.dart';

class ProfilePasswordScreen extends StatefulWidget {
  const ProfilePasswordScreen({super.key});

  @override
  State<ProfilePasswordScreen> createState() => _ProfilePasswordScreenState();
}

class _ProfilePasswordScreenState extends State<ProfilePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  String _matchLabel = '';
  Color _matchColor = AppColors.textMuted;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _checkMatch(String value) {
    if (value.isEmpty) {
      setState(() {
        _matchLabel = '';
        _matchColor = AppColors.textMuted;
      });
      return;
    }
    if (value == _newController.text) {
      setState(() {
        _matchLabel = PasswordStrings.passwordsMatch;
        _matchColor = Colors.black;
      });
    } else {
      setState(() {
        _matchLabel = PasswordStrings.passwordsMismatch;
        _matchColor = AppColors.rust;
      });
    }
  }

  void _submit() {
    final current = _currentController.text;
    final next = _newController.text;
    final confirm = _confirmController.text;
    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      PlaceifyToast.show(context, PasswordStrings.fillAllFields);
      return;
    }
    if (next != confirm) {
      PlaceifyToast.show(context, PasswordStrings.passwordsDoNotMatch);
      return;
    }
    if (next.length < 8) {
      PlaceifyToast.show(context, PasswordStrings.passwordTooShort);
      return;
    }
    PlaceifyToast.show(context, PasswordStrings.updatedToast);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ProfileListScreenHeader(
              title: PasswordStrings.title,
              subtitle: PasswordStrings.italicLine,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  12,
                  AppSpacing.screenPadding,
                  BottomNavTokens.scrollBottomPadding + bottomInset,
                ),
                children: [
                  const _SecurityTipCard(),
                  const SizedBox(height: 20),
                  _PasswordFormField(
                    label: PasswordStrings.currentPassword,
                    child: _PasswordTextField(
                      controller: _currentController,
                      hint: PasswordStrings.currentHint,
                      obscureText: !_showCurrent,
                      onToggleVisibility: () =>
                          setState(() => _showCurrent = !_showCurrent),
                      visible: _showCurrent,
                    ),
                  ),
                  _PasswordFormField(
                    label: PasswordStrings.newPassword,
                    child: Column(
                      children: [
                        _PasswordTextField(
                          controller: _newController,
                          hint: PasswordStrings.newHint,
                          obscureText: !_showNew,
                          onChanged: (_) => setState(() {}),
                          onToggleVisibility: () =>
                              setState(() => _showNew = !_showNew),
                          visible: _showNew,
                        ),
                        PasswordStrengthPanel(password: _newController.text),
                      ],
                    ),
                  ),
                  _PasswordFormField(
                    label: PasswordStrings.confirmPassword,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PasswordTextField(
                          controller: _confirmController,
                          hint: PasswordStrings.confirmHint,
                          obscureText: !_showConfirm,
                          onChanged: _checkMatch,
                          onToggleVisibility: () =>
                              setState(() => _showConfirm = !_showConfirm),
                          visible: _showConfirm,
                        ),
                        if (_matchLabel.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            _matchLabel,
                            style: AppFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _matchColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ProfileActionButton(
                      label: PasswordStrings.updatePassword,
                      onTap: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityTipCard extends StatelessWidget {
  const _SecurityTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ChairsCatalogTokens.imageWell,
        borderRadius: BorderRadius.circular(ChairsCatalogTokens.wideCardRadius),
        boxShadow: ChairsCatalogTokens.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.06),
              borderRadius: AppRadii.md,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.shield_outlined,
              color: Colors.black,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  PasswordStrings.tipTitle,
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  PasswordStrings.tipBody,
                  style: AppFonts.dmSerifDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordFormField extends StatelessWidget {
  const _PasswordFormField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({
    required this.controller,
    required this.hint,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.visible,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final bool visible;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: AppFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.dmSans(
          fontSize: 14,
          color: Colors.black.withValues(alpha: 0.35),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            visible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.black.withValues(alpha: 0.45),
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.md,
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }
}
