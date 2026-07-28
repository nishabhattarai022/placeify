import 'package:flutter/material.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';

/// Payment + order event timeline backed by [OrderStatusHistory] via order detail.
class PaymentLifecycleTimeline extends StatefulWidget {
  const PaymentLifecycleTimeline({required this.orderId, super.key});

  final String orderId;

  @override
  State<PaymentLifecycleTimeline> createState() =>
      _PaymentLifecycleTimelineState();
}

class _PaymentLifecycleTimelineState extends State<PaymentLifecycleTimeline> {
  late Future<List<UserOrderPaymentEvent>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant PaymentLifecycleTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orderId != widget.orderId) {
      _future = _load();
    }
  }

  Future<List<UserOrderPaymentEvent>> _load() async {
    final id = int.tryParse(widget.orderId);
    if (id == null) return const [];
    final detail = await client.user.getMyOrder(id);
    return detail.paymentUpdates;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserOrderPaymentEvent>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final events = snapshot.data ?? const <UserOrderPaymentEvent>[];
        if (events.isEmpty) {
          return const Text(
            'No payment timeline events yet.',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted),
          );
        }

        return Column(
          children: [
            for (var i = 0; i < events.length; i++)
              _TimelineRow(
                label: events[i].displayLabel ??
                    events[i].eventKey ??
                    events[i].status.name,
                timestamp: events[i].createdAt,
                note: events[i].note,
                isLast: i == events.length - 1,
              ),
          ],
        );
      },
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.label,
    required this.timestamp,
    required this.isLast,
    this.note,
  });

  final String label;
  final DateTime timestamp;
  final String? note;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: AppColors.forest,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: AppColors.creamDark,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.shortDateTime(timestamp),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                if (note != null && note!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    note!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
