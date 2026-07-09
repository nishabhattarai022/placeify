import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/services/haptic_service.dart';
import '../core/theme/app_fonts.dart';
import '../data/furniture_categories.dart';
import '../features/home/presentation/providers/catalog_provider.dart';
import 'widgets/dark_pill_button.dart';

FurnitureCategory _cat(String id) {
  return furnitureCategories.firstWhere((c) => c.id == id);
}

/// Right column in row 1: Sofas (130) + gap (12) + Desks (130).
const double _kBentoShortCard = 130;
const double _kBentoMediumCard = 150;
const double _kBentoSlimCard = 110;
const double _kBentoTallCard = _kBentoShortCard * 2 + 12;

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogIndexProvider.notifier).refresh(silent: true);
    });
  }

  List<FurnitureCategory> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return furnitureCategories;
    return furnitureCategories
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
  }

  void _openCategory(FurnitureCategory category) {
    context.push('/browse/category/${category.id}');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final isSearching = _query.trim().isNotEmpty;

    final categoryCount = furnitureCategories.length;
    final liveItemCount = ref.watch(catalogProductCountProvider);
    final itemCount =
        liveItemCount > 0 ? liveItemCount : furnitureCatalogItemCount;

    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, topInset + 28, 20, 0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 52),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ALL CATEGORIES',
                            style: AppFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.35,
                              color: const Color(0xFF8A8A8A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Browse',
                            style: AppFonts.dmSerifDisplay(
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.0,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'the collection',
                            style: AppFonts.dmSerifDisplay(
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                              height: 0.98,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            isSearching
                                ? '${filtered.length} categories found'
                                : '$categoryCount categories · $itemCount items',
                            style: AppFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8A8A8A),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DarkPillButton(
                        icon: Icons.storefront_outlined,
                        label: 'Select store',
                        onTap: () {
                          HapticService.light();
                          context.push('/shops');
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                      child: TextField(
                        onChanged: (query) => setState(() => _query = query),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Chairs, tables, sofas…',
                          hintStyle: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: Colors.black26,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: Colors.black38,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: _BrowseCartButton(
                    onTap: () {
                      HapticService.light();
                      context.push('/cart');
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: isSearching
                  ? _buildSearchResults(filtered)
                  : _buildBentoGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<FurnitureCategory> filtered) {
    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'No categories found',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < filtered.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _SearchCategoryRow(
            category: filtered[i],
            onTap: () => _openCategory(filtered[i]),
          ),
        ],
      ],
    );
  }

  Widget _buildBentoGrid() {
    final chairs = _cat('chairs');
    final sofas = _cat('sofas');
    final desks = _cat('desks');
    final tables = _cat('tables');
    final beds = _cat('beds');
    final storage = _cat('storage');
    final lighting = _cat('lighting');
    final outdoor = _cat('outdoor');

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _CategoryCard(
                  category: chairs,
                  height: _kBentoTallCard,
                  onTap: () => _openCategory(chairs),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _CategoryCard(
                      category: sofas,
                      height: _kBentoShortCard,
                      onTap: () => _openCategory(sofas),
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      category: desks,
                      height: _kBentoShortCard,
                      onTap: () => _openCategory(desks),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _CategoryCard(
          category: tables,
          height: _kBentoShortCard,
          isWide: true,
          showTag: 'Most popular',
          horizontalGradient: true,
          onTap: () => _openCategory(tables),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CategoryCard(
                category: beds,
                height: _kBentoMediumCard,
                onTap: () => _openCategory(beds),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryCard(
                category: storage,
                height: _kBentoMediumCard,
                onTap: () => _openCategory(storage),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CategoryCard(
                category: lighting,
                height: _kBentoSlimCard,
                onTap: () => _openCategory(lighting),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryCard(
                category: outdoor,
                height: _kBentoSlimCard,
                onTap: () => _openCategory(outdoor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrowseCartButton extends StatelessWidget {
  const _BrowseCartButton({required this.onTap});

  final VoidCallback onTap;

  static const double _size = 44;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.08),
          ),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'assets/icons/ic_cart.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF1A1A1A),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
    required this.height,
    this.isWide = false,
    this.showTag,
    this.horizontalGradient = false,
  });

  final FurnitureCategory category;
  final VoidCallback onTap;
  final double height;
  final bool isWide;
  final String? showTag;
  final bool horizontalGradient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: category.bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  category.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (_, __, ___) => ColoredBox(
                    color: category.bgColor,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: horizontalGradient
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.65],
                          )
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.62),
                            ],
                            stops: const [0.35, 1.0],
                          ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_outward_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (showTag != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        showTag!,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: 14,
                  right: 48,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${category.itemCount} items',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category.name,
                        style: GoogleFonts.dmSans(
                          fontSize: isWide ? 22 : 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchCategoryRow extends StatelessWidget {
  const _SearchCategoryRow({
    required this.category,
    required this.onTap,
  });

  final FurnitureCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                category.imagePath,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => SizedBox(
                  width: 48,
                  height: 48,
                  child: ColoredBox(color: category.bgColor),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${category.itemCount} items',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Colors.black26,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
