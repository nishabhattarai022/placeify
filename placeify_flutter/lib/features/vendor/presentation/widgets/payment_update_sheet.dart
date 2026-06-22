import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart' show OrderPaymentStatus;
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_submit_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/enums/payment_status.dart';
import '../providers/vendor_payments_provider.dart';

abstract final class PaymentUpdateSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required String orderId,
    required String orderLabel,
    required OrderPaymentStatus orderPaymentStatus,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _PaymentUpdateSheetBody(
        key: const ValueKey('payment-update-sheet'),
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        orderId: orderId,
        orderLabel: orderLabel,
        orderPaymentStatus: orderPaymentStatus,
      ),
    );
  }
}

class _PaymentUpdateSheetBody extends StatefulWidget {
  const _PaymentUpdateSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.orderId,
    required this.orderLabel,
    required this.orderPaymentStatus,
    super.key,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final String orderId;
  final String orderLabel;
  final OrderPaymentStatus orderPaymentStatus;

  @override
  State<_PaymentUpdateSheetBody> createState() =>
      _PaymentUpdateSheetBodyState();
}

class _PaymentUpdateSheetBodyState extends State<_PaymentUpdateSheetBody> {
  late final TextEditingController _noteController;
  late final FocusNode _noteFocusNode;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _noteFocusNode.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String get _actionLabel => switch (widget.orderPaymentStatus) {
        OrderPaymentStatus.unpaid => 'Mark payment received',
        OrderPaymentStatus.paymentReceived => 'Confirm payment',
        OrderPaymentStatus.paymentConfirmed => 'Payment confirmed',
      };

  Future<void> _submit() async {
    if (_isSubmitting ||
        widget.orderPaymentStatus == OrderPaymentStatus.paymentConfirmed) {
      return;
    }

    final note = _noteController.text.trim();
    FocusScope.of(context).unfocus();

    setState(() => _isSubmitting = true);
    HapticService.light();

    if (widget.sheetContext.mounted) {
      Navigator.pop(widget.sheetContext);
    }

    final error = await widget.ref
        .read(vendorPaymentsProvider.notifier)
        .updateOrderPayment(
          orderId: widget.orderId,
          status: PaymentStatus.paid,
          note: note,
        );

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    PlaceifyToast.show(widget.parentContext, 'Payment status updated');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final availableHeight =
        mediaQuery.size.height - mediaQuery.viewInsets.bottom;
    final maxSheetHeight = availableHeight * 0.75;
    final canSubmit =
        widget.orderPaymentStatus != OrderPaymentStatus.paymentConfirmed;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlaceifyBottomSheetHeader(
              title: 'Update payment status',
              subtitle: widget.orderLabel,
            ),
            const SizedBox(height: 16),
            Text(
              canSubmit
                  ? 'Record the next payment step for this order.'
                  : 'Payment is fully confirmed for this order.',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            if (canSubmit) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                focusNode: _noteFocusNode,
                enabled: !_isSubmitting,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => _noteFocusNode.unfocus(),
                decoration: InputDecoration(
                  hintText: 'Add a note (optional)',
                  filled: true,
                  fillColor: AppColors.cream,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ProfileSubmitButton(
                label: _isSubmitting ? 'Saving…' : _actionLabel,
                onPressed: _isSubmitting ? () {} : _submit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
