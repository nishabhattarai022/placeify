import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_mock_data.dart';
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
  int _selectedOrderIndex = 0;
  String _reason = ProfileMockData.refundReasonOptions.first;
  final _detailsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
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
              error: (error, _) => Center(
                child: TextButton(
                  onPressed: () =>
                      ref.read(profileRefundsProvider.notifier).refresh(),
                  child: Text(error.toString()),
                ),
              ),
              data: (state) {
                final orderOptions = state.orderOptions;
                if (orderOptions.isNotEmpty &&
                    _selectedOrderIndex >= orderOptions.length) {
                  _selectedOrderIndex = 0;
                }

                final reasonItems = ProfileMockData.refundReasonOptions;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    20,
                    18,
                    BottomNavTokens.scrollBottomPadding,
                  ),
                  children: [
                    const RefundSummaryCard(),
                    const _SectionTitle('Active Requests'),
                    if (state.active.isEmpty)
                      const Text(
                        'No active refund requests.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    for (final r in state.active) RefundListItem(refund: r),
                    const SizedBox(height: 8),
                    const _SectionTitle('Completed'),
                    if (state.completed.isEmpty)
                      const Text(
                        'No completed refunds yet.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    for (final r in state.completed)
                      RefundListItem(refund: r),
                    const SizedBox(height: 8),
                    const _SectionTitle('Request New Refund'),
                    if (orderOptions.isEmpty)
                      const Text(
                        'Place an order before requesting a refund.',
                        style: TextStyle(color: AppColors.textMuted),
                      )
                    else ...[
                      ProfileFormField(
                        label: 'Select Order',
                        child: ProfileDropdown(
                          value: orderOptions[_selectedOrderIndex].label,
                          items: [
                            for (final option in orderOptions) option.label,
                          ],
                          onChanged: (value) {
                            final index = orderOptions.indexWhere(
                              (option) => option.label == value,
                            );
                            if (index >= 0) {
                              setState(() => _selectedOrderIndex = index);
                            }
                          },
                        ),
                      ),
                      ProfileFormField(
                        label: 'Reason for Return',
                        child: ProfileDropdown(
                          value: _reason,
                          items: reasonItems,
                          onChanged: (v) =>
                              setState(() => _reason = v ?? _reason),
                        ),
                      ),
                      ProfileFormField(
                        label: 'Additional Details',
                        child: TextField(
                          controller: _detailsController,
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
                        label: _isSubmitting
                            ? 'Submitting...'
                            : 'Submit Refund Request',
                        onPressed: _isSubmitting
                            ? () {}
                            : () => _submit(orderOptions[_selectedOrderIndex]),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(RefundOrderOption order) async {
    setState(() => _isSubmitting = true);
    final error = await ref.read(profileRefundsProvider.notifier).submitRefund(
          orderId: order.orderId,
          reason: _reason,
          details: _detailsController.text,
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      PlaceifyToast.show(context, error);
      return;
    }

    PlaceifyToast.show(context, 'Refund request submitted ✓');
    _detailsController.clear();
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
