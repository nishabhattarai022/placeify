import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/constants/vendor_strings.dart';

abstract final class VendorStatusGateSheets {
  static Future<void> showPending(BuildContext context) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorStatusGateSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        title: VendorStrings.pendingSheetTitle,
        body: VendorStrings.pendingSheetBody,
        actionLabel: VendorStrings.contactSupport,
        toastMessage: VendorStrings.contactSupportToast,
      ),
    );
  }

  static Future<void> showSuspended(BuildContext context) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorStatusGateSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        title: VendorStrings.suspendedSheetTitle,
        body: VendorStrings.suspendedSheetBody,
        actionLabel: VendorStrings.appealCta,
        toastMessage: VendorStrings.appealSubmittedToast,
      ),
    );
  }
}

class _VendorStatusGateSheetBody extends StatelessWidget {
  const _VendorStatusGateSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.toastMessage,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final String title;
  final String body;
  final String actionLabel;
  final String toastMessage;

  void _onActionTap() {
    HapticService.light();
    Navigator.pop(sheetContext);
    if (parentContext.mounted) {
      PlaceifyToast.show(parentContext, toastMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: title,
          subtitle: body,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticService.light();
                  Navigator.pop(sheetContext);
                },
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: AppRadii.pill,
                    border: Border.all(color: AppColors.creamDark, width: 1.5),
                  ),
                  child: Text(
                    'Dismiss',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _onActionTap,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    actionLabel,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
