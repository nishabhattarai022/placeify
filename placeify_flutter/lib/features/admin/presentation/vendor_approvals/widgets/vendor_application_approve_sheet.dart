import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_spacing.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/vendor_applications_provider.dart';

abstract final class VendorApplicationApproveSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required VendorApplication application,
    required VoidCallback onApproved,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorApplicationApproveSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        application: application,
        onApproved: onApproved,
      ),
    );
  }
}

class _VendorApplicationApproveSheetBody extends StatefulWidget {
  const _VendorApplicationApproveSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.application,
    required this.onApproved,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final VendorApplication application;
  final VoidCallback onApproved;

  @override
  State<_VendorApplicationApproveSheetBody> createState() =>
      _VendorApplicationApproveSheetBodyState();
}

class _VendorApplicationApproveSheetBodyState
    extends State<_VendorApplicationApproveSheetBody> {
  bool _isSubmitting = false;

  Future<void> _confirmApprove() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();
    Navigator.pop(widget.sheetContext);

    final error = await widget.ref
        .read(vendorApplicationActionsProvider.notifier)
        .approve(
          userId: widget.application.userId,
          vendorId: widget.application.vendorId,
        );

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    widget.onApproved();
    PlaceifyToast.show(widget.parentContext, AdminStrings.vendorApproved);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Approve ${widget.application.businessName}?',
          subtitle:
              'This vendor will gain access to the vendor dashboard and can start listing products.',
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : () {
                        HapticService.light();
                        Navigator.pop(widget.sheetContext);
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
                    'Cancel',
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
                onTap: _isSubmitting ? null : _confirmApprove,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.sage,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    _isSubmitting ? 'Approving…' : 'Approve',
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
