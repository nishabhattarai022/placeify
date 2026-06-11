/// Maps catalog categories to on-disk GLB furniture templates.
abstract final class FurnitureTemplateRegistry {
  static const categoryTemplateFile = <String, String>{
    'chairs': 'chairs.glb',
    'sofas': 'sofas.glb',
    'tables': 'default.glb',
    'desks': 'default.glb',
    'beds': 'default.glb',
    'storage': 'default.glb',
    'lighting': 'default.glb',
    'lights': 'default.glb',
    'outdoor': 'default.glb',
    'decor': 'default.glb',
  };

  static String templateFileForCategory(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) {
      return 'default.glb';
    }
    return categoryTemplateFile[categoryName] ?? 'default.glb';
  }
}
