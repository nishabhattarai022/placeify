import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_submit_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/placeify_dialog.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/enums/payment_status.dart';
import '../providers/vendor_payments_provider.dart';

abstract final class PaymentUpdateSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required String orderId,
    required String orderLabel,
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
    super.key,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final String orderId;
  final String orderLabel;

  @override
  State<_PaymentUpdateSheetBody> createState() =>
      _PaymentUpdateSheetBodyState();
}

class _PaymentUpdateSheetBodyState extends State<_PaymentUpdateSheetBody> {
  PaymentStatus _selected = PaymentStatus.paid;
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

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final note = _noteController.text.trim();
    FocusScope.of(context).unfocus();

    if (_selected == PaymentStatus.refunded) {
      final confirmed = await PlaceifyDialog.showConfirm(
        widget.sheetContext,
        title: 'Confirm refund?',
        message:
            'Refunding marks this payment as reversed. This action is recorded in the audit trail.',
        confirmLabel: 'Confirm refund',
        confirmColor: AppColors.vendorForest,
        isDestructive: true,
      );
      if (confirmed != true || !mounted) return;
    }

    setState(() => _isSubmitting = true);
    HapticService.light();

    if (widget.sheetContext.mounted) {
      Navigator.pop(widget.sheetContext);
    }

    final error = await widget.ref
        .read(vendorPaymentsProvider.notifier)
        .updateOrderPayment(
          orderId: widget.orderId,
          status: _selected,
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusOption(
                  label: 'Received',
                  selected: _selected == PaymentStatus.paid,
                  onTap: _isSubmitting
                      ? null
                      : () => setState(() => _selected = PaymentStatus.paid),
                ),
                _StatusOption(
                  label: 'Failed',
                  selected: _selected == PaymentStatus.failed,
                  onTap: _isSubmitting
                      ? null
                      : () => setState(() => _selected = PaymentStatus.failed),
                ),
                _StatusOption(
                  label: 'Refunded',
                  selected: _selected == PaymentStatus.refunded,
                  onTap: _isSubmitting
                      ? null
                      : () =>
                          setState(() => _selected = PaymentStatus.refunded),
                ),
              ],
            ),
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
              label: _isSubmitting ? 'Saving…' : 'Save update',
              onPressed: _isSubmitting ? () {} : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onTap == null ? null : (_) => onTap!(),
      selectedColor: AppColors.vendorForestBg,
      labelStyle: TextStyle(
        color: selected ? AppColors.vendorForest : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
