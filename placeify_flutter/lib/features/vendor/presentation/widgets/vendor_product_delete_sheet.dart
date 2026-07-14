import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_action_row.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../providers/vendor_products_provider.dart';

abstract final class VendorProductDeleteSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required int count,
    required List<String> productIds,
    required VoidCallback onDeleted,
  }) {
    if (count == 0) return Future<void>.value();

    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorProductDeleteSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        count: count,
        productIds: productIds,
        onDeleted: onDeleted,
      ),
    );
  }
}

class _VendorProductDeleteSheetBody extends StatefulWidget {
  const _VendorProductDeleteSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.count,
    required this.productIds,
    required this.onDeleted,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final int count;
  final List<String> productIds;
  final VoidCallback onDeleted;

  @override
  State<_VendorProductDeleteSheetBody> createState() =>
      _VendorProductDeleteSheetBodyState();
}

class _VendorProductDeleteSheetBodyState
    extends State<_VendorProductDeleteSheetBody> {
  bool _isDeleting = false;

  Future<void> _confirmDelete() async {
    if (_isDeleting) return;

    setState(() => _isDeleting = true);
    HapticService.medium();
    Navigator.pop(widget.sheetContext);

    final error = await widget.ref
        .read(vendorProductsProvider.notifier)
        .deleteProducts(widget.productIds);

    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
    } else {
      widget.onDeleted();
      final label = widget.count == 1 ? 'Product deleted' : 'Products deleted';
      PlaceifyToast.show(widget.parentContext, '$label ✓');
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.count == 1
        ? 'Delete this product?'
        : 'Delete ${widget.count} products?';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: title,
          subtitle:
              'This cannot be undone. Selected products will be permanently removed from your catalog.',
        ),
        const SizedBox(height: AppSpacing.xl),
        PlaceifyActionRow(
          cancelLabel: 'Cancel',
          confirmLabel: _isDeleting ? 'Deleting…' : 'Delete',
          confirmColor: AppColors.rust,
          isConfirmLoading: _isDeleting,
          onCancel: _isDeleting
              ? null
              : () {
                  HapticService.light();
                  Navigator.pop(widget.sheetContext);
                },
          onConfirm: _isDeleting ? null : _confirmDelete,
        ),
      ],
    );
  }
}
