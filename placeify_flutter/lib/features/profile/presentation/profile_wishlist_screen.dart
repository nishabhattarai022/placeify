import 'package:flutter/material.dart';

import 'widgets/wishlist/wishlist_screen.dart';

class ProfileWishlistScreen extends StatelessWidget {
  const ProfileWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WishlistScreen(showBackButton: true);
  }
}
