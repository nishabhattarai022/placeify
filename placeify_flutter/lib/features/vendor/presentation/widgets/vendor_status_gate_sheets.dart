import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_action_row.dart';
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
        PlaceifyActionRow(
          cancelLabel: VendorStrings.dismiss,
          confirmLabel: actionLabel,
          onCancel: () {
            HapticService.light();
            Navigator.pop(sheetContext);
          },
          onConfirm: _onActionTap,
        ),
      ],
    );
  }
}
