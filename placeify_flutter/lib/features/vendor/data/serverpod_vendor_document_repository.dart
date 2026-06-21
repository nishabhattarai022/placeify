import 'dart:io';
import 'dart:typed_data';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/utils/local_image_path.dart';

class VendorDocumentUploadException implements Exception {
  VendorDocumentUploadException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Uploads vendor verification documents via [client.vendor.uploadDocument].
class ServerpodVendorDocumentRepository {
  const ServerpodVendorDocumentRepository();

  Future<String> upload({
    required VendorDocumentType documentType,
    required String localPath,
  }) async {
    if (!client.auth.isAuthenticated) {
      throw VendorDocumentUploadException('Sign in to upload documents.');
    }

    final file = File(LocalImagePath.normalize(localPath));
    if (!await file.exists()) {
      throw VendorDocumentUploadException('Could not read the selected file.');
    }

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw VendorDocumentUploadException('The selected file is empty.');
    }

    try {
      return await client.vendor.uploadDocument(
        documentType,
        ByteData.sublistView(bytes),
        _fileName(localPath),
      );
    } catch (error) {
      throw VendorDocumentUploadException(_mapError(error));
    }
  }

  String _fileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index == -1 ? normalized : normalized.substring(index + 1);
  }

  String _mapError(Object error) {
    if (error is VendorDocumentUploadException) return error.message;
    if (error is PlaceifyException) {
      return switch (error.code) {
        'FILE_TOO_LARGE' => 'Document must be 5 MB or smaller.',
        'INVALID_FILE_TYPE' => 'Use a JPG, PNG, or PDF file.',
        'INVALID_FILE' => 'The selected file is invalid.',
        'UNAUTHORIZED' => 'You can only upload documents for your own shop.',
        _ => error.message,
      };
    }

    final raw = error.toString();
    if (raw.toLowerCase().contains('socketexception') ||
        raw.toLowerCase().contains('connection refused')) {
      return 'Cannot reach the server. Make sure placeify_server is running.';
    }
    return 'Could not upload document. Please try again.';
  }
}
