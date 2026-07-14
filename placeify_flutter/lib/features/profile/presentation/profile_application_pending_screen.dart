import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../home/presentation/chairs_catalog_tokens.dart';
import '../../vendor/domain/constants/vendor_strings.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/shared/profile_action_button.dart';

/// Full-screen status view for vendors whose application is still under review.
class ProfileApplicationPendingScreen extends StatelessWidget {
  const ProfileApplicationPendingScreen({super.key});

  static const _italicLine = 'under review';
  static const _timelineTitle = 'What happens next';
  static const _stepSubmitted = 'Application submitted';
  static const _stepSubmittedBody = 'Your store details are with our team.';
  static const _stepReview = 'Under review';
  static const _stepReviewBody = 'Usually takes up to 24 hours.';
  static const _stepApproved = 'Approved & live';
  static const _stepApprovedBody =
      "You'll get access to the vendor dashboard once approved.";

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
              title: VendorStrings.applicationPendingTitle,
              subtitle: _italicLine,
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
                  const _StatusHeroCard(),
                  const SizedBox(height: 20),
                  Text(
                    _timelineTitle,
                    style: AppFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _TimelineCard(),
                  const SizedBox(height: 24),
                  ProfileActionButton(
                    label: VendorStrings.contactSupport,
                    onTap: () {
                      HapticService.light();
                      PlaceifyToast.show(
                        context,
                        VendorStrings.contactSupportToast,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileActionButton(
                    label: VendorStrings.dismiss,
                    primary: false,
                    onTap: () {
                      HapticService.light();
                      context.pop();
                    },
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

class _StatusHeroCard extends StatelessWidget {
  const _StatusHeroCard();

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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.06),
              borderRadius: AppRadii.md,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  VendorStrings.pendingSheetTitle,
                  style: AppFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  VendorStrings.pendingSheetBody,
                  style: AppFonts.dmSerifDisplay(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textMuted,
                    height: 1.45,
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

class _TimelineCard extends StatelessWidget {
  const _TimelineCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
      decoration: BoxDecoration(
        color: ChairsCatalogTokens.imageWell,
        borderRadius:
            BorderRadius.circular(ChairsCatalogTokens.compactCardRadius),
        boxShadow: ChairsCatalogTokens.cardShadow,
      ),
      child: const Column(
        children: [
          _TimelineStep(
            title: ProfileApplicationPendingScreen._stepSubmitted,
            body: ProfileApplicationPendingScreen._stepSubmittedBody,
            done: true,
          ),
          _TimelineStep(
            title: ProfileApplicationPendingScreen._stepReview,
            body: ProfileApplicationPendingScreen._stepReviewBody,
            active: true,
          ),
          _TimelineStep(
            title: ProfileApplicationPendingScreen._stepApproved,
            body: ProfileApplicationPendingScreen._stepApprovedBody,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.body,
    this.done = false,
    this.active = false,
    this.isLast = false,
  });

  final String title;
  final String body;
  final bool done;
  final bool active;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final markerColor = done || active
        ? Colors.black
        : Colors.black.withValues(alpha: 0.18);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: done || active ? Colors.black : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: markerColor, width: 1.5),
              ),
              alignment: Alignment.center,
              child: done
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : active
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 36,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.black.withValues(alpha: 0.12),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 8 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: done || active
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: AppFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMuted,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
