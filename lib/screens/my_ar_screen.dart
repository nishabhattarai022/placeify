import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/features/ar/domain/constants/ar_strings.dart';
import 'package:placeify/features/ar/presentation/providers/ar_saved_products_provider.dart';
import 'package:placeify/features/ar/presentation/widgets/ar_products_by_category_sliver.dart';
import 'package:placeify/features/home/domain/models/product.dart';
import 'package:placeify/features/home/presentation/providers/category_provider.dart';

class MyArScreen extends ConsumerStatefulWidget {
  const MyArScreen({super.key});

  @override
  ConsumerState<MyArScreen> createState() => _MyArScreenState();
}

class _MyArScreenState extends ConsumerState<MyArScreen> {
  final _searchController = TextEditingController();
  String _searchInput = '';
  String _debouncedQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _searchInput = value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() => _debouncedQuery = value.trim().toLowerCase());
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  List<({Product product, DateTime savedAt})> _resolveEntries(
    Map<String, DateTime> saved,
  ) {
    final query = _debouncedQuery;
    final entries = <({Product product, DateTime savedAt})>[];

    for (final entry in saved.entries) {
      final product = ref.read(productByIdProvider(entry.key));
      if (product == null) continue;

      if (query.isNotEmpty) {
        final haystack =
            '${product.name} ${product.brand} ${product.categoryId}'
                .toLowerCase();
        if (!haystack.contains(query)) continue;
      }

      entries.add((product: product, savedAt: entry.value));
    }

    entries.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final saved = ref.watch(arSavedProductsProvider);
    final entries = _resolveEntries(saved);
    final topInset = MediaQuery.paddingOf(context).top;
    final isSearching = _searchInput.trim().isNotEmpty;

    if (saved.isEmpty) {
      return _MyArEmptyState(
        onBrowse: () {
          HapticService.light();
          context.go('/browse');
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, topInset + 28, 20, 20),
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
                              ArStrings.eyebrow,
                              style: AppFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.35,
                                color: const Color(0xFF8A8A8A),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              ArStrings.titleLine1,
                              style: AppFonts.dmSerifDisplay(
                                fontSize: 48,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.0,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              isSearching
                                  ? ArStrings.searchResults(entries.length)
                                  : ArStrings.savedCount(entries.length),
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
                      const SizedBox(height: 24),
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
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: ArStrings.searchHint,
                            hintStyle: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: Colors.black26,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: Colors.black38,
                            ),
                            suffixIcon: isSearching
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: Colors.black38,
                                    ),
                                    onPressed: _clearSearch,
                                    padding: EdgeInsets.zero,
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _MyArCartButton(
                      onTap: () {
                        HapticService.light();
                        context.push('/cart');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (entries.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _MyArSearchEmptyState(onClear: _clearSearch),
            )
          else
            ArProductsByCategorySliver(entries: entries),
        ],
      ),
    );
  }
}

class _MyArEmptyState extends StatelessWidget {
  const _MyArEmptyState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, topInset + 28, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ArStrings.eyebrow,
                style: AppFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.35,
                  color: const Color(0xFF8A8A8A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                ArStrings.titleLine1,
                style: AppFonts.dmSerifDisplay(
                  fontSize: 48,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.0,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                ArStrings.savedCount(0),
                style: AppFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8A8A8A),
                  height: 1.3,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Icon(
                        Icons.view_in_ar_outlined,
                        size: 48,
                        color: AppColors.charcoal.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        ArStrings.emptyTitle,
                        style: AppFonts.dmSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.charcoal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ArStrings.emptySubtitle,
                        textAlign: TextAlign.center,
                        style: AppFonts.dmSans(
                          fontSize: 14,
                          color: AppColors.charcoal.withValues(alpha: 0.55),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: onBrowse,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.charcoal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text(
                          ArStrings.emptyCta,
                          style: AppFonts.dmSans(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyArSearchEmptyState extends StatelessWidget {
  const _MyArSearchEmptyState({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: AppColors.charcoal.withValues(alpha: 0.18),
          ),
          const SizedBox(height: 20),
          Text(
            'No saved items match your search',
            textAlign: TextAlign.center,
            style: AppFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.charcoal.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFB5654B).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Clear search',
                style: AppFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFB5654B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyArCartButton extends StatelessWidget {
  const _MyArCartButton({required this.onTap});

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
