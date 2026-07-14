import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Heading with a parenthesized count in superscript — e.g. `Chair⁽⁹⁾`.
class SuperscriptCountTitle extends StatelessWidget {
  const SuperscriptCountTitle({
    required this.title,
    required this.count,
    this.fontSize = 34,
    this.color = const Color(0xDE000000),
    super.key,
  });

  final String title;
  final int count;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final countFontSize = fontSize * 0.38;
    final superscriptLift = fontSize * 0.44;

    final titleStyle = GoogleFonts.dmSerifDisplay(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: color,
      letterSpacing: -0.5,
      height: 1.0,
    );

    final countStyle = GoogleFonts.dmSerifDisplay(
      fontSize: countFontSize,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: color,
      letterSpacing: -0.15,
      height: 1.0,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        Transform.translate(
          offset: Offset(0, -superscriptLift),
          child: Text('($count)', style: countStyle),
        ),
      ],
    );
  }
}
