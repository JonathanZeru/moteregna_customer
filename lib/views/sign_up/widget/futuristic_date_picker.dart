import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FuturisticDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isDark;
  final ThemeData theme;
  final BuildContext context;
  final String? Function(String?)? validator;

  const FuturisticDatePicker({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.isDark,
    required this.theme,
    required this.context,
    this.validator,
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
            readOnly: true,
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
           onTap: () {
  HapticFeedback.mediumImpact();
  FocusScope.of(context).unfocus(); // close keyboard

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: theme.colorScheme.primary,
              onPrimary: isDark ? Colors.white : Colors.black,
              onSurface: isDark ? Colors.white : Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  });
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