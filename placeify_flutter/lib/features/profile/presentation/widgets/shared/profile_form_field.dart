import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_colors.dart';

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    required this.label,
    required this.child,
    this.error,
    super.key,
  });

  final String label;
  final Widget child;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: error != null ? AppColors.coral : AppColors.espresso,
              letterSpacing: 0.07 * 12,
            ),
          ),
          const SizedBox(height: 6),
          child,
          if (error != null) ...[
            const SizedBox(height: 6),
            Text(
              error!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.coral,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProfileTextInput extends StatelessWidget {
  const ProfileTextInput({
    this.controller,
    this.hint,
    this.obscureText = false,
    this.onChanged,
    this.onEditingComplete,
    this.suffix,
    this.keyboardType,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
    this.fieldKey,
    this.hasError = false,
    super.key,
  });

  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormFieldState<String>>? fieldKey;
  final bool hasError;

  InputDecoration _decoration() {
    final borderRadius = BorderRadius.circular(14);
    final borderColor = hasError ? AppColors.coral : AppColors.creamDark;
    final focusedColor = hasError ? AppColors.coral : AppColors.accent;
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: AppColors.textMuted,
      ),
      filled: true,
      fillColor: AppColors.cream,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: borderColor, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: focusedColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 14,
      color: AppColors.espresso,
    );

    if (validator != null) {
      return TextFormField(
        key: fieldKey,
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        keyboardType: keyboardType,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        validator: validator,
        style: style,
        decoration: _decoration(),
      );
    }

    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      style: style,
      decoration: _decoration(),
    );
  }
}

class ProfileDropdown extends StatelessWidget {
  const ProfileDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.espresso,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.espresso,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
