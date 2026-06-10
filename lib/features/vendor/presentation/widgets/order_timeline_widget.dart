import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/enums/delivery_stage.dart';
import '../../domain/enums/order_status.dart';
import '../../domain/models/delivery_update.dart';

enum _TimelineStepState { completed, active, pending }

class OrderTimelineWidget extends StatelessWidget {
  const OrderTimelineWidget({
    required this.status,
    this.deliveryUpdates = const [],
    super.key,
  });

  final OrderStatus status;
  final List<DeliveryUpdate> deliveryUpdates;

  static const _stages = DeliveryStage.values;

  @override
  Widget build(BuildContext context) {
    final isTerminalFailure =
        status == OrderStatus.rejected || status == OrderStatus.cancelled;
    final activeIndex = _activeStageIndex(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _stages.length; i++)
          _TimelineStep(
            label: _stageLabel(_stages[i]),
            state: _stepState(
              index: i,
              activeIndex: activeIndex,
              stage: _stages[i],
              isTerminalFailure: isTerminalFailure,
            ),
            update: _updateForStage(_stages[i]),
            isLast: i == _stages.length - 1,
          ),
        if (isTerminalFailure) ...[
          const SizedBox(height: 4),
          _TerminalStep(
            label: status == OrderStatus.rejected ? 'Rejected' : 'Cancelled',
            isRejected: status == OrderStatus.rejected,
          ),
        ],
      ],
    );
  }

  static int _activeStageIndex(OrderStatus status) {
    return switch (status) {
      OrderStatus.pending => 0,
      OrderStatus.accepted => 1,
      OrderStatus.processing => 1,
      OrderStatus.shipped => 3,
      OrderStatus.delivered => _stages.length,
      OrderStatus.rejected || OrderStatus.cancelled => 0,
    };
  }

  static String _stageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order Placed',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for Delivery',
      DeliveryStage.delivered => 'Delivered',
    };
  }

  DeliveryUpdate? _updateForStage(DeliveryStage stage) {
    for (final update in deliveryUpdates) {
      if (update.stage == stage) return update;
    }
    return null;
  }

  _TimelineStepState _stepState({
    required int index,
    required int activeIndex,
    required DeliveryStage stage,
    required bool isTerminalFailure,
  }) {
    if (isTerminalFailure) {
      return index == 0
          ? _TimelineStepState.completed
          : _TimelineStepState.pending;
    }

    if (status == OrderStatus.delivered) {
      return _TimelineStepState.completed;
    }

    if (_updateForStage(stage) != null) {
      return _TimelineStepState.completed;
    }
    if (index < activeIndex) return _TimelineStepState.completed;
    if (index == activeIndex) return _TimelineStepState.active;
    return _TimelineStepState.pending;
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.label,
    required this.state,
    required this.update,
    required this.isLast,
  });

  final String label;
  final _TimelineStepState state;
  final DeliveryUpdate? update;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final (dotColor, lineColor, titleColor) = switch (state) {
      _TimelineStepState.completed => (
          AppColors.teal,
          AppColors.teal,
          AppColors.textPrimary,
        ),
      _TimelineStepState.active => (
          AppColors.accent,
          AppColors.creamDark,
          AppColors.textPrimary,
        ),
      _TimelineStepState.pending => (
          AppColors.creamDark,
          AppColors.creamDark,
          AppColors.textMuted,
        ),
    };

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                _TimelineDot(
                  state: state,
                  color: dotColor,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: lineColor,
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: state == _TimelineStepState.active
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (update != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      Formatters.shortDate(update!.updatedAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (update!.note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        update!.note,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ] else if (state == _TimelineStepState.active) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'In progress',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
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

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({
    required this.state,
    required this.color,
  });

  final _TimelineStepState state;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == _TimelineStepState.completed;

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: isCompleted || state == _TimelineStepState.active
            ? color
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: state == _TimelineStepState.active
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: isCompleted
          ? const Icon(Icons.check, size: 9, color: Colors.white)
          : null,
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
