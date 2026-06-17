import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x142C1810),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x242C1810),
      blurRadius: 40,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> arFloat = [
    BoxShadow(
      color: Color(0x6B000000),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 16),
    ),
  ];
}
