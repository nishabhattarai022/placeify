/// Image picker settings for product / Tripo multiview uploads.
///
/// Matches server [ProductImageProcessor] `_maxTripoWidth` (2560) so photos
/// are not over-compressed before 3D generation.
abstract final class ProductPhotoCapture {
  static const maxEdge = 2560;
  static const pickerQuality = 98;
}
