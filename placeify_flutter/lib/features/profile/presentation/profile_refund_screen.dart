import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_mock_data.dart';
import '../domain/constants/refund_strings.dart';
import 'widgets/profile_list_screen_header.dart';
import 'widgets/refund/refund_action_button.dart';
import 'widgets/refund/refund_list_item.dart';
import 'widgets/refund/refund_section_title.dart';
import 'widgets/refund/refund_summary_card.dart';

class ProfileRefundScreen extends StatefulWidget {
  const ProfileRefundScreen({super.key});

  @override
  State<ProfileRefundScreen> createState() => _ProfileRefundScreenState();
}

class _ProfileRefundScreenState extends State<ProfileRefundScreen> {
  String _order = ProfileMockData.refundOrderOptions.first;
  String _reason = ProfileMockData.refundReasonOptions.first;
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final activeCount = ProfileMockData.activeRefunds.length;

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
              count: activeCount,
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
                  RefundSummaryCard(activeRequestCount: activeCount),
                  const RefundSectionTitle(RefundStrings.activeRequests),
                  for (final refund in ProfileMockData.activeRefunds)
                    RefundListItem(refund: refund),
                  const SizedBox(height: 8),
                  const RefundSectionTitle(RefundStrings.completed),
                  for (final refund in ProfileMockData.completedRefunds)
                    RefundListItem(refund: refund),
                  const SizedBox(height: 8),
                  const RefundSectionTitle(RefundStrings.requestNewRefund),
                  _RefundFormField(
                    label: 'Select Order',
                    child: _RefundDropdown(
                      value: _order,
                      items: ProfileMockData.refundOrderOptions,
                      onChanged: (value) =>
                          setState(() => _order = value ?? _order),
                    ),
                  ),
                  _RefundFormField(
                    label: 'Reason for Return',
                    child: _RefundDropdown(
                      value: _reason,
                      items: ProfileMockData.refundReasonOptions,
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
                    child: RefundActionButton(
                      label: RefundStrings.submitRequest,
                      onTap: () => PlaceifyToast.show(
                        context,
                        RefundStrings.requestSubmittedToast,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
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
          value: value,
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
