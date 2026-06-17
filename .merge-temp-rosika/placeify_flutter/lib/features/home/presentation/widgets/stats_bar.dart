import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dark rounded stats pill — three columns separated by hairline dividers.
class StatsBar extends StatelessWidget {
  const StatsBar({super.key});

  Widget _stat(String number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          style: GoogleFonts.dmSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1A18),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('1K+', 'Furniture'),
          Container(
            width: 0.5,
            height: 40,
            color: Colors.white24,
          ),
          _stat('100K+', 'Happy Customers'),
          Container(
            width: 0.5,
            height: 40,
            color: Colors.white24,
          ),
          _stat('1K+', 'Awards Won'),
        ],
      ),
    );
  }
}
