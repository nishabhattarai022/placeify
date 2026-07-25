import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../../shared/placeify_exception.dart';
import '../../shared/server_static_paths.dart';

/// Stores consumer profile photos under `uploads/profiles/`.
abstract final class UserProfileImageStorage {
  static const maxBytes = 5 * 1024 * 1024;

  static Future<String> persist({
    required Session session,
    required UuidValue userId,
    required ByteData fileData,
    required String fileName,
  }) async {
    final bytes = fileData.buffer.asUint8List(
      fileData.offsetInBytes,
      fileData.lengthInBytes,
    );
    if (bytes.isEmpty) {
      throw PlaceifyException(
        message: 'Image file is empty.',
        code: 'INVALID_FILE',
      );
    }
    if (bytes.length > maxBytes) {
      throw PlaceifyException(
        message: 'Image must be 5 MB or smaller.',
        code: 'FILE_TOO_LARGE',
      );
    }

    final sanitized = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final extension = _extension(sanitized) ?? _extensionFromBytes(bytes);
    if (extension == null) {
      throw PlaceifyException(
        message: 'Use a JPG, PNG, or WEBP image.',
        code: 'INVALID_FILE_TYPE',
      );
    }

    final ownerDir = Directory(
      '${ServerStaticPaths.uploadsDir()}${Platform.pathSeparator}profiles'
      '${Platform.pathSeparator}${userId.uuid}',
    );
    if (!ownerDir.existsSync()) {
      ownerDir.createSync(recursive: true);
    }

    final baseName = sanitized.replaceAll(RegExp(r'\.[^.]+$'), '');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storedName = '${timestamp}_$baseName$extension';
    await File(
      '${ownerDir.path}${Platform.pathSeparator}$storedName',
    ).writeAsBytes(bytes);

    return '/uploads/profiles/${userId.uuid}/$storedName';
  }

  static String? _extension(String fileName) {
    final match = RegExp(r'\.([a-zA-Z0-9]+)$').firstMatch(fileName);
    if (match == null) return null;
    return '.${match.group(1)!.toLowerCase()}';
  }

  static String? _extensionFromBytes(Uint8List bytes) {
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
