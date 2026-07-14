import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/profile_sub_hero.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_submit_button.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_review.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../core/widgets/toast_overlay.dart';

class VendorReviewsScreen extends StatefulWidget {
  const VendorReviewsScreen({super.key});

  @override
  State<VendorReviewsScreen> createState() => _VendorReviewsScreenState();
}

class _VendorReviewsScreenState extends State<VendorReviewsScreen> {
  late List<VendorReview> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = List<VendorReview>.from(vendorMockReviews);
  }

  void _openReplySheet(VendorReview review) {
    HapticService.light();
    PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _ReplySheet(
        review: review,
        onSubmit: (reply) {
          setState(() {
            final index = _reviews.indexWhere((item) => item.id == review.id);
            if (index >= 0) {
              final current = _reviews[index];
              _reviews[index] = VendorReview(
                id: current.id,
                customerName: current.customerName,
                productName: current.productName,
                rating: current.rating,
                comment: current.comment,
                createdAt: current.createdAt,
                vendorReply: reply,
              );
            }
          });
          Navigator.pop(sheetContext);
          PlaceifyToast.show(context, 'Reply posted ✓');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: ProfileSubHero(
              title: 'Reviews',
              subtitle: 'customer feedback',
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, AppSpacing.xxl),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                _reviews
                    .map(
                      (review) => _ReviewCard(
                        review: review,
                        onReply: () => _openReplySheet(review),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.review,
    required this.onReply,
  });

  final VendorReview review;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.lg,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.customerName,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: index < review.rating
                        ? AppColors.accent
                        : AppColors.creamDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${review.productName} · ${Formatters.shortDate(review.createdAt)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (review.vendorReply != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppRadii.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your reply',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review.vendorReply!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onReply,
              child: Text(review.vendorReply == null ? 'Reply' : 'Edit reply'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplySheet extends StatefulWidget {
  const _ReplySheet({
    required this.review,
    required this.onSubmit,
  });

  final VendorReview review;
  final ValueChanged<String> onSubmit;

  @override
  State<_ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends State<_ReplySheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.review.vendorReply ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlaceifyBottomSheetHeader(
          title: 'Reply to ${widget.review.customerName}',
          subtitle: widget.review.productName,
        ),
        const SizedBox(height: 12),
        ProfileFormField(
          label: 'Your response',
          child: ProfileTextInput(
            controller: _controller,
            hint: 'Thank the customer or address their feedback',
            maxLines: 4,
          ),
        ),
        const SizedBox(height: 16),
        ProfileSubmitButton(
          label: 'Post reply',
          onPressed: () {
            final reply = _controller.text.trim();
            if (reply.isEmpty) return;
            widget.onSubmit(reply);
          },
        ),
      ],
    );
  }
}
