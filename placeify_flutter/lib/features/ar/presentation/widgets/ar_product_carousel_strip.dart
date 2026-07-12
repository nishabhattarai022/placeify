import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/placeify_image.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';

/// Horizontal product picker shown at the bottom of the AR viewer.
class ArProductCarouselStrip extends StatefulWidget {
  const ArProductCarouselStrip({
    required this.products,
    required this.activeIndex,
    required this.onActiveIndexChanged,
    super.key,
  });

  final List<Product> products;
  final int activeIndex;
  final ValueChanged<int> onActiveIndexChanged;

  @override
  State<ArProductCarouselStrip> createState() => _ArProductCarouselStripState();
}

class _ArProductCarouselStripState extends State<ArProductCarouselStrip> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
  }

  @override
  void didUpdateWidget(covariant ArProductCarouselStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeIndex != widget.activeIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToActive() {
    if (!_scrollController.hasClients || widget.products.isEmpty) return;
    const itemExtent = 72.0;
    final offset = (widget.activeIndex * itemExtent - 40).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _step(int delta) {
    final next = (widget.activeIndex + delta).clamp(
      0,
      widget.products.length - 1,
    );
    if (next == widget.activeIndex) return;
    HapticService.selection();
    widget.onActiveIndexChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _NavCircle(
            icon: Icons.chevron_left_rounded,
            enabled: widget.activeIndex > 0,
            onTap: () => _step(-1),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 88,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EFE8),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  final isActive = index == widget.activeIndex;
                  return GestureDetector(
                    onTap: () {
                      HapticService.light();
                      widget.onActiveIndexChanged(index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: isActive
                              ? AppColors.charcoal
                              : Colors.transparent,
                          width: isActive ? 2.5 : 0,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: PlaceifyImage(
                            source: product.imageUrl,
                            fit: BoxFit.contain,
                            error: Center(
                              child: SvgPicture.asset(
                                product.svgIconPath,
                                width: 22,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.bark,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          _NavCircle(
            icon: Icons.chevron_right_rounded,
            enabled: widget.activeIndex < widget.products.length - 1,
            onTap: () => _step(1),
          ),
        ],
      ),
    );
  }
}

class _NavCircle extends StatelessWidget {
  const _NavCircle({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: enabled ? 4 : 0,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: enabled ? AppColors.charcoal : Colors.black26,
            size: 24,
          ),
        ),
      ),
    );
  }
}
