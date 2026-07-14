import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart' hide Order;
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/cart/data/product_id_codec.dart';
import 'package:placeify_flutter/features/orders/domain/models/order.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_submit_button.dart';

abstract final class LeaveReviewSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required Order order,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _LeaveReviewSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        order: order,
      ),
    );
  }
}

class _LeaveReviewSheetBody extends StatefulWidget {
  const _LeaveReviewSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.order,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final Order order;

  @override
  State<_LeaveReviewSheetBody> createState() => _LeaveReviewSheetBodyState();
}

class _LeaveReviewSheetBodyState extends State<_LeaveReviewSheetBody> {
  late final TextEditingController _commentController;
  int _rating = 5;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final orderId = int.tryParse(widget.order.id);
    final productId = ProductIdCodec.toDatabaseId(
      widget.order.items.first.productId,
    );
    if (orderId == null || productId == null) {
      PlaceifyToast.show(widget.parentContext, 'Could not submit review.');
      return;
    }

    setState(() => _isSubmitting = true);
    HapticService.light();

    try {
      await client.review.submitReview(
        productId,
        orderId,
        _rating,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
      );
      if (!widget.parentContext.mounted) return;
      Navigator.pop(widget.sheetContext);
      PlaceifyToast.show(widget.parentContext, 'Review submitted ✓');
    } on PlaceifyException catch (error) {
      if (!widget.parentContext.mounted) return;
      PlaceifyToast.show(widget.parentContext, error.message);
    } catch (_) {
      if (!widget.parentContext.mounted) return;
      PlaceifyToast.show(widget.parentContext, 'Could not submit review.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productName = widget.order.items.first.productName;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Leave a review',
          subtitle: productName,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            5,
            (index) => IconButton(
              onPressed: _isSubmitting
                  ? null
                  : () {
                      HapticService.selection();
                      setState(() => _rating = index + 1);
                    },
              icon: Icon(
                index < _rating
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: index < _rating ? AppColors.accent : AppColors.creamDark,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ProfileFormField(
          label: 'Your review',
          child: ProfileTextInput(
            controller: _commentController,
            hint: 'Share what you liked about this product',
            maxLines: 4,
          ),
        ),
        const SizedBox(height: 16),
        ProfileSubmitButton(
          label: _isSubmitting ? 'Submitting…' : 'Submit review',
          onPressed: _isSubmitting ? () {} : _submit,
        ),
      ],
    );
  }
}
