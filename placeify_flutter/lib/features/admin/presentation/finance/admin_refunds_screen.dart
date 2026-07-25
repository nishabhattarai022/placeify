import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_spacing.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_refunds_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/widgets/admin_empty_state.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/profile_sub_hero.dart';

/// Admin refund queue with eSewa Mode B status / settle actions.
class AdminRefundsScreen extends ConsumerWidget {
  const AdminRefundsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refundsAsync = ref.watch(adminRefundsListProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSubHero(
            title: 'Refunds',
            subtitle: 'Approve, reject, and confirm eSewa portal settlements',
          ),
          Expanded(
            child: refundsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AdminEmptyState(message: '$error'),
                      TextButton(
                        onPressed: () => ref
                            .read(adminRefundsListProvider.notifier)
                            .refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (rows) {
                if (rows.isEmpty) {
                  return const Center(
                    child: AdminEmptyState(
                      message: 'No refund requests yet.',
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.bark,
                  onRefresh: () =>
                      ref.read(adminRefundsListProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                      AppSpacing.screenPadding,
                      BottomNavTokens.scrollBottomPadding + 24,
                    ),
                    itemCount: rows.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) =>
                        _RefundTile(row: rows[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundTile extends ConsumerWidget {
  const _RefundTile({required this.row});

  final AdminRefundRequestSummary row;

  bool get _isEsewaProcessing =>
      row.paymentMethod == PaymentMethod.esewa &&
      row.status == RequestStatus.inProgress;

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Updated')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminRefundsListProvider.notifier);
    final muted = AppFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textMuted,
    );
    final body = AppFonts.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${row.customerName} · ORD-${row.orderId}',
            style: AppFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${Formatters.currencyDecimal(row.refundAmount)} · ${row.status.name}'
            '${row.paymentStatus != null ? ' · payment ${row.paymentStatus!.name}' : ''}',
            style: muted,
          ),
          if (row.destinationLabel != null &&
              row.destinationLabel!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(row.destinationLabel!, style: body),
          ],
          if (row.gatewayStatus != null &&
              row.gatewayStatus!.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('Gateway: ${row.gatewayStatus}', style: muted),
          ],
          if (row.gatewayReference != null &&
              row.gatewayReference!.trim().isNotEmpty) ...[
            const SizedBox(height: 2),
            Text('Ref: ${row.gatewayReference}', style: muted),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (row.status == RequestStatus.pending) ...[
                _ActionChip(
                  label: 'Approve',
                  onPressed: () => _run(
                    context,
                    ref,
                    () => notifier.approve(row.id),
                  ),
                ),
                _ActionChip(
                  label: 'Reject',
                  tone: _ChipTone.muted,
                  onPressed: () => _run(
                    context,
                    ref,
                    () => notifier.reject(row.id),
                  ),
                ),
              ],
              if (_isEsewaProcessing) ...[
                _ActionChip(
                  label: 'Check status',
                  onPressed: () => _run(
                    context,
                    ref,
                    () => notifier.checkEsewaStatus(row.id),
                  ),
                ),
                _ActionChip(
                  label: 'Retry check',
                  tone: _ChipTone.muted,
                  onPressed: () => _run(
                    context,
                    ref,
                    () => notifier.retryEsewaStatus(row.id),
                  ),
                ),
                _ActionChip(
                  label: 'Complete manual',
                  onPressed: () => _run(
                    context,
                    ref,
                    () => notifier.completeManualSettlement(row.id),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

enum _ChipTone { primary, muted }

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.onPressed,
    this.tone = _ChipTone.primary,
  });

  final String label;
  final VoidCallback onPressed;
  final _ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final bg =
        tone == _ChipTone.primary ? AppColors.bark : AppColors.cartQtyPill;
    final fg =
        tone == _ChipTone.primary ? Colors.white : AppColors.textPrimary;
    return Material(
      color: bg,
      borderRadius: AppRadii.pill,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: AppTypography.statusPill.copyWith(color: fg),
          ),
        ),
      ),
    );
  }
}
