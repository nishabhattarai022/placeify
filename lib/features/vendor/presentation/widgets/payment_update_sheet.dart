import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
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
  }) async {
    HapticService.light();

    PaymentStatus selected = PaymentStatus.paid;
    final noteController = TextEditingController();

    await PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PlaceifyBottomSheetHeader(
                  title: 'Update payment status',
                  subtitle: orderLabel,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _StatusOption(
                      label: 'Received',
                      selected: selected == PaymentStatus.paid,
                      onTap: () =>
                          setState(() => selected = PaymentStatus.paid),
                    ),
                    _StatusOption(
                      label: 'Failed',
                      selected: selected == PaymentStatus.failed,
                      onTap: () =>
                          setState(() => selected = PaymentStatus.failed),
                    ),
                    _StatusOption(
                      label: 'Refunded',
                      selected: selected == PaymentStatus.refunded,
                      onTap: () =>
                          setState(() => selected = PaymentStatus.refunded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  maxLines: 3,
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
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.vendorForest,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () async {
                    if (selected == PaymentStatus.refunded) {
                      final confirmed = await showDialog<bool>(
                        context: sheetContext,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Confirm refund?'),
                          content: const Text(
                            'Refunding marks this payment as reversed. This action is recorded in the audit trail.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: const Text('Confirm refund'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed != true) return;
                    }

                    final error = await ref
                        .read(vendorPaymentsProvider.notifier)
                        .updateOrderPayment(
                          orderId: orderId,
                          status: selected,
                          note: noteController.text.trim(),
                        );

                    if (!context.mounted) return;
                    if (error != null) {
                      PlaceifyToast.show(context, error);
                      return;
                    }

                    Navigator.pop(sheetContext);
                    PlaceifyToast.show(context, 'Payment status updated');
                  },
                  child: const Text('Save update'),
                ),
              ],
            );
          },
        );
      },
    );

    noteController.dispose();
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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.vendorForestBg,
      labelStyle: TextStyle(
        color: selected ? AppColors.vendorForest : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
