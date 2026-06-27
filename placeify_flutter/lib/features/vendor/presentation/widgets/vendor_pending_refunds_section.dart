import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../domain/models/vendor_pending_refund.dart';
import '../providers/vendor_refunds_provider.dart';

class VendorPendingRefundsSection extends ConsumerWidget {
  const VendorPendingRefundsSection({
    super.key,
    required this.refunds,
  });

  final List<VendorPendingRefund> refunds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (refunds.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Pending Refund Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.espresso,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.coralBg,
                borderRadius: AppRadii.pill,
              ),
              child: Text(
                '${refunds.length}',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coral,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...refunds.take(3).map(
              (refund) => _RefundTile(refund: refund),
            ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _RefundTile extends ConsumerStatefulWidget {
  const _RefundTile({required this.refund});

  final VendorPendingRefund refund;

  @override
  ConsumerState<_RefundTile> createState() => _RefundTileState();
}

class _RefundTileState extends ConsumerState<_RefundTile> {
  bool _busy = false;

  Future<void> _approve() async {
    if (_busy) return;
    setState(() => _busy = true);
    final error = await ref
        .read(vendorPendingRefundsProvider.notifier)
        .approve(
          widget.refund.id,
          orderId: widget.refund.orderId.toString(),
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      PlaceifyToast.show(context, error);
    } else {
      PlaceifyToast.show(context, 'Refund approved');
    }
  }

  Future<void> _reject() async {
    if (_busy) return;
    setState(() => _busy = true);
    final error = await ref
        .read(vendorPendingRefundsProvider.notifier)
        .reject(
          widget.refund.id,
          orderId: widget.refund.orderId.toString(),
          reason: 'Rejected by vendor',
        );
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      PlaceifyToast.show(context, error);
    } else {
      PlaceifyToast.show(context, 'Refund rejected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final refund = widget.refund;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadii.md,
        border: Border.all(color: AppColors.creamDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order #${refund.orderNumber}',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.espresso,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            Formatters.currency(refund.refundAmount),
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.vendorForest,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            refund.reason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () {
                          HapticService.light();
                          _reject();
                        },
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: _busy
                      ? null
                      : () {
                          HapticService.medium();
                          _approve();
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.vendorForest,
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
