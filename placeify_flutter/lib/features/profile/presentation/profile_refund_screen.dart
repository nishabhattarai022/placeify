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
    final headerCount = refundsAsync.maybeWhen(
      data: (state) => state.active.length,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileListScreenHeader(
              title: RefundStrings.title,
              subtitle: RefundStrings.italicLine,
              count: headerCount,
            ),
            Expanded(
              child: refundsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => _RefundErrorState(
                  message: error.toString(),
                  onRetry: () =>
                      ref.read(profileRefundsProvider.notifier).refresh(),
                ),
                data: (state) => _RefundBody(
                  state: state,
                  selectedOrderId: _selectedOrderId,
                  reason: _reason,
                  detailsController: _detailsController,
                  submitting: _submitting,
                  bottomInset: bottomInset,
                  onOrderChanged: (orderId) =>
                      setState(() => _selectedOrderId = orderId),
                  onReasonChanged: (value) =>
                      setState(() => _reason = value ?? _reason),
                  onSubmit: _submit,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RefundBody extends StatelessWidget {
  const _RefundBody({
    required this.state,
    required this.selectedOrderId,
    required this.reason,
    required this.detailsController,
    required this.submitting,
    required this.bottomInset,
    required this.onOrderChanged,
    required this.onReasonChanged,
    required this.onSubmit,
  });

  final ProfileRefundsState state;
  final int? selectedOrderId;
  final String reason;
  final TextEditingController detailsController;
  final bool submitting;
  final double bottomInset;
  final ValueChanged<int?> onOrderChanged;
  final ValueChanged<String?> onReasonChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final orderLabels = [
      for (final option in state.orderOptions) option.label,
    ];
    final selectedLabel = state.orderOptions
        .where((option) => option.orderId == selectedOrderId)
        .map((option) => option.label)
        .firstOrNull;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        12,
        AppSpacing.screenPadding,
        BottomNavTokens.scrollBottomPadding + bottomInset,
      ),
      children: [
        RefundSummaryCard(
          activeRequestCount: state.active.length,
          pendingTotal: state.pendingTotal,
          completedTotal: state.completedTotal,
          destinationPreview: state.active.isNotEmpty
              ? state.active.first.destinationLabel
              : null,
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
          for (final refund in state.active) RefundListItem(refund: refund),
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
          for (final refund in state.completed) RefundListItem(refund: refund),
        const SizedBox(height: 8),
        const RefundSectionTitle(RefundStrings.requestNewRefund),
        _RefundFormField(
          label: 'Select Order',
          child: orderLabels.isEmpty
              ? _EligibleOrdersEmptyState(
                  exclusionNotes: state.eligibilityDebug,
                )
              : _RefundDropdown(
                  value: selectedLabel ?? orderLabels.first,
                  items: orderLabels,
                  onChanged: (value) {
                    final match = state.orderOptions
                        .where((option) => option.label == value)
                        .firstOrNull;
                    onOrderChanged(match?.orderId);
                  },
                ),
        ),
        _RefundFormField(
          label: 'Reason for Return',
          child: _RefundDropdown(
            value: reason,
            items: ProfileRefundReasons.options,
            onChanged: onReasonChanged,
          ),
        ),
        _RefundFormField(
          label: 'Additional Details',
          child: TextField(
            controller: detailsController,
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
            label: submitting ? 'Submitting…' : RefundStrings.submitRequest,
            onTap: submitting ? () {} : onSubmit,
          ),
        ),
      ],
    );
  }
}

class _RefundErrorState extends StatelessWidget {
  const _RefundErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Could not load refunds',
              textAlign: TextAlign.center,
              style: AppFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppFonts.dmSans(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            ProfileActionButton(label: 'Try again', onTap: onRetry),
          ],
        ),
      ),
    );
  }
}

class _EligibleOrdersEmptyState extends StatelessWidget {
  const _EligibleOrdersEmptyState({this.exclusionNotes = const []});

  final List<String> exclusionNotes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.md,
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            RefundStrings.noEligibleOrders,
            style: AppFonts.dmSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            RefundStrings.noEligibleOrdersHint,
            style: AppFonts.dmSans(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.35,
            ),
          ),
          if (exclusionNotes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              exclusionNotes.take(3).join('\n'),
              style: AppFonts.dmSans(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ],
        ],
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
    final resolvedItems =
        items.isEmpty ? const <String>['No eligible orders'] : items;
    final resolvedValue =
        resolvedItems.contains(value) ? value : resolvedItems.first;
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
          items: resolvedItems
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
