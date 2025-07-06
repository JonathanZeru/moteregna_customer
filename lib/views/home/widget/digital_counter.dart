import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DigitalCounter extends StatelessWidget {
  final int value;
  final String Function(int) formatter;
  final Color color;
  final double fontSize;
  final bool isDark;

  const DigitalCounter({
    super.key,
    required this.value,
    required this.formatter,
    required this.color,
    this.fontSize = 16.0,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final formattedValue = formatter(value);
    
    // Split the formatted value (HH:MM:SS) into parts
    final parts = formattedValue.split(':');
    final hours = parts[0];
    final minutes = parts[1];
    final seconds = parts[2];
    
    // Create the top row (seconds)
    final secondsRow = _buildDigitalRow(seconds, color, fontSize, isDark);
    
    // Create the bottom row (hours:minutes)
    final hoursMinutesRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._buildDigitalRow(hours, color, fontSize * 0.9, isDark).children,
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            ":",
            style: GoogleFonts.orbitron(
              fontSize: fontSize * 0.9,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: isDark
                  ? [
                      Shadow(
                        color: color.withOpacity(0.8),
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        ..._buildDigitalRow(minutes, color, fontSize * 0.9, isDark).children,
      ],
    );
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Seconds at the top
        secondsRow,
        
        // Small divider
        Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: 20,
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.5),
                color.withOpacity(0.1),
              ],
            ),
          ),
        ),
        
        // Hours:Minutes at the bottom
        hoursMinutesRow,
      ],
    );
  }
  
  // Helper method to build a row of digital characters
  Row _buildDigitalRow(String text, Color color, double fontSize, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: text.split('').map((char) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            char,
            style: GoogleFonts.orbitron(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
              shadows: isDark
                  ? [
                      Shadow(
                        color: color.withOpacity(0.8),
                        blurRadius: 5,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
            ),
          ),
        );
      }).toList(),
    );
  }
}


