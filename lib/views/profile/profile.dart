import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/components/general_components/language_bottom_sheet.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:gibe_market/views/documentation/about_screen.dart';
import 'package:gibe_market/views/documentation/privacy_screen.dart';
import 'package:gibe_market/views/documentation/support_screen.dart';
import 'package:gibe_market/views/documentation/terms_screen.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/views/package/package_list_screen.dart';
import 'package:gibe_market/views/profile/change_password.dart';
import 'package:gibe_market/views/profile/widgets/profile_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final ThemeController _themeController;
  late AnimationController _pulseController;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _themeController = Get.put(ThemeController());
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.grey[50]!, Colors.white, Colors.grey[100]!],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final isDark = _themeController.isDarkMode;

            return Column(
              children: [
                // Header with user profile
                buildUserProfileHeader(theme, isDark, box),

                // Theme Toggle
                buildThemeToggle(theme, isDark),

                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor.withOpacity(0.1),
                          theme.primaryColor,
                          theme.primaryColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Menu items
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          // Main menu section
                          buildSectionHeader("MAIN MENU", theme, isDark),
                          const SizedBox(height: 10),
                          buildMenuItem(
                            icon: FontAwesomeIcons.user,
                            title: "Edit Profile",
                            subtitle: "Update your profile information",
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.to(() => ProfileScreen());  
                            },
                            iconColor: theme.primaryColor,
                            context: context,
                          ),
                          buildMenuItem(
                            icon: FontAwesomeIcons.lock,
                            title: "Change Password",
                            subtitle: "Update your security credentials",
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.to(() => ChangePasswordScreen());
                            },
                            iconColor: theme.colorScheme.secondary,
                            context: context,
                          ),
                          buildMenuItem(
                            icon: FontAwesomeIcons.lock,
                            title: "Package History",
                            subtitle: "Chekc your order",
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.to(() => PackageListScreen(isHomeFrom: true,));
                            },
                            iconColor: theme.colorScheme.secondary,
                            context: context,
                          ),

                          const SizedBox(height: 20),

                          // Support section
                          buildSectionHeader("SUPPORT", theme, isDark),
                          const SizedBox(height: 10),
                          buildMenuItem(
                            icon: FontAwesomeIcons.circleInfo,
                            title: "About",
                            subtitle: "Learn more about the app",
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.to(() => AboutScreen());
                            },
                            iconColor: theme.primaryColor,
                            context: context,
                          ),
                          buildMenuItem(
                            icon: FontAwesomeIcons.fileContract,
                            title: "Privacy Policy",
                            subtitle: "Read our privacy policy",
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // Navigate to privacy policy
                              Get.to(() => PrivacyPolicyScreen());
                            },
                            iconColor: theme.colorScheme.secondary,
                            context: context,
                          ),
                          buildMenuItem(
                            icon: FontAwesomeIcons.fileLines,
                            title: "Terms & Conditions",
                            subtitle: "Read our terms and conditions",
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.to(() => TermsConditionsScreen());
                            },
                            iconColor: theme.colorScheme.tertiary,
                            context: context,
                          ),
                          buildMenuItem(
                            icon: FontAwesomeIcons.headset,
                            title: "Help & Support",
                            subtitle: "Get help and support",
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Get.to(() => SupportScreen());
                            },
                            iconColor: theme.primaryColor,
                            context: context,
                          ),
                          buildMenuItem(
                            icon: FontAwesomeIcons.language,
                            title: 'Language',
                            subtitle: 'Change app language',
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              HapticFeedback.lightImpact();
                                Get.bottomSheet(
                                const LanguageBottomSheet(),
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                              );
                            },
                            iconColor: theme.primaryColor,
                            context: context,
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildLogoutButton(theme, isDark, context),
                ),
                 const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildDeleteButton(
                    theme, isDark, context, box),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
    
    }
