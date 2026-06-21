import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/profile_mock_data.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/refund/refund_list_item.dart';
import 'widgets/refund/refund_summary_card.dart';
import 'widgets/shared/profile_form_field.dart';
import 'widgets/shared/profile_submit_button.dart';

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
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Refund & Returns'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: [
                const RefundSummaryCard(),
                const _SectionTitle('Active Requests'),
                for (final r in ProfileMockData.activeRefunds)
                  RefundListItem(refund: r),
                const SizedBox(height: 8),
                const _SectionTitle('Completed'),
                for (final r in ProfileMockData.completedRefunds)
                  RefundListItem(refund: r),
                const SizedBox(height: 8),
                const _SectionTitle('Request New Refund'),
                ProfileFormField(
                  label: 'Select Order',
                  child: ProfileDropdown(
                    value: _order,
                    items: ProfileMockData.refundOrderOptions,
                    onChanged: (v) => setState(() => _order = v ?? _order),
                  ),
                ),
                ProfileFormField(
                  label: 'Reason for Return',
                  child: ProfileDropdown(
                    value: _reason,
                    items: ProfileMockData.refundReasonOptions,
                    onChanged: (v) => setState(() => _reason = v ?? _reason),
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
                  label: 'Submit Refund Request',
                  onPressed: () =>
                      PlaceifyToast.show(context, 'Refund request submitted ✓'),
                ),
              ],
            ),
          ),
        ],
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
