import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/painters/pulse_rings_painter.dart';
import '../../domain/constants/order_strings.dart';
import '../../domain/enums/consumer_order_status.dart';
import '../../domain/models/order.dart';
import '../../domain/models/order_status_update.dart';

enum _TimelineStepState { completed, active, pending }

/// Vertical order lifecycle stepper for consumer orders.
class OrderTimeline extends StatefulWidget {
  const OrderTimeline({
    required this.order,
    super.key,
  });

  final Order order;

  static const _lifecycle = <ConsumerOrderStatus>[
    ConsumerOrderStatus.placed,
    ConsumerOrderStatus.confirmed,
    ConsumerOrderStatus.packed,
    ConsumerOrderStatus.dispatched,
    ConsumerOrderStatus.inTransit,
    ConsumerOrderStatus.outForDelivery,
    ConsumerOrderStatus.delivered,
  ];

  @override
  State<OrderTimeline> createState() => _OrderTimelineState();
}

class _OrderTimelineState extends State<OrderTimeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void deactivate() {
    _pulseController.stop();
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  OrderStatusUpdate? _updateFor(ConsumerOrderStatus status) {
    OrderStatusUpdate? match;
    for (final update in widget.order.statusHistory) {
      if (update.status == status) {
        match = update;
      }
    }
    return match;
  }

  int _activeLifecycleIndex() {
    final status = widget.order.status;
    if (status == ConsumerOrderStatus.cancelled) {
      for (var i = OrderTimeline._lifecycle.length - 1; i >= 0; i--) {
        if (_updateFor(OrderTimeline._lifecycle[i]) != null) return i;
      }
      return 0;
    }
    if (status == ConsumerOrderStatus.returnRequested ||
        status == ConsumerOrderStatus.returned) {
      return OrderTimeline._lifecycle.length;
    }
    final index = OrderTimeline._lifecycle.indexOf(status);
    return index >= 0 ? index : 0;
  }

  _TimelineStepState _stepState(int index, int activeIndex) {
    final status = widget.order.status;

    if (status == ConsumerOrderStatus.cancelled) {
      return _updateFor(OrderTimeline._lifecycle[index]) != null
          ? _TimelineStepState.completed
          : _TimelineStepState.pending;
    }

    if (status == ConsumerOrderStatus.delivered ||
        status == ConsumerOrderStatus.returnRequested ||
        status == ConsumerOrderStatus.returned) {
      return _TimelineStepState.completed;
    }

    if (_updateFor(OrderTimeline._lifecycle[index]) != null) {
      return _TimelineStepState.completed;
    }
    if (index < activeIndex) return _TimelineStepState.completed;
    if (index == activeIndex) return _TimelineStepState.active;
    return _TimelineStepState.pending;
  }

  bool _showPulse(int index, _TimelineStepState state) {
    if (state != _TimelineStepState.active) return false;
    return widget.order.status == OrderTimeline._lifecycle[index];
  }

  List<({ConsumerOrderStatus status, String label})> _terminalSteps() {
    return switch (widget.order.status) {
      ConsumerOrderStatus.cancelled => [
          (
            status: ConsumerOrderStatus.cancelled,
            label: OrderStrings.statusLabel(ConsumerOrderStatus.cancelled),
          ),
        ],
      ConsumerOrderStatus.returnRequested => [
          (
            status: ConsumerOrderStatus.returnRequested,
            label: OrderStrings.statusLabel(ConsumerOrderStatus.returnRequested),
          ),
        ],
      ConsumerOrderStatus.returned => [
          (
            status: ConsumerOrderStatus.returnRequested,
            label: OrderStrings.statusLabel(ConsumerOrderStatus.returnRequested),
          ),
          (
            status: ConsumerOrderStatus.returned,
            label: OrderStrings.statusLabel(ConsumerOrderStatus.returned),
          ),
        ],
      _ => const [],
    };
  }

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeLifecycleIndex();
    final terminals = _terminalSteps();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < OrderTimeline._lifecycle.length; i++)
          _TimelineStepRow(
            label: OrderStrings.statusLabel(OrderTimeline._lifecycle[i]),
            state: _stepState(i, activeIndex),
            update: _updateFor(OrderTimeline._lifecycle[i]),
            isLast: i == OrderTimeline._lifecycle.length - 1 && terminals.isEmpty,
            showPulse: _showPulse(i, _stepState(i, activeIndex)),
            pulseAnimation: _pulseController,
          ),
        for (var i = 0; i < terminals.length; i++)
          _TerminalStepRow(
            label: terminals[i].label,
            update: _updateFor(terminals[i].status),
            status: terminals[i].status,
            isLast: i == terminals.length - 1,
          ),
      ],
    );
  }
}

class _TimelineStepRow extends StatelessWidget {
  const _TimelineStepRow({
    required this.label,
    required this.state,
    required this.update,
    required this.isLast,
    required this.showPulse,
    required this.pulseAnimation,
  });

  final String label;
  final _TimelineStepState state;
  final OrderStatusUpdate? update;
  final bool isLast;
  final bool showPulse;
  final Animation<double> pulseAnimation;

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
            width: 32,
            child: Column(
              children: [
                _TimelineDot(
                  state: state,
                  color: dotColor,
                  showPulse: showPulse,
                  pulseAnimation: pulseAnimation,
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
                      Formatters.shortDate(update!.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (update!.note != null && update!.note!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        update!.note!,
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
    required this.showPulse,
    required this.pulseAnimation,
  });

  final _TimelineStepState state;
  final Color color;
  final bool showPulse;
  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    final isCompleted = state == _TimelineStepState.completed;

    Widget dot = Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: isCompleted || state == _TimelineStepState.active
            ? color
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: state == _TimelineStepState.active
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.25),
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: isCompleted
          ? const Icon(Icons.check, size: 10, color: Colors.white)
          : null,
    );

    if (showPulse) {
      dot = AnimatedBuilder(
        animation: pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + pulseAnimation.value * 0.04,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: const Size(48, 48),
                  painter: PulseRingsPainter(
                    outerOpacity: pulseAnimation.value,
                    innerOpacity: 1 - pulseAnimation.value * 0.5,
                    outerScale: 0.35 + pulseAnimation.value * 0.08,
                    innerScale: 0.28 + pulseAnimation.value * 0.06,
                  ),
                ),
                child!,
              ],
            ),
          );
        },
        child: dot,
      );
    }

    return dot;
  }
}

class _TerminalStepRow extends StatelessWidget {
  const _TerminalStepRow({
    required this.label,
    required this.update,
    required this.status,
    required this.isLast,
  });

  final String label;
  final OrderStatusUpdate? update;
  final ConsumerOrderStatus status;
  final bool isLast;

  Color _color() => switch (status) {
        ConsumerOrderStatus.cancelled => AppColors.coral,
        ConsumerOrderStatus.returnRequested => AppColors.lavender,
        ConsumerOrderStatus.returned => AppColors.lavender,
        _ => AppColors.textMuted,
      };

  IconData _icon() => switch (status) {
        ConsumerOrderStatus.cancelled => Icons.block,
        ConsumerOrderStatus.returnRequested => Icons.assignment_return_outlined,
        ConsumerOrderStatus.returned => Icons.check_circle_outline,
        _ => Icons.info_outline,
      };

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(_icon(), size: 10, color: color),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  if (update != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      Formatters.shortDate(update!.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (update!.note != null && update!.note!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        update!.note!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
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
