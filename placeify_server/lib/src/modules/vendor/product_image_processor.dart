import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:serverpod/serverpod.dart';

import '../../shared/placeify_exception.dart';
import '../../shared/removebg_api_key_config.dart';

class ProcessedProductImage {
  const ProcessedProductImage({
    required this.bytes,
    required this.extension,
    required this.backgroundRemoved,
  });

  final Uint8List bytes;
  final String extension;
  final bool backgroundRemoved;
}

/// Catalog image (white background) plus untouched original for Tripo 3D.
class VendorProductImages {
  const VendorProductImages({
    required this.catalog,
    required this.tripoSource,
  });

  final ProcessedProductImage catalog;
  final ProcessedProductImage tripoSource;
}

/// Removes backgrounds via remove.bg for catalog; keeps originals for Tripo 3D.
///
/// Background removal is best-effort: quota, auth, network, or segmentation
/// failures never block product upload — the original photo is saved instead.
class ProductImageProcessor {
  ProductImageProcessor({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _removeBgUrl = 'https://api.remove.bg/v1.0/removebg';
  static const _maxCatalogWidth = 1600;
  static const _maxTripoWidth = 2560;
  static const _jpegQuality = 88;
  static const _tripoJpegQuality = 98;
  static final _white = img.ColorRgb8(255, 255, 255);

  final http.Client _httpClient;

  /// Removes the background, composites on white, and returns catalog-ready JPEG.
  Future<ProcessedProductImage> processForCatalog(
    Session session,
    Uint8List bytes,
    String fileName,
  ) async {
    final images = await processForVendorUpload(
      session,
      bytes,
      fileName,
      fileExtension: _extensionFromFileName(fileName),
    );
    return images.catalog;
  }

  /// White-background catalog JPEG + original photo for Tripo (no bg removal).
  Future<VendorProductImages> processForVendorUpload(
    Session session,
    Uint8List bytes,
    String fileName, {
    required String fileExtension,
  }) async {
    final apiKey = RemoveBgApiKeyConfig.apiKey();
    Uint8List? cutout;

    if (apiKey == null || apiKey.isEmpty) {
      session.log(
        'remove.bg API key missing — saving catalog without bg removal',
        level: LogLevel.warning,
      );
    } else {
      session.log(
        'Removing product image background via remove.bg (catalog only)',
        level: LogLevel.info,
      );
      try {
        cutout = await _removeBackgroundBestEffort(
          session,
          apiKey,
          bytes,
          fileName,
        );
      } catch (error, stackTrace) {
        session.log(
          'remove.bg failed unexpectedly — continuing with original photo: $error',
          level: LogLevel.warning,
          stackTrace: stackTrace,
        );
        cutout = null;
      }
    }

    late final Uint8List catalogBytes;
    late final bool backgroundRemoved;
    if (cutout != null) {
      try {
        final composited = _compositedOnWhiteImage(cutout);
        catalogBytes = Uint8List.fromList(
          img.encodeJpg(composited, quality: _jpegQuality),
        );
        backgroundRemoved = true;
      } catch (error, stackTrace) {
        session.log(
          'Cutout compositing failed — catalog fallback: $error',
          level: LogLevel.warning,
          stackTrace: stackTrace,
        );
        catalogBytes = _fallbackCatalogFromOriginal(bytes);
        backgroundRemoved = false;
      }
    } else {
      session.log(
        'remove.bg unavailable for this photo — saving catalog fallback '
        '(original, upload continues)',
        level: LogLevel.warning,
      );
      catalogBytes = _fallbackCatalogFromOriginal(bytes);
      backgroundRemoved = false;
    }

    final tripoSource = _prepareTripoSource(bytes, fileExtension);

    session.log(
      'Stored catalog (${catalogBytes.length} B, bgRemoved=$backgroundRemoved); '
      'Tripo source original (${tripoSource.bytes.length} B)',
      level: LogLevel.info,
    );

    return VendorProductImages(
      catalog: ProcessedProductImage(
        bytes: catalogBytes,
        extension: '.jpg',
        backgroundRemoved: backgroundRemoved,
      ),
      tripoSource: tripoSource,
    );
  }

  /// Tries `product` then `auto`; returns null when segmentation fails.
  Future<Uint8List?> _removeBackgroundBestEffort(
    Session session,
    String apiKey,
    Uint8List bytes,
    String fileName,
  ) async {
    for (final type in ['product', 'auto']) {
      final result = await _callRemoveBg(
        session,
        apiKey,
        bytes,
        fileName,
        type: type,
      );
      if (result != null) {
        session.log('remove.bg succeeded (type=$type)', level: LogLevel.info);
        return result;
      }
      session.log(
        'remove.bg type=$type could not segment image — trying next mode',
        level: LogLevel.warning,
      );
    }
    return null;
  }

  ProcessedProductImage _prepareTripoSource(
    Uint8List bytes,
    String fileExtension,
  ) {
    final ext = _normalizeExtension(fileExtension);

    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return ProcessedProductImage(
        bytes: bytes,
        extension: ext,
        backgroundRemoved: false,
      );
    }

    if (decoded.width <= _maxTripoWidth) {
      return ProcessedProductImage(
        bytes: bytes,
        extension: ext,
        backgroundRemoved: false,
      );
    }

    final resized = img.copyResize(decoded, width: _maxTripoWidth);
    final encoded = switch (ext) {
      '.png' => Uint8List.fromList(img.encodePng(resized)),
      _ => Uint8List.fromList(
        img.encodeJpg(resized, quality: _tripoJpegQuality),
      ),
    };

    return ProcessedProductImage(
      bytes: encoded,
      extension: ext == '.webp' ? '.jpg' : ext,
      backgroundRemoved: false,
    );
  }

  String _normalizeExtension(String extension) {
    final lower = extension.toLowerCase();
    if (lower == '.jpeg') return '.jpg';
    if (lower == '.png' || lower == '.webp' || lower == '.jpg') {
      return lower == '.jpeg' ? '.jpg' : lower;
    }
    return '.jpg';
  }

  String _extensionFromFileName(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.png')) return '.png';
    if (lower.endsWith('.webp')) return '.webp';
    if (lower.endsWith('.jpeg')) return '.jpg';
    if (lower.endsWith('.jpg')) return '.jpg';
    return '.jpg';
  }

  Future<Uint8List?> _callRemoveBg(
    Session session,
    String apiKey,
    Uint8List bytes,
    String fileName, {
    required String type,
  }) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_removeBgUrl))
        ..headers['X-Api-Key'] = apiKey
        ..fields['size'] = 'auto'
        ..fields['type'] = type
        ..fields['format'] = 'png'
        ..fields['bg_color'] = 'FFFFFF'
        ..files.add(
          http.MultipartFile.fromBytes(
            'image_file',
            bytes,
            filename: _uploadFileName(fileName),
          ),
        );

      final streamed = await _httpClient.send(request);
      final body = await http.Response.fromStream(streamed);

      if (body.statusCode == 200) {
        return body.bodyBytes;
      }

      final detail = _extractRemoveBgError(body.body);
      session.log(
        'remove.bg HTTP ${body.statusCode} (type=$type): $detail',
        level: LogLevel.warning,
      );

      // Quota / auth / rate limit: never fail product upload — fall back.
      if (body.statusCode == 402 ||
          body.statusCode == 403 ||
          body.statusCode == 429) {
        session.log(
          'remove.bg quota/auth/rate-limit (${body.statusCode}) — '
          'catalog will use original photo',
          level: LogLevel.warning,
        );
        return null;
      }

      return null;
    } catch (error, stackTrace) {
      session.log(
        'remove.bg request error (type=$type): $error',
        level: LogLevel.warning,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  String _extractRemoveBgError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        final errors = decoded['errors'];
        if (errors is List && errors.isNotEmpty) {
          final first = errors.first;
          if (first is Map && first['title'] is String) {
            return first['title'] as String;
          }
        }
        if (decoded['message'] is String) {
          return decoded['message'] as String;
        }
      }
    } catch (_) {
      // Fall through to raw body snippet.
    }
    return body.length > 200 ? '${body.substring(0, 200)}...' : body;
  }

  /// When remove.bg fails: resize if needed and save as JPEG (room background kept).
  Uint8List _fallbackCatalogFromOriginal(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw PlaceifyException(
        message: 'Could not decode product image.',
        code: 'IMAGE_DECODE_FAILED',
      );
    }

    final resized = decoded.width > _maxCatalogWidth
        ? img.copyResize(decoded, width: _maxCatalogWidth)
        : decoded;

    return Uint8List.fromList(
      img.encodeJpg(resized, quality: _jpegQuality),
    );
  }

  img.Image _compositedOnWhiteImage(Uint8List cutoutPngBytes) {
    final decoded = img.decodeImage(cutoutPngBytes);
    if (decoded == null) {
      throw PlaceifyException(
        message: 'Could not decode cutout image.',
        code: 'IMAGE_DECODE_FAILED',
      );
    }

    final resized = decoded.width > _maxCatalogWidth
        ? img.copyResize(decoded, width: _maxCatalogWidth)
        : decoded;

    final canvas = img.Image(
      width: resized.width,
      height: resized.height,
    );
    img.fill(canvas, color: _white);
    img.compositeImage(canvas, resized);
    return canvas;
  }

  String _uploadFileName(String fileName) {
    final sanitized = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    if (RegExp(r'\.(jpe?g|png|webp)$', caseSensitive: false).hasMatch(
      sanitized,
    )) {
      return sanitized;
    }
    return '$sanitized.jpg';
  }
}
