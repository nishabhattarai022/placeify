import 'package:flutter/material.dart';

class VendorMetric {
  const VendorMetric({
    required this.label,
    required this.value,
    required this.trendLabel,
    required this.trendColor,
    this.iconPath,
  });

  final String label;
  final String value;
  final String trendLabel;
  final Color trendColor;
  final String? iconPath;
}

class TopProductStat {
  const TopProductStat({
    required this.name,
    required this.iconPath,
    required this.revenue,
    required this.progressFraction,
    required this.barColor,
    this.imageUrl,
  });

  final String name;
  final String iconPath;
  final String revenue;
  final double progressFraction;
  final Color barColor;
  final String? imageUrl;
}
