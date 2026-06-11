import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickedProductImage {
  const PickedProductImage({
    required this.bytes,
    required this.fileName,
  });

  final Uint8List bytes;
  final String fileName;
}

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

  Future<PickedProductImage?> _pick(
    ImageSource source, {
    CameraDevice? preferredCameraDevice,
  }) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
      preferredCameraDevice: preferredCameraDevice ?? CameraDevice.rear,
    );
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    final name = file.name.isNotEmpty ? file.name : 'product_${source.name}.jpg';
    return PickedProductImage(bytes: bytes, fileName: name);
  }
}
