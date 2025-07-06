import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gibe_market/controllers/language_controller.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();
    
    return GetBuilder<ThemeController>(
      builder: (themeCtrl) {
        final isDark = themeCtrl.isDarkMode;
        final theme = Theme.of(context);
        
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0A0E21) : const Color(0xFFE8F0FE),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.3)
                      : Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.language,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  isDark
                      ? NeonText(
                          text: 'select_language'.tr,
                          color: theme.colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )
                      : Text(
                          'select_language'.tr,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Language options
              Obx(() => Column(
                children: [
                  // English option
                  _buildLanguageOption(
                    languageCode: 'en',
                    languageName: 'English',
                    nativeName: 'English',
                    flagEmoji: '🇺🇸',
                    isSelected: languageController.currentLanguage == 'en',
                    onTap: () => languageController.changeLanguage('en'),
                    theme: theme,
                    isDark: isDark,
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Amharic option
                  _buildLanguageOption(
                    languageCode: 'am',
                    languageName: 'Amharic',
                    nativeName: 'አማርኛ',
                    flagEmoji: '🇪🇹',
                    isSelected: languageController.currentLanguage == 'am',
                    onTap: () => languageController.changeLanguage('am'),
                    theme: theme,
                    isDark: isDark,
                  ),
                ],
              )),
              
              const SizedBox(height: 20),
            ],
          ),
        ).animate().slideY(
          begin: 1.0,
          end: 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      },
    );
  }
  
  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
    required String nativeName,
    required String flagEmoji,
    required bool isSelected,
    required Function() onTap,
    required ThemeData theme,
    required bool isDark,
  }) {
    return CyberCard(
      isDark: isDark,
      padding: EdgeInsets.zero,
      borderColor: isSelected
          ? theme.colorScheme.primary.withOpacity(0.7)
          : (isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1)),
      backgroundColor: isSelected
          ? (isDark
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.primary.withOpacity(0.05))
          : null,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: theme.colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Flag emoji
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    flagEmoji,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Language name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      languageName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      nativeName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDark
                            ? Colors.white.withOpacity(0.7)
                            : Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Selected indicator
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(isDark ? 0.5 : 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

