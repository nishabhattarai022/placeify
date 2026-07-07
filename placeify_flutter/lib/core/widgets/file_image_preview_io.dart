import 'dart:io';

import 'package:flutter/material.dart';

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
    var resolved = path;
    if (resolved.startsWith('file://')) {
      resolved = Uri.parse(resolved).toFilePath();
    }

    return Image.file(
      File(resolved),
      fit: fit,
      height: height,
      width: width,
      errorBuilder: errorBuilder,
    );
  }
}
