/// Per-product demo image filenames under `assets/catalog_seed/`.
///
/// Insert order matches [CatalogSeed] demo products (`p1`…`p18` on the client).
abstract final class CatalogSeedImages {
  static const tolaLoungeChair = 'tola_lounge_chair.jpg';
  static const pexelsBlackcurrant = 'pexels_blackcurrant.jpg';
  static const pexelsSuhailat = 'pexels_suhailat.jpg';
  static const dianeSofa = 'diane_sofa.jpg';
  static const chairWalnut = 'chair_walnut.jpg';
  static const exploreHero = 'explore_hero.jpg';

  static const _byProductName = <String, ({String thumbnail, List<String> views})>{
    'Astra': (
      thumbnail: tolaLoungeChair,
      views: [pexelsSuhailat, chairWalnut],
    ),
    'Brixon Chair': (
      thumbnail: dianeSofa,
      views: [pexelsSuhailat, tolaLoungeChair],
    ),
    'Odin 75': (
      thumbnail: chairWalnut,
      views: [tolaLoungeChair, pexelsBlackcurrant],
    ),
    'Harmony Chair': (
      thumbnail: pexelsSuhailat,
      views: [dianeSofa, chairWalnut],
    ),
    'Brixon': (
      thumbnail: pexelsBlackcurrant,
      views: [pexelsSuhailat, tolaLoungeChair],
    ),
    'Brixon Pro': (
      thumbnail: dianeSofa,
      views: [tolaLoungeChair, chairWalnut],
    ),
    'Walnut Desk': (
      thumbnail: pexelsBlackcurrant,
      views: [exploreHero, chairWalnut],
    ),
    'Studio Desk': (
      thumbnail: chairWalnut,
      views: [pexelsBlackcurrant, exploreHero],
    ),
    'Cloud Bed': (
      thumbnail: exploreHero,
      views: [dianeSofa, pexelsBlackcurrant],
    ),
    'Linen Bed Frame': (
      thumbnail: dianeSofa,
      views: [exploreHero, chairWalnut],
    ),
    'Round Dining Table': (
      thumbnail: pexelsBlackcurrant,
      views: [exploreHero, pexelsSuhailat],
    ),
    'Oak Console': (
      thumbnail: exploreHero,
      views: [pexelsBlackcurrant, chairWalnut],
    ),
    'Modular Shelf': (
      thumbnail: pexelsSuhailat,
      views: [tolaLoungeChair, exploreHero],
    ),
    'Cabinet Unit': (
      thumbnail: tolaLoungeChair,
      views: [pexelsSuhailat, exploreHero],
    ),
    'Arc Floor Lamp': (
      thumbnail: exploreHero,
      views: [chairWalnut, dianeSofa],
    ),
    'Pendant Light': (
      thumbnail: chairWalnut,
      views: [exploreHero, pexelsSuhailat],
    ),
    'Patio Lounge': (
      thumbnail: pexelsSuhailat,
      views: [dianeSofa, exploreHero],
    ),
    'Garden Set': (
      thumbnail: exploreHero,
      views: [pexelsSuhailat, pexelsBlackcurrant],
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
