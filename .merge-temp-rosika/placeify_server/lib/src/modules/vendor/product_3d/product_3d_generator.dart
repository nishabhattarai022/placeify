import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../shared/server_static_paths.dart';
import 'product_3d_generation_result.dart';
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

    final textureFile = ServerStaticPaths.fileFromUrlPath(thumbnail);
    if (!textureFile.existsSync()) {
      session.log(
        'Thumbnail file missing for 3D generation: ${textureFile.path}',
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_THUMBNAIL_MISSING',
        message:
            'Product photo file is missing on the server. '
            'Re-upload the product photo, then try Build 3D again.',
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
      final imageBytes = await textureFile.readAsBytes();
      final imageFormat = TripoClient.detectImageFormat(imageBytes);
      if (imageFormat == null) {
        return Product3dGenerationResult.failure(
          code: 'MODEL3D_INVALID_IMAGE',
          message: 'Product photo must be JPG, PNG, or WEBP.',
        );
      }

      final remoteModelUrl = await TripoClient.generateModelFromImage(
        session,
        imageBytes: imageBytes,
        imageFormat: imageFormat,
      );

      final glbBytes = await _downloadGlb(remoteModelUrl);
      final localUrl = await _storeGlb(productId, glbBytes);

      session.log(
        'Tripo 3D model saved for product $productId at $localUrl',
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
