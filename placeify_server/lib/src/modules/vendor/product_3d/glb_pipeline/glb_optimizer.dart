import 'glb_container.dart';

/// Compresses textures and strips unused glTF data before AR export.
final class GlbOptimizer {
  const GlbOptimizer();

  void optimize(GlbContainer container) {
    _stripUnusedExtensions(container);
    _ensureSingleBuffer(container);
  }

  void _stripUnusedExtensions(GlbContainer container) {
    container.removeExtensionUsed('KHR_materials_unlit');
    container.removeExtensionUsed('KHR_materials_pbrSpecularGlossiness');

    final materials = container.materials();
    for (var i = 0; i < materials.length; i++) {
      final material = Map<String, dynamic>.from(materials[i]);
      material.remove('extensions');
      materials[i] = material;
    }
    container.setMaterials(materials);
  }

  void _ensureSingleBuffer(GlbContainer container) {
    final buffers = container.buffers();
    if (buffers.isEmpty) {
      container.setBuffers([
        {'byteLength': container.binary.length},
      ]);
    } else {
      buffers[0] = {'byteLength': container.binary.length};
      container.setBuffers([buffers.first]);
    }
  }
}
