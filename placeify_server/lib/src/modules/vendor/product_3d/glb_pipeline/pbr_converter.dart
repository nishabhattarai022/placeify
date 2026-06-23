import 'furniture_material_profile.dart';
import 'glb_container.dart';

/// Converts legacy / Tripo materials to glTF metallic-roughness PBR.
final class PbrConverter {
  const PbrConverter();

  void convertAll(GlbContainer container, FurnitureMaterialProfile profile) {
    final materials = container.materials();
    if (materials.isEmpty) return;

    for (var i = 0; i < materials.length; i++) {
      materials[i] = _convertMaterial(materials[i], profile);
    }
    container.setMaterials(materials);
    container.removeExtensionUsed('KHR_materials_pbrSpecularGlossiness');
    container.removeExtensionUsed('KHR_materials_unlit');
  }

  Map<String, dynamic> _convertMaterial(
    Map<String, dynamic> material,
    FurnitureMaterialProfile profile,
  ) {
    final result = Map<String, dynamic>.from(material);
    result.remove('extensions');

    // Drop legacy Phong / unlit flags that flatten AR rendering.
    result.remove('emissiveFactor');
    result.remove('emissiveTexture');
    result['doubleSided'] = material['doubleSided'] ?? true;

    final existing = material['pbrMetallicRoughness'];
    final pbr = existing is Map
        ? Map<String, dynamic>.from(existing)
        : <String, dynamic>{};

    pbr['metallicFactor'] = profile.metallic;
    pbr['roughnessFactor'] = profile.targetRoughness;

    if (pbr['baseColorFactor'] == null) {
      pbr['baseColorFactor'] = [1.0, 1.0, 1.0, 1.0];
    }

    // Migrate diffuse-only Tripo materials.
    final legacyBase = material['baseColorTexture'] ??
        material['diffuseTexture'] ??
        (material['extensions'] is Map
            ? (material['extensions']
                as Map)['KHR_materials_pbrSpecularGlossiness']
            : null);
    if (legacyBase is Map && pbr['baseColorTexture'] == null) {
      final diffuse = legacyBase['diffuseTexture'] ?? legacyBase;
      if (diffuse is Map) {
        pbr['baseColorTexture'] = Map<String, dynamic>.from(diffuse);
      }
    }

    result['pbrMetallicRoughness'] = pbr;
    result['alphaMode'] = material['alphaMode'] ?? 'OPAQUE';
    return result;
  }
}
