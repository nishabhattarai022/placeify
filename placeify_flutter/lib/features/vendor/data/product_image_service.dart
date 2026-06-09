import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PickedProductImage {
  const PickedProductImage({
    required this.bytes,
    required this.fileName,
  });

  final Uint8List bytes;
  final String fileName;
}

class ProductImageService {
  ProductImageService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<PickedProductImage?> pickFromCamera() {
    return _pick(ImageSource.camera);
  }

  Future<PickedProductImage?> pickFromGallery() {
    return _pick(ImageSource.gallery);
  }

  Future<PickedProductImage?> _pick(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (file == null) return null;

    final bytes = await file.readAsBytes();
    final name = file.name.isNotEmpty ? file.name : 'product_${source.name}.jpg';
    return PickedProductImage(bytes: bytes, fileName: name);
  }
}
