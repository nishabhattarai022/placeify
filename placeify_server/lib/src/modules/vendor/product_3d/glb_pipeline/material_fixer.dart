import 'furniture_material_profile.dart';
import 'glb_container.dart';

/// Fixes material factors and texture bindings for AR-ready PBR.
final class MaterialFixer {
  const MaterialFixer();

  void fixAll(
    GlbContainer container,
    FurnitureMaterialProfile profile, {
    required Map<int, int> normalTextureByMaterial,
    required Map<int, int> metallicRoughnessTextureByMaterial,
  }) {
    final materials = container.materials();
    for (var i = 0; i < materials.length; i++) {
      materials[i] = _fixMaterial(
        materials[i],
        profile,
        normalTextureIndex: normalTextureByMaterial[i],
        metallicRoughnessTextureIndex: metallicRoughnessTextureByMaterial[i],
      );
    }
    container.setMaterials(materials);
  }

  Map<String, dynamic> _fixMaterial(
    Map<String, dynamic> material,
    FurnitureMaterialProfile profile, {
    int? normalTextureIndex,
    int? metallicRoughnessTextureIndex,
  }) {
    final result = Map<String, dynamic>.from(material);
    final pbrRaw = result['pbrMetallicRoughness'];
    final pbr = pbrRaw is Map
        ? Map<String, dynamic>.from(pbrRaw)
        : <String, dynamic>{};

    pbr['metallicFactor'] = profile.metallic;
    if (metallicRoughnessTextureIndex == null) {
      pbr['roughnessFactor'] = profile.targetRoughness;
    } else {
      pbr['metallicRoughnessTexture'] = {'index': metallicRoughnessTextureIndex};
      pbr['roughnessFactor'] = 1.0;
      pbr['metallicFactor'] = 1.0;
    }

    if (pbr['baseColorFactor'] == null) {
      pbr['baseColorFactor'] = [1.0, 1.0, 1.0, 1.0];
    }

    result['pbrMetallicRoughness'] = pbr;

    if (normalTextureIndex != null) {
      result['normalTexture'] = {
        'index': normalTextureIndex,
        'scale': 1.0,
      };
    }

    result['doubleSided'] = true;
    return result;
  }
}
