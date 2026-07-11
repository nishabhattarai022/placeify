import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../profile/presentation/widgets/shared/profile_action_button.dart';
import '../../domain/constants/vendor_strings.dart';

abstract final class VendorStatusGateSheets {
  /// Opens the full Application Pending screen (My Orders–style header).
  static Future<void> showPending(BuildContext context) {
    HapticService.light();
    return context.pushNamed('profileApplicationPending');
  }

  static Future<void> showSuspended(BuildContext context) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorSuspendedSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
      ),
    );
  }
}

class _VendorSuspendedSheetBody extends StatelessWidget {
  const _VendorSuspendedSheetBody({
    required this.parentContext,
    required this.sheetContext,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          VendorStrings.suspendedSheetTitle,
          style: AppFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          VendorStrings.suspendedSheetBody,
          style: AppFonts.dmSerifDisplay(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: const Color(0xFF9B9088),
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ProfileActionButton(
          label: VendorStrings.appealCta,
          onTap: () {
            HapticService.medium();
            Navigator.pop(sheetContext);
            if (parentContext.mounted) {
              PlaceifyToast.show(
                parentContext,
                VendorStrings.appealSubmittedToast,
              );
            }
          },
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        ProfileActionButton(
          label: VendorStrings.dismiss,
          primary: false,
          onTap: () {
            HapticService.light();
            Navigator.pop(sheetContext);
          },
        ),
      ],
    );
  }
}
