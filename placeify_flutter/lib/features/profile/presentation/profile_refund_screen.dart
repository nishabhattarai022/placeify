import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_constants.dart';
import '../domain/constants/refund_strings.dart';
import 'providers/profile_refunds_provider.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/refund/refund_list_item.dart';
import 'widgets/refund/refund_section_title.dart';
import 'widgets/refund/refund_summary_card.dart';
import 'widgets/shared/profile_action_button.dart';

class ProfileRefundScreen extends ConsumerStatefulWidget {
  const ProfileRefundScreen({super.key});

  @override
  ConsumerState<ProfileRefundScreen> createState() =>
      _ProfileRefundScreenState();
}

class _ProfileRefundScreenState extends ConsumerState<ProfileRefundScreen> {
  int? _selectedOrderId;
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
    final orderId = _selectedOrderId;
    if (orderId == null) {
      PlaceifyToast.show(context, 'Select an order to refund.');
      return;
    }
    setState(() => _submitting = true);
    final message = await ref
        .read(profileRefundsProvider.notifier)
        .submitRefund(
          orderId: orderId,
          reason: _reason,
          details: _detailsController.text,
        );
    if (!mounted) return;
    setState(() => _submitting = false);
    PlaceifyToast.show(
      context,
      message ?? RefundStrings.requestSubmittedToast,
    );
    if (message == null) {
      setState(() {
        _selectedOrderId = null;
        _reason = ProfileRefundReasons.selectPlaceholder;
        _detailsController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final refundsAsync = ref.watch(profileRefundsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: refundsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
          data: (state) {
            final orderLabels = [
              for (final option in state.orderOptions) option.label,
            ];
            final selectedLabel = state.orderOptions
                .where((option) => option.orderId == _selectedOrderId)
                .map((option) => option.label)
                .firstOrNull;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileListScreenHeader(
                  title: RefundStrings.title,
                  subtitle: RefundStrings.italicLine,
                  count: state.active.length,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      12,
                      AppSpacing.screenPadding,
                      BottomNavTokens.scrollBottomPadding + bottomInset,
                    ),
                    children: [
                      RefundSummaryCard(
                        activeRequestCount: state.active.length,
                      ),
                      const RefundSectionTitle(RefundStrings.activeRequests),
                      if (state.active.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'No active refund requests.',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        for (final refund in state.active)
                          RefundListItem(refund: refund),
                      const SizedBox(height: 8),
                      const RefundSectionTitle(RefundStrings.completed),
                      if (state.completed.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            'No completed refunds yet.',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        )
                      else
                        for (final refund in state.completed)
                          RefundListItem(refund: refund),
                      const SizedBox(height: 8),
                      const RefundSectionTitle(RefundStrings.requestNewRefund),
                      _RefundFormField(
                        label: 'Select Order',
                        child: _RefundDropdown(
                          value: selectedLabel ??
                              (orderLabels.isEmpty
                                  ? 'No eligible orders'
                                  : orderLabels.first),
                          items: orderLabels.isEmpty
                              ? const ['No eligible orders']
                              : orderLabels,
                          onChanged: orderLabels.isEmpty
                              ? null
                              : (value) {
                                  final match = state.orderOptions
                                      .where((option) => option.label == value)
                                      .firstOrNull;
                                  setState(() {
                                    _selectedOrderId = match?.orderId;
                                  });
                                },
                        ),
                      ),
                      _RefundFormField(
                        label: 'Reason for Return',
                        child: _RefundDropdown(
                          value: _reason,
                          items: ProfileRefundReasons.options,
                          onChanged: (value) =>
                              setState(() => _reason = value ?? _reason),
                        ),
                      ),
                      _RefundFormField(
                        label: 'Additional Details',
                        child: TextField(
                          controller: _detailsController,
                          maxLines: 4,
                          style: AppFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Describe the issue in detail...',
                            hintStyle: AppFonts.dmSans(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.35),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: AppRadii.md,
                              borderSide: BorderSide(
                                color: Colors.black.withValues(alpha: 0.08),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppRadii.md,
                              borderSide: BorderSide(
                                color: Colors.black.withValues(alpha: 0.08),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppRadii.md,
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ProfileActionButton(
                          label: _submitting
                              ? 'Submitting…'
                              : RefundStrings.submitRequest,
                          onTap: _submitting ? () {} : _submit,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RefundFormField extends StatelessWidget {
  const _RefundFormField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.1,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _RefundDropdown extends StatelessWidget {
  const _RefundDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final resolvedValue = items.contains(value) ? value : items.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.md,
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: resolvedValue,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.black.withValues(alpha: 0.55),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
