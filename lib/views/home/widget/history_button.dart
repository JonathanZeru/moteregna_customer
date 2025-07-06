import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gibe_market/views/delivery_history/delivery_history.dart';

class HistoryButton extends StatelessWidget {
  const HistoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      bottom: 120,
      left: 20,
      child: _buildMapControlButton(
        theme,
        FontAwesomeIcons.clockRotateLeft,
        () {
          Get.to(() => const PackageHistoryScreen());
        },
        isDark: isDark,
        tooltip: "View delivery history",
      ),
    );
  }

  Widget _buildMapControlButton(
    ThemeData theme,
    IconData icon,
    VoidCallback onPressed, {
    required bool isDark,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? "Map control",
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}