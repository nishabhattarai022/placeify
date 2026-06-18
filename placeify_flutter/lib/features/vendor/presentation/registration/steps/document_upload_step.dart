import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../../core/config/placeify_server_client.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/utils/local_image_path.dart';
import '../../../domain/constants/vendor_registration_field_keys.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../providers/vendor_registration_provider.dart';

class DocumentUploadStep extends ConsumerWidget {
  const DocumentUploadStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(vendorRegistrationProvider);
    final documents = uiState.form.documents;

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
          'Upload JPG, PNG, or PDF files up to 5 MB. Documents are stored securely on the server.',
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
          fieldKey: VendorRegistrationFieldKeys.businessLicense,
          errorText: uiState.fieldError(VendorRegistrationFieldKeys.businessLicense),
          isUploading: uiState.uploadingDocuments
              .contains(VendorRegistrationFieldKeys.businessLicense),
          onUpload: () => _pickAndUpload(
            ref,
            documentType: VendorDocumentType.businessLicense,
            fieldKey: VendorRegistrationFieldKeys.businessLicense,
            applyUrl: (docs, url) => docs.copyWith(businessLicensePath: url),
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
          fieldKey: VendorRegistrationFieldKeys.governmentId,
          errorText: uiState.fieldError(VendorRegistrationFieldKeys.governmentId),
          isUploading: uiState.uploadingDocuments
              .contains(VendorRegistrationFieldKeys.governmentId),
          onUpload: () => _pickAndUpload(
            ref,
            documentType: VendorDocumentType.governmentId,
            fieldKey: VendorRegistrationFieldKeys.governmentId,
            applyUrl: (docs, url) => docs.copyWith(governmentIdPath: url),
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
          fieldKey: VendorRegistrationFieldKeys.taxCertificate,
          errorText: uiState.fieldError(VendorRegistrationFieldKeys.taxCertificate),
          isUploading: uiState.uploadingDocuments
              .contains(VendorRegistrationFieldKeys.taxCertificate),
          onUpload: () => _pickAndUpload(
            ref,
            documentType: VendorDocumentType.taxCertificate,
            fieldKey: VendorRegistrationFieldKeys.taxCertificate,
            applyUrl: (docs, url) => docs.copyWith(taxCertificatePath: url),
          ),
          onRemove: () => _setDocument(
            ref,
            documents.copyWith(taxCertificatePath: null),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndUpload(
    WidgetRef ref, {
    required VendorDocumentType documentType,
    required String fieldKey,
    required VendorDocuments Function(VendorDocuments documents, String url)
        applyUrl,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
      withData: false,
    );
    final path = result?.files.single.path;
    if (path == null || path.isEmpty) return;

    await ref.read(vendorRegistrationProvider.notifier).uploadDocument(
          documentType: documentType,
          fieldKey: fieldKey,
          localPath: path,
          applyUrl: applyUrl,
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
    required this.fieldKey,
    required this.onUpload,
    required this.onRemove,
    this.errorText,
    this.isUploading = false,
  });

  final String title;
  final String subtitle;
  final String? path;
  final String fieldKey;
  final String? errorText;
  final bool isUploading;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final hasFile = isUploadedVendorDocument(path);
    final displayName = _displayName(path);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: errorText != null
                  ? AppColors.rust
                  : hasFile
                      ? AppColors.vendorForest
                      : AppColors.creamDark,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              _Preview(path: path, isUploading: isUploading),
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
                      isUploading
                          ? 'Uploading...'
                          : hasFile
                              ? displayName
                              : subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: hasFile ? AppColors.sage : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUploading)
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
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
        ),
        if (errorText != null && errorText!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: const TextStyle(fontSize: 12, color: AppColors.rust),
          ),
        ],
      ],
    );
  }

  String _displayName(String? value) {
    if (value == null) return subtitle;
    final normalized = value.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index == -1 ? normalized : normalized.substring(index + 1);
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.path, required this.isUploading});

  final String? path;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final hasFile = isUploadedVendorDocument(path);

    if (isUploading) {
      return _iconBox(Icons.cloud_upload_outlined);
    }

    if (hasFile && path != null) {
      final lower = path!.toLowerCase();
      if (lower.endsWith('.pdf')) {
        return _iconBox(Icons.picture_as_pdf_outlined);
      }

      final imageProvider = _imageProvider(path!);
      if (imageProvider != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image(
            image: imageProvider,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    return _iconBox(
      hasFile ? Icons.check_circle_outline : Icons.upload_file_outlined,
    );
  }

  ImageProvider? _imageProvider(String value) {
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }
    if (value.startsWith('/uploads/')) {
      return NetworkImage('$serverUrl$value');
    }
    if (LocalImagePath.isLocal(value)) {
      return FileImage(File(LocalImagePath.normalize(value)));
    }
    return null;
  }

  Widget _iconBox(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.vendorForestBg,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: AppColors.vendorForest, size: 22),
    );
  }
}
