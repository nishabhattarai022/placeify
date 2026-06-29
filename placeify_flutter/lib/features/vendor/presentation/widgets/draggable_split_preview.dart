import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';

/// Before/after split preview — drag the divider to compare original vs processed.
class DraggableSplitPreview extends StatefulWidget {
  const DraggableSplitPreview({
    required this.originalPath,
    required this.processedPath,
    super.key,
  });

  final String originalPath;
  final String processedPath;

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
                  _ImageLayer(path: widget.processedPath),
                  ClipRect(
                    clipper: _LeftClipper(splitX),
                    child: _ImageLayer(path: widget.originalPath),
                  ),
                  Positioned(
                    left: splitX - 14,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _splitFraction =
                              ((_splitFraction * width) + details.delta.dx) /
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: _LabelChip(text: 'Original'),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: _LabelChip(text: 'Processed'),
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

class _LeftClipper extends CustomClipper<Rect> {
  _LeftClipper(this.splitX);

  final double splitX;

  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, splitX, size.height);

  @override
  bool shouldReclip(_LeftClipper oldClipper) => oldClipper.splitX != splitX;
}

class _ImageLayer extends StatelessWidget {
  const _ImageLayer({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.cream,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined, color: AppColors.bark),
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  const _LabelChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: AppRadii.pill,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
