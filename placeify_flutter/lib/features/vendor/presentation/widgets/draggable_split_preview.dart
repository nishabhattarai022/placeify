import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/widgets/local_image_preview.dart';

/// Before/after split preview — drag the divider to compare original vs processed.
class DraggableSplitPreview extends StatefulWidget {
  const DraggableSplitPreview({
    required this.originalPath,
    required this.processedPath,
    this.originalBytes,
    this.processedBytes,
    super.key,
  });

  final String originalPath;
  final String processedPath;
  final Uint8List? originalBytes;
  final Uint8List? processedBytes;

  @override
  State<DraggableSplitPreview> createState() => _DraggableSplitPreviewState();
}

class _DraggableSplitPreviewState extends State<DraggableSplitPreview> {
  double _splitFraction = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final splitX = width * _splitFraction;

        return ClipRRect(
          borderRadius: AppRadii.lg,
          child: SizedBox(
            height: 280,
            child: RepaintBoundary(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ImageLayer(
                    path: widget.processedPath,
                    bytes: widget.processedBytes,
                  ),
                  ClipRect(
                    clipper: _LeftClipper(splitX),
                    child: _ImageLayer(
                      path: widget.originalPath,
                      bytes: widget.originalBytes,
                    ),
                  ),
                  Positioned(
                    left: splitX - 14,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _splitFraction = ((_splitFraction * width) +
                                  details.delta.dx) /
                              width;
                          _splitFraction = _splitFraction.clamp(0.08, 0.92);
                        });
                      },
                      child: SizedBox(
                        width: 28,
                        child: Center(
                          child: Container(
                            width: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImageLayer extends StatelessWidget {
  const _ImageLayer({
    required this.path,
    this.bytes,
  });

  final String path;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return LocalImagePreview(
      source: path,
      bytes: bytes,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.cream,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_outlined,
          color: AppColors.bark,
          size: 32,
        ),
      ),
    );
  }
}

class _LeftClipper extends CustomClipper<Rect> {
  _LeftClipper(this.splitX);

  final double splitX;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, splitX, size.height);

  @override
  bool shouldReclip(covariant _LeftClipper oldClipper) =>
      oldClipper.splitX != splitX;
}
