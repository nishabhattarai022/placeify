/// A product saved for AR viewing in My AR.
class ArSavedProduct {
  const ArSavedProduct({
    required this.productId,
    required this.savedAt,
  });

  final String productId;
  final DateTime savedAt;
}
