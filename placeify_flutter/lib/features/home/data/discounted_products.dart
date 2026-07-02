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

const List<DiscountedProduct> discountedProducts = [
  DiscountedProduct(
    id: 'p1',
    name: 'Astra',
    imagePath:
        'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg',
    originalPrice: 399,
    discountedPrice: 199,
    discountPercent: 50,
    tagline: 'Sage suede sculptural lounge.',
    cardColor: Color(0xFFB5A99A),
  ),
  DiscountedProduct(
    id: 'p4',
    name: 'Harmony Chair',
    imagePath: 'assets/images/splash/Diane_Sofa_Venice_Vegan_Suede_Sage_1.jpg',
    originalPrice: 299,
    discountedPrice: 179,
    discountPercent: 40,
    tagline: 'Sculpted suede, modern lines.',
    cardColor: Color(0xFFA8B5A0),
  ),
  DiscountedProduct(
    id: 'p7',
    name: 'Walnut Desk',
    imagePath:
        'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg',
    originalPrice: 499,
    discountedPrice: 299,
    discountPercent: 40,
    tagline: 'Mid-century walnut classic.',
    cardColor: Color(0xFFB0AABF),
  ),
  DiscountedProduct(
    id: 'p17',
    name: 'Patio Lounge',
    imagePath: 'assets/images/splash/462222_1_800.jpg',
    originalPrice: 349,
    discountedPrice: 229,
    discountPercent: 34,
    tagline: 'Curved cream, warm interiors.',
    cardColor: Color(0xFFBFAE98),
  ),
];
