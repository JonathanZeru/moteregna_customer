import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gibe_market/components/general_components/language_bottom_sheet.dart';
import 'package:gibe_market/controllers/language_controller.dart';
import 'package:gibe_market/controllers/signup_controller.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/views/home/widget/animated_button.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/views/sign_up/widget/account_info_step.dart';
import 'package:gibe_market/views/sign_up/widget/personal_info_step.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();
    final controller = Get.find<SignUpController>();

    return Obx(() {
      final isDark = themeController.isDarkMode;
      final theme = Theme.of(context);

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isDark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.white.withOpacity(0.3),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                FontAwesomeIcons.arrowLeft,
                color: theme.colorScheme.primary,
                size: 16,
              ),
            ),
            onPressed: () => Get.back(),
          ),
          title:
              isDark
                  ? NeonText(
                    text: "sign_up".tr,
                    color: theme.colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                  : Text(
                    "sign_up".tr,
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: 1.5,
                    ),
                  ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.white.withOpacity(0.3),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  FontAwesomeIcons.language,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                Get.bottomSheet(
                  const LanguageBottomSheet(),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 8.0),
            //   child: ThemeToggle(),
            // ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors:
                  isDark
                      ? [
                        const Color(0xFF0A0E21),
                        const Color(0xFF0F1642),
                        const Color(0xFF0A0E21).withOpacity(0.9),
                      ]
                      : [
                        const Color(0xFFE8F0FE),
                        const Color(0xFFF8F9FA),
                        const Color(0xFFE8F0FE).withOpacity(0.9),
                      ],
            ),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: CyberCard(
                        isDark: isDark,
                        padding: const EdgeInsets.all(24),
                        borderRadius: 20,
                        borderColor: theme.colorScheme.primary.withOpacity(0.5),
                        backgroundColor:
                            isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.3),
                        child: PersonalInfoStep(
                          theme: theme,
                          isDark: isDark,
                          context: context,
                        ),
                      ),
                    ),
                    AnimatedButton(
                      width: 140,
                      height: 50,
                      isActive: true,
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (controller.validateStep(
                          controller.currentStep.value,
                        )) {
                          controller.handleSignUp();
                        }
                      },
                      startText: "submit".tr,
                      stopText: "submit".tr,
                      startIcon: FontAwesomeIcons.check,
                      stopIcon: FontAwesomeIcons.check,
                      startColor: theme.colorScheme.primary,
                      stopColor: theme.colorScheme.primary,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
