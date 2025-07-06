import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gibe_market/controllers/signup_controller.dart';
import 'package:gibe_market/views/home/widget/animated_button.dart';
import 'package:gibe_market/views/home/widget/neon_text.dart';
import 'package:gibe_market/views/sign_up/widget/futuristic_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountInfoStep extends GetView<SignUpController> {
  final ThemeData theme;
  final bool isDark;

  const AccountInfoStep({required this.theme, required this.isDark, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.shieldHalved,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              const SizedBox(width: 10),
              isDark
                  ? NeonText(
                      text: "account_credentials".tr,
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  : Text(
                      "account_credentials".tr,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
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
          Text(
            "account_credentials_subtitle".tr,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 20),
          Obx(() => FuturisticTextField(
            controller: controller.passwordController,
            hintText: "password".tr,
            prefixIcon: FontAwesomeIcons.lock,
            isPassword: true,
            obscureText: controller.obscurePassword.value,
            onTogglePasswordVisibility: controller.togglePasswordVisibility,
            isDark: isDark,
            theme: theme,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Password is required'.tr;
              }
              if (value.trim().length < 8) {
                return 'Password must be at least 8 characters long'.tr;
              }
              return null;
            },
          )),
          const SizedBox(height: 16),
          Obx(() => FuturisticTextField(
            controller: controller.confirmPasswordController,
            hintText: "confirm_password".tr,
            prefixIcon: FontAwesomeIcons.lockOpen,
            isPassword: true,
            obscureText: controller.obscurePassword.value,
            onTogglePasswordVisibility: controller.togglePasswordVisibility,
            isDark: isDark,
            theme: theme,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Confirm password is required'.tr;
              }
              if (value.trim() != controller.passwordController.text.trim()) {
                return 'Passwords do not match'.tr;
              }
              return null;
            },
          ))
        ],
      ),
    );
  }
}

