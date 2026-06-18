import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:serverpod/serverpod.dart';

import '../product_image_processor.dart';

/// Result of preparing a frame for Tripo upload.
final class PreparedTripoFrame {
  const PreparedTripoFrame({
    required this.bytes,
    required this.format,
    required this.width,
    required this.height,
    required this.sourceBytes,
  });

  final Uint8List bytes;
  final String format;
  final int width;
  final int height;
  final int sourceBytes;
}

/// Centers furniture on white background without unnecessary downscaling.
class TripoInputPreprocessor {
  TripoInputPreprocessor({ProductImageProcessor? imageProcessor})
      : _imageProcessor = imageProcessor ?? ProductImageProcessor();

  /// Max edge length sent to Tripo — only downscale above this (no upscaling).
  static const maxTripoEdge = 4096;
  static const marginRatio = 0.08;
  static const jpegQuality = 98;
  static final _white = img.ColorRgb8(255, 255, 255);

  final ProductImageProcessor _imageProcessor;

  /// White-background catalog image → centered frame, resolution preserved when possible.
  PreparedTripoFrame prepareCatalogFrame(Uint8List catalogBytes) {
    final decoded = img.decodeImage(catalogBytes);
    if (decoded == null) {
      throw TripoInputPreprocessorException('Could not decode catalog image.');
    }
    return _prepareFrame(decoded, sourceBytes: catalogBytes.length);
  }

  /// Original vendor upload → bg removal on full-resolution source, then center.
  Future<PreparedTripoFrame> prepareVendorOriginalFrame(
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

  PreparedTripoFrame _prepareFrame(img.Image source, {required int sourceBytes}) {
    final framed = _centerOnSquareCanvas(source);
    final usePng = _shouldUsePng(source);
    final encoded = usePng
        ? Uint8List.fromList(img.encodePng(framed))
        : Uint8List.fromList(img.encodeJpg(framed, quality: jpegQuality));

    return PreparedTripoFrame(
      bytes: encoded,
      format: usePng ? 'png' : 'jpeg',
      width: framed.width,
      height: framed.height,
      sourceBytes: sourceBytes,
    );
  }

  bool _shouldUsePng(img.Image source) {
    for (var y = 0; y < source.height; y += 8) {
      for (var x = 0; x < source.width; x += 8) {
        if (source.getPixel(x, y).a < 250) return true;
      }
    }
    return false;
  }

  img.Image _centerOnSquareCanvas(img.Image source) {
    final bounds = _subjectBounds(source);
    final subject = bounds == null
        ? source
        : img.copyCrop(
            source,
            x: bounds.left,
            y: bounds.top,
            width: bounds.width,
            height: bounds.height,
          );

    final longestEdge = subject.width > subject.height
        ? subject.width
        : subject.height;
    final margin = (longestEdge * marginRatio).round().clamp(8, 512);
    var canvasSize = longestEdge + (margin * 2);

    if (canvasSize > maxTripoEdge) {
      canvasSize = maxTripoEdge;
    }

    final maxSubject = canvasSize - (margin * 2);
    final needsDownscale = subject.width > maxSubject || subject.height > maxSubject;
    final placed = needsDownscale
        ? img.copyResize(
            subject,
            width: subject.width > subject.height
                ? maxSubject
                : (subject.width * maxSubject / subject.height).round(),
            height: subject.height >= subject.width
                ? maxSubject
                : (subject.height * maxSubject / subject.width).round(),
            interpolation: img.Interpolation.cubic,
          )
        : subject;

    final canvas = img.Image(width: canvasSize, height: canvasSize);
    img.fill(canvas, color: _white);
    img.compositeImage(
      canvas,
      placed,
      dstX: ((canvasSize - placed.width) / 2).round(),
      dstY: ((canvasSize - placed.height) / 2).round(),
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
