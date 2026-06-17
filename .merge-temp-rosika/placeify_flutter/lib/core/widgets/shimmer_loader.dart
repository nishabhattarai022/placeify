import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key, this.borderRadius});

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.creamDark,
      highlightColor: AppColors.cream,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.creamDark,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
