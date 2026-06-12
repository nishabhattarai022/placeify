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
import 'package:placeify/features/admin/presentation/providers/vendor_applications_provider.dart';

abstract final class VendorApplicationDeclineSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required VendorApplication application,
    required VoidCallback onDeclined,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorApplicationDeclineSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        application: application,
        onDeclined: onDeclined,
      ),
    );
  }
}

class _VendorApplicationDeclineSheetBody extends StatefulWidget {
  const _VendorApplicationDeclineSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.application,
    required this.onDeclined,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final VendorApplication application;
  final VoidCallback onDeclined;

  @override
  State<_VendorApplicationDeclineSheetBody> createState() =>
      _VendorApplicationDeclineSheetBodyState();
}

class _VendorApplicationDeclineSheetBodyState
    extends State<_VendorApplicationDeclineSheetBody> {
  bool _isSubmitting = false;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _confirmDecline() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();
    Navigator.pop(widget.sheetContext);

    final note = _noteController.text.trim();
    final error = await widget.ref
        .read(vendorApplicationActionsProvider.notifier)
        .decline(
          userId: widget.application.userId,
          vendorId: widget.application.vendorId,
          note: note.isEmpty ? null : note,
        );

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    widget.onDeclined();
    PlaceifyToast.show(widget.parentContext, 'Application declined');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Decline ${widget.application.businessName}?',
          subtitle:
              'The applicant can submit a new registration later. Add an optional note for the audit log.',
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _noteController,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Optional note (internal)',
            hintStyle: GoogleFonts.dmSans(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: AppColors.cream,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.creamDark, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.creamDark, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.espresso, width: 1.5),
            ),
          ),
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textPrimary,
            height: 1.4,
          ),
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
                onTap: _isSubmitting ? null : _confirmDecline,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.rust,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    _isSubmitting ? 'Declining…' : 'Decline',
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
