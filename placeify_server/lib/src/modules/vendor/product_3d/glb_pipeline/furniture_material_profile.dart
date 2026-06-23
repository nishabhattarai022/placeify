/// Catalog material hints mapped to PBR surface presets for furniture.
enum FurnitureSurfaceType {
  fabric,
  wood,
  plastic,
  leather,
  metal,
  unknown,
}

/// PBR roughness/metallic presets per surface type (Principled BSDF style).
final class FurnitureMaterialProfile {
  const FurnitureMaterialProfile({
    required this.surfaceType,
    required this.metallic,
    required this.roughnessMin,
    required this.roughnessMax,
  });

  final FurnitureSurfaceType surfaceType;
  final double metallic;
  final double roughnessMin;
  final double roughnessMax;

  double get targetRoughness => (roughnessMin + roughnessMax) / 2;

  static FurnitureMaterialProfile fromCatalogMaterials(String? materials) {
    final normalized = (materials ?? '').toLowerCase();

    if (_containsAny(normalized, const ['metal', 'steel', 'aluminum', 'iron'])) {
      return const FurnitureMaterialProfile(
        surfaceType: FurnitureSurfaceType.metal,
        metallic: 0.85,
        roughnessMin: 0.25,
        roughnessMax: 0.45,
      );
    }
    if (_containsAny(
      normalized,
      const [
        'fabric',
        'linen',
        'cotton',
        'polyester',
        'upholstery',
        'textile',
        'velvet',
      ],
    )) {
      return const FurnitureMaterialProfile(
        surfaceType: FurnitureSurfaceType.fabric,
        metallic: 0.0,
        roughnessMin: 0.75,
        roughnessMax: 0.9,
      );
    }
    if (_containsAny(normalized, const ['leather', 'vinyl', 'pu leather'])) {
      return const FurnitureMaterialProfile(
        surfaceType: FurnitureSurfaceType.leather,
        metallic: 0.0,
        roughnessMin: 0.55,
        roughnessMax: 0.75,
      );
    }
    if (_containsAny(normalized, const ['wood', 'oak', 'walnut', 'teak', 'pine'])) {
      return const FurnitureMaterialProfile(
        surfaceType: FurnitureSurfaceType.wood,
        metallic: 0.0,
        roughnessMin: 0.4,
        roughnessMax: 0.6,
      );
    }
    if (_containsAny(normalized, const ['plastic', 'acrylic', 'resin', 'pvc'])) {
      return const FurnitureMaterialProfile(
        surfaceType: FurnitureSurfaceType.plastic,
        metallic: 0.0,
        roughnessMin: 0.3,
        roughnessMax: 0.5,
      );
    }

    // Chairs and sofas are usually upholstered — default to fabric.
    return const FurnitureMaterialProfile(
      surfaceType: FurnitureSurfaceType.unknown,
      metallic: 0.0,
      roughnessMin: 0.75,
      roughnessMax: 0.9,
    );
  }

  static bool _containsAny(String haystack, List<String> needles) {
    for (final needle in needles) {
      if (haystack.contains(needle)) return true;
    }
    return false;
  }
}
