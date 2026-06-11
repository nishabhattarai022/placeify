import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../shared/server_static_paths.dart';
import 'furniture_template_registry.dart';
import 'glb_customizer.dart';
import 'product_3d_generation_result.dart';

/// Builds a per-product GLB from a category template, vendor dimensions,
/// and the catalog product photo.
class Product3dGenerator {
  const Product3dGenerator();

  Future<Product3dGenerationResult> generateForProduct(
    Session session, {
    required Product product,
    required String categoryName,
  }) async {
    final thumbnail = product.thumbnailUrl?.trim();
    if (thumbnail == null || thumbnail.isEmpty) {
      session.log(
        'Skipping 3D generation for product ${product.id}: no thumbnail',
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_NO_THUMBNAIL',
        message: 'Add a product photo before building a 3D preview.',
      );
    }

    final widthCm = product.widthCm;
    final depthCm = product.depthCm;
    final heightCm = product.heightCm;
    if (widthCm == null ||
        depthCm == null ||
        heightCm == null ||
        widthCm <= 0 ||
        depthCm <= 0 ||
        heightCm <= 0) {
      session.log(
        'Skipping 3D generation for product ${product.id}: invalid dimensions',
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_NO_DIMENSIONS',
        message: 'Enter valid width, depth, and height for this product.',
      );
    }

    final templatePath =
        ServerStaticPaths.templatePath(
      FurnitureTemplateRegistry.templateFileForCategory(categoryName),
    );
    final templateFile = File(templatePath);
    if (!templateFile.existsSync()) {
      session.log(
        '3D template missing at $templatePath for category $categoryName',
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_TEMPLATE_MISSING',
        message:
            '3D template for "$categoryName" is missing on the server. '
            'Restart the server from placeify_server after pulling updates.',
      );
    }

    final textureFile = ServerStaticPaths.fileFromUrlPath(thumbnail);
    if (!textureFile.existsSync()) {
      session.log(
        'Thumbnail file missing for 3D generation: ${textureFile.path} '
        '(thumbnailUrl=$thumbnail)',
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
      final templateBytes = await templateFile.readAsBytes();
      final textureBytes = await textureFile.readAsBytes();
      final customized = GlbCustomizer.customize(
        templateBytes: templateBytes,
        textureJpegBytes: textureBytes,
        widthCm: widthCm,
        depthCm: depthCm,
        heightCm: heightCm,
      );

      final outputDir = Directory(ServerStaticPaths.uploadsModelsDir());
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }

      final outputPath =
          '${outputDir.path}${Platform.pathSeparator}product_$productId.glb';
      await File(outputPath).writeAsBytes(customized);
      session.log(
        'Generated 3D model for product $productId at $outputPath',
        level: LogLevel.info,
      );
      return Product3dGenerationResult.success(
        '/uploads/models/product_$productId.glb',
      );
    } catch (error, stackTrace) {
      session.log(
        '3D generation failed for product ${product.id}: $error',
        exception: error,
        stackTrace: stackTrace,
        level: LogLevel.warning,
      );
      return Product3dGenerationResult.failure(
        code: 'MODEL3D_GENERATION_FAILED',
        message: '3D model could not be generated. Try again or re-upload the photo.',
      );
    }
  }
}
