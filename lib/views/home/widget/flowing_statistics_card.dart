import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class FloatingStatsCard extends StatelessWidget {
  final int secondsElapsed;
  final double distance;
  final double initialPrice;
  final double pricePerKm;
  final double pricePerMinute;
  final bool isDark;
  final String customerPhone; // Add customer phone

  const FloatingStatsCard({
    super.key,
    required this.secondsElapsed,
    required this.distance,
    required this.initialPrice,
    required this.pricePerKm,
    required this.pricePerMinute,
    required this.isDark,
    required this.customerPhone,
  });

  // Calculate estimated fare dynamically
  double get estimatedFare {
    final distanceKm = distance / 1000;
    final timeMinutes = secondsElapsed / 60;
    return initialPrice + (distanceKm * pricePerKm) + (timeMinutes * pricePerMinute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: isDark ? 8 : 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark
          ? const Color(0xFF1A1F38).withOpacity(0.8)
          : Colors.white.withOpacity(0.8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Customer phone
                _buildStatRow(
                  context,
                  FontAwesomeIcons.phone,
                  "customer".tr,
                  customerPhone,
                  theme.colorScheme.secondary,
                ),
                const Divider(height: 16),

                // Time
                _buildStatRow(
                  context,
                  FontAwesomeIcons.stopwatch,
                  "time".tr,
                  _formatDuration(secondsElapsed),
                  theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),

                // Distance
                _buildStatRow(
                  context,
                  FontAwesomeIcons.route,
                  "distance".tr,
                  "${(distance / 1000).toStringAsFixed(2)} ${'km'.tr}",
                  theme.colorScheme.secondary,
                ),
                const SizedBox(height: 8),

                // Pricing details
                _buildStatRow(
                  context,
                  FontAwesomeIcons.moneyBillWave,
                  "rate".tr,
                  "${pricePerKm.toStringAsFixed(0)} ${'etb'.tr} per ${'km'.tr}",
                  theme.colorScheme.tertiary,
                ),
                const SizedBox(height: 8),

                // Estimated fare
                _buildStatRow(
                  context,
                  FontAwesomeIcons.moneyBill,
                  "est_fare".tr,
                  "${estimatedFare.toStringAsFixed(0)} ${'etb'.tr}",
                  Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(
      begin: 0.3, 
      end: 0, 
      duration: const Duration(milliseconds: 500)
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: GoogleFonts.orbitron(
            fontSize: 12,
            color: isDark
                ? Colors.white.withOpacity(0.7)
                : Colors.black.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 8),
        isDark
            ? GlowText(
                value,
                style: GoogleFonts.orbitron(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                glowColor: color.withOpacity(0.5),
                blurRadius: 10,
              )
            : Shimmer.fromColors(
                baseColor: color,
                highlightColor: color.withOpacity(0.5),
                child: Text(
                  value,
                  style: GoogleFonts.orbitron(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:${remainingMinutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}