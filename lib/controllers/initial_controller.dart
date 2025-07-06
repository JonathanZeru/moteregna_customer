
import 'package:get/get.dart';
import 'package:gibe_market/controllers/motorist_controller.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:flutter/widgets.dart';

class InitialController extends GetxController {
  late final PageController pageController;
  RxBool isFirstLaunch = true.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    // _checkFirstLaunch();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Future<void> _checkFirstLaunch() async {
  //   isFirstLaunch.value = ConfigPreference.isFirstLaunch();

  //   if (isFirstLaunch.value) {
  //     await ConfigPreference.markAppLaunched();
  //     await _showSplashScreens();
  //     Get.offAllNamed('/signIn');
  //   } else if (ConfigPreference.getAccessToken() == null) {
  //     Get.offAllNamed('/signIn');
  //   } else {
  //     Get.lazyPut<MotoristController>(() => MotoristController(), fenix: true);
  //     Get.offAllNamed('/home');
  //   }
  // }

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
}