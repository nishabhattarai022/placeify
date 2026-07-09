import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_spacing.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_routes.dart';
import 'package:placeify_flutter/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_product_complaint_summary.dart';
import 'package:placeify_flutter/features/admin/domain/models/admin_product_summary.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_products_provider.dart';

abstract final class AdminRemoveProductSheet {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required AdminProductDetail product,
    required VoidCallback onUpdated,
  }) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _AdminRemoveProductSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        ref: ref,
        product: product,
        onUpdated: onUpdated,
      ),
    );
  }
}

class _AdminRemoveProductSheetBody extends StatefulWidget {
  const _AdminRemoveProductSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.ref,
    required this.product,
    required this.onUpdated,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final WidgetRef ref;
  final AdminProductDetail product;
  final VoidCallback onUpdated;

  @override
  State<_AdminRemoveProductSheetBody> createState() =>
      _AdminRemoveProductSheetBodyState();
}

class _AdminRemoveProductSheetBodyState
    extends State<_AdminRemoveProductSheetBody> {
  bool _isSubmitting = false;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _confirmRemove() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    HapticService.medium();

    final error = await widget.ref
        .read(adminProductActionsProvider.notifier)
        .removeProduct(productId: widget.product.productId, reason: reason);

    if (!mounted) return;
    if (widget.sheetContext.mounted) Navigator.pop(widget.sheetContext);
    if (!widget.parentContext.mounted) return;

    if (error != null) {
      PlaceifyToast.show(widget.parentContext, error);
      return;
    }

    PlaceifyToast.show(widget.parentContext, AdminStrings.productRemoved);
    widget.onUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AdminStrings.removeProductTitle,
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.product.productName,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: AdminStrings.removeProductReasonLabel,
              filled: true,
              fillColor: AppColors.warmWhite,
              border: OutlineInputBorder(borderRadius: AppRadii.md),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.pop(widget.sheetContext),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _confirmRemove,
                  style: FilledButton.styleFrom(backgroundColor: AppColors.rust),
                  child: Text(_isSubmitting ? 'Removing…' : 'Remove'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminProductDetailScreen extends ConsumerWidget {
  const AdminProductDetailScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(adminProductDetailProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.espresso),
        title: const Text(
          AdminStrings.productDetailTitle,
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.espresso,
          ),
        ),
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(adminProductDetailProvider(productId)),
            child: Text(AdminStrings.retry),
          ),
        ),
        data: (product) {
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    24,
                  ),
                  children: [
                    if (product.thumbnailUrl != null &&
                        product.thumbnailUrl!.trim().isNotEmpty)
                      ClipRRect(
                        borderRadius: AppRadii.md,
                        child: Image.network(
                          product.thumbnailUrl!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      product.productName,
                      style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.currencyFull(product.price),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.espresso,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _InfoSection(
                      title: 'Vendor',
                      lines: [
                        product.shopName,
                        product.ownerName,
                        product.vendorEmail,
                      ],
                      onVendorTap: () => context.push(
                        AdminRoutes.vendorDetail(product.vendorId),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _InfoSection(
                      title: 'Catalog',
                      lines: [
                        'Category: ${product.categoryName ?? 'Uncategorized'}',
                        'Status: ${product.isDeleted ? 'deleted' : product.status}',
                        'Created: ${Formatters.shortDate(product.createdAt)}',
                        'Updated: ${Formatters.shortDate(product.updatedAt)}',
                        if (product.removedReason != null)
                          'Removal reason: ${product.removedReason}',
                      ],
                    ),
                    if (product.complaints.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Complaints',
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: 8),
                      ...product.complaints.map(
                        (complaint) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.warmWhite,
                            borderRadius: AppRadii.md,
                            border: Border.all(color: AppColors.creamDark),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                complaint.reason,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (complaint.description != null) ...[
                                const SizedBox(height: 4),
                                Text(complaint.description!),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                '${complaint.status} · ${Formatters.shortDate(complaint.createdAt)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _ProductActionsBar(
                product: product,
                onUpdated: () {
                  ref.invalidate(adminProductDetailProvider(productId));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.lines,
    this.onVendorTap,
  });

  final String title;
  final List<String> lines;
  final VoidCallback? onVendorTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.sectionTitle),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(line),
            ),
          if (onVendorTap != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onVendorTap, child: const Text('View vendor')),
          ],
        ],
      ),
    );
  }
}

class _ProductActionsBar extends ConsumerWidget {
  const _ProductActionsBar({
    required this.product,
    required this.onUpdated,
  });

  final AdminProductDetail product;
  final VoidCallback onUpdated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canRemove = !product.isRemoved;
    final canRestore = product.isRemoved;

    if (!canRemove && !canRestore) return const SizedBox.shrink();

    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.warmWhite,
        border: Border(top: BorderSide(color: AppColors.creamDark, width: 1.5)),
      ),
      child: Row(
        children: [
          if (canRestore)
            Expanded(
              child: FilledButton(
                onPressed: () async {
                  final error = await ref
                      .read(adminProductActionsProvider.notifier)
                      .restoreProduct(product.productId);
                  if (!context.mounted) return;
                  if (error != null) {
                    PlaceifyToast.show(context, error);
                    return;
                  }
                  PlaceifyToast.show(context, AdminStrings.productRestored);
                  onUpdated();
                },
                child: const Text('Restore Product'),
              ),
            ),
          if (canRemove) ...[
            if (canRestore) const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () => AdminRemoveProductSheet.show(
                  context,
                  ref,
                  product: product,
                  onUpdated: onUpdated,
                ),
                style: FilledButton.styleFrom(backgroundColor: AppColors.rust),
                child: const Text('Remove Product'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
