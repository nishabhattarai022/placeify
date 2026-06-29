import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.showVisibilityToggle = false,
    this.textInputAction,
    this.validator,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showVisibilityToggle;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  static const _fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  );

  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText || widget.showVisibilityToggle;
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        color: AppColors.onboardingTextBody.withValues(alpha: 0.55),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.07),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      suffixIcon: widget.showVisibilityToggle
          ? IconButton(
              onPressed: () => setState(() => _obscured = !_obscured),
              icon: Icon(
                _obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.onboardingTextBody.withValues(alpha: 0.75),
                size: 22,
              ),
            )
          : null,
      border: _fieldBorder.copyWith(
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      enabledBorder: _fieldBorder.copyWith(
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      focusedBorder: _fieldBorder.copyWith(
        borderSide: const BorderSide(
          color: AppColors.bark,
          width: 1.4,
        ),
      ),
      errorBorder: _fieldBorder.copyWith(
        borderSide: BorderSide(
          color: AppColors.rust.withValues(alpha: 0.85),
        ),
      ),
      focusedErrorBorder: _fieldBorder.copyWith(
        borderSide: const BorderSide(
          color: AppColors.rust,
          width: 1.4,
        ),
      ),
      errorStyle: TextStyle(
        fontSize: 12,
        color: AppColors.rust.withValues(alpha: 0.95),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: AppColors.bark,
        secondary: AppColors.bark,
        surfaceTint: AppColors.bark,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.bark,
        selectionColor: Color(0x408B7355),
        selectionHandleColor: AppColors.bark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: AppColors.bark,
        hoverColor: AppColors.bark.withValues(alpha: 0.06),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.onboardingTextHead.withValues(alpha: 0.75),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Theme(
          data: fieldTheme,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.showVisibilityToggle
                ? _obscured
                : widget.obscureText,
            textInputAction: widget.textInputAction,
            validator: widget.validator,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.onboardingTextHead,
            ),
            cursorColor: AppColors.bark,
            decoration: _decoration(context),
          ),
        ),
      ],
    );
  }
}
