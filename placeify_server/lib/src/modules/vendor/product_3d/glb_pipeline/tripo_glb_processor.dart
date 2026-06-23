import 'dart:typed_data';

import 'ar_exporter.dart';
import 'furniture_material_profile.dart';
import 'glb_container.dart';
import 'glb_optimizer.dart';
import 'material_fixer.dart';
import 'pbr_converter.dart';
import 'texture_processor.dart';

/// Result of processing a raw Tripo GLB into an AR-ready asset.
final class TripoGlbProcessResult {
  const TripoGlbProcessResult({
    required this.bytes,
    required this.profile,
    required this.materialCount,
    required this.generatedNormalMaps,
    required this.generatedRoughnessMaps,
  });

  final Uint8List bytes;
  final FurnitureMaterialProfile profile;
  final int materialCount;
  final int generatedNormalMaps;
  final int generatedRoughnessMaps;
}

/// Orchestrates the full Tripo → AR-ready GLB material pipeline.
///
/// ```
/// TripoGLBProcessor
///  |-- PbrConverter
///  |-- TextureProcessor
///  |-- MaterialFixer
///  |-- GlbOptimizer
///  |-- ArExporter
/// ```
final class TripoGlbProcessor {
  TripoGlbProcessor({
    PbrConverter? pbrConverter,
    TextureProcessor? textureProcessor,
    MaterialFixer? materialFixer,
    GlbOptimizer? glbOptimizer,
    ArExporter? arExporter,
  })  : _pbrConverter = pbrConverter ?? const PbrConverter(),
        _textureProcessor = textureProcessor ?? TextureProcessor(),
        _materialFixer = materialFixer ?? const MaterialFixer(),
        _glbOptimizer = glbOptimizer ?? const GlbOptimizer(),
        _arExporter = arExporter ?? const ArExporter();

  final PbrConverter _pbrConverter;
  final TextureProcessor _textureProcessor;
  final MaterialFixer _materialFixer;
  final GlbOptimizer _glbOptimizer;
  final ArExporter _arExporter;

  /// Transforms [rawGlbBytes] from Tripo into an optimized PBR GLB for preview + AR.
  TripoGlbProcessResult process(
    List<int> rawGlbBytes, {
    String? catalogMaterials,
  }) {
    final profile = FurnitureMaterialProfile.fromCatalogMaterials(catalogMaterials);
    final container = GlbContainer.parse(Uint8List.fromList(rawGlbBytes));

    _pbrConverter.convertAll(container, profile);
    _textureProcessor.processAll(container, profile);
    _materialFixer.fixAll(
      container,
      profile,
      normalTextureByMaterial: _textureProcessor.generatedNormals,
      metallicRoughnessTextureByMaterial:
          _textureProcessor.generatedMetallicRoughness,
    );
    _glbOptimizer.optimize(container);

    final bytes = _arExporter.export(container);
    return TripoGlbProcessResult(
      bytes: bytes,
      profile: profile,
      materialCount: container.materials().length,
      generatedNormalMaps: _textureProcessor.generatedNormals.length,
      generatedRoughnessMaps: _textureProcessor.generatedMetallicRoughness.length,
    );
  }
}
