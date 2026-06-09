import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/presentation/providers/wishlist_provider.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/wishlist/wishlist_grid_view.dart';
import 'widgets/wishlist/wishlist_search_field.dart';

class ProfileWishlistScreen extends ConsumerStatefulWidget {
  const ProfileWishlistScreen({super.key});

  @override
  ConsumerState<ProfileWishlistScreen> createState() =>
      _ProfileWishlistScreenState();
}

class _ProfileWishlistScreenState extends ConsumerState<ProfileWishlistScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(wishlistProvider).length;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(
            title: 'Wishlist · $count items',
            bottom: WishlistSearchField(
              onChanged: (query) => setState(() => _searchQuery = query),
            ),
          ),
          Expanded(
            child: WishlistGridView(
              searchQuery: _searchQuery,
              showBottomPadding: true,
            ),
          ),
        ],
      ),
    );
  }
}
