import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'glowing_progress_indicator.dart';

class MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget value;
  final Color accentColor;
  final bool isDark;
  final String? tooltip;
  final bool showProgress;
  final double progressValue;

  const MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.isDark,
    this.tooltip,
    this.showProgress = false,
    this.progressValue = 0.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? label,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label with icon
            Row(
              children: [
                Icon(icon, size: 14, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress indicator if needed
            if (showProgress)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlowingProgressIndicator(
                  value: progressValue.clamp(0.0, 1.0),
                  color: accentColor,
                  height: 3,
                  isDark: isDark,
                ),
              ),
            // Value
            Center(child: value),
          ],
        ),
      ),
    );
  }
}