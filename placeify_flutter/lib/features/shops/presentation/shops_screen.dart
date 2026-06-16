import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_routes.dart';
import 'package:placeify_flutter/features/shops/domain/constants/shop_strings.dart';
import 'package:placeify_flutter/features/shops/domain/models/shop_listing.dart';
import 'package:placeify_flutter/features/shops/presentation/providers/consumer_shop_provider.dart';
import 'package:placeify_flutter/features/shops/presentation/widgets/shop_list_tile.dart';

class ShopsScreen extends ConsumerStatefulWidget {
  const ShopsScreen({super.key});

  @override
  ConsumerState<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends ConsumerState<ShopsScreen> {
  String _searchInput = '';
  String _debouncedQuery = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
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

  @override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(consumerShopsProvider(_debouncedQuery));
    final topInset = MediaQuery.paddingOf(context).top;
    final isSearching = _searchInput.trim().isNotEmpty;

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
                            ShopStrings.eyebrow,
                            style: AppFonts.dmSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.35,
                              color: const Color(0xFF8A8A8A),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ShopStrings.titleLine1,
                            style: AppFonts.dmSerifDisplay(
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.0,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 14),
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
                            error: (_, __) => Text(
                              'Could not load shops',
                              style: AppFonts.dmSans(
                                fontSize: 14,
                                color: const Color(0xFF8A8A8A),
                              ),
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
                  child: _ShopsCartButton(
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
            child: shopsAsync.when(
              data: (shops) => _ShopsList(shops: shops),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Text(
                  ShopStrings.emptyShopsTitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.black38,
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

class _ShopsList extends StatelessWidget {
  const _ShopsList({required this.shops});

  final List<ShopListing> shops;

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
        child: Center(
          child: Column(
            children: [
              Text(
                ShopStrings.emptyShopsTitle,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                ShopStrings.emptyShopsSubtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: shops.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final shop = shops[index];
        return ShopListTile(
          shop: shop,
          onTap: () {
            HapticService.light();
            context.push(ShopRoutes.shopDetail(shop.vendorId));
          },
        );
      },
    );
  }
}

class _ShopsCartButton extends StatelessWidget {
  const _ShopsCartButton({required this.onTap});

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
