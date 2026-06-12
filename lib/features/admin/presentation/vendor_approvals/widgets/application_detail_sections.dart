import 'package:flutter/material.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/features/vendor/domain/models/vendor_registration.dart';

class ApplicationDetailSections extends StatelessWidget {
  const ApplicationDetailSections({
    required this.registration,
    super.key,
  });

  final VendorRegistration registration;

  @override
  Widget build(BuildContext context) {
    final form = registration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailSection(
          title: 'Business',
          rows: [
            _DetailRow('Business', form.business.businessName),
            _DetailRow('Contact', form.business.contactName),
            _DetailRow('Email', form.business.email),
            _DetailRow('Phone', form.business.phone),
            if (form.business.taxId.trim().isNotEmpty)
              _DetailRow('Tax ID', form.business.taxId),
          ],
        ),
        _DetailSection(
          title: 'Address',
          rows: [
            _DetailRow('Street', form.address.street),
            _DetailRow('City', form.address.city),
            _DetailRow('State', form.address.state),
            _DetailRow('Postal', form.address.postalCode),
            _DetailRow('Country', form.address.country),
          ],
        ),
        _DetailSection(
          title: 'Category',
          rows: [
            _DetailRow('Category', form.category.category),
            if (form.category.description.trim().isNotEmpty)
              _DetailRow('Description', form.category.description),
          ],
        ),
        _DetailSection(
          title: 'Documents',
          rows: [
            _DetailRow(
              'Business License',
              form.documents.businessLicensePath != null
                  ? 'Uploaded'
                  : 'Not provided',
            ),
            _DetailRow(
              'Government ID',
              form.documents.governmentIdPath != null
                  ? 'Uploaded'
                  : 'Not provided',
            ),
            _DetailRow(
              'Tax Certificate',
              form.documents.taxCertificatePath != null
                  ? 'Uploaded'
                  : 'Not provided',
            ),
          ],
        ),
        _DetailSection(
          title: 'Bank',
          rows: [
            _DetailRow('Holder', form.bank.accountHolderName),
            _DetailRow('Bank', form.bank.bankName),
            _DetailRow('Account', _maskAccount(form.bank.accountNumber)),
            _DetailRow('Routing', form.bank.routingNumber),
          ],
        ),
      ],
    );
  }

  String _maskAccount(String accountNumber) {
    if (accountNumber.length <= 4) return '••••';
    return '•••• ${accountNumber.substring(accountNumber.length - 4)}';
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({
    required this.title,
    required this.rows,
  });

  final String title;
  final List<_DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.creamDark, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.sectionTitle.copyWith(fontSize: 16),
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

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 108,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
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
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
