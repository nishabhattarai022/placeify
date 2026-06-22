import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../profile/presentation/widgets/shared/profile_submit_button.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/models/order.dart';
import '../providers/orders_provider.dart';

abstract final class OrderCancelSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) {
    if (!order.isCancellable) return Future<void>.value();

    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _OrderReasonSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        order: order,
        isCancel: true,
      ),
    );
  }
}

abstract final class OrderReturnSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    Order order,
  ) {
    if (!order.isDelivered) return Future<void>.value();

    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _OrderReasonSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        order: order,
        isCancel: false,
      ),
    );
  }
}

class _OrderReasonSheetBody extends ConsumerStatefulWidget {
  const _OrderReasonSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.order,
    required this.isCancel,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final Order order;
  final bool isCancel;

  @override
  ConsumerState<_OrderReasonSheetBody> createState() =>
      _OrderReasonSheetBodyState();
}

class _OrderReasonSheetBodyState extends ConsumerState<_OrderReasonSheetBody> {
  String? _selectedReason;
  bool _isSubmitting = false;

  List<String> get _reasons =>
      widget.isCancel ? OrderStrings.cancelReasons : OrderStrings.returnReasons;

  Future<void> _submit() async {
    if (_isSubmitting || _selectedReason == null) return;

    final reason = _selectedReason!;
    setState(() => _isSubmitting = true);
    HapticService.light();

    if (widget.sheetContext.mounted) {
      Navigator.pop(widget.sheetContext);
    }

    final error = widget.isCancel
        ? await ref
            .read(ordersProvider.notifier)
            .cancelOrder(widget.order.id, reason)
        : await ref
            .read(ordersProvider.notifier)
            .requestReturn(widget.order.id, reason);

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    PlaceifyToast.show(
      widget.parentContext,
      widget.isCancel
          ? OrderStrings.cancelSuccess
          : OrderStrings.returnSuccess,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _selectedReason != null && !_isSubmitting;
    final maxSheetHeight = MediaQuery.sizeOf(context).height * 0.75;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlaceifyBottomSheetHeader(
              title: widget.isCancel
                  ? OrderStrings.cancelSheetTitle
                  : OrderStrings.returnSheetTitle,
              subtitle: widget.isCancel
                  ? OrderStrings.cancelSheetSubtitle
                  : OrderStrings.returnSheetSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              OrderStrings.reasonLabel,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final reason in _reasons)
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
            const SizedBox(height: AppSpacing.xl),
            ProfileSubmitButton(
              label: _isSubmitting
                  ? 'Submitting…'
                  : widget.isCancel
                      ? OrderStrings.confirmCancel
                      : OrderStrings.confirmReturn,
              onPressed: canSubmit ? _submit : () {},
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        HapticService.light();
                        Navigator.pop(widget.sheetContext);
                      },
                child: Text(
                  OrderStrings.keepOrder,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
