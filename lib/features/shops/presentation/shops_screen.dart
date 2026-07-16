import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';
import 'package:placeify/core/widgets/placeify_cart_icon_button.dart';
import 'package:placeify/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify/features/shops/presentation/providers/consumer_shop_provider.dart';
import 'package:placeify/features/shops/presentation/widgets/vendor_grid_shimmer.dart';
import 'package:placeify/features/shops/presentation/widgets/vendor_masonry_grid.dart';

class ShopsScreen extends ConsumerStatefulWidget {
  const ShopsScreen({super.key});

  @override
  ConsumerState<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends ConsumerState<ShopsScreen> {
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
      setState(() => _debouncedQuery = value.trim());
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(consumerShopsProvider(_debouncedQuery));
    final topInset = MediaQuery.paddingOf(context).top;
    final isSearching = _searchInput.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Header: eyebrow, title, subtitle, search bar ──────────────────
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
                            // Eyebrow
                            Text(
                              ShopStrings.eyebrow,
                              style: AppFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.35,
                                color: const Color(0xFF8A8A8A),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Title
                            Text(
                              ShopStrings.titleLine1,
                              style: AppFonts.dmSerifDisplay(
                                fontSize: 48,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                                height: 1.0,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Subtitle — count line
                            shopsAsync.when(
                              data: (shops) => Text(
                                isSearching
                                    ? '${shops.length} shops found'
                                    : '${shops.length} local shops',
                                style: AppFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF8A8A8A),
                                  height: 1.3,
                                ),
                              ),
                              loading: () => Text(
                                'Loading shops…',
                                style: AppFonts.dmSans(
                                  fontSize: 14,
                                  color: const Color(0xFF8A8A8A),
                                ),
                              ),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Search bar
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
                            hintText: ShopStrings.searchHint,
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
                  // Cart button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: PlaceifyCartIconButton(
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

          // ── Grid / shimmer / empty / error ───────────────────────────────
          shopsAsync.when(
            data: (shops) {
              if (shops.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(
                    query: _debouncedQuery,
                    onClear: _clearSearch,
                  ),
                );
              }
              return VendorMasonryGrid(
                shops: shops,
                query: _debouncedQuery,
              );
            },
            loading: () => const VendorGridShimmer(),
            error: (error, _) => SliverFillRemaining(
              hasScrollBody: false,
              child: _ErrorState(
                onRetry: () =>
                    ref.invalidate(consumerShopsProvider(_debouncedQuery)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query, required this.onClear});

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasQuery = query.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 52,
            color: AppColors.charcoal.withValues(alpha: 0.18),
          ),
          const SizedBox(height: 20),
          Text(
            hasQuery
                ? ShopStrings.emptySearch(query)
                : ShopStrings.emptyShopsTitle,
            textAlign: TextAlign.center,
            style: AppFonts.dmSerifDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: AppColors.charcoal.withValues(alpha: 0.65),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hasQuery
                ? ShopStrings.emptyShopsSubtitle
                : 'Check back soon for new local stores.',
            textAlign: TextAlign.center,
            style: AppFonts.dmSans(
              fontSize: 14,
              color: AppColors.charcoal.withValues(alpha: 0.45),
              height: 1.45,
            ),
          ),
          if (hasQuery) ...[
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFB5654B).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  ShopStrings.emptySearchCta,
                  style: AppFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB5654B),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Error state ────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: AppColors.charcoal.withValues(alpha: 0.18),
          ),
          const SizedBox(height: 20),
          Text(
            ShopStrings.errorTitle,
            textAlign: TextAlign.center,
            style: AppFonts.dmSerifDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: AppColors.charcoal.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Something went wrong while loading shops.',
            textAlign: TextAlign.center,
            style: AppFonts.dmSans(
              fontSize: 14,
              color: AppColors.charcoal.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.charcoal.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                ShopStrings.errorCta,
                style: AppFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal.withValues(alpha: 0.70),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
