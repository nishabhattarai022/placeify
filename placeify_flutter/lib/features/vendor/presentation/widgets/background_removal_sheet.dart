import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/models/vendor_product_image_item.dart';
import '../providers/vendor_product_form_provider.dart';
import 'draggable_split_preview.dart';

/// Shows before/after preview and confirm/cancel for background removal.
class BackgroundRemovalSheet {
  BackgroundRemovalSheet._();

  static Future<void> show(
    BuildContext context,
    WidgetRef ref, {
    required VendorProductImageItem item,
  }) async {
    if (item.localPath == null) return;

    HapticService.light();

    await PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final form = ref.watch(vendorProductFormProvider);
            final current =
                form.images.where((i) => i.id == item.id).firstOrNull ?? item;
            final notifier = ref.read(vendorProductFormProvider.notifier);

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PlaceifyBottomSheetHeader(
                    title: 'Remove background',
                    subtitle: current.hasBackgroundRemoved
                        ? 'Compare original and processed images'
                        : 'Preview the processed result before applying',
                  ),
                  const SizedBox(height: 16),
                  if (current.isProcessingBg)
                    const _ProcessingOverlay()
                  else if (current.hasBackgroundRemoved &&
                      current.processedLocalPath != null)
                    DraggableSplitPreview(
                      originalPath: current.localPath!,
                      processedPath: current.processedLocalPath!,
                    )
                  else if (current.localPath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(current.localPath!),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (current.bgRemovalError != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      current.bgRemovalError!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.rust,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (current.hasBackgroundRemoved)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              notifier.cancelBackgroundRemoval(item.id);
                              Navigator.pop(sheetContext);
                            },
                            child: const Text('Restore original'),
                          ),
                        ),
                      if (current.hasBackgroundRemoved)
                        const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.vendorForest,
                          ),
                          onPressed: current.isProcessingBg
                              ? null
                              : () async {
                                  if (current.hasBackgroundRemoved) {
                                    Navigator.pop(sheetContext);
                                    return;
                                  }
                                  final error = await notifier.removeBackground(
                                    item.id,
                                  );
                                  if (!context.mounted) return;
                                  if (error != null) {
                                    PlaceifyToast.show(context, error);
                                  }
                                },
                          child: Text(
                            current.isProcessingBg
                                ? 'Processing…'
                                : current.hasBackgroundRemoved
                                ? 'Done'
                                : current.bgRemovalError != null
                                ? 'Retry'
                                : 'Remove BG',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _ProcessingOverlay extends StatelessWidget {
  const _ProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.vendorForest),
            SizedBox(height: 12),
            Text(
              'Removing background…',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
