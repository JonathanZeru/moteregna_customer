import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/components/general_components/theme_toggle.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:gibe_market/views/delivery_history/delivery_history.dart';
import 'package:gibe_market/views/documentation/about_screen.dart';
import 'package:gibe_market/views/documentation/privacy_screen.dart';
import 'package:gibe_market/views/documentation/support_screen.dart';
import 'package:gibe_market/views/documentation/terms_screen.dart';
import 'package:gibe_market/views/package/package_list_screen.dart';
import 'package:gibe_market/views/profile/change_password.dart';
import 'package:gibe_market/views/profile/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/glowing_progress_indicator.dart';
import 'package:gibe_market/controllers/language_controller.dart';
import 'package:gibe_market/components/general_components/language_bottom_sheet.dart';

class CyberDrawer extends StatefulWidget {
  final Function()? onProfileTap;
  final Function()? onSettingsTap;
  final Function()? onNotificationsTap;
  final Function()? onPrivacyPolicyTap;
  final Function()? onTermsConditionsTap;
  final Function()? onPackageListTap;
  final Function()? onAboutTap;
  final Function()? onLogoutTap;

  const CyberDrawer({
    Key? key,
    this.onProfileTap,
    this.onSettingsTap,
    this.onNotificationsTap,
    this.onPackageListTap,
    this.onPrivacyPolicyTap,
    this.onTermsConditionsTap,
    this.onAboutTap,
    this.onLogoutTap,
  }) : super(key: key);

  @override
  State<CyberDrawer> createState() => _CyberDrawerState();
}

class _CyberDrawerState extends State<CyberDrawer> with SingleTickerProviderStateMixin {
  late final ThemeController _themeController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _themeController = Get.find<ThemeController>();

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
    return Obx(() {
      final isDark = _themeController.isDarkMode;
      final theme = Theme.of(context);
      final screenSize = MediaQuery.of(context).size;

      return Container(
        width: screenSize.width * 0.85,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            child: Column(
              children: [
                // Header with user profile
                _buildUserProfileHeader(theme, isDark),

                ThemeToggle(),
                // Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
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
                          _buildSectionHeader("main_menu".tr, theme, isDark),
                          const SizedBox(height: 10),

                          _buildMenuItem(
                            icon: FontAwesomeIcons.user,
                            title: "profile".tr,
                            subtitle: "profile_subtitle".tr,
                            theme: theme,
                            isDark: isDark,
                            onTap: (){
                              HapticFeedback.lightImpact();
                              Get.to(() => ProfileScreen());   
                            },
                            iconColor: theme.colorScheme.primary,
                            context: context
                          ),

                          _buildMenuItem(
                            icon: FontAwesomeIcons.moneyBillTransfer,
                            title: "change_password".tr,
                            subtitle: "change_password_subtitle".tr,
                            theme: theme,
                            isDark: isDark,
                            onTap: () => Get.to(() => ChangePasswordScreen()),
                            iconColor: theme.colorScheme.secondary,
                            context: context
                          ),
                          const SizedBox(height: 20),

                          // Support section
                           _buildSectionHeader("support".tr, theme, isDark),
                          const SizedBox(height: 10),


                          _buildMenuItem(
                              icon: FontAwesomeIcons.circleInfo,
                              title: "Package History".tr,
                              subtitle: "Packages".tr,
                              theme: theme,
                              isDark: isDark,
                              onTap: () => Get.to(() => PackageListScreen(isHomeFrom: true,)),
                              iconColor: theme.colorScheme.primary,
                              context: context
                          ),
                          _buildMenuItem(
                            icon: FontAwesomeIcons.circleInfo,
                            title: "about".tr,
                            subtitle: "about_subtitle".tr,
                            theme: theme,
                            isDark: isDark,
                            onTap: () => Get.to(() => AboutScreen()),
                            iconColor: theme.colorScheme.primary,
                            context: context
                          ),

                          _buildMenuItem(
                            icon: FontAwesomeIcons.fileContract,
                            title: "privacy_policy".tr,
                            subtitle: "privacy_policy_subtitle".tr,
                            theme: theme,
                            isDark: isDark,
                            onTap: () => Get.to(() => PrivacyPolicyScreen()),
                            iconColor: theme.colorScheme.secondary,
                            context: context
                          ),

                          _buildMenuItem(
                            icon: FontAwesomeIcons.fileLines,
                            title: "terms_conditions".tr,
                            subtitle: "terms_conditions_subtitle".tr,
                            theme: theme,
                            isDark: isDark,
                            onTap: () => Get.to(() => TermsConditionsScreen()),
                            iconColor: theme.colorScheme.tertiary,
                            context: context
                          ),

                          _buildMenuItem(
                            icon: FontAwesomeIcons.headset,
                            title: "help_support".tr,
                            subtitle: "help_support_subtitle".tr,
                            theme: theme,
                            isDark: isDark,
                            onTap: () => Get.to(() => SupportScreen()),
                            iconColor: theme.colorScheme.primary,
                            context: context
                          ),



                          _buildMenuItem(
                            icon: FontAwesomeIcons.language,
                            title: 'language'.tr,
                            subtitle: 'language_subtitle'.tr,
                            theme: theme,
                            isDark: isDark,
                            onTap: () {
                              // Show language selection bottom sheet
                              Get.bottomSheet(
                                const LanguageBottomSheet(),
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                              );
                            },
                            iconColor: theme.colorScheme.primary,
                            context: context
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),

                // Logout button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildLogoutButton(theme, isDark, context)
                )
              ]
            )
          )
        )
      );
    });
  }

  Widget _buildUserProfileHeader(ThemeData theme, bool isDark, ) {
    // Fetch data from storage
    
  final box = GetStorage(); // Access GetStorage

    final userData = box.read('customerData');
    final accessToken = box.read('accessToken');

    if (userData == null) {
      return Center(child: CircularProgressIndicator());
    }

    // Extract data from the stored userData
    final String userName = '${userData['firstName']} ${userData['lastName']}';
    final String userPhone = userData['phone']?.toString() ?? 'No phone available';
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.3),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Icon(
                  FontAwesomeIcons.xmark,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          isDark
              ? NeonText(
                  text: userName.toUpperCase(),
                  color: theme.colorScheme.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )
              : Text(
                  userName.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    letterSpacing: 1,
                  ),
                ),

          const SizedBox(height: 5),

          // User phone
          Text(
            userPhone,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : Colors.black.withOpacity(0.7),
            ),
          ),

        ],
      ),
    );
  }
}


  Widget _buildSectionHeader(String title, ThemeData theme, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark
                ? Colors.white.withOpacity(0.7)
                : Colors.black.withOpacity(0.7),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeData theme,
    required bool isDark,
    required Function()? onTap,
    required Color iconColor,
    bool showBadge = false,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: CyberCard(
        isDark: isDark,
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context);
            if (onTap != null) {
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon with container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: iconColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 16,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
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
    );
  }

  Widget _buildLogoutButton(ThemeData theme, bool isDark, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
        ConfigPreference.clear();
          HapticFeedback.mediumImpact();
          Navigator.pop(context);
          Get.offAllNamed<void>('/signIn');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? Colors.red.shade900.withOpacity(0.8)
              : Colors.red.shade400.withOpacity(0.8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: isDark ? 8 : 4,
          shadowColor: Colors.red.withOpacity(isDark ? 0.5 : 0.3),
        ),
        icon: const Icon(FontAwesomeIcons.rightFromBracket),
        label: Text(
          "logout".tr,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 500));
  }
