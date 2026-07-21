import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cart/presentation/cart_actions.dart';
import '../../home/domain/models/product.dart';
import '../../home/presentation/providers/catalog_provider.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../data/product_3d_model_resolver.dart';
import '../data/product_detail_content.dart';
import 'ar_room_screen.dart';
import 'product_detail_tokens.dart';
import 'package:placeify_flutter/features/shops/presentation/providers/consumer_shop_provider.dart';
import 'widgets/product_detail_cart_bar.dart';
import 'widgets/product_detail_gallery.dart';
import 'widgets/product_detail_header.dart';
import 'widgets/product_detail_info_section.dart';
import 'widgets/product_detail_price_row.dart';
import 'widgets/product_detail_reviews_section.dart';
import 'widgets/product_detail_sold_by_row.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({
    required this.productId,
    this.highlightReviewId,
    super.key,
  });

  final String productId;
  final String? highlightReviewId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _selectedImageIndex = 0;
  bool _expanded = false;

  late final AnimationController _entryController;
  late final Animation<double> _galleryOpacity;
  late final Animation<Offset> _gallerySlide;
  late final Animation<double> _infoOpacity;
  late final Animation<Offset> _infoSlide;
  late final Animation<double> _cartBarOpacity;
  late final Animation<Offset> _cartBarSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    CurvedAnimation curve(double begin, double end) => CurvedAnimation(
          parent: _entryController,
          curve: Interval(begin, end, curve: Curves.easeOutCubic),
        );

    _galleryOpacity = curve(0.05, 0.55).drive(Tween<double>(begin: 0, end: 1));
    _gallerySlide = curve(0.05, 0.6).drive(
      Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero),
    );
    _infoOpacity = curve(0.25, 0.85).drive(Tween<double>(begin: 0, end: 1));
    _infoSlide = curve(0.25, 0.9).drive(
      Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero),
    );
    _cartBarOpacity = curve(0.4, 1.0).drive(Tween<double>(begin: 0, end: 1));
    _cartBarSlide = curve(0.4, 1.0).drive(
      Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero),
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  Future<void> _openArRoom(BuildContext context, Product product) async {
    final preview = await Product3dModelResolver.ensurePreviewSourceForProduct(
      product,
    );
    if (!context.mounted) return;
    if (preview?.unavailableMessage != null ||
        preview?.src == null ||
        preview!.src.isEmpty) {
      PlaceifyToast.show(
        context,
        preview?.unavailableMessage ??
            '3D model is not available for this product yet.',
      );
      return;
    }

    final remoteUrl = await Product3dModelResolver.ensureSrcForProduct(product);
    if (!context.mounted) return;
    if (remoteUrl == null || remoteUrl.isEmpty) {
      PlaceifyToast.show(
        context,
        '3D model is not available for this product yet.',
      );
      return;
    }

    final result = await ArRoomLauncher.open(
      context: context,
      remoteModelUrl: remoteUrl,
      productId: product.id,
      productName: product.name,
      dimensions: product.dimensions,
    );

    if (!context.mounted) return;
    switch (result) {
      case ArRoomOpenResult.permissionDenied:
        PlaceifyToast.show(context, 'Camera permission is required for AR.');
      case ArRoomOpenResult.modelDownloadFailed:
        PlaceifyToast.show(context, 'Could not load the 3D model.');
      case ArRoomOpenResult.opened:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return productAsync.when(
      loading: () => Scaffold(
        backgroundColor: ProductDetailTokens.screenBg,
        body: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: ProductDetailTokens.screenBg,
        body: Center(
          child: TextButton(
            onPressed: () => context.pop(),
            child: const Text('Product not found'),
          ),
        ),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            backgroundColor: ProductDetailTokens.screenBg,
            body: Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: const Text('Product not found'),
              ),
            ),
          );
        }
        return _ProductDetailBody(
          product: product,
          highlightReviewId: widget.highlightReviewId,
          entryController: _entryController,
          galleryOpacity: _galleryOpacity,
          gallerySlide: _gallerySlide,
          infoOpacity: _infoOpacity,
          infoSlide: _infoSlide,
          cartBarOpacity: _cartBarOpacity,
          cartBarSlide: _cartBarSlide,
          selectedImageIndex: _selectedImageIndex,
          expanded: _expanded,
          onSelected: (index) => setState(() => _selectedImageIndex = index),
          onToggleExpanded: () {
            HapticService.light();
            setState(() => _expanded = !_expanded);
          },
          onOpenArRoom: (context) => _openArRoom(context, product),
          onAddToCart: () => addToCart(ref, context, product.id),
        );
      },
    );
  }
}

class _ProductDetailBody extends ConsumerWidget {
  const _ProductDetailBody({
    required this.product,
    required this.highlightReviewId,
    required this.entryController,
    required this.galleryOpacity,
    required this.gallerySlide,
    required this.infoOpacity,
    required this.infoSlide,
    required this.cartBarOpacity,
    required this.cartBarSlide,
    required this.selectedImageIndex,
    required this.expanded,
    required this.onSelected,
    required this.onToggleExpanded,
    required this.onOpenArRoom,
    required this.onAddToCart,
  });

  final Product product;
  final String? highlightReviewId;
  final AnimationController entryController;
  final Animation<double> galleryOpacity;
  final Animation<Offset> gallerySlide;
  final Animation<double> infoOpacity;
  final Animation<Offset> infoSlide;
  final Animation<double> cartBarOpacity;
  final Animation<Offset> cartBarSlide;
  final int selectedImageIndex;
  final bool expanded;
  final ValueChanged<int> onSelected;
  final VoidCallback onToggleExpanded;
  final Future<void> Function(BuildContext context) onOpenArRoom;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ProductDetailContentRepository.forProduct(product);
    final top = MediaQuery.paddingOf(context).top;
    final vendorId = product.vendorId;
    final shopAsync = vendorId != null
        ? ref.watch(shopListingProvider(vendorId))
        : null;

    return Scaffold(
      backgroundColor: ProductDetailTokens.screenBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: top +
                      ProductDetailTokens.headerSize +
                      ProductDetailTokens.headerTopPadding +
                      8,
                ),
                SlideTransition(
                  position: gallerySlide,
                  child: FadeTransition(
                    opacity: galleryOpacity,
                    child: ProductDetailGallery(
                      product: product,
                      images: content.galleryImages,
                      selectedIndex: selectedImageIndex,
                      onSelected: onSelected,
                    ),
                  ),
                ),
                const SizedBox(
                  height: ProductDetailTokens.infoCardTopGap,
                ),
                ProductDetailPriceRow(product: product),
                if (vendorId != null)
                  shopAsync?.maybeWhen(
                    data: (shop) {
                      if (shop == null) return const SizedBox.shrink();
                      return ProductDetailSoldByRow(
                        vendorId: vendorId,
                        businessName: shop.businessName,
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  ) ??
                  const SizedBox.shrink(),
                SlideTransition(
                  position: infoSlide,
                  child: FadeTransition(
                    opacity: infoOpacity,
                    child: ProductDetailInfoSection(
                      title: content.displayTitle ?? product.name,
                      shortDescription: content.shortDescription,
                      fullDescription:
                          content.extendedDescription ?? content.description,
                      materials: content.materials,
                      specs: content.specs,
                      careInstructions: content.careInstructions,
                      warranty: content.warranty,
                      expanded: expanded,
                      onViewMore: onToggleExpanded,
                    ),
                  ),
                ),
                ProductDetailReviewsSection(
                  productId: product.id,
                  highlightReviewId: highlightReviewId,
                ),
                const SizedBox(
                  height: ProductDetailTokens.cartBarBottomSpacer,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: top + ProductDetailTokens.headerTopPadding,
            child: ProductDetailHeader(
              product: product,
              onBack: () {
                HapticService.light();
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: cartBarSlide,
              child: FadeTransition(
                opacity: cartBarOpacity,
                child: ProductDetailCartBar(
                  onTryInMyRoom: () => onOpenArRoom(context),
                  onAddToCart: onAddToCart,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
