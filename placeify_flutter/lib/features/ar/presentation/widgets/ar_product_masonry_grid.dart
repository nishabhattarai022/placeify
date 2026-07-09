import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/screens/widgets/ar_product_card.dart';

/// Masonry grid of saved AR product cards — mirrors [VendorMasonryGrid].
class ArProductMasonryGrid extends StatelessWidget {
  const ArProductMasonryGrid({
    required this.entries,
    required this.onProductTap,
    this.selectionMode = false,
    this.selectedIds = const {},
    super.key,
  });

  final List<({Product product, DateTime savedAt})> entries;
  final void Function(Product product) onProductTap;
  final bool selectionMode;
  final Set<String> selectedIds;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount =
        MediaQuery.sizeOf(context).width > 600 ? 3 : 2;

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return RepaintBoundary(
            key: ValueKey(entry.product.id),
            child: _AnimatedArCard(
              index: index,
              product: entry.product,
              savedAt: entry.savedAt,
              selectionMode: selectionMode,
              isSelected: selectedIds.contains(entry.product.id),
              onTap: () => onProductTap(entry.product),
            ),
          );
        },
        childCount: entries.length,
      ),
    );
  }
}

class _AnimatedArCard extends StatefulWidget {
  const _AnimatedArCard({
    required this.index,
    required this.product,
    required this.savedAt,
    required this.onTap,
    this.selectionMode = false,
    this.isSelected = false,
  });

  final int index;
  final Product product;
  final DateTime savedAt;
  final VoidCallback onTap;
  final bool selectionMode;
  final bool isSelected;

  @override
  State<_AnimatedArCard> createState() => _AnimatedArCardState();
}

class _AnimatedArCardState extends State<_AnimatedArCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();

    final staggerIndex = widget.index.clamp(0, 7);
    _controller = AnimationController(
      duration: Duration(milliseconds: 320 + staggerIndex * 40),
      vsync: this,
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _slide = Tween<double>(begin: 12, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => FadeTransition(
        opacity: _opacity,
        child: Transform.translate(
          offset: Offset(0, _slide.value),
          child: child,
        ),
      ),
      child: ArProductCard(
        product: widget.product,
        savedAt: widget.savedAt,
        selectionMode: widget.selectionMode,
        isSelected: widget.isSelected,
        onTap: widget.onTap,
      ),
    );
  }
}
