import 'package:flutter/material.dart';

/// Web builds do not use dart:io file previews.
class FileImagePreview extends StatelessWidget {
  const FileImagePreview({
    required this.path,
    required this.fit,
    this.height,
    this.width,
    this.errorBuilder,
    super.key,
  });

  final String path;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return errorBuilder?.call(context, 'unsupported', null) ??
        Container(
          height: height,
          width: width,
          color: const Color(0xFFF5F0EB),
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, color: Color(0xFF8B7355), size: 28),
        );
  }
}
