import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:serverpod/serverpod.dart';

import '../product_image_processor.dart';

/// Normalizes catalog / cutout frames before Tripo multiview generation.
class TripoInputPreprocessor {
  TripoInputPreprocessor({ProductImageProcessor? imageProcessor})
      : _imageProcessor = imageProcessor ?? ProductImageProcessor();

  static const _canvasSize = 2048;
  static const _marginRatio = 0.08;
  static const _jpegQuality = 95;
  static final _white = img.ColorRgb8(255, 255, 255);

  final ProductImageProcessor _imageProcessor;

  /// White-background catalog JPEG → centered square frame at fixed resolution.
  Uint8List prepareCatalogFrame(Uint8List catalogBytes) {
    final decoded = img.decodeImage(catalogBytes);
    if (decoded == null) {
      throw TripoInputPreprocessorException('Could not decode catalog image.');
    }
    return _encodeJpeg(_centerOnSquareCanvas(decoded));
  }

  /// Original vendor photo → bg removal, white composite, center, normalize.
  Future<Uint8List> prepareOriginalFrame(
    Session session,
    Uint8List bytes,
    String fileName,
  ) async {
    final processed = await _imageProcessor.processForCatalog(
      session,
      bytes,
      fileName,
    );
    return prepareCatalogFrame(processed.bytes);
  }

  img.Image _centerOnSquareCanvas(img.Image source) {
    final bounds = _subjectBounds(source);
    if (bounds == null) {
      return _fitOnSquare(source);
    }

    final cropped = img.copyCrop(
      source,
      x: bounds.left,
      y: bounds.top,
      width: bounds.width,
      height: bounds.height,
    );

    final margin = (_canvasSize * _marginRatio).round();
    final maxSubject = _canvasSize - (margin * 2);
    final scale = maxSubject /
        (cropped.width > cropped.height ? cropped.width : cropped.height);
    final targetW = (cropped.width * scale).round().clamp(1, maxSubject);
    final targetH = (cropped.height * scale).round().clamp(1, maxSubject);
    final resized = img.copyResize(
      cropped,
      width: targetW,
      height: targetH,
      interpolation: img.Interpolation.average,
    );

    final canvas = img.Image(width: _canvasSize, height: _canvasSize);
    img.fill(canvas, color: _white);
    img.compositeImage(
      canvas,
      resized,
      dstX: ((_canvasSize - targetW) / 2).round(),
      dstY: ((_canvasSize - targetH) / 2).round(),
    );
    return canvas;
  }

  img.Image _fitOnSquare(img.Image source) {
    final margin = (_canvasSize * _marginRatio).round();
    final maxSubject = _canvasSize - (margin * 2);
    final scale = maxSubject /
        (source.width > source.height ? source.width : source.height);
    final targetW = (source.width * scale).round().clamp(1, maxSubject);
    final targetH = (source.height * scale).round().clamp(1, maxSubject);
    final resized = img.copyResize(
      source,
      width: targetW,
      height: targetH,
      interpolation: img.Interpolation.average,
    );

    final canvas = img.Image(width: _canvasSize, height: _canvasSize);
    img.fill(canvas, color: _white);
    img.compositeImage(
      canvas,
      resized,
      dstX: ((_canvasSize - targetW) / 2).round(),
      dstY: ((_canvasSize - targetH) / 2).round(),
    );
    return canvas;
  }

  _Bounds? _subjectBounds(img.Image image) {
    var minX = image.width;
    var minY = image.height;
    var maxX = -1;
    var maxY = -1;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        if (!_isSubjectPixel(image.getPixel(x, y))) continue;
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
    }

    if (maxX < minX || maxY < minY) return null;

    final pad = ((maxX - minX + maxY - minY) * 0.02).round().clamp(2, 24);
    final left = (minX - pad).clamp(0, image.width - 1);
    final top = (minY - pad).clamp(0, image.height - 1);
    final right = (maxX + pad).clamp(0, image.width - 1);
    final bottom = (maxY + pad).clamp(0, image.height - 1);

    return _Bounds(
      left: left,
      top: top,
      width: (right - left + 1).clamp(1, image.width),
      height: (bottom - top + 1).clamp(1, image.height),
    );
  }

  bool _isSubjectPixel(img.Pixel pixel) {
    final alpha = pixel.a;
    if (alpha < 16) return false;
    if (alpha < 250) return true;
    return pixel.r < 245 || pixel.g < 245 || pixel.b < 245;
  }

  Uint8List _encodeJpeg(img.Image image) {
    return Uint8List.fromList(img.encodeJpg(image, quality: _jpegQuality));
  }
}

final class _Bounds {
  const _Bounds({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final int left;
  final int top;
  final int width;
  final int height;
}

final class TripoInputPreprocessorException implements Exception {
  TripoInputPreprocessorException(this.message);
  final String message;

  @override
  String toString() => message;
}
