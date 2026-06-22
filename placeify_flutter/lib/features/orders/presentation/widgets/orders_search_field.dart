import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/constants/order_strings.dart';

/// Pill search bar for the My Orders screen — matches wishlist search styling.
class OrdersSearchField extends StatelessWidget {
  const OrdersSearchField({
    required this.onChanged,
    super.key,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: OrderStrings.searchHint,
          hintStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black.withValues(alpha: 0.35),
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 22,
            color: Colors.black.withValues(alpha: 0.45),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          isDense: true,
        ),
      ),
    );
  }
}
