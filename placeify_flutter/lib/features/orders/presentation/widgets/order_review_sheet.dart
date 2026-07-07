import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/models/order.dart';
import '../../../product_detail/presentation/providers/product_reviews_provider.dart';
import '../../../profile/presentation/widgets/shared/profile_form_field.dart';
import '../../../profile/presentation/widgets/shared/profile_submit_button.dart';

Future<void> showOrderReviewSheet(
  BuildContext context,
  WidgetRef ref, {
  required Order order,
}) async {
  if (order.items.isEmpty) {
    PlaceifyToast.show(context, 'No items to review.');
    return;
  }

  final item = order.items.first;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _OrderReviewSheet(
      productId: item.productId,
      productName: item.productName,
      orderId: order.id,
    ),
  );
}

class _OrderReviewSheet extends ConsumerStatefulWidget {
  const _OrderReviewSheet({
    required this.productId,
    required this.productName,
    required this.orderId,
  });

  final String productId;
  final String productName;
  final String orderId;

  @override
  ConsumerState<_OrderReviewSheet> createState() => _OrderReviewSheetState();
}

class _OrderReviewSheetState extends ConsumerState<_OrderReviewSheet> {
  int _rating = 5;
  final _commentController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);

    final error = await ref
        .read(productReviewsProvider(widget.productId).notifier)
        .submit(
          orderId: widget.orderId,
          rating: _rating,
          comment: _commentController.text,
        );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (error != null) {
      PlaceifyToast.show(context, error);
      return;
    }

    PlaceifyToast.show(context, 'Review submitted ✓');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review ${widget.productName}',
            style: const TextStyle(
              fontFamily: 'Fraunces',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.accent,
                    size: 32,
                  ),
                ),
            ],
          ),
          ProfileFormField(
            label: 'Comment (optional)',
            child: ProfileTextInput(
              controller: _commentController,
              hint: 'Share your experience',
              maxLines: 4,
            ),
          ),
          const SizedBox(height: 8),
          ProfileSubmitButton(
            label: _submitting ? 'Submitting…' : 'Submit Review',
            onPressed: _submitting ? () {} : _submit,
          ),
        ],
      ),
    );
  }
}
