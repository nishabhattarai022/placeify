import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/vendor_registration_provider.dart';

class ReviewSubmitStep extends ConsumerWidget {
  const ReviewSubmitStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(vendorRegistrationProvider);
    final form = uiState.form;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        const Text(
          'Review your application',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C1810),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Confirm everything looks correct before submitting for review.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        _ReviewSection(
          title: 'Business',
          rows: [
            _ReviewRow('Business', form.business.businessName),
            _ReviewRow('Contact', form.business.contactName),
            _ReviewRow('Email', form.business.email),
            _ReviewRow('Phone', form.business.phone),
            _ReviewRow('Tax ID', form.business.taxId),
          ],
        ),
        _ReviewSection(
          title: 'Address',
          rows: [
            _ReviewRow('Street', form.address.street),
            _ReviewRow('City', form.address.city),
            _ReviewRow('State', form.address.state),
            _ReviewRow('Postal', form.address.postalCode),
            _ReviewRow('Country', form.address.country),
          ],
        ),
        _ReviewSection(
          title: 'Category',
          rows: [
            _ReviewRow('Category', form.category.category),
            if (form.category.description.trim().isNotEmpty)
              _ReviewRow('Description', form.category.description),
          ],
        ),
        _ReviewSection(
          title: 'Documents',
          rows: [
            _ReviewRow(
              'Business License',
              form.documents.businessLicensePath != null ? 'Uploaded' : 'Missing',
            ),
            _ReviewRow(
              'Government ID',
              form.documents.governmentIdPath != null ? 'Uploaded' : 'Missing',
            ),
            _ReviewRow(
              'Tax Certificate',
              form.documents.taxCertificatePath != null ? 'Uploaded' : 'Not provided',
            ),
          ],
        ),
        _ReviewSection(
          title: 'Bank',
          rows: [
            _ReviewRow('Holder', form.bank.accountHolderName),
            _ReviewRow('Bank', form.bank.bankName),
            _ReviewRow(
              'Account',
              _maskAccount(form.bank.accountNumber),
            ),
            _ReviewRow('Routing', form.bank.routingNumber),
          ],
        ),
        if (uiState.submitError != null) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.coralBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.coral.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.coral, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    uiState.submitError!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.rust,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _maskAccount(String accountNumber) {
    if (accountNumber.length <= 4) return '••••';
    return '•••• ${accountNumber.substring(accountNumber.length - 4)}';
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_ReviewRow> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.vendorForest,
                letterSpacing: 0.08 * 11,
              ),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const SizedBox(height: 8),
              rows[i],
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.espresso,
            ),
          ),
        ),
      ],
    );
  }
}
