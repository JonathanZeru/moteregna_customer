import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:gibe_market/controllers/theme_controller.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final controller = ValueNotifier<bool>(themeController.isDarkMode);

    controller.addListener(() {
      themeController.toggleTheme();
    });

    return Tooltip(
      message: controller.value ? "Dark Mode" : "Light Mode",
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: controller.value
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: controller.value ? Colors.orange.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wb_sunny,
              color: controller.value ? Colors.grey : Colors.orange,
              size: 16,
            ),
            const SizedBox(width: 5),
            AdvancedSwitch(
              controller: controller,
              activeColor: Colors.orange,
              inactiveColor: Colors.grey,
              width: 40,
              height: 20,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.nightlight_round,
              color: controller.value ? Colors.orange : Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}