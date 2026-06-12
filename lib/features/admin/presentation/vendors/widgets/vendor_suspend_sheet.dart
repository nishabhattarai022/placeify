import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/features/admin/domain/models/vendor_application.dart';
import 'package:placeify/features/admin/presentation/providers/admin_vendors_provider.dart';

abstract final class VendorSuspendSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required VendorApplication vendor,
    required VoidCallback onSuspended,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorSuspendSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        vendor: vendor,
        onSuspended: onSuspended,
      ),
    );
  }
}

class _VendorSuspendSheetBody extends StatefulWidget {
  const _VendorSuspendSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.vendor,
    required this.onSuspended,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final VendorApplication vendor;
  final VoidCallback onSuspended;

  @override
  State<_VendorSuspendSheetBody> createState() => _VendorSuspendSheetBodyState();
}

class _VendorSuspendSheetBodyState extends State<_VendorSuspendSheetBody> {
  bool _isSubmitting = false;

  Future<void> _confirmSuspend() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();
    Navigator.pop(widget.sheetContext);

    final error = await widget.ref
        .read(adminVendorActionsProvider.notifier)
        .suspend(
          userId: widget.vendor.userId,
          vendorId: widget.vendor.vendorId,
        );

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    widget.onSuspended();
    PlaceifyToast.show(widget.parentContext, 'Vendor suspended');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Suspend ${widget.vendor.businessName}?',
          subtitle:
              'This vendor will lose access to the vendor dashboard until reinstated.',
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
                onTap: _isSubmitting ? null : _confirmSuspend,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.rust,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    _isSubmitting ? 'Suspending…' : 'Suspend',
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
