import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LottieOverlay extends StatelessWidget {
  final bool isLoading;
  final bool isDark;
  final AnimationController fadeController;

  const LottieOverlay({
    required this.isLoading,
    required this.isDark,
    required this.fadeController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeController,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0 - fadeController.value,
          child: Container(
            color: isDark
                ? Colors.black.withOpacity(0.7)
                : Colors.white.withOpacity(0.7),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Lottie.asset(
                      "assets/loading.json",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    isLoading ? "finding_location".tr : "processing".tr,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please wait a moment",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.white.withOpacity(0.7)
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}