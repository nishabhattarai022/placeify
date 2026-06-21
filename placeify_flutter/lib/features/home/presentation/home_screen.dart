import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'data/home_categories_config.dart';
import 'providers/home_room_provider.dart';
import 'theme/home_screen_tokens.dart';
import 'widgets/ambient_strip.dart';
import 'widgets/home_category_filter_chips.dart';
import 'widgets/home_explore_hero.dart';
import 'widgets/discounted_products_section.dart';
import 'widgets/stats_bar.dart';
import 'widgets/home_about_us_section.dart';
import 'widgets/home_suppliers_section.dart';
import 'widgets/home_recommend_header.dart';
import 'widgets/home_recommend_product_card.dart';
import 'widgets/home_showcase_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ref.watch(selectedRoomProvider);
    final products = HomeCategoriesConfig.forRoom(roomId);

    return Scaffold(
      backgroundColor: HomeScreenTokens.homeBg,
      body: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeExploreHero(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HomeScreenTokens.screenPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: HomeScreenTokens.sectionSpacing),
                  const HomeRecommendHeader(),
                  const SizedBox(height: HomeScreenTokens.sectionSpacing),
                  const HomeCategoryFilterChips(),
                  const SizedBox(height: HomeScreenTokens.sectionSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < products.length; i++) ...[
                        if (i > 0)
                          const SizedBox(
                            width: HomeScreenTokens.productGap,
                          ),
                        Expanded(
                          child: HomeRecommendProductCard(
                            product: products[i],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 28),
                  const AmbientStrip(
                    imagePath:
                        'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg',
                    quote: '"Designed for the\nway you live."',
                  ),
                  const SizedBox(height: 28),
                  const DiscountedProductsSection(),
                  const SizedBox(height: 28),
                  const AmbientStrip(
                    imagePath:
                        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
                    quote: '"Every detail,\nintentional."',
                  ),
                  const SizedBox(height: 28),
                  const HomeShowcaseSection(),
                  const SizedBox(height: 28),
                  const StatsBar(),
                  const SizedBox(height: 28),
                  const HomeAboutUsSection(),
                  const SizedBox(height: 28),
                  const HomeSuppliersSection(),
                  const SizedBox(
                    height: BottomNavTokens.scrollBottomPadding,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
