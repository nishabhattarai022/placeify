import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Text field for cream / warm-white app screens (vendor forms, add product).
class FormTextField extends StatefulWidget {
  const FormTextField({
    required this.label,
    required this.controller,
    this.hint,
    this.helperText,
    this.prefixText,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.maxLines = 1,
    this.required = false,
    super.key,
  });

  final String label;
  final String? hint;
  final String? helperText;
  final String? prefixText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool required;

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  static const _fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(14)),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
            if (widget.required)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.rust,
                ),
              ),
          ],
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: const TextStyle(
              fontSize: 11,
              height: 1.35,
              color: AppColors.textMuted,
            ),
          ),
        ],
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
            height: 1.35,
          ),
          cursorColor: AppColors.bark,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixText: widget.prefixText,
            prefixStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            hintStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: AppColors.warmWhite,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: _fieldBorder.copyWith(
              borderSide: const BorderSide(color: AppColors.creamDark),
            ),
            enabledBorder: _fieldBorder.copyWith(
              borderSide: const BorderSide(color: AppColors.creamDark),
            ),
            focusedBorder: _fieldBorder.copyWith(
              borderSide: const BorderSide(color: AppColors.bark, width: 1.4),
            ),
            errorBorder: _fieldBorder.copyWith(
              borderSide: BorderSide(
                color: AppColors.rust.withValues(alpha: 0.85),
              ),
            ),
            focusedErrorBorder: _fieldBorder.copyWith(
              borderSide: const BorderSide(color: AppColors.rust, width: 1.4),
            ),
            errorStyle: TextStyle(
              fontSize: 12,
              color: AppColors.rust.withValues(alpha: 0.95),
            ),
          ),
        ),
      ],
    );
  }
}
