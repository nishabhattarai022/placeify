import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/core/constants/app_spacing.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/placeify_bottom_sheet.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/messaging/presentation/conversations_screen.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_routes.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';
import 'package:placeify_flutter/features/shops/presentation/providers/consumer_shop_provider.dart';
import 'package:placeify_flutter/features/shops/presentation/widgets/vendor_shop_header.dart';
import 'package:placeify_flutter/screens/widgets/category_product_list_tile.dart';

enum _SortOption { featured, priceAsc, priceDesc, nameAsc }

class VendorShopScreen extends ConsumerStatefulWidget {
  const VendorShopScreen({required this.vendorId, super.key});

  final String vendorId;

  @override
  ConsumerState<VendorShopScreen> createState() => _VendorShopScreenState();
}

class _VendorShopScreenState extends ConsumerState<VendorShopScreen> {
  _SortOption _sort = _SortOption.featured;

  List<Product> _sortedProducts(List<Product> products) {
    switch (_sort) {
      case _SortOption.featured:
        return products;
      case _SortOption.priceAsc:
        return List<Product>.from(products)
          ..sort((a, b) => a.price.compareTo(b.price));
      case _SortOption.priceDesc:
        return List<Product>.from(products)
          ..sort((a, b) => b.price.compareTo(a.price));
      case _SortOption.nameAsc:
        return List<Product>.from(products)
          ..sort((a, b) => a.name.compareTo(b.name));
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
              title: ShopStrings.sortSheetTitle,
              subtitle: ShopStrings.sortSheetSubtitle,
            ),
            const SizedBox(height: AppSpacing.lg),
            PlaceifySelectTile(
              label: ShopStrings.sortFeatured,
              selected: _sort == _SortOption.featured,
              onTap: () => _applySort(sheetContext, _SortOption.featured),
            ),
            PlaceifySelectTile(
              label: ShopStrings.sortPriceLowHigh,
              selected: _sort == _SortOption.priceAsc,
              onTap: () => _applySort(sheetContext, _SortOption.priceAsc),
            ),
            PlaceifySelectTile(
              label: ShopStrings.sortPriceHighLow,
              selected: _sort == _SortOption.priceDesc,
              onTap: () => _applySort(sheetContext, _SortOption.priceDesc),
            ),
            PlaceifySelectTile(
              label: ShopStrings.sortNameAsc,
              selected: _sort == _SortOption.nameAsc,
              onTap: () => _applySort(sheetContext, _SortOption.nameAsc),
            ),
          ],
        );
      },
    );
  }

  void _applySort(BuildContext sheetContext, _SortOption option) {
    if (_sort != option) {
      HapticService.selection();
      setState(() => _sort = option);
    }
    Navigator.pop(sheetContext);
  }

  @override
  Widget build(BuildContext context) {
    final shopAsync = ref.watch(shopListingProvider(widget.vendorId));
    final productsAsync = ref.watch(shopProductsProvider(widget.vendorId));

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      body: SafeArea(
        child: shopAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _VendorShopError(
            onBack: () => context.pop(),
          ),
          data: (shop) {
            if (shop == null) {
              return _VendorShopError(onBack: () => context.pop());
            }

            return productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _VendorShopScaffold(
                shop: shop,
                products: const [],
                onOpenSortSheet: _openSortSheet,
              ),
              data: (products) => _VendorShopScaffold(
                shop: shop,
                products: _sortedProducts(products),
                onOpenSortSheet: _openSortSheet,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VendorShopScaffold extends ConsumerWidget {
  const _VendorShopScaffold({
    required this.shop,
    required this.products,
    required this.onOpenSortSheet,
  });

  final ShopListing shop;
  final List<Product> products;
  final VoidCallback onOpenSortSheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = products.length;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: Colors.black87,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => openChatWithVendor(
                        context,
                        ref,
                        shop.vendorId,
                      ),
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text('Chat'),
                    ),
                  ],
                ),
                Text(
                  '${shop.businessName} ($count)',
                  style: GoogleFonts.dmSans(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _Breadcrumb(shopName: shop.businessName)),
                    GestureDetector(
                      onTap: onOpenSortSheet,
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sort by',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.unfold_more_rounded,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                VendorShopHeader(shop: shop),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        if (products.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyShopState(
              onBrowseShops: () => context.go(ShopRoutes.shops),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < products.length - 1 ? 32 : 0,
                    ),
                    child: CategoryProductListTile(product: product),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.shopName});

  final String shopName;

  @override
  Widget build(BuildContext context) {
    final segmentStyle = GoogleFonts.dmSans(
      fontSize: 12,
      color: Colors.black38,
    );
    final separatorStyle = GoogleFonts.dmSans(
      fontSize: 12,
      color: Colors.black26,
    );
    final currentStyle = GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () => context.go(ShopRoutes.shops),
          child: Text(ShopStrings.breadcrumbShops, style: segmentStyle),
        ),
        Text(' › ', style: separatorStyle),
        Text(shopName, style: currentStyle),
      ],
    );
  }
}

class _EmptyShopState extends StatelessWidget {
  const _EmptyShopState({
    required this.onBrowseShops,
  });

  final VoidCallback onBrowseShops;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ShopStrings.emptyProductsTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            ShopStrings.emptyProductsSubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.black38,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: onBrowseShops,
            child: Text(
              'Browse all shops',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VendorShopError extends StatelessWidget {
  const _VendorShopError({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Shop not found',
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onBack,
            child: Text(
              'Go back',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
