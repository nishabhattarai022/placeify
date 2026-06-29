import 'package:placeify_flutter/features/vendor/domain/enums/vendor_product_3d_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';

/// In-memory draft + processing state for vendor 3D model generation.
class Vendor3dModelRecord {
  const Vendor3dModelRecord({
    required this.productId,
    required this.status,
    required this.capturedAngles,
    this.updatedAt,
    this.modelFileName,
    this.errorMessage,
  });

  final String productId;
  final VendorProduct3dStatus status;
  final Set<String> capturedAngles;
  final DateTime? updatedAt;
  final String? modelFileName;
  final String? errorMessage;

  Vendor3dModelRecord copyWith({
    VendorProduct3dStatus? status,
    Set<String>? capturedAngles,
    DateTime? updatedAt,
    String? modelFileName,
    String? errorMessage,
    bool clearError = false,
  }) {
    return Vendor3dModelRecord(
      productId: productId,
      status: status ?? this.status,
      capturedAngles: capturedAngles ?? this.capturedAngles,
      updatedAt: updatedAt ?? this.updatedAt,
      modelFileName: modelFileName ?? this.modelFileName,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

abstract final class Vendor3dCaptureAngles {
  static const front = 'front';
  static const side = 'side';
  static const top = 'top';
  static const detail = 'detail';

  static const all = [front, side, top, detail];

  static String labelFor(String angle) => switch (angle) {
    front => 'Front',
    side => 'Side',
    top => 'Top',
    detail => 'Detail',
    _ => 'Angle',
  };

  static String hintFor(String angle) => switch (angle) {
    front => 'Full front view',
    side => '45° or profile view',
    top => 'Overhead angle',
    detail => 'Texture / joinery',
    _ => 'Reference photo',
  };
}

abstract final class Vendor3dModelStore {
  static final Map<String, Vendor3dModelRecord> _records = {};

  static VendorProduct3dStatus statusFor(VendorProduct product) {
    if (product.hasArView) return VendorProduct3dStatus.ready;
    return _records[product.id]?.status ?? VendorProduct3dStatus.none;
  }

  static Vendor3dModelRecord? recordFor(String productId) =>
      _records[productId];

  static Vendor3dModelRecord ensureDraft(String productId) {
    final existing = _records[productId];
    if (existing != null) return existing;

    final created = Vendor3dModelRecord(
      productId: productId,
      status: VendorProduct3dStatus.draft,
      capturedAngles: const {},
      updatedAt: DateTime.now(),
    );
    _records[productId] = created;
    return created;
  }

  static Vendor3dModelRecord updateRecord(Vendor3dModelRecord record) {
    _records[record.productId] = record.copyWith(updatedAt: DateTime.now());
    return _records[record.productId]!;
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

  static void markReady(String productId, {required String modelFileName}) {
    final record = ensureDraft(productId);
    updateRecord(
      record.copyWith(
        status: VendorProduct3dStatus.ready,
        modelFileName: modelFileName,
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

  static void toggleCapture(String productId, String angle) {
    final record = ensureDraft(productId);
    final angles = Set<String>.from(record.capturedAngles);
    if (angles.contains(angle)) {
      angles.remove(angle);
    } else {
      angles.add(angle);
    }
    updateRecord(
      record.copyWith(
        capturedAngles: angles,
        status: angles.isEmpty
            ? VendorProduct3dStatus.none
            : VendorProduct3dStatus.draft,
        clearError: true,
      ),
    );
  }

  static int countNeedingModel(List<VendorProduct> products) {
    return products.where((product) => !statusFor(product).isReady).length;
  }

  static int countReady(List<VendorProduct> products) {
    return products.where((product) => statusFor(product).isReady).length;
  }
}
