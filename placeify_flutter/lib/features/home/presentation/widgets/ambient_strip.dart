import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-bleed interior photo with warm gradient overlay and animated quote.
class AmbientStrip extends StatefulWidget {
  const AmbientStrip({
    super.key,
    required this.imagePath,
    required this.quote,
  });

  final String imagePath;
  final String quote;

  @override
  State<AmbientStrip> createState() => _AmbientStripState();
}

class _AmbientStripState extends State<AmbientStrip>
    with SingleTickerProviderStateMixin {
  static const Color _fallbackBg = Color(0xFFEFE8DC);

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: _fallbackBg),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x8C000000),
                  ],
                  stops: [0.3, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Text(
                  widget.quote,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.35,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
