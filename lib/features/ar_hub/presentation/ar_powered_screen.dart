import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/placeify_image.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../home/domain/models/product.dart';
import '../../home/presentation/providers/category_provider.dart';
import 'package:placeify/features/ar/presentation/widgets/ar_product_carousel_strip.dart';
import 'ar_hub_tokens.dart';
import 'widgets/ar_compact_cta_button.dart';
import 'widgets/ar_powered_app_bar.dart';

class ArPoweredScreen extends ConsumerStatefulWidget {
  const ArPoweredScreen({
    this.productId,
    this.productIds = const [],
    this.initialActiveId,
    super.key,
  });

  final String? productId;
  final List<String> productIds;
  final String? initialActiveId;

  @override
  ConsumerState<ArPoweredScreen> createState() => _ArPoweredScreenState();
}

class _ArPoweredScreenState extends ConsumerState<ArPoweredScreen> {
  late int _activeIndex;

  static final _headlineStyle = AppFonts.dmSerifDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: ArHubTokens.textPrimary,
    height: 1.25,
    letterSpacing: -0.3,
  );

  List<String> get _allIds {
    if (widget.productIds.isNotEmpty) return widget.productIds;
    if (widget.productId != null && widget.productId!.isNotEmpty) {
      return [widget.productId!];
    }
    return const [];
  }

  @override
  void initState() {
    super.initState();
    final ids = _allIds;
    final initialId = widget.initialActiveId ?? widget.productId;
    if (ids.isEmpty) {
      _activeIndex = 0;
    } else if (initialId != null) {
      final idx = ids.indexOf(initialId);
      _activeIndex = idx >= 0 ? idx : 0;
    } else {
      _activeIndex = 0;
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void _openArAssistant() {
    HapticService.heavy();
    PlaceifyToast.show(context, 'In progress / Building');
  }

  List<Product> _resolveProducts(List<String> ids) {
    return [
      for (final id in ids)
        if (ref.read(productByIdProvider(id)) != null)
          ref.read(productByIdProvider(id))!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ids = _allIds;
    final products = _resolveProducts(ids);
    final hasProducts = products.isNotEmpty;
    final activeProduct = hasProducts
        ? products[_activeIndex.clamp(0, products.length - 1)]
        : null;

    final headlineLine1 = activeProduct != null
        ? 'Viewing ${activeProduct.name}'
        : ArHubTokens.headlineLine1;
    final headlineLine2 =
        activeProduct != null ? 'in your room' : ArHubTokens.headlineLine2;
    final body = activeProduct != null
        ? 'Place and preview this piece in AR. '
            'Adjust scale and position before you buy.'
        : ArHubTokens.body;

    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: ArHubTokens.background,
      body: Column(
        children: [
          ArPoweredAppBar(onMoreTap: () => context.pop()),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        ArHubTokens.screenPadding,
                        ArHubTokens.heroTopSpacing,
                        ArHubTokens.screenPadding,
                        0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            headlineLine1,
                            textAlign: TextAlign.center,
                            style: _headlineStyle,
                          ),
                          Text(
                            headlineLine2,
                            textAlign: TextAlign.center,
                            style: _headlineStyle,
                          ),
                          const SizedBox(height: 14),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Text(
                              body,
                              textAlign: TextAlign.center,
                              style: AppFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: ArHubTokens.textSecondary,
                                height: 1.55,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          ArCompactCtaButton(onTap: _openArAssistant),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: activeProduct != null
                          ? _ArActiveProductPreview(product: activeProduct)
                          : const _ArDefaultPreview(),
                    ),
                  ],
                ),
                if (products.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomInset + 12,
                    child: ArProductCarouselStrip(
                      products: products,
                      activeIndex: _activeIndex,
                      onActiveIndexChanged: (index) {
                        setState(() => _activeIndex = index);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArActiveProductPreview extends StatelessWidget {
  const _ArActiveProductPreview({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 28,
            child: Container(
              width: 180,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 36),
            child: PlaceifyImage(
              source: product.imageUrl,
              fit: BoxFit.contain,
              error: Center(
                child: SvgPicture.asset(
                  product.svgIconPath,
                  width: 72,
                  colorFilter: const ColorFilter.mode(
                    AppColors.bark,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArDefaultPreview extends StatelessWidget {
  const _ArDefaultPreview();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Image.asset(
        'assets/images/products/chair_green.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const ColoredBox(
          color: Color(0xFFF3EFE8),
          child: Center(
            child: Icon(
              Icons.view_in_ar_outlined,
              size: 64,
              color: Colors.black26,
            ),
          ),
        ),
      ),
    );
  }
}
