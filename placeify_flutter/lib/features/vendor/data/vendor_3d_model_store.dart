import 'package:placeify_flutter/features/vendor/domain/enums/vendor_product_3d_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';

/// In-memory draft + processing state for vendor 3D model generation.
class Vendor3dModelRecord {
  const Vendor3dModelRecord({
    required this.productId,
    required this.status,
    required this.angleSources,
    this.updatedAt,
    this.modelFileName,
    this.errorMessage,
  });

  final String productId;
  final VendorProduct3dStatus status;
  final Map<String, String> angleSources;
  final DateTime? updatedAt;
  final String? modelFileName;
  final String? errorMessage;

  Set<String> get capturedAngles => angleSources.entries
      .where((entry) => entry.value.trim().isNotEmpty)
      .map((entry) => entry.key)
      .toSet();

  Vendor3dModelRecord copyWith({
    VendorProduct3dStatus? status,
    Map<String, String>? angleSources,
    DateTime? updatedAt,
    String? modelFileName,
    String? errorMessage,
    bool clearError = false,
  }) {
    return Vendor3dModelRecord(
      productId: productId,
      status: status ?? this.status,
      angleSources: angleSources ?? this.angleSources,
      updatedAt: updatedAt ?? this.updatedAt,
      modelFileName: modelFileName ?? this.modelFileName,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Tripo expects front, left, back, and right multiview photos.
abstract final class Vendor3dCaptureAngles {
  static const front = 'front';
  static const left = 'left';
  static const back = 'back';
  static const right = 'right';

  static const all = [front, left, back, right];

  static String labelFor(String angle) => switch (angle) {
        front => 'Front',
        left => 'Left',
        back => 'Back',
        right => 'Right',
        _ => 'Angle',
      };

  static String hintFor(String angle) => switch (angle) {
        front => 'Full front view',
        left => 'Left side profile',
        back => 'Full back view',
        right => 'Right side profile',
        _ => 'Reference photo',
      };
}

abstract final class Vendor3dModelStore {
  static final Map<String, Vendor3dModelRecord> _records = {};

  static VendorProduct3dStatus statusFor(VendorProduct product) {
    switch (product.model3dStatus) {
      case 'building':
        return VendorProduct3dStatus.processing;
      case 'ready':
        return VendorProduct3dStatus.ready;
      case 'failed':
        return VendorProduct3dStatus.failed;
      default:
        if (product.hasArView) return VendorProduct3dStatus.ready;
        return _records[product.id]?.status ?? VendorProduct3dStatus.none;
    }
  }

  static Vendor3dModelRecord? recordFor(String productId) => _records[productId];

  static Vendor3dModelRecord ensureDraft(String productId) {
    final existing = _records[productId];
    if (existing != null) return existing;

    final created = Vendor3dModelRecord(
      productId: productId,
      status: VendorProduct3dStatus.none,
      angleSources: const {},
      updatedAt: DateTime.now(),
    );
    _records[productId] = created;
    return created;
  }

  static Vendor3dModelRecord updateRecord(Vendor3dModelRecord record) {
    _records[record.productId] = record.copyWith(updatedAt: DateTime.now());
    return _records[record.productId]!;
  }

  static void preloadFromProduct(VendorProduct product) {
    final sources = <String, String>{};
    for (var i = 0; i < Vendor3dCaptureAngles.all.length; i++) {
      if (i >= product.imageUrls.length) break;
      final url = product.imageUrls[i].trim();
      if (url.isEmpty) continue;
      sources[Vendor3dCaptureAngles.all[i]] = url;
    }

    final record = ensureDraft(product.id);
    final serverStatus = statusFor(product);
    updateRecord(
      record.copyWith(
        angleSources: sources,
        status: serverStatus == VendorProduct3dStatus.none && sources.isNotEmpty
            ? VendorProduct3dStatus.draft
            : serverStatus,
        errorMessage: product.model3dError.isEmpty ? null : product.model3dError,
        clearError: product.model3dError.isEmpty,
      ),
    );
  }

  static void setAngleSource(String productId, String angle, String source) {
    final record = ensureDraft(productId);
    final sources = Map<String, String>.from(record.angleSources);
    sources[angle] = source.trim();
    updateRecord(
      record.copyWith(
        angleSources: sources,
        status: sources.values.any((value) => value.isNotEmpty)
            ? VendorProduct3dStatus.draft
            : VendorProduct3dStatus.none,
        clearError: true,
      ),
    );
  }

  static void clearAngleSource(String productId, String angle) {
    final record = ensureDraft(productId);
    final sources = Map<String, String>.from(record.angleSources)..remove(angle);
    updateRecord(
      record.copyWith(
        angleSources: sources,
        status: sources.isEmpty
            ? VendorProduct3dStatus.none
            : VendorProduct3dStatus.draft,
        clearError: true,
      ),
    );
  }

  static List<String> orderedSourcesFor(String productId) {
    final record = recordFor(productId);
    if (record == null) return const [];

    return [
      for (final angle in Vendor3dCaptureAngles.all)
        if (record.angleSources[angle]?.trim().isNotEmpty ?? false)
          record.angleSources[angle]!.trim(),
    ];
  }

  static void markProcessing(String productId) {
    final record = ensureDraft(productId);
    updateRecord(
      record.copyWith(
        status: VendorProduct3dStatus.processing,
        clearError: true,
      ),
    );
  }

  static void markReady(String productId) {
    final record = ensureDraft(productId);
    updateRecord(
      record.copyWith(
        status: VendorProduct3dStatus.ready,
        clearError: true,
      ),
    );
  }

  static void markFailed(String productId, String message) {
    final record = ensureDraft(productId);
    updateRecord(
      record.copyWith(
        status: VendorProduct3dStatus.failed,
        errorMessage: message,
      ),
    );
  }

  static int countNeedingModel(List<VendorProduct> products) {
    return productsNeedingModel(products).length;
  }

  static List<VendorProduct> productsNeedingModel(List<VendorProduct> products) {
    return products
        .where((product) => !statusFor(product).isReady)
        .toList(growable: false);
  }

  static int countReady(List<VendorProduct> products) {
    return products.where((product) => statusFor(product).isReady).length;
  }
}
