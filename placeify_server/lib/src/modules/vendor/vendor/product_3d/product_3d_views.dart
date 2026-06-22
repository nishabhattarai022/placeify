/// Multiview photo requirements for furniture 3D generation.
abstract final class Product3dViews {
  static const minImages = 4;
  static const recommendedImages = 4;

  /// Extra catalog URLs on [Product.viewImageUrls]: [left, back, right].
  static const extraSlotCount = 3;

  static const insufficientViewsMessage =
      'Please upload 4 photos (front, left, back, right) for 3D generation.';
}
