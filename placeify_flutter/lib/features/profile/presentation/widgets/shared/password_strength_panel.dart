import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radii.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../home/presentation/chairs_catalog_tokens.dart';

class PasswordStrengthPanel extends StatelessWidget {
  const PasswordStrengthPanel({
    required this.password,
    super.key,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    final hasLength = password.length >= 8;
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    final score =
        [hasLength, hasUpper, hasNumber, hasSymbol].where((e) => e).length;

    final configs = [
      (0.0, AppColors.textMuted, ''),
      (0.25, AppColors.rust, 'Weak'),
      (0.5, Colors.black54, 'Fair'),
      (0.75, AppColors.sage, 'Good'),
      (1.0, Colors.black, 'Strong'),
    ];
    final cfg = configs[score.clamp(0, 4)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: AppRadii.pill,
          child: LinearProgressIndicator(
            value: cfg.$1,
            minHeight: 4,
            backgroundColor: Colors.black.withValues(alpha: 0.08),
            color: cfg.$2,
          ),
        ),
        if (cfg.$3.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            cfg.$3,
            style: AppFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cfg.$2,
            ),
          ),
        ],
        const SizedBox(height: 8),
        _PasswordRules(
          hasLength: hasLength,
          hasUpper: hasUpper,
          hasNumber: hasNumber,
          hasSymbol: hasSymbol,
        ),
      ],
    );
  }
}

class _PasswordRules extends StatelessWidget {
  const _PasswordRules({
    required this.hasLength,
    required this.hasUpper,
    required this.hasNumber,
    required this.hasSymbol,
  });

  final bool hasLength;
  final bool hasUpper;
  final bool hasNumber;
  final bool hasSymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ChairsCatalogTokens.imageWell,
        borderRadius:
            BorderRadius.circular(ChairsCatalogTokens.compactCardRadius),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          _Rule(label: 'At least 8 characters', valid: hasLength),
          _Rule(label: 'One uppercase letter', valid: hasUpper),
          _Rule(label: 'One number', valid: hasNumber),
          _Rule(label: 'One special character (!@#\$...)', valid: hasSymbol),
        ],
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.label, required this.valid});

  final String label;
  final bool valid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: valid
                  ? Colors.black
                  : Colors.black.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.check,
              size: 10,
              color: valid ? Colors.white : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: valid ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
