import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:serverpod/serverpod.dart';

import '../../shared/placeify_exception.dart';

/// Result of preparing a vendor product photo for the catalog.
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

/// Removes backgrounds (via remove.bg when configured) and composites on white.
class ProductImageProcessor {
  ProductImageProcessor({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _removeBgUrl = 'https://api.remove.bg/v1.0/removebg';
  static const _apiKeyEnv = 'PLACEIFY_REMOVEBG_API_KEY';
  static const _maxCatalogWidth = 1600;
  static const _jpegQuality = 88;

  final http.Client _httpClient;

  /// Prepares catalog-ready JPEG bytes on a white background.
  ///
  /// When [PLACEIFY_REMOVEBG_API_KEY] is set, calls remove.bg first. Otherwise
  /// the original image is normalized (resize/re-encode) without bg removal.
  Future<ProcessedProductImage> processForCatalog(
    Session session,
    Uint8List bytes,
    String fileName,
  ) async {
    final apiKey = Platform.environment[_apiKeyEnv]?.trim();
    Uint8List working = bytes;
    var backgroundRemoved = false;

    if (apiKey != null && apiKey.isNotEmpty) {
      try {
        working = await _removeBackground(apiKey, bytes, fileName);
        backgroundRemoved = true;
      } on PlaceifyException catch (error) {
        session.log(
          'Product image background removal failed (${error.code}); '
          'using original upload.',
          level: LogLevel.warning,
        );
        working = bytes;
      }
    } else {
      session.log(
        '$_apiKeyEnv is not set; storing product image without background removal.',
        level: LogLevel.info,
      );
    }

    final catalogBytes = backgroundRemoved
        ? _compositeOnWhite(working)
        : _normalizeOriginal(working);

    return ProcessedProductImage(
      bytes: catalogBytes,
      extension: '.jpg',
      backgroundRemoved: backgroundRemoved,
    );
  }

  Future<Uint8List> _removeBackground(
    String apiKey,
    Uint8List bytes,
    String fileName,
  ) async {
    final request = http.MultipartRequest('POST', Uri.parse(_removeBgUrl))
      ..headers['X-Api-Key'] = apiKey
      ..fields['size'] = 'auto'
      ..fields['format'] = 'png'
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

    final detail = body.body.length > 200
        ? '${body.body.substring(0, 200)}...'
        : body.body;

    if (body.statusCode == 402 || body.statusCode == 403) {
      throw PlaceifyException(
        'Background removal quota or API key issue.',
        code: 'BG_REMOVAL_AUTH',
      );
    }

    throw PlaceifyException(
      'Background removal service error (${body.statusCode}): $detail',
      code: 'BG_REMOVAL_FAILED',
    );
  }

  Uint8List _compositeOnWhite(Uint8List cutoutPngBytes) {
    final decoded = img.decodeImage(cutoutPngBytes);
    if (decoded == null) {
      throw PlaceifyException(
        'Could not decode cutout image.',
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
    img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
    img.compositeImage(canvas, resized);

    return Uint8List.fromList(
      img.encodeJpg(canvas, quality: _jpegQuality),
    );
  }

  Uint8List _normalizeOriginal(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return bytes;
    }

    final resized = decoded.width > _maxCatalogWidth
        ? img.copyResize(decoded, width: _maxCatalogWidth)
        : decoded;

    return Uint8List.fromList(
      img.encodeJpg(resized, quality: _jpegQuality),
    );
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
