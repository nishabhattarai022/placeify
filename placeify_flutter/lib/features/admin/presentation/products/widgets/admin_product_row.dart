import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_product_summary.dart';

class AdminProductRow extends StatelessWidget {
  const AdminProductRow({
    required this.product,
    required this.onTap,
    super.key,
  });

  final AdminProductSummary product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final category = product.categoryName ?? 'Uncategorized';
    final meta =
        '${Formatters.shortDate(product.createdAt)} · $category · ${product.shopName}';

    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: AppRadii.md,
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: Row(
          children: [
            _ProductThumb(
              thumbnailUrl: product.thumbnailUrl,
              label: product.productName,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meta,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      HapticService.light();
                      context.push(AdminRoutes.vendorDetail(product.vendorId));
                    },
                    child: Text(
                      'Uploaded by ${product.shopName} · ${product.ownerName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.adminSlate,
                      ),
                    ),
                  ),
                  if (product.complaintCount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${product.complaintCount} complaint${product.complaintCount == 1 ? '' : 's'}'
                      '${product.latestComplaintAt == null ? '' : ' · latest ${Formatters.shortDate(product.latestComplaintAt!)}'}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.rust,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.currencyFull(product.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 6),
                _ProductStatusChip(
                  status: product.isDeleted ? 'deleted' : product.status,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({required this.thumbnailUrl, required this.label});

  final String? thumbnailUrl;
  final String label;

  @override
  Widget build(BuildContext context) {
    final url = thumbnailUrl?.trim();
    return ClipRRect(
      borderRadius: AppRadii.sm,
      child: Container(
        width: 52,
        height: 52,
        color: AppColors.creamDark,
        child: url != null && url.isNotEmpty
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(label),
              )
            : _fallback(label),
      ),
    );
  }

  Widget _fallback(String label) {
    final initial = label.isNotEmpty ? label[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.adminSlate,
        ),
      ),
    );
  }
}

class _ProductStatusChip extends StatelessWidget {
  const _ProductStatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      'active' => (
          AppColors.sage.withValues(alpha: 0.14),
          AppColors.sage,
        ),
      'flagged' => (
          AppColors.accent.withValues(alpha: 0.14),
          AppColors.accent,
        ),
      'removed' || 'deleted' => (
          AppColors.coral.withValues(alpha: 0.14),
          AppColors.coral,
        ),
      _ => (
          AppColors.creamDark,
          AppColors.textMuted,
        ),
    };

    final label = status.isEmpty
        ? 'Unknown'
        : status[0].toUpperCase() + status.substring(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
