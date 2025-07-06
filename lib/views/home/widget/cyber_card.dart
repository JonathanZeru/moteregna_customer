import 'dart:ui';
import 'package:flutter/material.dart';

class CyberCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final double blurAmount;
  final bool isDark;

  const CyberCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 16.0,
    this.borderColor,
    this.backgroundColor,
    this.blurAmount = 10.0,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColorToUse = borderColor ?? theme.colorScheme.primary.withOpacity(0.5);
    final backgroundColorToUse = backgroundColor ?? (isDark
        ? Colors.black.withOpacity(0.2)
        : Colors.white.withOpacity(0.2));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: isDark ? 15 : 8,
            spreadRadius: isDark ? 1 : 0.5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: Container(
            padding: padding ?? const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: backgroundColorToUse,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColorToUse,
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

