import 'dart:io';

/// Wraps remove.bg API — mock delay in prototype; swap implementation for production.
class BackgroundRemovalService {
  BackgroundRemovalService({this.simulateFailure = false});

  static const maxFileSizeBytes = 12 * 1024 * 1024;

  /// When true, [removeBackground] throws after the mock delay.
  bool simulateFailure;

  Future<BackgroundRemovalResult> removeBackground({
    required String sourcePath,
  }) async {
    final file = File(sourcePath);
    if (!await file.exists()) {
      throw BackgroundRemovalException('Image file not found.');
    }

    final size = await file.length();
    if (size > maxFileSizeBytes) {
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

    // Mock: processed image is the same file path (real API would write a new file).
    return BackgroundRemovalResult(
      originalPath: sourcePath,
      processedPath: sourcePath,
    );
  }
}

class BackgroundRemovalResult {
  const BackgroundRemovalResult({
    required this.originalPath,
    required this.processedPath,
  });

  final String originalPath;
  final String processedPath;
}

enum BackgroundRemovalErrorType { fileTooLarge, apiFailure }

class BackgroundRemovalException implements Exception {
  BackgroundRemovalException(this.message, {this.type});

  final String message;
  final BackgroundRemovalErrorType? type;

  @override
  String toString() => message;
}
