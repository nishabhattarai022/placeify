import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../presentation/providers/profile_refunds_provider.dart';

/// Menu subtitle for Refund & Returns — same totals as [RefundSummaryCard].
String readRefundMenuSubtitle(
  WidgetRef ref, {
  String fallback = 'View refund requests',
}) {
  return ref
      .watch(profileRefundsProvider)
      .maybeWhen(
        data: (state) => formatRefundMenuSubtitle(
          pendingTotal: state.pendingTotal,
          activeCount: state.active.length,
          approvedCount: state.completed
              .where((refund) => refund.isCompleted)
              .length,
        ),
        orElse: () => fallback,
      );
}

String formatRefundMenuSubtitle({
  required double pendingTotal,
  required int activeCount,
  int approvedCount = 0,
}) {
  if (activeCount <= 0 && pendingTotal <= 0) {
    return 'No active refunds';
  }

  final parts = <String>[];
  if (pendingTotal > 0) {
    parts.add('${Formatters.currencyDecimal(pendingTotal)} pending');
  }
  if (activeCount > 0) {
    parts.add(activeCount == 1 ? '1 active' : '$activeCount active');
  }
  if (approvedCount > 0) {
    parts.add(
      approvedCount == 1 ? '1 approved' : '$approvedCount approved',
    );
  }
  return parts.join(' · ');
}

String formatWishlistMenuSubtitle(int count) {
  if (count <= 0) return 'No saved items';
  return count == 1 ? '1 saved item' : '$count saved items';
}
