import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cart/presentation/providers/cart_provider.dart';
import '../../home/domain/models/product.dart';
import '../../home/presentation/providers/catalog_provider.dart';
import '../../../core/services/haptic_service.dart';
import '../data/product_detail_content.dart';
import 'product_detail_tokens.dart';
import '../../shops/presentation/providers/consumer_shop_provider.dart';
import 'widgets/product_detail_sold_by_row.dart';
import 'widgets/product_detail_cart_bar.dart';
import 'widgets/product_detail_gallery.dart';
import 'widgets/product_detail_header.dart';
import 'widgets/product_detail_info_section.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

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

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return productAsync.when(
      loading: () => const Scaffold(
        backgroundColor: ProductDetailTokens.screenBg,
        body: Center(child: CircularProgressIndicator()),
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
        return _buildProductDetail(context, product);
      },
    );
  }

  Widget _buildProductDetail(BuildContext context, Product product) {
    final content = ProductDetailContentRepository.forProduct(product);
    final top = MediaQuery.paddingOf(context).top;
    final vendorId = product.vendorId;
    final shopAsync =
        vendorId != null ? ref.watch(shopListingProvider(vendorId)) : null;

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
                  position: _gallerySlide,
                  child: FadeTransition(
                    opacity: _galleryOpacity,
                    child: ProductDetailGallery(
                      product: product,
                      images: content.galleryImages,
                      selectedIndex: _selectedImageIndex,
                      onSelected: (i) =>
                          setState(() => _selectedImageIndex = i),
                    ),
                  ),
                ),
                const SizedBox(
                  height: ProductDetailTokens.infoCardTopGap,
                ),
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
                  position: _infoSlide,
                  child: FadeTransition(
                    opacity: _infoOpacity,
                    child: ProductDetailInfoSection(
                      title: content.displayTitle ?? product.name,
                      shortDescription: content.shortDescription,
                      fullDescription:
                          content.extendedDescription ?? content.description,
                      materials: content.materials,
                      specs: content.specs,
                      careInstructions: content.careInstructions,
                      warranty: content.warranty,
                      expanded: _expanded,
                      onViewMore: () {
                        HapticService.light();
                        setState(() => _expanded = !_expanded);
                      },
                    ),
                  ),
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
              position: _cartBarSlide,
              child: FadeTransition(
                opacity: _cartBarOpacity,
                child: ProductDetailCartBar(
                  onTryInMyRoom: () {
                    context.push('/profile/augmented-reality');
                  },
                  onAddToCart: () {
                    ref
                        .read(cartProvider.notifier)
                        .addProduct(product.id);
                    HapticService.medium();
                    context.push('/cart');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
