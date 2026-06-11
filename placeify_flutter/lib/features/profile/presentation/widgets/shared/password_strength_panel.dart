import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class PasswordStrengthPanel extends StatelessWidget {
  const PasswordStrengthPanel({
    required this.password,
    super.key,
  });

  final String password;

  @override
  Widget build(BuildContext context) {
    final len = password.length >= 8;
    final upper = RegExp(r'[A-Z]').hasMatch(password);
    final num = RegExp(r'\d').hasMatch(password);
    final sym = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    final score = [len, upper, num, sym].where((e) => e).length;

    final configs = [
      (0.0, AppColors.textMuted, ''),
      (0.25, AppColors.rust, 'Weak'),
      (0.5, AppColors.accent, 'Fair'),
      (0.75, AppColors.sage, 'Good'),
      (1.0, AppColors.teal, 'Strong'),
    ];
    final cfg = configs[score.clamp(0, 4)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: cfg.$1,
            minHeight: 4,
            backgroundColor: AppColors.creamDark,
            color: cfg.$2,
          ),
        ),
        if (cfg.$3.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            cfg.$3,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cfg.$2,
            ),
          ),
        ],
        const SizedBox(height: 6),
        _PwRules(len: len, upper: upper, num: num, sym: sym),
      ],
    );
  }
}

class _PwRules extends StatelessWidget {
  const _PwRules({
    required this.len,
    required this.upper,
    required this.num,
    required this.sym,
  });

  final bool len;
  final bool upper;
  final bool num;
  final bool sym;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _Rule(label: 'At least 8 characters', valid: len),
          _Rule(label: 'One uppercase letter', valid: upper),
          _Rule(label: 'One number', valid: num),
          _Rule(label: 'One special character (!@#\$...)', valid: sym),
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
              color: valid ? AppColors.teal : AppColors.creamDark,
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
            style: TextStyle(
              fontSize: 13,
              color: valid ? AppColors.teal : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
