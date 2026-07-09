import 'package:flutter/material.dart';

import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';

/// Bottom CTA shown when the user has selected items on My AR.
class MyArTryInRoomBar extends StatelessWidget {
  const MyArTryInRoomBar({
    required this.selectedCount,
    required this.onTap,
    this.enabled = true,
    super.key,
  });

  final int selectedCount;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      left: 20,
      right: 20,
      bottom: BottomNavTokens.fabBottomPadding + bottomInset,
      child: Material(
        elevation: 16,
        shadowColor: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        color: AppColors.charcoal,
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: enabled
                ? () {
                    HapticService.medium();
                    onTap();
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.view_in_ar_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Try in my room',
                      textAlign: TextAlign.center,
                      style: AppFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
