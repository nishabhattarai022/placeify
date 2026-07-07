import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/constants/product_photo_capture.dart';
import '../domain/models/picked_product_image.dart';

export '../domain/models/picked_product_image.dart';

/// Camera permission was denied or permanently blocked.
class CameraPermissionException implements Exception {
  const CameraPermissionException({this.permanentlyDenied = false});

  final bool permanentlyDenied;
}

class ProductImageService {
  ProductImageService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  bool supportsCamera() {
    return _picker.supportsImageSource(ImageSource.camera);
  }

  bool supportsGallery() {
    return _picker.supportsImageSource(ImageSource.gallery);
  }

  Future<PickedProductImage?> pickFromCamera() async {
    if (!supportsCamera()) return null;

    final granted = await _ensureCameraPermission();
    if (!granted) {
      final status = await Permission.camera.status;
      throw CameraPermissionException(
        permanentlyDenied: status.isPermanentlyDenied,
      );
    }

    return _pick(
      ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
  }

  Future<PickedProductImage?> pickFromGallery() {
    return _pick(ImageSource.gallery);
  }

  Future<bool> _ensureCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    return status.isGranted;
  }

  String _normalizeFileName(String fileName, Uint8List bytes) {
    if (RegExp(r'\.(jpe?g|png|webp|heic)$', caseSensitive: false)
        .hasMatch(fileName)) {
      return fileName;
    }

    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return '$fileName.jpg';
    }
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return '$fileName.png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return '$fileName.webp';
    }

    return '$fileName.jpg';
  }

  Future<PickedProductImage?> _pick(
    ImageSource source, {
    CameraDevice? preferredCameraDevice,
  }) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: ProductPhotoCapture.maxEdge.toDouble(),
      maxHeight: ProductPhotoCapture.maxEdge.toDouble(),
      imageQuality: ProductPhotoCapture.pickerQuality,
      preferredCameraDevice: preferredCameraDevice ?? CameraDevice.rear,
    );
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    final name = _normalizeFileName(
      file.name.isNotEmpty ? file.name : 'product_${source.name}.jpg',
      bytes,
    );
    return PickedProductImage(bytes: bytes, fileName: name);
  }
}
