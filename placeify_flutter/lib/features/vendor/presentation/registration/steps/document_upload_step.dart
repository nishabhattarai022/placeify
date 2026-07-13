import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placeify_client/placeify_client.dart' show VendorDocumentType;

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../data/serverpod_vendor_document_repository.dart';
import '../../../domain/constants/vendor_registration_field_keys.dart'
    show isUploadedVendorDocument;
import '../../../domain/models/vendor_registration.dart';
import '../../../domain/validators/vendor_registration_validator.dart';
import '../../providers/vendor_document_repository_provider.dart';
import '../../providers/vendor_registration_provider.dart';
import '../widgets/vendor_registration_error_banner.dart';

enum _DocumentSource { gallery, camera, file }

class DocumentUploadStep extends ConsumerStatefulWidget {
  const DocumentUploadStep({super.key});

  @override
  ConsumerState<DocumentUploadStep> createState() => _DocumentUploadStepState();
}

class _DocumentUploadStepState extends ConsumerState<DocumentUploadStep> {
  VendorDocumentType? _uploadingType;
  String? _uploadError;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(vendorRegistrationProvider);
    final documents = uiState.form.documents;
    final fieldErrors = uiState.fieldErrors;

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
          'Upload JPG, PNG, or PDF files. Documents are stored securely for admin review.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        VendorRegistrationErrorBanner(errors: fieldErrors),
        if (_uploadError != null) ...[
          Text(
            _uploadError!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.coral,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
        ],
        _DocumentTile(
          title: 'Business License',
          subtitle: 'Required',
          path: documents.businessLicensePath,
          isUploading: _uploadingType == VendorDocumentType.businessLicense,
          error: fieldErrors[VendorRegistrationFieldKeys.businessLicense],
          onUpload: () => _upload(
            type: VendorDocumentType.businessLicense,
            clearErrorFor: VendorRegistrationFieldKeys.businessLicense,
          ),
          onRemove: () => _setDocument(
            documents.copyWith(businessLicensePath: null),
          ),
        ),
        const SizedBox(height: 12),
        _DocumentTile(
          title: 'Government ID',
          subtitle: 'Required',
          path: documents.governmentIdPath,
          isUploading: _uploadingType == VendorDocumentType.governmentId,
          error: fieldErrors[VendorRegistrationFieldKeys.governmentId],
          onUpload: () => _upload(
            type: VendorDocumentType.governmentId,
            clearErrorFor: VendorRegistrationFieldKeys.governmentId,
          ),
          onRemove: () => _setDocument(
            documents.copyWith(governmentIdPath: null),
          ),
        ),
        const SizedBox(height: 12),
        _DocumentTile(
          title: 'Tax Certificate',
          subtitle: 'Optional',
          path: documents.taxCertificatePath,
          isUploading: _uploadingType == VendorDocumentType.taxCertificate,
          onUpload: () => _upload(type: VendorDocumentType.taxCertificate),
          onRemove: () => _setDocument(
            documents.copyWith(taxCertificatePath: null),
          ),
        ),
      ],
    );
  }

  Future<_DocumentSource?> _showDocumentSourceSheet() {
    return PlaceifyBottomSheet.show<_DocumentSource>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PlaceifyBottomSheetHeader(title: 'Upload document'),
            const SizedBox(height: 12),
            PlaceifySelectTile(
              label: 'Choose from gallery',
              selected: false,
              icon: Icons.photo_library_outlined,
              onTap: () => Navigator.pop(sheetContext, _DocumentSource.gallery),
            ),
            const SizedBox(height: 4),
            PlaceifySelectTile(
              label: 'Take a photo',
              selected: false,
              icon: Icons.photo_camera_outlined,
              onTap: () => Navigator.pop(sheetContext, _DocumentSource.camera),
            ),
            const SizedBox(height: 4),
            PlaceifySelectTile(
              label: 'Choose a file',
              selected: false,
              icon: Icons.insert_drive_file_outlined,
              onTap: () => Navigator.pop(sheetContext, _DocumentSource.file),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _pickLocalPath(_DocumentSource source) async {
    switch (source) {
      case _DocumentSource.gallery:
        final image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        return image?.path;
      case _DocumentSource.camera:
        final image = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        return image?.path;
      case _DocumentSource.file:
        final picked = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
          withData: false,
        );
        return picked?.files.single.path;
    }
  }

  Future<void> _upload({
    required VendorDocumentType type,
    String? clearErrorFor,
  }) async {
    if (_uploadingType != null) return;

    final source = await _showDocumentSourceSheet();
    if (source == null || !mounted) return;

    setState(() {
      _uploadingType = type;
      _uploadError = null;
    });

    try {
      final localPath = await _pickLocalPath(source);
      if (localPath == null || localPath.trim().isEmpty) {
        return;
      }

      final repo = ref.read(vendorDocumentRepositoryProvider);
      final serverUrl = await repo.upload(
        documentType: type,
        localPath: localPath,
      );

      if (!isUploadedVendorDocument(serverUrl)) {
        throw VendorDocumentUploadException(
          'Upload succeeded but the server returned an invalid document URL.',
        );
      }

      if (kDebugMode) {
        debugPrint('vendor_doc_upload type=$type url=$serverUrl');
      }

      final latest = ref.read(vendorRegistrationProvider).form.documents;
      final updated = switch (type) {
        VendorDocumentType.businessLicense => latest.copyWith(
          businessLicensePath: serverUrl,
        ),
        VendorDocumentType.governmentId => latest.copyWith(
          governmentIdPath: serverUrl,
        ),
        VendorDocumentType.taxCertificate => latest.copyWith(
          taxCertificatePath: serverUrl,
        ),
      };
      _setDocument(updated, clearErrorFor: clearErrorFor);
    } on VendorDocumentUploadException catch (error) {
      if (mounted) {
        setState(() => _uploadError = error.message);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _uploadError = 'Could not upload document. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _uploadingType = null);
      }
    }
  }

  void _setDocument(
    VendorDocuments documents, {
    String? clearErrorFor,
  }) {
    final notifier = ref.read(vendorRegistrationProvider.notifier);
    notifier.updateDocuments(documents);
    if (clearErrorFor != null) notifier.clearFieldError(clearErrorFor);
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.subtitle,
    required this.path,
    required this.onUpload,
    required this.onRemove,
    this.isUploading = false,
    this.error,
  });

  final String title;
  final String subtitle;
  final String? path;
  final bool isUploading;
  final VoidCallback onUpload;
  final VoidCallback onRemove;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final hasFile = isUploadedVendorDocument(path);
    final hasError = error != null;
    final fileLabel = hasFile ? _fileLabel(path!) : subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError
                  ? AppColors.coral
                  : hasFile
                  ? AppColors.vendorForest
                  : AppColors.creamDark,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: hasError
                      ? AppColors.coralBg
                      : AppColors.vendorForestBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        hasFile
                            ? Icons.check_circle_outline
                            : Icons.upload_file_outlined,
                        color: hasError
                            ? AppColors.coral
                            : AppColors.vendorForest,
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
                      isUploading ? 'Uploading…' : fileLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: hasFile ? AppColors.sage : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: isUploading
                    ? null
                    : () {
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
        if (error != null) ...[
          const SizedBox(height: 6),
          Text(
            error!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.coral,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }

  String _fileLabel(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    final name = index == -1 ? normalized : normalized.substring(index + 1);
    if (name.isEmpty) return 'Uploaded';
    return name;
  }
}
