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

/// Removes backgrounds via remove.bg and composites furniture on white (#FFFFFF).
class ProductImageProcessor {
  ProductImageProcessor({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _removeBgUrl = 'https://api.remove.bg/v1.0/removebg';
  static const _maxCatalogWidth = 1600;
  static const _jpegQuality = 88;
  static final _white = img.ColorRgb8(255, 255, 255);

  final http.Client _httpClient;

  /// Removes the background, composites on white, and returns catalog-ready JPEG.
  Future<ProcessedProductImage> processForCatalog(
    Session session,
    Uint8List bytes,
    String fileName,
  ) async {
    final apiKey = RemoveBgApiKeyConfig.apiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw PlaceifyException(
        message:
            'Background removal is not configured. Copy '
            'config/removebg_api_key.example.yaml to config/removebg_api_key.yaml '
            'and add your remove.bg API key.',
        code: 'BG_REMOVAL_NOT_CONFIGURED',
      );
    }

    session.log(
      'Removing product image background via remove.bg',
      level: LogLevel.info,
    );

    final cutout = await _removeBackground(apiKey, bytes, fileName);
    final catalogBytes = _compositeOnWhite(cutout);

    session.log(
      'Product image processed on white background (${catalogBytes.length} bytes)',
      level: LogLevel.info,
    );

    return ProcessedProductImage(
      bytes: catalogBytes,
      extension: '.jpg',
      backgroundRemoved: true,
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

    final detail = body.body.length > 200
        ? '${body.body.substring(0, 200)}...'
        : body.body;

    if (body.statusCode == 402 || body.statusCode == 403) {
      throw PlaceifyException(
        message: 'Background removal quota or API key issue.',
        code: 'BG_REMOVAL_AUTH',
      );
    }

    throw PlaceifyException(
      message: 'Background removal failed (${body.statusCode}): $detail',
      code: 'BG_REMOVAL_FAILED',
    );
  }

  Uint8List _compositeOnWhite(Uint8List cutoutPngBytes) {
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

    return Uint8List.fromList(
      img.encodeJpg(canvas, quality: _jpegQuality),
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
