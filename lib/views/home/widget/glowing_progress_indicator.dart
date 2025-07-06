import 'package:flutter/material.dart';

class GlowingProgressIndicator extends StatelessWidget {
  final double value;
  final Color color;
  final double height;
  final double borderRadius;
  final bool isDark;

  const GlowingProgressIndicator({
    super.key,
    required this.value,
    required this.color,
    this.height = 4.0,
    this.borderRadius = 2.0,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.3)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          // Glow effect (only in dark mode)
          if (isDark)
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * value,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.7),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          
          // Progress bar
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth * value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.7),
                      color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

