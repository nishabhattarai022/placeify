import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/utils/local_image_data.dart';
import 'package:placeify_flutter/core/utils/local_image_reader.dart';
import 'package:placeify_flutter/core/utils/local_image_store.dart';

import 'file_image_preview_io.dart'
    if (dart.library.html) 'file_image_preview_stub.dart';

/// Displays a local asset, in-memory, file-path, or remote image.
class LocalImagePreview extends StatelessWidget {
  const LocalImagePreview({
    required this.source,
    this.bytes,
    this.fileName,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.errorBuilder,
    super.key,
  });

  final String source;
  final Uint8List? bytes;
  final String? fileName;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final memory = _memoryBytes();
    if (memory != null) {
      return Image.memory(
        memory,
        fit: fit,
        height: height,
        width: width,
        errorBuilder: errorBuilder ?? _defaultError,
      );
    }

    if (source.startsWith('assets/')) {
      return Image.asset(
        source,
        fit: fit,
        height: height,
        width: width,
        errorBuilder: errorBuilder ?? _defaultError,
      );
    }

    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(
        source,
        fit: fit,
        height: height,
        width: width,
        errorBuilder: errorBuilder ?? _defaultError,
      );
    }

    if (source.startsWith(LocalImageStore.scheme)) {
      return FutureBuilder<LocalImageData?>(
        future: LocalImageReader.read(source, fileName: fileName),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return errorBuilder?.call(context, 'missing', null) ?? _placeholder();
          }
          return Image.memory(
            data.bytes,
            fit: fit,
            height: height,
            width: width,
            errorBuilder: errorBuilder ?? _defaultError,
          );
        },
      );
    }

    if (_looksLikeLocalPath(source)) {
      return FileImagePreview(
        path: source,
        fit: fit,
        height: height,
        width: width,
        errorBuilder: errorBuilder ?? _defaultError,
      );
    }

    return errorBuilder?.call(context, 'unsupported', null) ?? _placeholder();
  }

  Uint8List? _memoryBytes() {
    if (bytes != null && bytes!.isNotEmpty) return bytes;
    return LocalImageStore.readUri(source)?.bytes;
  }

  bool _looksLikeLocalPath(String value) {
    return value.startsWith('/') ||
        value.startsWith('file://') ||
        RegExp(r'^[A-Za-z]:\\').hasMatch(value);
  }

  Widget _defaultError(BuildContext context, Object error, StackTrace? stackTrace) {
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: width,
      color: const Color(0xFFF5F0EB),
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: Color(0xFF8B7355), size: 28),
    );
  }
}
