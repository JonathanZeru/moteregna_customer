import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gibe_market/views/home/widget/cyber_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'online_switch.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
void _openDrawer() {
  HapticFeedback.mediumImpact();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return CyberDrawer(
        onProfileTap: () {
          // Navigate to profile screen
          print("Navigate to profile");
        },
        onSettingsTap: () {
          // Navigate to settings screen
          print("Navigate to settings");
        },
        onNotificationsTap: () {
          // Navigate to notifications screen
          print("Navigate to notifications");
        },
        onPrivacyPolicyTap: () {
          // Navigate to privacy policy screen
          print("Navigate to privacy policy");
        },
        onTermsConditionsTap: () {
          // Navigate to terms and conditions screen
          print("Navigate to terms and conditions");
        },
        onAboutTap: () {
          // Navigate to about screen
          print("Navigate to about");
        },
        onLogoutTap: () {
          // Handle logout
          print("Logout");
        },
      );
    },
  );
}
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 10,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.white.withOpacity(0.2),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Drawer menu button
                GestureDetector(
                  onTap: _openDrawer, // Add drawer logic
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
                      FontAwesomeIcons.bars,
                      color: theme.colorScheme.primary,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Logo
                const _Logo(),
                const SizedBox(width: 15),

                // App name and status
                const _AppStatus(),
                const SizedBox(width: 10),

                // Online/Offline switch
                OnlineSwitch(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: "app_name".tr,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            FontAwesomeIcons.motorcycle,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _AppStatus extends StatelessWidget {
  const _AppStatus();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "app_name".tr,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Text(
            "ready_to_deliver".tr,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark
                  ? Colors.white.withOpacity(0.7)
                  : Colors.black.withOpacity(0.7),
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}


