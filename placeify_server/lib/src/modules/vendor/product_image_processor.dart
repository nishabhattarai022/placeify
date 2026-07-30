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
class ProductImageProcessor {
  ProductImageProcessor({
    http.Client? httpClient,
    String? apiKeyOverride,
  })  : _httpClient = httpClient ?? http.Client(),
        _apiKeyOverride = apiKeyOverride;

  static const _removeBgUrl = 'https://api.remove.bg/v1.0/removebg';
  static const _maxCatalogWidth = 1600;
  static const _maxTripoWidth = 2560;
  static const _jpegQuality = 88;
  static const _tripoJpegQuality = 98;
  static final _white = img.ColorRgb8(255, 255, 255);

  final http.Client _httpClient;
  final String? _apiKeyOverride;

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
    final apiKey = _apiKeyOverride ?? RemoveBgApiKeyConfig.apiKey();
    if (apiKey == null || apiKey.isEmpty) {
      session.log(
        'remove.bg API key not configured — saving catalog fallback without '
        'background removal',
        level: LogLevel.warning,
      );
      final catalogBytes = _fallbackCatalogFromOriginal(bytes);
      final tripoSource = _prepareTripoSource(bytes, fileExtension);
      return VendorProductImages(
        catalog: ProcessedProductImage(
          bytes: catalogBytes,
          extension: '.jpg',
          backgroundRemoved: false,
        ),
        tripoSource: tripoSource,
      );
    }

    session.log(
      'Removing product image background via remove.bg (catalog only)',
      level: LogLevel.info,
    );

    final cutout = await _removeBackgroundBestEffort(session, apiKey, bytes, fileName);

    final Uint8List catalogBytes;
    final bool backgroundRemoved;
    if (cutout != null) {
      final composited = _compositedOnWhiteImage(cutout);
      catalogBytes = Uint8List.fromList(
        img.encodeJpg(composited, quality: _jpegQuality),
      );
      backgroundRemoved = true;
    } else {
      session.log(
        'remove.bg could not segment this photo — saving catalog fallback '
        '(original on white, upload continues)',
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

  /// Uses remove.bg `product` mode only — same segmentation as the front photo.
  ///
  /// Side/back views often fail `product` and previously fell back to `auto`, which
  /// over-segments thin furniture legs and erodes mesh-friendly detail.
  Future<Uint8List?> _removeBackgroundBestEffort(
    Session session,
    String apiKey,
    Uint8List bytes,
    String fileName,
  ) async {
    const type = 'product';
    final result = await _callRemoveBg(
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
      'remove.bg type=$type could not segment image — using catalog fallback',
      level: LogLevel.warning,
    );
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
      _ => Uint8List.fromList(img.encodeJpg(resized, quality: _tripoJpegQuality)),
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
    String apiKey,
    Uint8List bytes,
    String fileName, {
    required String type,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(_removeBgUrl))
      ..headers['X-Api-Key'] = apiKey
      ..fields['size'] = 'auto'
      ..fields['type'] = type
      ..fields['format'] = 'png'
      ..fields['crop'] = 'false'
      ..fields['semitransparency'] = 'true'
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

    if (body.statusCode == 402 || body.statusCode == 403) {
      throw PlaceifyException(
        message: 'Background removal quota or API key issue.',
        code: 'BG_REMOVAL_AUTH',
      );
    }

    if (body.statusCode == 429) {
      throw PlaceifyException(
        message: 'Background removal rate limit reached. Try again shortly.',
        code: 'BG_REMOVAL_AUTH',
      );
    }

    // Segmentation / foreground failures — caller will fall back to original.
    if (_isSegmentationFailure(body.statusCode, detail)) {
      return null;
    }

    // Unknown errors: still allow upload via fallback rather than block vendor.
    return null;
  }

  bool _isSegmentationFailure(int statusCode, String detail) {
    if (statusCode == 400 || statusCode == 422) return true;
    final lower = detail.toLowerCase();
    return lower.contains('foreground') ||
        lower.contains('identify') ||
        lower.contains('segment');
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
