import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUploadField extends StatelessWidget {
  final String title;
  final IconData icon;
  final Rx<File?> imageFile;
  final VoidCallback onTap;
  final bool isDark;
  final ThemeData theme;

  const ImageUploadField({
    required this.title,
    required this.icon,
    required this.imageFile,
    required this.onTap,
    required this.isDark,
    required this.theme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasImage = imageFile.value != null;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasImage
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0.3),
              width: hasImage ? 2 : 1,
            ),
            boxShadow: hasImage
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(isDark ? 0.5 : 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        if (hasImage)
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.xmark,
                              color: theme.colorScheme.error,
                              size: 16,
                            ),
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              imageFile.value = null;
                            },
                          ),
                      ],
                    ),
                  ),
                  if (hasImage)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageFile.value!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white.withOpacity(0.1),
                        border: Border(
                          top: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.fileUpload,
                            color: theme.colorScheme.primary.withOpacity(0.5),
                            size: 32,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Tap to upload",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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
    });
  }
}