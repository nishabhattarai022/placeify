import 'package:flutter/material.dart';

import 'ar_feature_tag.dart';
import '../ar_hub_tokens.dart';

class ArFeatureShowcase extends StatelessWidget {
  const ArFeatureShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final tagInset = ArHubTokens.screenPadding;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset + 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final areaWidth = constraints.maxWidth;
          final areaHeight = constraints.maxHeight;

          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: _FadedChairImage(
                  width: areaWidth,
                  height: areaHeight,
                ),
              ),
              Positioned(
                left: areaWidth * 0.12,
                right: areaWidth * 0.12,
                bottom: areaHeight * 0.06,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: areaHeight * 0.02,
                left: tagInset,
                child: const ArFeatureTag(
                  icon: Icons.open_in_full_rounded,
                  label: 'Space Saving',
                ),
              ),
              Positioned(
                top: areaHeight * 0.1,
                right: tagInset,
                child: const ArFeatureTag(
                  icon: Icons.auto_awesome_outlined,
                  label: 'Easy to Clean',
                ),
              ),
              Positioned(
                bottom: areaHeight * 0.22,
                left: tagInset,
                child: const ArFeatureTag(
                  icon: Icons.layers_outlined,
                  label: 'Premium Fabric',
                ),
              ),
              Positioned(
                bottom: areaHeight * 0.16,
                right: tagInset,
                child: const ArFeatureTag(
                  icon: Icons.weekend_outlined,
                  label: 'Modern Style',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FadedChairImage extends StatelessWidget {
  const _FadedChairImage({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Color(0x00000000),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
            Color(0x00000000),
          ],
          stops: const [0.0, 0.07, 0.93, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: SizedBox(
        width: width,
        height: height,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Image.asset(
            ArHubTokens.chairAsset,
            width: width,
            height: height,
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomCenter,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
