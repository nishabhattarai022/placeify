import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../shared/placeify_exception.dart';
import '../../shared/server_static_paths.dart';

/// Stores vendor verification documents on disk under `uploads/vendor_documents/`.
abstract final class VendorDocumentStorage {
  static const maxBytes = 5 * 1024 * 1024;

  static Future<String> persist({
    required Session session,
    required String ownerSegment,
    required ByteData fileData,
    required String fileName,
  }) async {
    final bytes = fileData.buffer.asUint8List(
      fileData.offsetInBytes,
      fileData.lengthInBytes,
    );
    if (bytes.isEmpty) {
      throw PlaceifyException(
        message: 'Document file is empty.',
        code: 'INVALID_FILE',
      );
    }
    if (bytes.length > maxBytes) {
      throw PlaceifyException(
        message: 'Document must be 5 MB or smaller.',
        code: 'FILE_TOO_LARGE',
      );
    }

    final sanitized = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final extension = _extension(sanitized) ?? _extensionFromBytes(bytes);
    if (extension == null) {
      throw PlaceifyException(
        message: 'Use a JPG, PNG, or PDF document.',
        code: 'INVALID_FILE_TYPE',
      );
    }

    final baseDir = Directory(
      '${ServerStaticPaths.uploadsDir()}${Platform.pathSeparator}vendor_documents'
      '${Platform.pathSeparator}$ownerSegment',
    );
    if (!baseDir.existsSync()) {
      baseDir.createSync(recursive: true);
    }

    final baseName = sanitized.replaceAll(RegExp(r'\.[^.]+$'), '');
    final storedName =
        '${DateTime.now().millisecondsSinceEpoch}_$baseName$extension';
    final file = File('${baseDir.path}${Platform.pathSeparator}$storedName');
    await file.writeAsBytes(bytes);

    session.log(
      'Stored vendor document $storedName for $ownerSegment',
      level: LogLevel.info,
    );

    return '/uploads/vendor_documents/$ownerSegment/$storedName';
  }

  static String? _extension(String fileName) {
    final match = RegExp(r'\.(pdf|jpe?g|png)$', caseSensitive: false)
        .firstMatch(fileName);
    if (match == null) return null;
    final ext = match.group(1)!.toLowerCase();
    return ext == 'jpeg' ? '.jpg' : '.$ext';
  }

  static String? _extensionFromBytes(Uint8List bytes) {
    if (bytes.length >= 4 &&
        bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46) {
      return '.pdf';
    }
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return '.jpg';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return '.png';
    }
    return null;
  }
}
