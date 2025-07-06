import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void showCyberSnackBar(BuildContext context, String message) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.circleInfo,
              color: theme.colorScheme.secondary,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: isDark
          ? const Color(0xFF1A1F38).withOpacity(0.9)
          : Colors.white.withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.secondary.withOpacity(0.5),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 6),
    ),
  );
}