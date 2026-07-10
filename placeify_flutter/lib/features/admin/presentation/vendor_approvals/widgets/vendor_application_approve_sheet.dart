import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_spacing.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/placeify_action_row.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/vendor_applications_provider.dart';

abstract final class VendorApplicationApproveSheet {
  static Future<void> show(
    BuildContext context, {
    required VendorApplication application,
    required VoidCallback onApproved,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorApplicationApproveSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        application: application,
        onApproved: onApproved,
      ),
    );
  }
}

class _VendorApplicationApproveSheetBody extends ConsumerStatefulWidget {
  const _VendorApplicationApproveSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.application,
    required this.onApproved,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final VendorApplication application;
  final VoidCallback onApproved;

  @override
  ConsumerState<_VendorApplicationApproveSheetBody> createState() =>
      _VendorApplicationApproveSheetBodyState();
}

class _VendorApplicationApproveSheetBodyState
    extends ConsumerState<_VendorApplicationApproveSheetBody> {
  bool _isSubmitting = false;

  Future<void> _confirmApprove() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();

    final actions = ref.read(vendorApplicationActionsProvider.notifier);
    final error = await actions.approve(
      userId: widget.application.userId,
      vendorId: widget.application.vendorId,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() => _isSubmitting = false);
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    Navigator.pop(widget.sheetContext);

    if (!widget.parentContext.mounted) return;

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
        PlaceifyActionRow(
          cancelLabel: 'Cancel',
          confirmLabel: _isSubmitting ? 'Approving…' : 'Approve',
          confirmColor: AppColors.sage,
          isConfirmLoading: _isSubmitting,
          onCancel: _isSubmitting
              ? null
              : () {
                  HapticService.light();
                  Navigator.pop(widget.sheetContext);
                },
          onConfirm: _isSubmitting ? null : _confirmApprove,
        ),
      ],
    );
  }
}
