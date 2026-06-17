/// Multiview photo requirements for furniture 3D generation.
abstract final class Product3dViews {
  static const minImages = 5;
  static const recommendedImages = 6;

  /// Extra catalog URLs stored on [Product.viewImageUrls]:
  /// [left, back, right, frontLeft, frontRight].
  static const extraSlotCount = 5;

  static const insufficientViewsMessage =
      'Please upload at least 5 images for accurate 3D reconstruction.';
}
