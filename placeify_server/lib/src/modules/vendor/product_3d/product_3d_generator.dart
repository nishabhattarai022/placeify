import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../shared/server_static_paths.dart';
import 'product_3d_generation_result.dart';
import 'product_3d_image_paths.dart';
import 'product_3d_views.dart';
import 'tripo_client.dart';
import 'tripo_view_mapper.dart';

/// Generates a per-product GLB via the Tripo multiview API.
class Product3dGenerator {
  const Product3dGenerator();

  Future<Product3dGenerationResult> generateForProduct(
    Session session, {
    required Product product,
  }) async {
    final thumbnail = product.thumbnailUrl?.trim();
    if (thumbnail == null || thumbnail.isEmpty) {
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_NO_THUMBNAIL',
        message: 'Add a product photo before building a 3D preview.',
      );
    }

    final productId = product.id;
    if (productId == null) {
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_INVALID_PRODUCT',
        message: 'Product id is missing.',
      );
    }

    try {
      final started = DateTime.now();
      final views = await _loadProductViews(session, product);
      if (views == null) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_THUMBNAIL_MISSING',
          message:
              'Product photo file is missing on the server. '
              'Re-upload the product photo, then try Build 3D again.',
        );
      }

      final providedViews = TripoViewMapper.countProvidedViews(
        front: views.front,
        left: views.left,
        back: views.back,
        right: views.right,
      );

      if (providedViews < Product3dViews.minImages) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_INSUFFICIENT_VIEWS',
          message: Product3dViews.insufficientViewsMessage,
        );
      }

      if (views.front == null ||
          views.left == null ||
          views.back == null ||
          views.right == null) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_INSUFFICIENT_VIEWS',
          message: Product3dViews.insufficientViewsMessage,
        );
      }

      final tripoSlots = TripoViewMapper.toTripoMultiviewSlots(
        front: views.front,
        left: views.left,
        back: views.back,
        right: views.right,
      );

      final slotSources = TripoViewMapper.slotSourceLabels(
        front: views.front,
        left: views.left,
        back: views.back,
        right: views.right,
      );

      session.log(
        'Tripo: 4 raw photos [${slotSources.join(', ')}] loaded in '
        '${DateTime.now().difference(started).inMilliseconds}ms',
        level: LogLevel.info,
      );

      session.log(
        'Tripo task params: '
        '${jsonEncode(TripoClient.taskParamsForLogging(viewCount: providedViews))}',
        level: LogLevel.info,
      );

      final remoteModelUrl = await TripoClient.generateModelFromMultiview(
        session,
        views: tripoSlots,
        sourceViewCount: providedViews,
        slotLabels: slotSources,
      );

      final glbBytes = await _downloadGlb(remoteModelUrl);
      final localUrl = await _storeGlb(productId, glbBytes);

      final totalSeconds = DateTime.now().difference(started).inSeconds;
      session.log(
        'Tripo 3D model saved for product $productId at $localUrl '
        '(${totalSeconds}s total)',
        level: LogLevel.info,
      );
      return Product3dGenerationResult.success(localUrl);
    } on TripoClientException catch (error) {
      session.log(
        'Tripo 3D generation failed for product $productId: $error',
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_TRIPO_FAILED',
        message: error.message,
      );
    } catch (error, stackTrace) {
      session.log(
        '3D generation failed for product $productId: $error',
        exception: error,
        stackTrace: stackTrace,
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_GENERATION_FAILED',
        message: '3D model could not be generated: $error',
      );
    }
  }

  Future<_ProductViews?> _loadProductViews(
    Session session,
    Product product,
  ) async {
    final extraUrls = product.viewImageUrls ?? const <String>[];

    final results = await Future.wait([
      _loadRawView(session, product.thumbnailUrl, preferTripoOriginal: true),
      _loadRawView(session, extraUrls.elementAtOrNull(0)),
      _loadRawView(session, extraUrls.elementAtOrNull(1)),
      _loadRawView(session, extraUrls.elementAtOrNull(2)),
    ]);

    if (results[0] == null) return null;

    return _ProductViews(
      front: results[0],
      left: results[1],
      back: results[2],
      right: results[3],
    );
  }

  /// Raw upload bytes only — no remove.bg or reframing (fast path for demos).
  Future<TripoViewImage?> _loadRawView(
    Session session,
    String? urlPath, {
    bool preferTripoOriginal = false,
  }) async {
    final trimmed = urlPath?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    if (preferTripoOriginal) {
      for (final tripoPath
          in Product3dImagePaths.tripoSourceCandidatesForCatalog(trimmed)) {
        final view = await _bytesFromFile(session, tripoPath);
        if (view != null) return view;
      }
    }

    return _bytesFromFile(session, trimmed);
  }

  Future<TripoViewImage?> _bytesFromFile(
    Session session,
    String urlPath,
  ) async {
    final file = ServerStaticPaths.fileFromUrlPath(urlPath);
    if (!file.existsSync()) {
      session.log('Tripo input missing: $urlPath', level: LogLevel.warning);
      return null;
    }

    final bytes = await file.readAsBytes();
    final format = TripoClient.detectImageFormat(bytes);
    if (format == null) {
      throw TripoClientException('Product photo must be JPG, PNG, or WEBP.');
    }

    session.log(
      'Tripo raw input $urlPath (${bytes.length} bytes, $format)',
      level: LogLevel.info,
    );
    return TripoViewImage(bytes: bytes, format: format);
  }

  Future<List<int>> _downloadGlb(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TripoClientException(
        'Failed to download model from Tripo (${response.statusCode}).',
      );
    }
    if (response.bodyBytes.isEmpty) {
      throw TripoClientException('Downloaded model file is empty.');
    }
    return response.bodyBytes;
  }

  Future<String> _storeGlb(int productId, List<int> bytes) async {
    final outputDir = Directory(ServerStaticPaths.uploadsModelsDir());
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final fileName = 'product_$productId.glb';
    final outputPath =
        '${outputDir.path}${Platform.pathSeparator}$fileName';
    await File(outputPath).writeAsBytes(bytes);

    // Version query busts client/WebView caches after regenerate (same file path).
    final version = DateTime.now().millisecondsSinceEpoch;
    return '/uploads/models/$fileName?v=$version';
  }
}

final class _ProductViews {
  const _ProductViews({
    required this.front,
    required this.left,
    required this.back,
    required this.right,
  });

  final TripoViewImage? front;
  final TripoViewImage? left;
  final TripoViewImage? back;
  final TripoViewImage? right;
}
