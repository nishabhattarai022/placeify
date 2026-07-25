import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/features/shops/presentation/providers/consumer_shop_provider.dart';

import '../theme/home_screen_tokens.dart';
import 'suppliers_name_marquee.dart';

/// Local suppliers showcase — title, subtitle, auto-scrolling name marquee.
class HomeSuppliersSection extends ConsumerWidget {
  const HomeSuppliersSection({super.key});

  static const String _subtitle =
      'Local makers and showrooms who stock or build furniture for your space.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopsAsync = ref.watch(consumerShopsProvider(''));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suppliers',
          style: HomeScreenTokens.sectionTitle(),
        ),
        const SizedBox(height: 10),
        Text(
          _subtitle,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            height: 1.5,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 16),
        shopsAsync.when(
          loading: () => const SizedBox(height: 88),
          error: (_, __) => Text(
            'No suppliers available.',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.black45,
            ),
          ),
          data: (shops) {
            if (shops.isEmpty) {
              return Text(
                'No suppliers available.',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: Colors.black45,
                ),
              );
            }
            return SuppliersNameMarquee(suppliers: shops);
          },
        ),
      ],
    );
  }
}
