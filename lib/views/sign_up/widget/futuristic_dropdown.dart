import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FuturisticDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;
  final List<String> items;
  final String hintText;
  final IconData prefixIcon;
  final bool isDark;
  final ThemeData theme;

  const FuturisticDropdown({
    required this.value,
    required this.onChanged,
    required this.items,
    required this.hintText,
    required this.prefixIcon,
    required this.isDark,
    required this.theme,
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
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              );
            }).toList(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black,
            ),
            dropdownColor: isDark
                ? Colors.black.withOpacity(0.8)
                : Colors.white.withOpacity(0.8),
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
            icon: Icon(
              FontAwesomeIcons.chevronDown,
              color: theme.colorScheme.primary,
              size: 16,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an option';
              }
              return null;
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