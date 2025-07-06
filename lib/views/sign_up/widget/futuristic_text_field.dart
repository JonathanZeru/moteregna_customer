import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
class FuturisticTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePasswordVisibility;
  final TextInputType? keyboardType;
  final bool isDark;
  final ThemeData theme;
  final String? Function(String?)? validator;
  final int maxLines;

  const FuturisticTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePasswordVisibility,
    this.keyboardType,
    required this.isDark,
    required this.theme,
    this.validator,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.2)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            keyboardType: keyboardType,
            maxLines: isPassword ? 1 : maxLines,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                color: isDark
                    ? Colors.white.withOpacity(0.5)
                    : Colors.black.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                      onPressed: onTogglePasswordVisibility,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              errorStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.red.shade300,
              ),
            ),
            validator: validator,
            onChanged: (_) {
              HapticFeedback.selectionClick();
            },
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 100.ms).slideX(
      begin: 0.05,
      end: 0,
      duration: 300.ms,
      delay: 100.ms,
      curve: Curves.easeOutCubic,
    );
  }
}