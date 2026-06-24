import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_constants.dart';
import 'providers/profile_refunds_provider.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/refund/refund_list_item.dart';
import 'widgets/refund/refund_summary_card.dart';
import 'widgets/shared/profile_form_field.dart';
import 'widgets/shared/profile_submit_button.dart';

class ProfileRefundScreen extends ConsumerStatefulWidget {
  const ProfileRefundScreen({super.key});

  @override
  ConsumerState<ProfileRefundScreen> createState() =>
      _ProfileRefundScreenState();
}

class _ProfileRefundScreenState extends ConsumerState<ProfileRefundScreen> {
  RefundOrderOption? _selectedOrder;
  String _reason = ProfileRefundReasons.selectPlaceholder;
  final _detailsController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final state = ref.read(profileRefundsProvider).value;
    final order = _selectedOrder ??
        (state != null && state.orderOptions.isNotEmpty
            ? state.orderOptions.first
            : null);
    if (order == null) {
      PlaceifyToast.show(context, 'No eligible orders for a refund request.');
      return;
    }

    setState(() => _submitting = true);
    final error = await ref.read(profileRefundsProvider.notifier).submitRefund(
          orderId: order.orderId,
          reason: _reason,
          details: _detailsController.text,
        );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (error != null) {
      PlaceifyToast.show(context, error);
      return;
    }

    PlaceifyToast.show(context, 'Refund request submitted ✓');
    setState(() {
      _reason = ProfileRefundReasons.selectPlaceholder;
      _detailsController.clear();
      _selectedOrder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final refundsAsync = ref.watch(profileRefundsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Refund & Returns'),
          Expanded(
            child: refundsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _RefundBody(
                state: ProfileRefundsState.empty,
                order: _selectedOrder,
                reason: _reason,
                detailsController: _detailsController,
                submitting: _submitting,
                onOrderChanged: (order) => setState(() => _selectedOrder = order),
                onReasonChanged: (reason) => setState(() => _reason = reason),
                onSubmit: _submit,
              ),
              data: (state) => _RefundBody(
                state: state,
                order: _selectedOrder,
                reason: _reason,
                detailsController: _detailsController,
                submitting: _submitting,
                onOrderChanged: (order) => setState(() => _selectedOrder = order),
                onReasonChanged: (reason) => setState(() => _reason = reason),
                onSubmit: _submit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundBody extends StatelessWidget {
  const _RefundBody({
    required this.state,
    required this.order,
    required this.reason,
    required this.detailsController,
    required this.submitting,
    required this.onOrderChanged,
    required this.onReasonChanged,
    required this.onSubmit,
  });

  final ProfileRefundsState state;
  final RefundOrderOption? order;
  final String reason;
  final TextEditingController detailsController;
  final bool submitting;
  final ValueChanged<RefundOrderOption?> onOrderChanged;
  final ValueChanged<String> onReasonChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final orderOptions = state.orderOptions;
    final selected = order ??
        (orderOptions.isNotEmpty ? orderOptions.first : null);
    final walletCredit = state.completedTotal;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        18,
        20,
        18,
        BottomNavTokens.scrollBottomPadding,
      ),
      children: [
        RefundSummaryCard(
          pendingTotal: state.pendingTotal,
          activeRequestCount: state.active.length,
          walletCredit: walletCredit,
        ),
        const _SectionTitle('Active Requests'),
        if (state.active.isEmpty)
          const _EmptyHint('No active refund requests.')
        else
          for (final r in state.active) RefundListItem(refund: r),
        const SizedBox(height: 8),
        const _SectionTitle('Completed'),
        if (state.completed.isEmpty)
          const _EmptyHint('No completed refunds yet.')
        else
          for (final r in state.completed) RefundListItem(refund: r),
        const SizedBox(height: 8),
        const _SectionTitle('Request New Refund'),
        ProfileFormField(
          label: 'Select Order',
          child: orderOptions.isEmpty
              ? const Text(
                  'No eligible orders',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                )
              : ProfileDropdown(
                  value: selected?.label ?? orderOptions.first.label,
                  items: [for (final option in orderOptions) option.label],
                  onChanged: (label) {
                    if (label == null) return;
                    onOrderChanged(
                      orderOptions.firstWhere((o) => o.label == label),
                    );
                  },
                ),
        ),
        ProfileFormField(
          label: 'Reason for Return',
          child: ProfileDropdown(
            value: reason,
            items: ProfileRefundReasons.options,
            onChanged: (v) => onReasonChanged(v ?? reason),
          ),
        ),
        ProfileFormField(
          label: 'Additional Details',
          child: TextField(
            controller: detailsController,
            maxLines: 4,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.espresso,
            ),
            decoration: InputDecoration(
              hintText: 'Describe the issue in detail...',
              hintStyle: const TextStyle(
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.cream,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.creamDark,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.creamDark,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: AppColors.accent,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        ProfileSubmitButton(
          label: submitting ? 'Submitting…' : 'Submit Refund Request',
          onPressed: () {
            if (submitting || orderOptions.isEmpty) return;
            onSubmit();
          },
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Fraunces',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.espresso,
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textMuted,
        ),
      ),
    );
  }
}
