import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/data/furniture_categories.dart';
import 'package:placeify_flutter/features/ar/domain/constants/ar_strings.dart';
import 'package:placeify_flutter/features/ar/presentation/ar_selection_room_launcher.dart';
import 'package:placeify_flutter/features/ar/presentation/providers/ar_saved_products_provider.dart';
import 'package:placeify_flutter/features/ar/presentation/widgets/ar_products_by_category_sliver.dart';
import 'package:placeify_flutter/features/ar/presentation/widgets/my_ar_toolbar.dart';
import 'package:placeify_flutter/features/ar/presentation/widgets/my_ar_try_in_room_bar.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/home/presentation/providers/category_provider.dart';

enum _MyArSort { recent, category, name }

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
  bool _selectionMode = false;
  final Set<String> _selectedIds = {};
  bool _openingArRoom = false;
  _MyArSort _sort = _MyArSort.recent;

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

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      if (!_selectionMode) _selectedIds.clear();
    });
  }

  void _onProductTap(Product product) {
    if (_selectionMode) {
      setState(() {
        if (_selectedIds.contains(product.id)) {
          _selectedIds.remove(product.id);
        } else {
          _selectedIds.add(product.id);
        }
      });
      return;
    }

    HapticService.light();
    context.push('/profile/augmented-reality?productId=${product.id}');
  }

  Future<void> _openTryInRoom() async {
    if (_selectedIds.isEmpty || _openingArRoom) return;

    final saved = ref.read(arSavedProductsProvider);
    final entries = _resolveEntries(saved);
    final selectedProducts = [
      for (final entry in entries)
        if (_selectedIds.contains(entry.product.id)) entry.product,
    ];
    if (selectedProducts.isEmpty) return;

    setState(() {
      _openingArRoom = true;
      _selectionMode = false;
      _selectedIds.clear();
    });

    try {
      await ArSelectionRoomLauncher.open(
        context: context,
        selectedProducts: selectedProducts,
      );
    } finally {
      if (mounted) setState(() => _openingArRoom = false);
    }
  }

  void _openSortSheet() {
    HapticService.light();
    PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(
              title: 'Sort by',
              subtitle: 'Organize your saved AR items',
            ),
            const SizedBox(height: 16),
            PlaceifySelectTile(
              label: 'Recently saved',
              selected: _sort == _MyArSort.recent,
              onTap: () => _applySort(sheetContext, _MyArSort.recent),
            ),
            PlaceifySelectTile(
              label: 'Category',
              selected: _sort == _MyArSort.category,
              onTap: () => _applySort(sheetContext, _MyArSort.category),
            ),
            PlaceifySelectTile(
              label: 'Name A–Z',
              selected: _sort == _MyArSort.name,
              onTap: () => _applySort(sheetContext, _MyArSort.name),
            ),
          ],
        );
      },
    );
  }

  void _applySort(BuildContext sheetContext, _MyArSort sort) {
    if (_sort != sort) {
      HapticService.selection();
      setState(() => _sort = sort);
    }
    Navigator.pop(sheetContext);
  }

  List<({Product product, DateTime savedAt})> _resolveEntries(
    Map<String, DateTime> saved,
  ) {
    final query = _debouncedQuery;
    final entries = <({Product product, DateTime savedAt})>[];

    for (final entry in saved.entries) {
      final product = ref.watch(productByIdProvider(entry.key));
      if (product == null) continue;

      if (query.isNotEmpty) {
        final haystack =
            '${product.name} ${product.brand} ${product.categoryId}'
                .toLowerCase();
        if (!haystack.contains(query)) continue;
      }

      entries.add((product: product, savedAt: entry.value));
    }

    switch (_sort) {
      case _MyArSort.recent:
        entries.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      case _MyArSort.category:
        entries.sort((a, b) {
          final catA = _categoryName(a.product.categoryId);
          final catB = _categoryName(b.product.categoryId);
          final cmp = catA.compareTo(catB);
          return cmp != 0 ? cmp : a.product.name.compareTo(b.product.name);
        });
      case _MyArSort.name:
        entries.sort(
          (a, b) => a.product.name.toLowerCase().compareTo(
            b.product.name.toLowerCase(),
          ),
        );
    }

    return entries;
  }

  String _categoryName(String categoryId) {
    return furnitureCategoryById(categoryId)?.name ?? categoryId;
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
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, topInset + 28, 20, 20),
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
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          height: 1.0,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _selectionMode && _selectedIds.isNotEmpty
                            ? ArStrings.selectedCount(_selectedIds.length)
                            : isSearching
                            ? ArStrings.searchResults(entries.length)
                            : ArStrings.savedCount(entries.length),
                        style: AppFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8A8A8A),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      MyArToolbar(
                        selectionMode: _selectionMode,
                        onFilterTap: _openSortSheet,
                        onSelectTap: _toggleSelectionMode,
                      ),
                      if (_selectionMode) ...[
                        const SizedBox(height: 12),
                        Text(
                          ArStrings.selectHint,
                          style: AppFonts.dmSans(
                            fontSize: 13,
                            color: AppColors.charcoal.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
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
                ArProductsByCategorySliver(
                  entries: entries,
                  selectionMode: _selectionMode,
                  selectedIds: _selectedIds,
                  onProductTap: _onProductTap,
                ),
            ],
          ),
          if (_selectionMode && _selectedIds.isNotEmpty)
            MyArTryInRoomBar(
              selectedCount: _selectedIds.length,
              enabled: !_openingArRoom,
              onTap: _openTryInRoom,
            ),
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
                  fontStyle: FontStyle.italic,
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
            style: AppFonts.dmSerifDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
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
