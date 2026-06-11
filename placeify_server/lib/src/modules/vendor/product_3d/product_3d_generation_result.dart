/// Outcome of building a per-product GLB from a template + photo.
sealed class Product3dGenerationResult {
  const Product3dGenerationResult();

  factory Product3dGenerationResult.success(String modelUrl) =
      Product3dGenerationSuccess;

  factory Product3dGenerationResult.failure({
    required String code,
    required String message,
  }) = Product3dGenerationFailure;
}

final class Product3dGenerationSuccess extends Product3dGenerationResult {
  const Product3dGenerationSuccess(this.modelUrl);

  final String modelUrl;
}

final class Product3dGenerationFailure extends Product3dGenerationResult {
  const Product3dGenerationFailure({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;
}
