import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/presentation/providers/wishlist_provider.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/wishlist/wishlist_grid_view.dart';

class ProfileWishlistScreen extends ConsumerWidget {
  const ProfileWishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(wishlistProvider).length;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          ProfileSubHero(title: 'Wishlist · $count items'),
          const Expanded(
            child: WishlistGridView(showBottomPadding: true),
          ),
        ],
      ),
    );
  }
}
