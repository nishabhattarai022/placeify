import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../profile/presentation/widgets/shared/profile_submit_button.dart';
import '../../domain/enums/order_status.dart';
import '../../domain/models/vendor_order.dart';
import '../providers/vendor_orders_provider.dart';

const _rejectReasons = [
  'Out of stock',
  'Unable to fulfill customization',
  'Delivery area not supported',
  'Duplicate or test order',
];

abstract final class OrderActionSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    VendorOrder order,
  ) {
    if (order.status != OrderStatus.pending) return Future<void>.value();

    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _OrderActionSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        order: order,
      ),
    );
  }
}

class _OrderActionSheetBody extends StatefulWidget {
  const _OrderActionSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.order,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final VendorOrder order;

  @override
  State<_OrderActionSheetBody> createState() => _OrderActionSheetBodyState();
}

class _OrderActionSheetBodyState extends State<_OrderActionSheetBody> {
  String? _selectedReason;
  bool _isSubmitting = false;

  Future<void> _accept() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.light();
    Navigator.pop(widget.sheetContext);

    final result = await widget.ref
        .read(vendorOrdersProvider.notifier)
        .acceptOrder(widget.order.id);

    if (!widget.parentContext.mounted) return;

    if (result.error != null) {
      PlaceifyToast.show(widget.parentContext, result.error!);
    } else {
      PlaceifyToast.show(
        widget.parentContext,
        result.message ?? 'Order accepted ✓',
      );
    }
  }

  Future<void> _reject() async {
    if (_isSubmitting || _selectedReason == null) return;

    setState(() => _isSubmitting = true);
    HapticService.light();

    final result = await widget.ref
        .read(vendorOrdersProvider.notifier)
        .rejectOrder(
          widget.order.id,
          reason: _selectedReason!,
        );

    if (!widget.parentContext.mounted) return;

    if (result.error != null) {
      setState(() => _isSubmitting = false);
      PlaceifyToast.show(widget.parentContext, result.error!);
      return;
    }

    Navigator.pop(widget.sheetContext);
    PlaceifyToast.show(
      widget.parentContext,
      result.message ?? 'Order rejected',
    );
  }

  @override
  Widget build(BuildContext context) {
    final canReject = _selectedReason != null && !_isSubmitting;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Order #${widget.order.orderNumber}',
          subtitle: widget.order.productName,
        ),
        const SizedBox(height: AppSpacing.lg),
        ProfileSubmitButton(
          label: _isSubmitting ? 'Accepting…' : 'Accept order',
          onPressed: _isSubmitting ? () {} : _accept,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Reject order',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Select a reason before rejecting.',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final reason in _rejectReasons)
          PlaceifySelectTile(
            label: reason,
            selected: _selectedReason == reason,
            onTap: _isSubmitting
                ? () {}
                : () {
                    HapticService.selection();
                    setState(() => _selectedReason = reason);
                  },
          ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: canReject ? _reject : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.rust,
              disabledBackgroundColor: AppColors.creamDark,
              foregroundColor: Colors.white,
              disabledForegroundColor: AppColors.textMuted,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text(
              _isSubmitting ? 'Rejecting…' : 'Confirm reject',
            ),
          ),
        ),
      ],
    );
  }
}
