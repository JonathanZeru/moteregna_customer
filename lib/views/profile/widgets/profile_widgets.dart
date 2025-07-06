import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/components/general_components/language_bottom_sheet.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/utils/config.dart' show apiBaseUrl;
import 'package:gibe_market/utils/storages.dart';
import 'package:gibe_market/views/documentation/about_screen.dart';
import 'package:gibe_market/views/documentation/privacy_screen.dart';
import 'package:gibe_market/views/documentation/support_screen.dart';
import 'package:gibe_market/views/documentation/terms_screen.dart';
import 'package:gibe_market/views/home/widget/cyber_card.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/views/package/package_list_screen.dart';
import 'package:gibe_market/views/profile/change_password.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

Widget buildUserProfileHeader(ThemeData theme, bool isDark, GetStorage box) {
    final Map<String, dynamic>? userData = box.read('userData');
    final Map<String, dynamic>? motorData = box.read('motorData');

    if (userData == null || motorData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (userData == null || motorData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final String userName = userData['name'] ?? '';
    final String userPhone = userData['phone'] ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Profile Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.primaryColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 47,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, size: 50, color: theme.primaryColor),
            ),
          ),

          const SizedBox(height: 16),

          NeonText(
            text: userName.toUpperCase(),
            color: theme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 5),

          // User phone
          Text(
            userPhone,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: theme.primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildThemeToggle(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CyberCard(
        isDark: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Dark Mode',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            Switch(
              value: isDark,
              onChanged: (value) {
              },
              activeColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

/// Make it public (remove the underscore if needed)
Widget buildSectionHeader(String title, ThemeData theme, bool isDark) {
  return Row(
    children: [
      Container(
        width: 4,
        height: 16,
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: GoogleFonts.orbitron(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: theme.primaryColor.withOpacity(0.7),
          letterSpacing: 1,
        ),
      ),
    ],
  );
}

  Widget buildMenuItem({
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
        isDark: false,
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            if (onTap != null) {
              onTap();
            }
          },
          borderRadius: BorderRadius.circular(16),
          splashColor: theme.primaryColor.withOpacity(0.1),
          highlightColor: theme.primaryColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon with container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: iconColor.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Center(child: Icon(icon, color: iconColor, size: 16)),
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
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: theme.primaryColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow icon
                Icon(Icons.arrow_forward_ios, color: iconColor, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogoutButton(
    ThemeData theme,
    bool isDark,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () async {
          HapticFeedback.selectionClick();
          HapticFeedback.mediumImpact();
          await ConfigPreference.clear();
          await GetStorage().remove('customer');
          await GetStorage().remove('token');
          Get.offAllNamed<void>('/signIn');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 4,
          shadowColor: Colors.red.withOpacity(0.3),
        ),
        icon: const Icon(FontAwesomeIcons.rightFromBracket),
        label: Text(
          "LOGOUT",
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    ).animate().fadeIn().slideY(
      begin: 0.2,
      end: 0,
      delay: const Duration(milliseconds: 500),
    );
  }

Widget buildDeleteButton(
  ThemeData theme,
  bool isDark,
  BuildContext context,
  GetStorage box
) {
  bool isLoading = false;
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton.icon(
      onPressed: isLoading == true ? null : () async {
        HapticFeedback.selectionClick();
        HapticFeedback.mediumImpact();

        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
              'Are you sure you want to delete your account?\n\nAll your data will be permanently deleted.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async{
                   final response = await http.delete(
        Uri.parse('$apiBaseUrl/customer/delete/${box.read('customer')['id']}'),
      );
      if(response.statusCode == 200) {
          // Successfully deleted account 
                      HapticFeedback.selectionClick();
          HapticFeedback.mediumImpact();
          await ConfigPreference.clear();
          await GetStorage().remove('customer');
          await GetStorage().remove('token');
          Get.offAllNamed<void>('/signIn');
          }else{
       Get.snackbar(
        'Error',
        'Problem deleting account. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
          }
                },
                child: isLoading == true ? 
                CircularProgressIndicator() : const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          // Proceed with deletion
          await ConfigPreference.clear();
          await GetStorage().remove('customer');
          await GetStorage().remove('token');
          Get.offAllNamed<void>('/signIn');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 4,
        shadowColor: Colors.red.withOpacity(0.3),
      ),
      icon: const Icon(FontAwesomeIcons.rightFromBracket),
      label: Text(
        "DELETE ACCOUNT",
        style: GoogleFonts.orbitron(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    ),
  ).animate().fadeIn().slideY(
        begin: 0.2,
        end: 0,
        delay: const Duration(milliseconds: 500),
      );
}
