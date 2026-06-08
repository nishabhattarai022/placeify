import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../ar_hub_tokens.dart';

class ArCompactCtaButton extends StatelessWidget {
  const ArCompactCtaButton({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: ArHubTokens.ctaHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: ArHubTokens.ctaHorizontalPadding,
          ),
          decoration: BoxDecoration(
            color: ArHubTokens.ctaBlack,
            borderRadius: BorderRadius.circular(999),
            boxShadow: ArHubTokens.softShadow(alpha: 0.14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ArHubTokens.ctaLabel,
                style: AppFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_awesome_outlined,
                size: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
