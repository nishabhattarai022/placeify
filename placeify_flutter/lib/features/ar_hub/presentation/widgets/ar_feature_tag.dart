import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../ar_hub_tokens.dart';

class ArFeatureTag extends StatelessWidget {
  const ArFeatureTag({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ArHubTokens.featureTagDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: ArHubTokens.textPrimary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ArHubTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
