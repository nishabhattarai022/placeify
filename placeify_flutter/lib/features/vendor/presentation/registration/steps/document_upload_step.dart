import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placeify_client/placeify_client.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/haptic_service.dart';
import '../../../../../core/widgets/toast_overlay.dart';
import '../../../data/serverpod_vendor_document_repository.dart';
import '../../../domain/constants/vendor_registration_field_keys.dart';
import '../../providers/vendor_document_repository_provider.dart';
import '../../providers/vendor_registration_provider.dart';
import '../widgets/vendor_registration_error_banner.dart';

class DocumentUploadStep extends ConsumerWidget {
  const DocumentUploadStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'Upload documents to verify your business. Required files must be '
          'uploaded before you can submit.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        VendorRegistrationErrorBanner(errors: fieldErrors),
        _DocumentTile(
          title: 'Business License',
          subtitle: 'Required · JPG, PNG, or PDF',
          path: documents.businessLicensePath,
          error: fieldErrors[VendorRegistrationFieldKeys.businessLicense],
          documentType: VendorDocumentType.businessLicense,
          clearErrorFor: VendorRegistrationFieldKeys.businessLicense,
        ),
        const SizedBox(height: 12),
        _DocumentTile(
          title: 'Government ID',
          subtitle: 'Required · JPG or PNG',
          path: documents.governmentIdPath,
          error: fieldErrors[VendorRegistrationFieldKeys.governmentId],
          documentType: VendorDocumentType.governmentId,
          clearErrorFor: VendorRegistrationFieldKeys.governmentId,
        ),
        const SizedBox(height: 12),
        _DocumentTile(
          title: 'Tax Certificate',
          subtitle: 'Optional · JPG, PNG, or PDF',
          path: documents.taxCertificatePath,
          documentType: VendorDocumentType.taxCertificate,
        ),
      ],
    );
  }
}

class _DocumentTile extends ConsumerStatefulWidget {
  const _DocumentTile({
    required this.title,
    required this.subtitle,
    required this.path,
    required this.documentType,
    this.error,
    this.clearErrorFor,
  });

  final String title;
  final String subtitle;
  final String? path;
  final VendorDocumentType documentType;
  final String? error;
  final String? clearErrorFor;

  @override
  ConsumerState<_DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends ConsumerState<_DocumentTile> {
  bool _uploading = false;

  bool get _hasFile =>
      widget.path != null && isUploadedVendorDocument(widget.path);

  String get _displayName {
    final path = widget.path;
    if (path == null || path.isEmpty) return widget.subtitle;
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index == -1 ? normalized : normalized.substring(index + 1);
  }

  Future<void> _pickAndUpload() async {
    if (_uploading) return;

    HapticService.light();
    final source = await showModalBottomSheet<_DocumentPickSource>(
      context: context,
      backgroundColor: AppColors.warmWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upload document',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.espresso,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _DocumentPickSource.gallery,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _DocumentPickSource.camera,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined),
                title: const Text('Choose a file'),
                onTap: () => Navigator.pop(
                  sheetContext,
                  _DocumentPickSource.file,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || source == null) return;

    final localPath = await _pickLocalPath(source);
    if (!mounted || localPath == null) return;

    setState(() => _uploading = true);
    try {
      final repo = ref.read(vendorDocumentRepositoryProvider);
      final uploadedUrl = await repo.upload(
        documentType: widget.documentType,
        localPath: localPath,
      );
      if (!mounted) return;

      _updateDocumentPath(uploadedUrl);
      if (widget.clearErrorFor != null) {
        ref
            .read(vendorRegistrationProvider.notifier)
            .clearFieldError(widget.clearErrorFor!);
      }
      PlaceifyToast.show(context, 'Document uploaded');
    } on VendorDocumentUploadException catch (error) {
      if (mounted) PlaceifyToast.show(context, error.message);
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(context, 'Could not upload document. Try again.');
      }
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<String?> _pickLocalPath(_DocumentPickSource source) async {
    switch (source) {
      case _DocumentPickSource.gallery:
      case _DocumentPickSource.camera:
        final picker = ImagePicker();
        final image = await picker.pickImage(
          source: source == _DocumentPickSource.camera
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 88,
        );
        return image?.path;
      case _DocumentPickSource.file:
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        );
        final path = result?.files.single.path;
        if (path == null || path.isEmpty) return null;
        if (!await File(path).exists()) return null;
        return path;
    }
  }

  void _updateDocumentPath(String? path) {
    final notifier = ref.read(vendorRegistrationProvider.notifier);
    final documents = ref.read(vendorRegistrationProvider).form.documents;
    final next = switch (widget.documentType) {
      VendorDocumentType.businessLicense =>
        documents.copyWith(businessLicensePath: path),
      VendorDocumentType.governmentId =>
        documents.copyWith(governmentIdPath: path),
      VendorDocumentType.taxCertificate =>
        documents.copyWith(taxCertificatePath: path),
    };
    notifier.updateDocuments(next);
  }

  void _removeDocument() {
    HapticService.light();
    _updateDocumentPath(null);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null;

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
                  : _hasFile
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
                child: _uploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _hasFile
                            ? Icons.check_circle_outline
                            : Icons.upload_file_outlined,
                        color:
                            hasError ? AppColors.coral : AppColors.vendorForest,
                        size: 22,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _displayName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: _hasFile ? AppColors.sage : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (_hasFile && !_uploading)
                IconButton(
                  tooltip: 'Preview',
                  onPressed: () => _showPreview(context),
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                ),
              TextButton(
                onPressed: _uploading
                    ? null
                    : () {
                        if (_hasFile) {
                          _removeDocument();
                        } else {
                          _pickAndUpload();
                        }
                      },
                child: Text(_hasFile ? 'Remove' : 'Upload'),
              ),
            ],
          ),
        ),
        if (widget.error != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.error!,
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

  void _showPreview(BuildContext context) {
    final path = widget.path;
    if (path == null) return;

    final isPdf = path.toLowerCase().endsWith('.pdf') ||
        path.toLowerCase().contains('.pdf?');

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(widget.title),
          content: isPdf
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.picture_as_pdf_outlined, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      _displayName,
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'PDF uploaded successfully.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ],
                )
              : SizedBox(
                  width: 280,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: path.startsWith('http')
                          ? Image.network(path, fit: BoxFit.cover)
                          : Image.file(File(path), fit: BoxFit.cover),
                    ),
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

enum _DocumentPickSource { gallery, camera, file }
