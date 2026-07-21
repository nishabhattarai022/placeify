import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'providers/catalog_provider.dart';
import 'theme/home_screen_tokens.dart';
import 'widgets/ambient_strip.dart';
import 'widgets/home_explore_hero.dart';
import 'widgets/discounted_products_section.dart';
import 'widgets/stats_bar.dart';
import 'widgets/home_about_us_section.dart';
import 'widgets/home_suppliers_section.dart';
import 'widgets/home_recommend_section.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogIndexProvider.notifier).refresh(silent: true);
    });
  }

  Future<void> _refreshHome() async {
    await refreshCustomerCatalogFromWidget(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeScreenTokens.homeBg,
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
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
                    const HomeRecommendSection(),
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
      ),
    );
  }
}
