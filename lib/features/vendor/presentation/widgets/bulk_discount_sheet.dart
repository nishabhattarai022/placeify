import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify/features/profile/presentation/widgets/shared/profile_submit_button.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/percent_input_formatter.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../providers/vendor_products_provider.dart';

abstract final class BulkDiscountSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required int count,
    required List<String> productIds,
    required VoidCallback onApplied,
  }) {
    if (count == 0) return Future<void>.value();

    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _BulkDiscountSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        count: count,
        productIds: productIds,
        onApplied: onApplied,
      ),
    );
  }
}

class _BulkDiscountSheetBody extends StatefulWidget {
  const _BulkDiscountSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.count,
    required this.productIds,
    required this.onApplied,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final int count;
  final List<String> productIds;
  final VoidCallback onApplied;

  @override
  State<_BulkDiscountSheetBody> createState() => _BulkDiscountSheetBodyState();
}

class _BulkDiscountSheetBodyState extends State<_BulkDiscountSheetBody> {
  final _discountController = TextEditingController();
  bool _isApplying = false;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _apply() async {
    if (_isApplying) return;

    final discount = double.tryParse(_discountController.text.trim());
    if (discount == null || discount <= 0 || discount > 100) {
      PlaceifyToast.show(
        widget.parentContext,
        'Enter a discount between 1 and 100.',
      );
      return;
    }

    setState(() => _isApplying = true);
    HapticService.medium();
    Navigator.pop(widget.sheetContext);

    final error = await widget.ref
        .read(vendorProductsProvider.notifier)
        .applyBulkDiscount(widget.productIds, discount);

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
    } else {
      widget.onApplied();
      PlaceifyToast.show(
        widget.parentContext,
        'Discount applied to ${widget.count} products ✓',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Apply bulk discount',
          subtitle: '${widget.count} selected products',
        ),
        const SizedBox(height: 12),
        ProfileFormField(
          label: 'Discount percent',
          child: ProfileTextInput(
            controller: _discountController,
            hint: 'e.g. 15',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: const [
              PercentInputFormatter(min: 1, max: 100),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sale price will be recalculated from each product list price.',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.textMuted,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 16),
        _isApplying
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : ProfileSubmitButton(
                label: 'Apply discount',
                onPressed: _apply,
              ),
      ],
    );
  }
}
