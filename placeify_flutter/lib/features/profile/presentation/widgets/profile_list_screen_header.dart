import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/superscript_count_title.dart';

/// Light header used on profile sub-screens — matches [MyOrdersScreen] leading.
class ProfileListScreenHeader extends StatelessWidget {
  const ProfileListScreenHeader({
    required this.title,
    required this.subtitle,
    this.count,
    super.key,
  });

  final String title;
  final String subtitle;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        16,
        AppSpacing.screenPadding,
        8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              HapticService.light();
              context.pop();
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warmWhite,
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (count != null)
                  SuperscriptCountTitle(
                    title: title,
                    count: count!,
                    color: Colors.black87,
                  )
                else
                  Text(
                    title,
                    style: AppFonts.dmSerifDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                      height: 1.0,
                    ),
                  ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    subtitle,
                    style: AppFonts.dmSerifDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textMuted,
                      height: 1.05,
                      letterSpacing: -0.3,
                    ),
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
