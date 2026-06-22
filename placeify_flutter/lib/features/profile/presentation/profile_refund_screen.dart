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
    if (_submitting) return;
    final order = _selectedOrder;
    if (order == null) {
      PlaceifyToast.show(context, 'Select an order to refund.');
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

    setState(() {
      _selectedOrder = null;
      _reason = ProfileRefundReasons.selectPlaceholder;
      _detailsController.clear();
    });
    PlaceifyToast.show(context, 'Refund request submitted ✓');
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
              error: (_, __) => _RefundErrorState(
                onRetry: () => ref.invalidate(profileRefundsProvider),
              ),
              data: (state) {
                if (_selectedOrder == null && state.orderOptions.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && _selectedOrder == null) {
                      setState(() => _selectedOrder = state.orderOptions.first);
                    }
                  });
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(profileRefundsProvider.notifier).refresh(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      20,
                      18,
                      BottomNavTokens.scrollBottomPadding,
                    ),
                    children: [
                      RefundSummaryCard(
                        pendingTotal: state.pendingTotal,
                        activeCount: state.active.length,
                      ),
                      const _SectionTitle('Active Requests'),
                      if (state.active.isEmpty)
                        const _EmptyHint(
                          'No active refund requests.',
                        )
                      else
                        for (final refund in state.active)
                          RefundListItem(refund: refund),
                      const SizedBox(height: 8),
                      const _SectionTitle('Completed'),
                      if (state.completed.isEmpty)
                        const _EmptyHint(
                          'Completed refunds will appear here.',
                        )
                      else
                        for (final refund in state.completed)
                          RefundListItem(refund: refund),
                      const SizedBox(height: 8),
                      const _SectionTitle('Request New Refund'),
                      if (state.orderOptions.isEmpty)
                        const _EmptyHint(
                          'Place an order first, then you can request a refund here.',
                        )
                      else ...[
                        ProfileFormField(
                          label: 'Select Order',
                          child: ProfileDropdown(
                            value: _selectedOrder?.label ??
                                state.orderOptions.first.label,
                            items: [
                              for (final option in state.orderOptions)
                                option.label,
                            ],
                            onChanged: (label) {
                              if (label == null) return;
                              setState(() {
                                _selectedOrder = state.orderOptions.firstWhere(
                                  (option) => option.label == label,
                                );
                              });
                            },
                          ),
                        ),
                        ProfileFormField(
                          label: 'Reason for Return',
                          child: ProfileDropdown(
                            value: _reason,
                            items: ProfileRefundReasons.options,
                            onChanged: (value) =>
                                setState(() => _reason = value ?? _reason),
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
                          label: _submitting
                              ? 'Submitting…'
                              : 'Submit Refund Request',
                          onPressed: _submit,
                        ),
                      ],
                    ],
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

class _RefundErrorState extends StatelessWidget {
  const _RefundErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Could not load refunds',
              style: TextStyle(
                fontFamily: 'Fraunces',
                fontSize: 18,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textMuted,
          height: 1.4,
        ),
      ),
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
