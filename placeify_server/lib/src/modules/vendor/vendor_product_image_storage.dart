import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/placeify_exception.dart';
import '../../shared/server_static_paths.dart';
import 'product_3d/product_3d_views.dart';
import 'product_image_processor.dart';

/// Persists vendor product and shop images to the static uploads directory.
class VendorProductImageStorage {
  Future<String> persistProductImage(
    Session session,
    ByteData fileData,
    String fileName, {
    required bool removeBackground,
  }) async {
    final bytes = fileData.buffer.asUint8List(
      fileData.offsetInBytes,
      fileData.lengthInBytes,
    );
    if (bytes.isEmpty) {
      throw PlaceifyException(message: 'Image file is empty.', code: 'INVALID_FILE');
    }
    if (bytes.length > 8 * 1024 * 1024) {
      throw PlaceifyException(
        message: 'Image must be 8 MB or smaller.',
        code: 'FILE_TOO_LARGE',
      );
    }

    final sanitized = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final extension =
        _imageExtension(sanitized) ?? _imageExtensionFromBytes(bytes);
    if (extension == null) {
      throw PlaceifyException(
        message: 'Use a JPG, PNG, or WEBP image.',
        code: 'INVALID_FILE_TYPE',
      );
    }

    final processor = ProductImageProcessor();
    final uploadsDir = Directory(ServerStaticPaths.uploadsDir());
    if (!uploadsDir.existsSync()) {
      uploadsDir.createSync(recursive: true);
    }

    final baseName = sanitized.replaceAll(RegExp(r'\.[^.]+$'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (removeBackground) {
      final processed = await processor.processForVendorUpload(
        session,
        bytes,
        sanitized,
        fileExtension: extension,
      );

      final storedName = '${timestamp}_$baseName${processed.catalog.extension}';
      final tripoStoredName =
          '${timestamp}_${baseName}_tripo${processed.tripoSource.extension}';

      await File(
        '${uploadsDir.path}${Platform.pathSeparator}$storedName',
      ).writeAsBytes(processed.catalog.bytes);
      await File(
        '${uploadsDir.path}${Platform.pathSeparator}$tripoStoredName',
      ).writeAsBytes(processed.tripoSource.bytes);

      session.log(
        'Stored catalog thumbnail $storedName and Tripo raw $tripoStoredName',
        level: LogLevel.info,
      );
      return '/uploads/$storedName';
    }

    final storedName = '${timestamp}_$baseName$extension';
    await File(
      '${uploadsDir.path}${Platform.pathSeparator}$storedName',
    ).writeAsBytes(bytes);
    session.log(
      'Stored raw product photo $storedName (${bytes.length} bytes, no bg removal)',
      level: LogLevel.info,
    );
    return '/uploads/$storedName';
  }

  /// Keeps Tripo view order [left, back, right].
  static List<String>? normalizeViewImageUrls(List<String>? urls) {
    if (urls == null || urls.isEmpty) return null;

    final normalized = urls
        .take(Product3dViews.maxStoredViewImages)
        .map((url) => url.trim())
        .toList(growable: false);
    if (normalized.every((url) => url.isEmpty)) return null;

    final trimmed = List<String>.from(normalized);
    while (trimmed.isNotEmpty && trimmed.last.isEmpty) {
      trimmed.removeLast();
    }
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _imageExtension(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return '.jpg';
    if (lower.endsWith('.png')) return '.png';
    if (lower.endsWith('.webp')) return '.webp';
    if (lower.endsWith('.heic')) return '.heic';
    return null;
  }

  String? _imageExtensionFromBytes(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return '.jpg';
    }
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return '.png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return '.webp';
    }
    return null;
  }
}
