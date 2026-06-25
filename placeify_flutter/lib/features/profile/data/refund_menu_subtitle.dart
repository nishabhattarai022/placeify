import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../presentation/providers/profile_refunds_provider.dart';

/// Menu subtitle for Refund & Returns — same totals as [RefundSummaryCard].
String readRefundMenuSubtitle(
  WidgetRef ref, {
  String fallback = 'View refund requests',
}) {
  return ref.watch(profileRefundsProvider).maybeWhen(
        data: (state) => formatRefundMenuSubtitle(
          pendingTotal: state.pendingTotal,
          activeCount: state.active.length,
        ),
        orElse: () => fallback,
      );
}

String formatRefundMenuSubtitle({
  required double pendingTotal,
  required int activeCount,
}) {
  final activeLabel = activeCount == 1 ? '1 active' : '$activeCount active';
  return '${Formatters.currencyDecimal(pendingTotal)} pending · $activeLabel';
}
