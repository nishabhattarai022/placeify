import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../utils/local_image_reader.dart';
import '../utils/local_image_store.dart';

/// Wraps remove.bg API — mock delay in prototype; swap implementation for production.
class BackgroundRemovalService {
  BackgroundRemovalService({this.simulateFailure = false});

  static const maxFileSizeBytes = 12 * 1024 * 1024;

  /// When true, [removeBackground] throws after the mock delay.
  bool simulateFailure;

  Future<BackgroundRemovalResult> removeBackground({
    required String sourcePath,
    Uint8List? sourceBytes,
    String? fileName,
  }) async {
    final bytes = sourceBytes ?? await _readSourceBytes(sourcePath, fileName: fileName);
    if (bytes == null) {
      throw BackgroundRemovalException('Image file not found.');
    }

    if (bytes.length > maxFileSizeBytes) {
      throw BackgroundRemovalException(
        'Image exceeds 12 MB limit. Choose a smaller file.',
        type: BackgroundRemovalErrorType.fileTooLarge,
      );
    }

    await Future<void>.delayed(const Duration(milliseconds: 1800));

    if (simulateFailure) {
      throw BackgroundRemovalException(
        'Background removal failed. Please try again.',
        type: BackgroundRemovalErrorType.apiFailure,
      );
    }

    final resolvedName = fileName?.trim().isNotEmpty == true
        ? fileName!.trim()
        : 'product.jpg';

    if (kIsWeb) {
      final processedUri = LocalImageStore.register(bytes, resolvedName);
      return BackgroundRemovalResult(
        originalPath: sourcePath,
        processedPath: processedUri,
        processedBytes: bytes,
      );
    }

    return BackgroundRemovalResult(
      originalPath: sourcePath,
      processedPath: sourcePath,
      processedBytes: bytes,
    );
  }

  Future<Uint8List?> _readSourceBytes(
    String sourcePath, {
    String? fileName,
  }) async {
    final data = await LocalImageReader.read(sourcePath, fileName: fileName);
    return data?.bytes;
  }
}

class BackgroundRemovalResult {
  const BackgroundRemovalResult({
    required this.originalPath,
    required this.processedPath,
    this.processedBytes,
  });

  final String originalPath;
  final String processedPath;
  final Uint8List? processedBytes;
}

enum BackgroundRemovalErrorType { fileTooLarge, apiFailure }

class BackgroundRemovalException implements Exception {
  BackgroundRemovalException(this.message, {this.type});

  final String message;
  final BackgroundRemovalErrorType? type;

  @override
  String toString() => message;
}
