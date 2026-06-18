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
import 'tripo_input_preprocessor.dart';
import 'tripo_view_mapper.dart';

/// Generates a per-product GLB via the Tripo multiview API.
class Product3dGenerator {
  Product3dGenerator({TripoInputPreprocessor? preprocessor})
      : _preprocessor = preprocessor ?? TripoInputPreprocessor();

  final TripoInputPreprocessor _preprocessor;

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
        frontLeft: views.frontLeft,
        frontRight: views.frontRight,
      );

      if (providedViews < Product3dViews.minImages) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_INSUFFICIENT_VIEWS',
          message: Product3dViews.insufficientViewsMessage,
        );
      }

      if (views.front == null) {
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
        frontLeft: views.frontLeft,
        frontRight: views.frontRight,
      );

      final tripoViewCount = tripoSlots.whereType<TripoViewImage>().length;
      if (tripoViewCount < 4) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_INSUFFICIENT_VIEWS',
          message: Product3dViews.insufficientViewsMessage,
        );
      }

      final slotSources = TripoViewMapper.slotSourceLabels(
        front: views.front,
        left: views.left,
        back: views.back,
        right: views.right,
        frontLeft: views.frontLeft,
        frontRight: views.frontRight,
      );

      session.log(
        'Tripo 3D: $providedViews vendor photos → $tripoViewCount API slots '
        '(sources: ${slotSources.join(', ')}). '
        'Note: Tripo multiview accepts 4 images [front, left, back, right]; '
        '45° views fill side slots when higher detail.',
        level: LogLevel.info,
      );

      session.log(
        'Tripo task params preview: '
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

      session.log(
        'Tripo 3D model saved for product $productId at $localUrl '
        '($providedViews photos, multiview)',
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
    } on TripoInputPreprocessorException catch (error) {
      session.log(
        'Tripo image preprocessing failed for product $productId: $error',
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_PREPROCESS_FAILED',
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
    final front = await _loadPreparedView(session, product.thumbnailUrl);
    if (front == null) return null;

    final extraUrls = product.viewImageUrls ?? const <String>[];
    return _ProductViews(
      front: front,
      left: await _loadPreparedView(session, extraUrls.elementAtOrNull(0)),
      back: await _loadPreparedView(session, extraUrls.elementAtOrNull(1)),
      right: await _loadPreparedView(session, extraUrls.elementAtOrNull(2)),
      frontLeft: await _loadPreparedView(session, extraUrls.elementAtOrNull(3)),
      frontRight:
          await _loadPreparedView(session, extraUrls.elementAtOrNull(4)),
    );
  }

  Future<TripoViewImage?> _loadPreparedView(
    Session session,
    String? catalogUrlPath,
  ) async {
    final trimmed = catalogUrlPath?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    for (final tripoPath
        in Product3dImagePaths.tripoSourceCandidatesForCatalog(trimmed)) {
      final tripoFile = ServerStaticPaths.fileFromUrlPath(tripoPath);
      if (!tripoFile.existsSync()) continue;

      final bytes = await tripoFile.readAsBytes();
      final prepared = await _preprocessor.prepareVendorOriginalFrame(
        session,
        bytes,
        tripoFile.uri.pathSegments.last,
      );
      session.log(
        'Tripo frame $tripoPath (vendor original): ${prepared.width}x${prepared.height} '
        '${prepared.format} ${prepared.bytes.length}B '
        '(source ${prepared.sourceBytes}B, bg-removed + centered)',
        level: LogLevel.info,
      );
      return TripoViewImage(
        bytes: prepared.bytes,
        format: prepared.format,
      );
    }

    final catalogFile = ServerStaticPaths.fileFromUrlPath(trimmed);
    if (catalogFile.existsSync()) {
      final bytes = await catalogFile.readAsBytes();
      final prepared = _preprocessor.prepareCatalogFrame(bytes);
      session.log(
        'Tripo frame $trimmed (catalog fallback): ${prepared.width}x${prepared.height} '
        '${prepared.format} ${prepared.bytes.length}B '
        '(source ${prepared.sourceBytes}B, centered)',
        level: LogLevel.info,
      );
      return TripoViewImage(
        bytes: prepared.bytes,
        format: prepared.format,
      );
    }

    session.log(
      'Missing vendor original and catalog photo for $trimmed',
      level: LogLevel.warning,
    );
    return null;
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

    final outputPath =
        '${outputDir.path}${Platform.pathSeparator}product_$productId.glb';
    await File(outputPath).writeAsBytes(bytes);
    return '/uploads/models/product_$productId.glb';
  }
}

final class _ProductViews {
  const _ProductViews({
    required this.front,
    required this.left,
    required this.back,
    required this.right,
    required this.frontLeft,
    required this.frontRight,
  });

  final TripoViewImage? front;
  final TripoViewImage? left;
  final TripoViewImage? back;
  final TripoViewImage? right;
  final TripoViewImage? frontLeft;
  final TripoViewImage? frontRight;
}
