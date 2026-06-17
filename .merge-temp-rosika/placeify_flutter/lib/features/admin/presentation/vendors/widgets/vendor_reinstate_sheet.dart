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
import 'package:placeify_flutter/features/admin/presentation/providers/admin_vendors_provider.dart';

abstract final class VendorReinstateSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required VendorApplication vendor,
    required VoidCallback onReinstated,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorReinstateSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        vendor: vendor,
        onReinstated: onReinstated,
      ),
    );
  }
}

class _VendorReinstateSheetBody extends StatefulWidget {
  const _VendorReinstateSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.vendor,
    required this.onReinstated,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final VendorApplication vendor;
  final VoidCallback onReinstated;

  @override
  State<_VendorReinstateSheetBody> createState() =>
      _VendorReinstateSheetBodyState();
}

class _VendorReinstateSheetBodyState extends State<_VendorReinstateSheetBody> {
  bool _isSubmitting = false;

  Future<void> _confirmReinstate() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();
    Navigator.pop(widget.sheetContext);

    final error = await widget.ref
        .read(adminVendorActionsProvider.notifier)
        .reinstate(
          userId: widget.vendor.userId,
          vendorId: widget.vendor.vendorId,
        );

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    widget.onReinstated();
    PlaceifyToast.show(widget.parentContext, AdminStrings.vendorReinstated);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Reinstate ${widget.vendor.businessName}?',
          subtitle:
              'This vendor will regain access to the vendor dashboard.',
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
                onTap: _isSubmitting ? null : _confirmReinstate,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.sage,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    _isSubmitting ? 'Reinstating…' : 'Reinstate',
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
