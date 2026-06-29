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
import 'package:placeify_flutter/features/admin/presentation/providers/vendor_applications_provider.dart';

abstract final class VendorApplicationDeclineSheet {
  static Future<void> show(
    BuildContext context, {
    required VendorApplication application,
    required VoidCallback onDeclined,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorApplicationDeclineSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        application: application,
        onDeclined: onDeclined,
      ),
    );
  }
}

class _VendorApplicationDeclineSheetBody extends ConsumerStatefulWidget {
  const _VendorApplicationDeclineSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.application,
    required this.onDeclined,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final VendorApplication application;
  final VoidCallback onDeclined;

  @override
  ConsumerState<_VendorApplicationDeclineSheetBody> createState() =>
      _VendorApplicationDeclineSheetBodyState();
}

class _VendorApplicationDeclineSheetBodyState
    extends ConsumerState<_VendorApplicationDeclineSheetBody> {
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

  Future<void> _confirmDecline() async {
    if (!_canSubmit || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();

    final note = _selectedReason!.formatNote(
      otherDetail: _otherController.text,
    );
    final actions = ref.read(vendorApplicationActionsProvider.notifier);
    final error = await actions.decline(
      userId: widget.application.userId,
      vendorId: widget.application.vendorId,
      note: note,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() => _isSubmitting = false);
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    Navigator.pop(widget.sheetContext);

    if (!widget.parentContext.mounted) return;

    widget.onDeclined();
    PlaceifyToast.show(widget.parentContext, AdminStrings.vendorDeclined);
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
              'The applicant can re-register after a decline. A reason is required.',
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AdminStrings.declineReasonLabel,
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
              onChanged: _isSubmitting
                  ? null
                  : (value) => setState(() => _selectedReason = value),
            ),
          ),
        ),
        if (_selectedReason == DeclineReason.other) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _otherController,
            enabled: !_isSubmitting,
            onChanged: (_) => setState(() {}),
            maxLines: 3,
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
            onTap: _canSubmit && !_isSubmitting ? _confirmDecline : null,
            child: Container(
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _canSubmit ? AppColors.rust : AppColors.creamDark,
                borderRadius: AppRadii.pill,
              ),
              child: Text(
                _isSubmitting ? 'Declining…' : AdminStrings.confirmDecline,
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
