import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/widgets/placeify_action_row.dart';
import 'package:placeify/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify/core/widgets/toast_overlay.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/domain/models/vendor_application.dart';
import 'package:placeify/features/admin/presentation/providers/admin_vendors_provider.dart';

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
        PlaceifyActionRow(
          cancelLabel: 'Cancel',
          confirmLabel: _isSubmitting ? 'Reinstating…' : 'Reinstate',
          confirmColor: AppColors.sage,
          isConfirmLoading: _isSubmitting,
          onCancel: _isSubmitting
              ? null
              : () {
                  HapticService.light();
                  Navigator.pop(widget.sheetContext);
                },
          onConfirm: _isSubmitting ? null : _confirmReinstate,
        ),
      ],
    );
  }
}
