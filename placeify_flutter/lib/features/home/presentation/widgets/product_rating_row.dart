import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/product_review_summary.dart';

/// Compact star rating + review count for product list tiles.
class ProductRatingRow extends StatelessWidget {
  const ProductRatingRow({
    required this.summary,
    this.starSize = 14,
    this.compact = false,
    super.key,
  });

  final ProductReviewSummary summary;
  final double starSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (summary.reviewCount <= 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          size: starSize,
          color: AppColors.accent,
        ),
        const SizedBox(width: 3),
        Text(
          summary.formattedRating,
          style: GoogleFonts.dmSans(
            fontSize: compact ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            compact ? '(${summary.reviewCount})' : summary.reviewCountLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(
              fontSize: compact ? 11 : 12,
              color: Colors.black38,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
