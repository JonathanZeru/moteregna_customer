import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double glowIntensity;
  final TextAlign textAlign;

  const NeonText({
    super.key,
    required this.text,
    required this.color,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.glowIntensity = 0.8,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.orbitron(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Theme.of(context).primaryColor,
        shadows: [
          Shadow(
            color: color.withOpacity(0.3),
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
          Shadow(
            color: color.withOpacity(glowIntensity),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
    );
  }
}
