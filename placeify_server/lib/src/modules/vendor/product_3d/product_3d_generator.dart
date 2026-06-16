import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../shared/server_static_paths.dart';
import 'product_3d_generation_result.dart';
import 'product_3d_image_paths.dart';
import 'tripo_client.dart';

/// Generates a per-product GLB via the Tripo image-to-model API.
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
      final catalogFile = ServerStaticPaths.fileFromUrlPath(thumbnail);
      if (!catalogFile.existsSync()) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_THUMBNAIL_MISSING',
          message:
              'Product photo file is missing on the server. '
              'Re-upload the product photo, then try Build 3D again.',
        );
      }

      final hasTripoOriginal = Product3dImagePaths
          .tripoSourceCandidatesForCatalog(thumbnail)
          .any(
            (path) => ServerStaticPaths.fileFromUrlPath(path).existsSync(),
          );
      if (!hasTripoOriginal) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_TRIPO_SOURCE_MISSING',
          message:
              '3D needs your original photos (not catalog cutouts). '
              'Re-upload all product photos, then try Build 3D again.',
        );
      }

      final views = await _loadTripoViews(session, product);
      if (views == null) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_THUMBNAIL_MISSING',
          message:
              'Product photo file is missing on the server. '
              'Re-upload the product photo, then try Build 3D again.',
        );
      }

      final providedViews = views.whereType<TripoViewImage>().length;
      if (providedViews == 0) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_TRIPO_SOURCE_MISSING',
          message:
              '3D needs your original photos (not catalog cutouts). '
              'Re-upload all product photos, then try Build 3D again.',
        );
      }
      final remoteModelUrl = providedViews >= 2
          ? await TripoClient.generateModelFromMultiview(
              session,
              views: views,
            )
          : await TripoClient.generateModelFromImage(
              session,
              imageBytes: views.first!.bytes,
              imageFormat: views.first!.format,
            );

      final glbBytes = await _downloadGlb(remoteModelUrl);
      final localUrl = await _storeGlb(productId, glbBytes);

      session.log(
        'Tripo 3D model saved for product $productId at $localUrl '
        '($providedViews view${providedViews == 1 ? '' : 's'}, '
        'multiview=${providedViews >= 2})',
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

  /// Loads view slots [front, left, back, right]. Returns null if front is missing.
  Future<List<TripoViewImage?>?> _loadTripoViews(
    Session session,
    Product product,
  ) async {
    final front = await _loadViewImage(session, product.thumbnailUrl);
    if (front == null) return null;

    final extraUrls = product.viewImageUrls ?? const <String>[];
    final left = extraUrls.isNotEmpty
        ? await _loadViewImage(session, extraUrls.elementAtOrNull(0))
        : null;
    final back = extraUrls.length > 1
        ? await _loadViewImage(session, extraUrls.elementAtOrNull(1))
        : null;
    final right = extraUrls.length > 2
        ? await _loadViewImage(session, extraUrls.elementAtOrNull(2))
        : null;

    if (left == null && back == null && right == null) {
      return [front];
    }

    return [front, left, back, right];
  }

  Future<TripoViewImage?> _loadViewImage(
    Session session,
    String? urlPath,
  ) async {
    final trimmed = urlPath?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    final tripoPath = _resolveTripoOriginalPath(session, trimmed);
    if (tripoPath == null) {
      return null;
    }

    final file = ServerStaticPaths.fileFromUrlPath(tripoPath);
    if (!file.existsSync()) {
      session.log(
        'Tripo original missing for 3D generation: ${file.path}',
        level: LogLevel.warning,
      );
      return null;
    }

    final bytes = await file.readAsBytes();
    final format = TripoClient.detectImageFormat(bytes);
    if (format == null) {
      throw TripoClientException('Product photo must be JPG, PNG, or WEBP.');
    }
    return TripoViewImage(bytes: bytes, format: format);
  }

  /// Tripo always uses `_tripo` originals — never white-background catalog JPEGs.
  String? _resolveTripoOriginalPath(Session session, String catalogUrlPath) {
    for (final tripoPath
        in Product3dImagePaths.tripoSourceCandidatesForCatalog(catalogUrlPath)) {
      final tripoFile = ServerStaticPaths.fileFromUrlPath(tripoPath);
      if (tripoFile.existsSync()) {
        session.log(
          'Tripo 3D using original photo $tripoPath (catalog bg removal not used)',
          level: LogLevel.info,
        );
        return tripoPath;
      }
    }

    session.log(
      'No original Tripo photo for $catalogUrlPath — re-upload product photos',
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
