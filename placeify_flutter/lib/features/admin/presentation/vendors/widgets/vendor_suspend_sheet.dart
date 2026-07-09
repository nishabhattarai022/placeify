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
import 'package:placeify_flutter/features/admin/domain/enums/decline_reason.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_vendors_provider.dart';

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
  DeclineReason? _selectedReason;
  final _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (_selectedReason == null) return false;
    if (_selectedReason == DeclineReason.other) {
      return _otherController.text.trim().isNotEmpty;
    }
    return true;
  }

  Future<void> _confirmSuspend() async {
    if (!_canSubmit || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();
    Navigator.pop(widget.sheetContext);

    final reason = _selectedReason!.formatNote(otherDetail: _otherController.text);
    final error = await widget.ref
        .read(adminVendorActionsProvider.notifier)
        .suspend(
          userId: widget.vendor.userId,
          vendorId: widget.vendor.vendorId,
          reason: reason,
        );

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    widget.onSuspended();
    PlaceifyToast.show(widget.parentContext, AdminStrings.vendorSuspended);
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
        const SizedBox(height: AppSpacing.md),
        Text(
          AdminStrings.suspendReasonLabel,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: AppRadii.md,
            border: Border.all(color: AppColors.creamDark, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DeclineReason>(
              isExpanded: true,
              value: _selectedReason,
              hint: Text(
                AdminStrings.selectReason,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              items: DeclineReason.values
                  .map(
                    (reason) => DropdownMenuItem(
                      value: reason,
                      child: Text(reason.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedReason = value),
            ),
          ),
        ),
        if (_selectedReason == DeclineReason.other) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _otherController,
            onChanged: (_) => setState(() {}),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: AdminStrings.declineOtherHint,
              filled: true,
              fillColor: AppColors.cream,
              border: OutlineInputBorder(
                borderRadius: AppRadii.md,
                borderSide: const BorderSide(color: AppColors.creamDark),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: _canSubmit && !_isSubmitting ? _confirmSuspend : null,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _canSubmit ? AppColors.rust : AppColors.creamDark,
                borderRadius: AppRadii.pill,
              ),
              child: Text(
                _isSubmitting ? 'Suspending…' : AdminStrings.confirmSuspend,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _canSubmit ? AppColors.warmWhite : AppColors.textMuted,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
