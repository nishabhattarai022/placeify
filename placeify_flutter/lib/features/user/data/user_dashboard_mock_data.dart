import 'package:flutter/material.dart';

/// Overview card model for the user dashboard grid.
class UserOverviewMetric {
  const UserOverviewMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
}
