import 'package:flutter/material.dart';

abstract final class Responsive {
  static double screenWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  static bool isCompact(BuildContext context) => screenWidth(context) < 380;

  static double arFloorHeight(BuildContext context) =>
      screenHeight(context) * 0.45;
}
