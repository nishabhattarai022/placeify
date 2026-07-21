/// Multiview photo requirements for furniture 3D generation.
abstract final class Product3dViews {
  static const minImages = 4;
  static const recommendedImages = 4;

  /// Extra catalog URLs on [Product.viewImageUrls]: [left, back, right].
  /// Only the first three are used for 3D generation.
  static const extraSlotCount = 3;

  /// Max entries stored on [Product.viewImageUrls]: the three required view
  /// photos plus up to four optional catalog photos (8 total with thumbnail).
  static const maxStoredViewImages = 7;

  static const insufficientViewsMessage =
      'Please upload 4 photos (front, left, back, right) for 3D generation.';
}
