import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/enums/delivery_stage.dart';
import '../../domain/enums/order_status.dart';
import '../../domain/models/delivery_update.dart';

/// Vendor delivery timeline — only shows updates the vendor has posted.
class OrderTimelineWidget extends StatelessWidget {
  const OrderTimelineWidget({
    required this.status,
    this.deliveryUpdates = const [],
    this.vendorEditable = false,
    super.key,
  });

  final OrderStatus status;
  final List<DeliveryUpdate> deliveryUpdates;
  final bool vendorEditable;

  @override
  Widget build(BuildContext context) {
    final isTerminalFailure =
        status == OrderStatus.rejected || status == OrderStatus.cancelled;
    final updates = [...deliveryUpdates]
      ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

    if (updates.isEmpty && !isTerminalFailure) {
      return const Text(
        'No delivery updates posted yet.',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
          height: 1.45,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < updates.length; i++)
          _TimelineStep(
            label: _stageLabel(updates[i].stage),
            update: updates[i],
            isLast: i == updates.length - 1 && !isTerminalFailure,
            showPhotoProof: vendorEditable,
          ),
        if (isTerminalFailure) ...[
          if (updates.isNotEmpty) const SizedBox(height: 4),
          _TerminalStep(
            label: status == OrderStatus.rejected ? 'Rejected' : 'Cancelled',
            isRejected: status == OrderStatus.rejected,
          ),
        ],
      ],
    );
  }

  static String _stageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order accepted',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for delivery',
      DeliveryStage.delivered => 'Delivered',
    };
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.update,
    required this.isLast,
    this.showPhotoProof = false,
  });

  final String label;
  final DeliveryUpdate update;
  final bool isLast;
  final bool showPhotoProof;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.teal,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, size: 9, color: Colors.white),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.teal,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.shortDate(update.updatedAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  if (update.note.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      update.note,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                  if (showPhotoProof &&
                      update.photoProofPath != null &&
                      update.photoProofPath!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: AppRadii.sm,
                      child: Image.file(
                        File(update.photoProofPath!),
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalStep extends StatelessWidget {
  const _TerminalStep({
    required this.label,
    required this.isRejected,
  });

  final String label;
  final bool isRejected;

  @override
  Widget build(BuildContext context) {
    final color = isRejected ? AppColors.rust : AppColors.textMuted;

    return Row(
      children: [
        Container(
          width: 28,
          alignment: Alignment.center,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(
              isRejected ? Icons.close : Icons.block,
              size: 9,
              color: color,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: AppRadii.md,
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
