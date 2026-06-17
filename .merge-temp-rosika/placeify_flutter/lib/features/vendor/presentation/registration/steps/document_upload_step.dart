import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../providers/vendor_registration_provider.dart';

class DocumentUploadStep extends ConsumerWidget {
  const DocumentUploadStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documents = ref.watch(vendorRegistrationProvider).form.documents;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        const Text(
          'Verification documents',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C1810),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Upload documents to verify your business. Files are stored locally in this demo.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        _DocumentTile(
          title: 'Business License',
          subtitle: 'Required',
          path: documents.businessLicensePath,
          mockFileName: 'business_license.pdf',
          onUpload: () => _setDocument(
            ref,
            documents.copyWith(
              businessLicensePath: '/mock/business_license.pdf',
            ),
          ),
          onRemove: () => _setDocument(
            ref,
            documents.copyWith(businessLicensePath: null),
          ),
        ),
        const SizedBox(height: 12),
        _DocumentTile(
          title: 'Government ID',
          subtitle: 'Required',
          path: documents.governmentIdPath,
          mockFileName: 'government_id.jpg',
          onUpload: () => _setDocument(
            ref,
            documents.copyWith(governmentIdPath: '/mock/government_id.jpg'),
          ),
          onRemove: () => _setDocument(
            ref,
            documents.copyWith(governmentIdPath: null),
          ),
        ),
        const SizedBox(height: 12),
        _DocumentTile(
          title: 'Tax Certificate',
          subtitle: 'Optional',
          path: documents.taxCertificatePath,
          mockFileName: 'tax_certificate.pdf',
          onUpload: () => _setDocument(
            ref,
            documents.copyWith(taxCertificatePath: '/mock/tax_certificate.pdf'),
          ),
          onRemove: () => _setDocument(
            ref,
            documents.copyWith(taxCertificatePath: null),
          ),
        ),
      ],
    );
  }

  void _setDocument(WidgetRef ref, VendorDocuments documents) {
    ref.read(vendorRegistrationProvider.notifier).updateDocuments(documents);
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.subtitle,
    required this.path,
    required this.mockFileName,
    required this.onUpload,
    required this.onRemove,
  });

  final String title;
  final String subtitle;
  final String? path;
  final String mockFileName;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasFile = path != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasFile ? AppColors.vendorForest : AppColors.creamDark,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.vendorForestBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              hasFile ? Icons.check_circle_outline : Icons.upload_file_outlined,
              color: AppColors.vendorForest,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.espresso,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasFile ? mockFileName : subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: hasFile ? AppColors.sage : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              HapticService.light();
              if (hasFile) {
                onRemove();
              } else {
                onUpload();
              }
            },
            child: Text(hasFile ? 'Remove' : 'Upload'),
          ),
        ],
      ),
    );
  }
}
