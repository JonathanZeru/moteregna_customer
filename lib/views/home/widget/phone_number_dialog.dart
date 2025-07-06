import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneNumberDialog extends StatelessWidget {
  final bool isDark;
  final TextEditingController phoneController;
  final VoidCallback onContinue;

  const PhoneNumberDialog({
    required this.isDark,
    required this.phoneController,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isValidPhone = phoneController.text.length == 9 &&
        int.tryParse(phoneController.text) != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0A0E21) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.5),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Colors.black.withOpacity(0.7),
                            const Color(0xFF0A0E21).withOpacity(0.9),
                          ]
                        : [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.7),
                          ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            FontAwesomeIcons.phone,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isDark
                                  ? NeonText(
                                      text: "Enter Phone Number",
                                      color: theme.colorScheme.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : Text(
                                      "Enter Phone Number",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                              Text(
                                "Please enter the customer's phone number to start the delivery",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Phone input field with country code
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isValidPhone
                              ? theme.colorScheme.primary.withOpacity(0.5)
                              : theme.colorScheme.error.withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isValidPhone
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.error)
                                .withOpacity(0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Country code
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              border: Border(
                                right: BorderSide(
                                  color: theme.colorScheme.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Text(
                              "+251",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          // Phone number input
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "9XXXXXXXX",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: isDark
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.3),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Validation message
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isValidPhone ? "Valid phone number" : "Please enter a valid 9-digit phone number",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isValidPhone
                              ? theme.colorScheme.primary
                              : theme.colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      children: [
                        // Cancel button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.error.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Continue button
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: isValidPhone ? onContinue : null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: isValidPhone
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.tertiary,
                                        ],
                                      )
                                    : null,
                                color: isValidPhone
                                    ? null
                                    : isDark
                                        ? Colors.grey.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isValidPhone
                                    ? [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.5),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.arrowRight,
                                    color: isValidPhone
                                        ? Colors.white
                                        : isDark
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.black.withOpacity(0.3),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Continue",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isValidPhone
                                          ? Colors.white
                                          : isDark
                                              ? Colors.white.withOpacity(0.3)
                                              : Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Security note
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.shieldHalved,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          size: 12,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "The phone number is used only for delivery purposes and is secured with encryption",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}