import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// About Us section — title, body copy, two interior images.
class HomeAboutUsSection extends StatelessWidget {
  const HomeAboutUsSection({super.key});

  static const String _aboutCopy =
      'Welcome to Placeify where we believe that every piece of furniture '
      'tells a unique story. At our online store, we curate a diverse '
      'collection of modern and timeless pieces that blend form, function, '
      'and style to transform your living spaces. Our passion for quality '
      'craftsmanship and innovative design fuels our commitment to bringing '
      'you a carefully selected range of furniture that suits your home.';

  static const String _image1 =
      'assets/images/splash/3d-room-decor-with-furniture-minimalist-beige-tones.jpg';
  static const String _image2 =
      'assets/images/splash/pexels-blackcurrant-great-2016663774-35378675.jpg';

  static const Color _fallbackBg = Color(0xFFEFE8DC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _aboutCopy,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            height: 1.6,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 20),
        _InteriorImage(assetPath: _image1),
        const SizedBox(height: 14),
        _InteriorImage(assetPath: _image2),
      ],
    );
  }
}

class _InteriorImage extends StatelessWidget {
  const _InteriorImage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const ColoredBox(color: HomeAboutUsSection._fallbackBg),
        ),
      ),
    );
  }
}
