import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/views/splash.dart';
import 'package:gibe_market/controllers/initial_controller.dart';

import 'package:get/get.dart';
import 'package:gibe_market/controllers/motorist_controller.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late final PageController pageController;
  @override
  void initState() {
    handleInitial();
    // TODO: implement initState
    pageController = PageController();
    super.initState();
  }
  void handleInitial() async {

    if (ConfigPreference.isFirstLaunch()) {
      await ConfigPreference.markAppLaunched();
      await _showSplashScreens();
      Get.offAllNamed('/signIn');
    } else if (ConfigPreference.getAccessToken() == null) {
      Get.offAllNamed('/signIn');
    } else {
      Get.lazyPut<MotoristController>(() => MotoristController(), fenix: true);
    Get.offAllNamed('/home');
    }
  }
    Future<void> _showSplashScreens() async {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 4));
      if (pageController.hasClients && i < 2) {
        await pageController.animateToPage(
          i + 1,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutExpo,
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<InitialController>(
        init: InitialController(),
        builder: (controller) {
          return PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SplashScreen(
                key: const ValueKey('splash1'),
                animationPath: 'assets/splash_one.json',
                duration: 4
              ),
              SplashScreen(
                key: const ValueKey('splash2'),
                animationPath: 'assets/splash_three.json',
                duration: 4
              ),
              SplashScreen(
                key: const ValueKey('splash3'),
                animationPath: 'assets/splash_two.json',
                duration: 4
              ),
            ],
          );
        },
      ),
    );
  }
}