import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Renders product and profile images from assets, network URLs, or local paths.
class PlaceifyImage extends StatelessWidget {
  const PlaceifyImage({
    required this.source,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholder,
    this.error,
    super.key,
  });

  final String source;
  final BoxFit fit;
  final Alignment alignment;
  final Widget? placeholder;
  final Widget? error;

  static bool isAsset(String value) => value.startsWith('assets/');

  static bool isLocalFile(String value) =>
      value.startsWith('/') || value.startsWith('file://');

  static bool isNetworkSource(String value) =>
      value.startsWith('http://') ||
      value.startsWith('https://') ||
      value.startsWith('blob:');

  @override
  Widget build(BuildContext context) {
    final trimmed = source.trim();
    if (trimmed.isEmpty) {
      return error ?? _defaultError();
    }

    if (isAsset(trimmed)) {
      return Image.asset(
        trimmed,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, _, _) => error ?? _defaultError(),
      );
    }

    if (isLocalFile(trimmed)) {
      if (kIsWeb) {
        return Image.network(
          trimmed,
          fit: fit,
          alignment: alignment,
          errorBuilder: (_, _, _) => error ?? _defaultError(),
        );
      }

      final path = trimmed.startsWith('file://')
          ? trimmed.replaceFirst('file://', '')
          : trimmed;
      return Image.file(
        File(path),
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, _, _) => error ?? _defaultError(),
      );
    }

    if (isNetworkSource(trimmed)) {
      return CachedNetworkImage(
        imageUrl: trimmed,
        fit: fit,
        alignment: alignment,
        placeholder: (_, _) => placeholder ?? _defaultPlaceholder(),
        errorWidget: (_, _, _) => error ?? _defaultError(),
      );
    }

    return Image.network(
      trimmed,
      fit: fit,
      alignment: alignment,
      errorBuilder: (_, _, _) => error ?? _defaultError(),
    );
  }

  Widget _defaultPlaceholder() => const ColoredBox(color: Color(0xFFF3F3F3));

  Widget _defaultError() => const ColoredBox(color: Color(0xFFF3F3F3));
}
