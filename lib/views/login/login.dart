import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gibe_market/components/general_components/language_bottom_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gibe_market/controllers/login_controller.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/controllers/language_controller.dart';
import 'package:gibe_market/views/home/widget/animated_button.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/components/general_components/theme_toggle.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the theme controller to check dark/light mode
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();
    
    return Obx(() {
      final isDark = themeController.isDarkMode;
      final theme = Theme.of(context);
      final screenSize = MediaQuery.of(context).size;
      
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
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
            child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenSize.height - MediaQuery.of(context).padding.vertical,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Logo animation
                              Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withOpacity(isDark ? 0.5 : 0.3),
                                        blurRadius: 20,
                                        spreadRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      child: Image.asset(
                                        "assets/moteregna-logo.png",
                                      )
                                    )
                                  ),
                                ).animate().fadeIn(duration: 600.ms).scale(
                                  begin: const Offset(0.5, 0.5),
                                  end: const Offset(1.0, 1.0),
                                  duration: 600.ms,
                                  curve: Curves.easeOutBack,
                                ),
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // App name
                              Center(
                                child: isDark
                                    ? NeonText(
                                        text: 'app_name'.tr,
                                        color: theme.colorScheme.primary,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        textAlign: TextAlign.center,
                                        glowIntensity: 0.8,
                                      )
                                    : Text(
                                        'app_name'.tr,
                                        style: GoogleFonts.orbitron(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                          letterSpacing: 2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                              ).animate().fadeIn(delay: 300.ms).slideY(
                                begin: -0.2,
                                end: 0,
                                delay: 300.ms,
                                duration: 500.ms,
                                curve: Curves.easeOutCubic,
                              ),
                              
                              const SizedBox(height: 10),
                              
                              // Tagline
                              Center(
                                child: Text(
                                  'Customer App'.tr,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.black.withOpacity(0.7),
                                    letterSpacing: 4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ).animate().fadeIn(delay: 500.ms).slideY(
                                begin: -0.2,
                                end: 0,
                                delay: 500.ms,
                                duration: 500.ms,
                                curve: Curves.easeOutCubic,
                              ),
                              
                              const SizedBox(height: 50),
                              
                              // Login form card
                              CyberCard(
                                isDark: isDark,
                                padding: const EdgeInsets.all(24),
                                borderRadius: 20,
                                borderColor: theme.colorScheme.primary.withOpacity(0.5),
                                backgroundColor: isDark
                                    ? Colors.black.withOpacity(0.3)
                                    : Colors.white.withOpacity(0.3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Login header
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children:[
                                            Icon(
                                              FontAwesomeIcons.rightToBracket,
                                              color: theme.colorScheme.primary,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 10),
                                            isDark
                                                ? NeonText(
                                                    text: 'login'.tr,
                                                    color: theme.colorScheme.primary,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  )
                                                : Text(
                                                    'login'.tr,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: theme.colorScheme.primary,
                                                    ),
                                                  )
                                          ]
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            HapticFeedback.selectionClick();
                                            Get.bottomSheet(
                                              const LanguageBottomSheet(),
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                            );
                                          },
                                          child: _buildLanguageToggle(context, isDark, theme, languageController))
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 1,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary.withOpacity(0.1),
                                            theme.colorScheme.primary,
                                            theme.colorScheme.primary.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    
                                    // Phone number field
                                    _buildTextField(
                                      controller: controller.emailController,
                                      hintText: 'phone_number'.tr,
                                      prefixIcon: FontAwesomeIcons.mobileScreen,
                                      keyboardType: TextInputType.phone,
                                      isDark: isDark,
                                      theme: theme,
                                    ),
                                    const SizedBox(height: 20),
                                    
                                    // Password field
                                    Obx(() => _buildTextField(
                                      controller: controller.passwordController,
                                      hintText: 'password'.tr,
                                      prefixIcon: FontAwesomeIcons.lock,
                                      isPassword: true,
                                      obscureText: controller.obscurePassword.value,
                                      onTogglePasswordVisibility: controller.togglePasswordVisibility,
                                      isDark: isDark,
                                      theme: theme,
                                    )),
                                    
                                    const SizedBox(height: 15),
                                    
                                    // Forgot password
                                    // Align(
                                    //   alignment: Alignment.centerRight,
                                    //   child: GestureDetector(
                                    //     onTap: () {
                                    //       // Handle forgot password
                                    //       HapticFeedback.lightImpact();
                                    //     },
                                    //     child: Text(
                                    //       'forgot_password'.tr,
                                    //       style: GoogleFonts.poppins(
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.w500,
                                    //         color: theme.colorScheme.secondary,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    
                                    const SizedBox(height: 30),
                                    
                                    // Login button
                                    Obx(() => AnimatedButton(
                                      width: double.infinity,
                                      height: 65,
                                      isActive: false,
                                      isLoading: controller.isLoading.value,
                                      onPressed: controller.handleLogin,
                                      startText: 'login'.tr,
                                      stopText: 'login'.tr,
                                      startIcon: FontAwesomeIcons.rightToBracket,
                                      stopIcon: FontAwesomeIcons.rightToBracket,
                                      startColor: theme.colorScheme.primary,
                                      stopColor: theme.colorScheme.primary,
                                      isDark: isDark,
                                    )),
                                  ],
                                ),
                              ).animate().fadeIn(delay: 700.ms).slideY(
                                begin: 0.2,
                                end: 0,
                                delay: 700.ms,
                                duration: 500.ms,
                                curve: Curves.easeOutCubic,
                              ),
                              
                              const SizedBox(height: 30),
                              
                              // Sign up section - Wrapped in Material to ensure proper touch detection
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    print("Navigate to sign up");
                                    Get.toNamed('/signUp');
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'new_to_app'.tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: isDark
                                                ? Colors.white.withOpacity(0.7)
                                                : Colors.black.withOpacity(0.7),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'sign_up'.tr,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.secondary,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(delay: 900.ms),
                              
                              const SizedBox(height: 20),
                              
                              // Terms and conditions
                              Text(
                                'terms_and_conditions'.tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.5)
                                      : Colors.black.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(delay: 1000.ms),
                              const SizedBox(height: 30)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            // child: Stack(
            //   children: [
            //     // Background animated pattern
            //     Positioned.fill(
            //       child: Lottie.asset(
            //         'assets/loading.json',
            //         fit: BoxFit.cover,
            //       )
            //     ),
                
            //     // Main content
                
                
            //     // Bottom decoration
            //     Positioned(
            //       bottom: 0,
            //       left: 0,
            //       right: 0,
            //       child: Container(
            //         height: 100,
            //         decoration: BoxDecoration(
            //           gradient: LinearGradient(
            //             begin: Alignment.topCenter,
            //             end: Alignment.bottomCenter,
            //             colors: [
            //               Colors.transparent,
            //               theme.colorScheme.primary.withOpacity(isDark ? 0.3 : 0.1),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ),
      );
    });
  }
  
  Widget _buildLanguageToggle(BuildContext context, bool isDark, ThemeData theme, LanguageController languageController) {
    return Obx(() {
      final isAmharic = languageController.isAmharic;
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              isAmharic ? 'አማርኛ' : 'English',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              FontAwesomeIcons.language,
              color: theme.colorScheme.primary,
              size: 14,
            ),
          ],
        ),
      );
    });
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePasswordVisibility,
    TextInputType? keyboardType,
    required bool isDark,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.2)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            keyboardType: keyboardType,
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
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 1
                )
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.primaryColor,
                  width: 1
                )
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}