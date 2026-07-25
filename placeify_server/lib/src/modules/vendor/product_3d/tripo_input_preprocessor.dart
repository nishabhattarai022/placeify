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
  static final _backgroundColor = img.ColorRgb8(200, 200, 200);

  /// Max per-channel / luminance scale (±40%) to avoid overcorrecting real lighting.
  static const minAdjustmentScale = 0.6;
  static const maxAdjustmentScale = 1.4;

  final ProductImageProcessor _imageProcessor;

  /// Decodes, normalizes exposure/white balance across views, then frames each image.
  ///
  /// [viewLabels] should align with Tripo slot order: front, left, back, right.
  List<PreparedTripoFrame> prepareMultiviewCatalogFrames(
    List<Uint8List> sources, {
    Session? session,
    List<String>? viewLabels,
  }) {
    if (sources.isEmpty) {
      throw TripoInputPreprocessorException('No multiview sources provided.');
    }

    final decoded = <img.Image>[];
    for (final bytes in sources) {
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw TripoInputPreprocessorException(
          'Could not decode multiview image.',
        );
      }
      decoded.add(image);
    }

    final labels =
        viewLabels ??
        List<String>.generate(sources.length, (index) => 'view_$index');
    final normalized = normalizeExposureAcrossViews(
      decoded,
      session: session,
      viewLabels: labels,
    );

    final frames = <PreparedTripoFrame>[];
    for (var i = 0; i < normalized.length; i++) {
      frames.add(
        _prepareFrame(normalized[i], sourceBytes: sources[i].length),
      );
    }
    return frames;
  }

  /// Aligns subject luminance and white balance to the front (index 0) reference.
  List<img.Image> normalizeExposureAcrossViews(
    List<img.Image> views, {
    Session? session,
    List<String>? viewLabels,
  }) {
    if (views.isEmpty) return views;

    final labels =
        viewLabels ??
        List<String>.generate(views.length, (index) => 'view_$index');
    final stats = views.map(_subjectColorStats).toList();
    final reference = stats.first;

    final results = <img.Image>[];
    for (var i = 0; i < views.length; i++) {
      final copy = img.Image.from(views[i]);
      if (i == 0) {
        session?.log(
          'Tripo multiview normalize ${labels[i]}: reference '
          '(subject L=${reference.meanLuminance.toStringAsFixed(1)}, '
          'R=${reference.meanR.toStringAsFixed(1)}, '
          'G=${reference.meanG.toStringAsFixed(1)}, '
          'B=${reference.meanB.toStringAsFixed(1)})',
          level: LogLevel.info,
        );
        results.add(copy);
        continue;
      }

      final viewStats = stats[i];
      final lumScale = _clampScale(
        reference.meanLuminance / _safePositive(viewStats.meanLuminance),
      );
      final rScale = _clampScale(
        reference.meanR / _safePositive(viewStats.meanR),
      );
      final gScale = _clampScale(
        reference.meanG / _safePositive(viewStats.meanG),
      );
      final bScale = _clampScale(
        reference.meanB / _safePositive(viewStats.meanB),
      );

      _applySubjectCorrection(
        copy,
        luminanceScale: lumScale,
        redScale: rScale,
        greenScale: gScale,
        blueScale: bScale,
      );

      session?.log(
        'Tripo multiview normalize ${labels[i]}: '
        'luminance×${lumScale.toStringAsFixed(3)}, '
        'R×${rScale.toStringAsFixed(3)}, '
        'G×${gScale.toStringAsFixed(3)}, '
        'B×${bScale.toStringAsFixed(3)} '
        '(subject L ${viewStats.meanLuminance.toStringAsFixed(1)} → '
        '${reference.meanLuminance.toStringAsFixed(1)})',
        level: LogLevel.info,
      );
      results.add(copy);
    }

    return results;
  }

  /// White-background catalog image → centered frame, resolution preserved when possible.
  PreparedTripoFrame prepareCatalogFrame(Uint8List catalogBytes) {
    final decoded = img.decodeImage(catalogBytes);
    if (decoded == null) {
      throw TripoInputPreprocessorException('Could not decode catalog image.');
    }
    return _prepareFrame(decoded, sourceBytes: catalogBytes.length);
  }

  /// Original vendor photo → bg removal, white composite, center, minimal resize.
  Future<PreparedTripoFrame> prepareOriginalFrame(
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

  PreparedTripoFrame _prepareFrame(
    img.Image source, {
    required int sourceBytes,
  }) {
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
    final needsDownscale =
        subject.width > maxSubject || subject.height > maxSubject;
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
    img.fill(canvas, color: _backgroundColor);
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

  _SubjectColorStats _subjectColorStats(img.Image image) {
    var sumLuminance = 0.0;
    var sumR = 0.0;
    var sumG = 0.0;
    var sumB = 0.0;
    var count = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        if (!_isSubjectPixel(pixel)) continue;

        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();
        sumR += r;
        sumG += g;
        sumB += b;
        sumLuminance += (0.299 * r) + (0.587 * g) + (0.114 * b);
        count++;
      }
    }

    if (count == 0) {
      return const _SubjectColorStats(
        meanLuminance: 128,
        meanR: 128,
        meanG: 128,
        meanB: 128,
        pixelCount: 0,
      );
    }

    return _SubjectColorStats(
      meanLuminance: sumLuminance / count,
      meanR: sumR / count,
      meanG: sumG / count,
      meanB: sumB / count,
      pixelCount: count,
    );
  }

  double _safePositive(double value) => value > 1.0 ? value : 1.0;

  double _clampScale(double scale) {
    if (!scale.isFinite || scale <= 0) return 1.0;
    return scale.clamp(minAdjustmentScale, maxAdjustmentScale);
  }

  void _applySubjectCorrection(
    img.Image image, {
    required double luminanceScale,
    required double redScale,
    required double greenScale,
    required double blueScale,
  }) {
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        if (!_isSubjectPixel(pixel)) continue;

        final r = (pixel.r * luminanceScale * redScale).round().clamp(0, 255);
        final g = (pixel.g * luminanceScale * greenScale).round().clamp(0, 255);
        final b = (pixel.b * luminanceScale * blueScale).round().clamp(0, 255);
        image.setPixelRgb(x, y, r, g, b);
      }
    }
  }
}

final class _SubjectColorStats {
  const _SubjectColorStats({
    required this.meanLuminance,
    required this.meanR,
    required this.meanG,
    required this.meanB,
    required this.pixelCount,
  });

  final double meanLuminance;
  final double meanR;
  final double meanG;
  final double meanB;
  final int pixelCount;
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
