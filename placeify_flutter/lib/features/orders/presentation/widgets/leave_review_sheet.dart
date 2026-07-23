import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart' show Review;
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/cart/data/product_id_codec.dart';
import 'package:placeify_flutter/core/debug/agent_debug_log.dart';
import 'package:placeify_flutter/features/orders/domain/models/order.dart';
import 'package:placeify_flutter/features/orders/domain/models/order_item.dart';
import 'package:placeify_flutter/features/orders/presentation/providers/orders_provider.dart';
import 'package:placeify_flutter/features/orders/presentation/providers/submitted_order_reviews_provider.dart';
import 'package:placeify_flutter/features/product_detail/presentation/providers/product_reviews_provider.dart';
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

class _LeaveReviewSheetBody extends ConsumerStatefulWidget {
  const _LeaveReviewSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.order,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final Order order;

  @override
  ConsumerState<_LeaveReviewSheetBody> createState() =>
      _LeaveReviewSheetBodyState();
}

class _LeaveReviewSheetBodyState extends ConsumerState<_LeaveReviewSheetBody> {
  late final TextEditingController _commentController;
  int _rating = 5;
  bool _isSubmitting = false;
  bool _isLoading = true;
  String? _loadError;
  List<OrderItem> _items = const [];
  OrderItem? _selectedItem;
  Review? _existingReview;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      var items = widget.order.items;
      final needsDetail = items.isEmpty ||
          items.any(
            (item) => ProductIdCodec.toDatabaseId(item.productId) == null,
          );

      if (needsDetail) {
        final detail = await ref.read(orderByIdProvider(widget.order.id).future);
        if (detail != null && detail.items.isNotEmpty) {
          items = detail.items;
        }
      }

      if (items.isEmpty) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _loadError = 'No items to review.';
        });
        return;
      }

      OrderItem selected = items.first;
      Review? existing;
      for (final item in items) {
        final found = await ref
            .read(productReviewsProvider(item.productId).notifier)
            .loadMyReviewForOrder(widget.order.id);
        if (found != null) {
          selected = item;
          existing = found;
          break;
        }
      }

      // If none found yet, still check first item (covers multi-item unreviewed).
      existing ??= await ref
          .read(productReviewsProvider(selected.productId).notifier)
          .loadMyReviewForOrder(widget.order.id);

      if (!mounted) return;
      // #region agent log
      agentDebugLog(
        location: 'leave_review_sheet.dart:_bootstrap',
        message: 'Review sheet bootstrap complete',
        hypothesisId: 'R1',
        data: {
          'orderId': widget.order.id,
          'itemCount': items.length,
          'selectedProductId': selected.productId,
          'hasExisting': existing != null,
          'existingReviewId': existing?.id,
          'existingRating': existing?.rating,
          'existingCommentLen': existing?.comment?.trim().length ?? 0,
        },
      );
      // #endregion
      setState(() {
        _items = items;
        _selectedItem = selected;
        _existingReview = existing;
        _rating = existing?.rating ?? 5;
        _commentController.text = existing?.comment?.trim() ?? '';
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError = 'Could not load review details.';
      });
    }
  }

  Future<void> _onProductChanged(OrderItem? item) async {
    if (item == null || _isSubmitting) return;
    setState(() {
      _selectedItem = item;
      _isLoading = true;
    });
    final existing = await ref
        .read(productReviewsProvider(item.productId).notifier)
        .loadMyReviewForOrder(widget.order.id);
    if (!mounted) return;
    setState(() {
      _existingReview = existing;
      _rating = existing?.rating ?? 5;
      _commentController.text = existing?.comment?.trim() ?? '';
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting || _selectedItem == null) return;

    setState(() => _isSubmitting = true);
    HapticService.light();

    final reviews = ref.read(
      productReviewsProvider(_selectedItem!.productId).notifier,
    );
    final existing = _existingReview;
    final isUpdate = existing?.id != null;
    // #region agent log
    agentDebugLog(
      location: 'leave_review_sheet.dart:_submit',
      message: 'Review submit path chosen',
      hypothesisId: 'R3',
      data: {
        'orderId': widget.order.id,
        'productId': _selectedItem!.productId,
        'isUpdate': isUpdate,
        'reviewId': existing?.id,
        'rating': _rating,
      },
    );
    // #endregion
    final error = isUpdate
        ? await reviews.updateMyReview(
            reviewId: existing!.id!,
            rating: _rating,
            comment: _commentController.text,
          )
        : await reviews.submit(
            orderId: widget.order.id,
            rating: _rating,
            comment: _commentController.text,
          );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      if (widget.parentContext.mounted) {
        PlaceifyToast.show(widget.parentContext, error);
      }
      return;
    }

    ref
        .read(submittedOrderReviewsProvider.notifier)
        .markReviewed(widget.order.id);

    final successMessage = isUpdate
        ? 'Review updated successfully.'
        : 'Review submitted successfully.';

    // Show toast on the parent before dismissing the sheet so feedback is visible.
    if (widget.parentContext.mounted) {
      PlaceifyToast.show(widget.parentContext, successMessage);
    }
    if (widget.sheetContext.mounted) {
      Navigator.pop(widget.sheetContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null || _selectedItem == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          _loadError ?? 'No items to review.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final isEdit = _existingReview != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlaceifyBottomSheetHeader(
          title: isEdit ? 'Update review' : 'Leave a review',
          subtitle: _selectedItem!.productName,
        ),
        if (_items.length > 1) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<OrderItem>(
            value: _selectedItem,
            items: [
              for (final item in _items)
                DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.productName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
            onChanged: _isSubmitting ? null : _onProductChanged,
            decoration: const InputDecoration(
              labelText: 'Product',
              border: OutlineInputBorder(),
            ),
          ),
        ],
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
          label: _isSubmitting
              ? (isEdit ? 'Updating…' : 'Submitting…')
              : (isEdit ? 'Update review' : 'Submit review'),
          onPressed: _isSubmitting ? () {} : _submit,
        ),
      ],
    );
  }
}
