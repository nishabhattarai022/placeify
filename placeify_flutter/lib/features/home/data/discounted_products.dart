import 'package:flutter/material.dart';

class DiscountedProduct {
  final String id;
  final String name;
  final String imagePath;
  final double originalPrice;
  final double discountedPrice;
  final int discountPercent;
  final String tagline;
  final Color cardColor;

  const DiscountedProduct({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.tagline,
    required this.cardColor,
  });
}
