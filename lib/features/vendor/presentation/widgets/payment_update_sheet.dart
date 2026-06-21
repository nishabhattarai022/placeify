import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/enums/payment_status.dart';
import '../providers/vendor_payments_provider.dart';

class PaymentUpdateSheet {
  PaymentUpdateSheet._();

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
        parentContext: context,
        sheetContext: sheetContext,
        orderId: orderId,
        orderLabel: orderLabel,
      ),
    );
  }
}

class _PaymentUpdateSheetBody extends ConsumerStatefulWidget {
  const _PaymentUpdateSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.orderId,
    required this.orderLabel,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final String orderId;
  final String orderLabel;

  @override
  ConsumerState<_PaymentUpdateSheetBody> createState() =>
      _PaymentUpdateSheetBodyState();
}

class _PaymentUpdateSheetBodyState extends ConsumerState<_PaymentUpdateSheetBody> {
  PaymentStatus _selected = PaymentStatus.paid;
  late final TextEditingController _noteController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();

    if (_selected == PaymentStatus.refunded) {
      final confirmed = await showDialog<bool>(
        context: widget.sheetContext,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Confirm refund?'),
          content: const Text(
            'Refunding marks this payment as reversed. This action is recorded in the audit trail.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Confirm refund'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    setState(() => _isSubmitting = true);

    final error = await ref.read(vendorPaymentsProvider.notifier).updateOrderPayment(
          orderId: widget.orderId,
          status: _selected,
          note: _noteController.text.trim(),
        );

    if (!mounted) return;

    if (error != null) {
      setState(() => _isSubmitting = false);
      if (widget.parentContext.mounted) {
        PlaceifyToast.show(widget.parentContext, error);
      }
      return;
    }

    if (widget.sheetContext.mounted) {
      Navigator.pop(widget.sheetContext);
    }
    if (widget.parentContext.mounted) {
      PlaceifyToast.show(widget.parentContext, 'Payment status updated');
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxSheetHeight = MediaQuery.sizeOf(context).height * 0.75;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      child: SingleChildScrollView(
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
              enabled: !_isSubmitting,
              maxLines: 3,
              textInputAction: TextInputAction.done,
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
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.vendorForest,
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: _isSubmitting ? null : _submit,
              child: Text(_isSubmitting ? 'Saving…' : 'Save update'),
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
