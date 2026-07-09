/// Per-product demo image filenames under `assets/catalog_seed/`.
///
/// Insert order matches [CatalogSeed] demo products (`p1`…`p18` on the client).
/// Each demo product uses a unique thumbnail upload path so catalog cards
/// never share the same `/uploads/catalog-seed/...` URL.
abstract final class CatalogSeedImages {
  static const _byProductName = <String, ({String thumbnail, List<String> views})>{
    'Astra': (
      thumbnail: 'product_astra.jpg',
      views: ['product_brixon_chair.jpg', 'product_studio_desk.png'],
    ),
    'Brixon Chair': (
      thumbnail: 'product_brixon_chair.jpg',
      views: ['product_odin_75.jpg', 'product_cloud_bed.png'],
    ),
    'Odin 75': (
      thumbnail: 'product_odin_75.jpg',
      views: ['product_harmony_chair.jpg', 'product_linen_bed_frame.png'],
    ),
    'Harmony Chair': (
      thumbnail: 'product_harmony_chair.jpg',
      views: ['product_brixon.jpg', 'product_round_dining_table.png'],
    ),
    'Brixon': (
      thumbnail: 'product_brixon.jpg',
      views: ['product_brixon_pro.jpg', 'product_oak_console.png'],
    ),
    'Brixon Pro': (
      thumbnail: 'product_brixon_pro.jpg',
      views: ['product_walnut_desk.jpg', 'product_modular_shelf.jpg'],
    ),
    'Walnut Desk': (
      thumbnail: 'product_walnut_desk.jpg',
      views: ['product_studio_desk.png', 'product_cabinet_unit.jpg'],
    ),
    'Studio Desk': (
      thumbnail: 'product_studio_desk.png',
      views: ['product_cloud_bed.png', 'product_arc_floor_lamp.png'],
    ),
    'Cloud Bed': (
      thumbnail: 'product_cloud_bed.png',
      views: ['product_linen_bed_frame.png', 'product_pendant_light.png'],
    ),
    'Linen Bed Frame': (
      thumbnail: 'product_linen_bed_frame.png',
      views: ['product_round_dining_table.png', 'product_patio_lounge.jpg'],
    ),
    'Round Dining Table': (
      thumbnail: 'product_round_dining_table.png',
      views: ['product_oak_console.png', 'product_garden_set.jpg'],
    ),
    'Oak Console': (
      thumbnail: 'product_oak_console.png',
      views: ['product_modular_shelf.jpg', 'product_astra.jpg'],
    ),
    'Modular Shelf': (
      thumbnail: 'product_modular_shelf.jpg',
      views: ['product_cabinet_unit.jpg', 'product_brixon_chair.jpg'],
    ),
    'Cabinet Unit': (
      thumbnail: 'product_cabinet_unit.jpg',
      views: ['product_arc_floor_lamp.png', 'product_odin_75.jpg'],
    ),
    'Arc Floor Lamp': (
      thumbnail: 'product_arc_floor_lamp.png',
      views: ['product_pendant_light.png', 'product_harmony_chair.jpg'],
    ),
    'Pendant Light': (
      thumbnail: 'product_pendant_light.png',
      views: ['product_patio_lounge.jpg', 'product_brixon.jpg'],
    ),
    'Patio Lounge': (
      thumbnail: 'product_patio_lounge.jpg',
      views: ['product_garden_set.jpg', 'product_brixon_pro.jpg'],
    ),
    'Garden Set': (
      thumbnail: 'product_garden_set.jpg',
      views: ['product_astra.jpg', 'product_walnut_desk.jpg'],
    ),
  };

  static ({String thumbnail, List<String> views}) forProduct(String productName) {
    final images = _byProductName[productName];
    if (images == null) {
      throw StateError('No catalog seed images configured for "$productName"');
    }
    return images;
  }
}
