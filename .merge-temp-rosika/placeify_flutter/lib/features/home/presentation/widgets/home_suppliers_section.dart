import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/local_suppliers_config.dart';
import '../theme/home_screen_tokens.dart';
import 'suppliers_name_marquee.dart';

/// Local suppliers showcase — title, subtitle, auto-scrolling name marquee.
class HomeSuppliersSection extends StatelessWidget {
  const HomeSuppliersSection({super.key});

  static const String _subtitle =
      'Local makers and showrooms who stock or build furniture for your space.';

  @override
  Widget build(BuildContext context) {
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
        const SuppliersNameMarquee(
          suppliers: LocalSuppliersConfig.all,
        ),
      ],
    );
  }
}
