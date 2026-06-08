import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/haptic_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/animated_scale_tap.dart';

/// Promotional "Perfect Place to Relax!" banner below recommended products.
class HomePromoBanner extends StatelessWidget {
  const HomePromoBanner({super.key});

  static const String _chairAsset =
      'assets/images/splash/Tola_Lounge_Chair_Venice_Vegan_Suede_Sage_1_0.jpg';

  static const Color _cardBg = Color(0xFFB5A99A);
  static const Color _discountInk = Color(0xFF4A3010);

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleTap(
      pressScale: 0.985,
      onTap: () {
        HapticService.light();
        context.go('/browse');
      },
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              bottom: 20,
              width: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '— Perfect Place to Relax!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '30% off',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: _discountInk,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: -40,
              bottom: 0,
              width: 180,
              child: Image.asset(
                _chairAsset,
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            Positioned(
              top: 16,
              right: 24,
              child: Transform.rotate(
                angle: -0.14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Formatters.currencyFull(399),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black45,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        Formatters.currencyFull(199),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
