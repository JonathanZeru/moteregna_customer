import 'package:get/get.dart';
import 'package:gibe_market/controllers/auth_controller.dart';
import 'package:gibe_market/controllers/initial_controller.dart';
import 'package:gibe_market/controllers/drawer_controller.dart';
import 'package:gibe_market/controllers/login_controller.dart';
import 'package:gibe_market/controllers/signup_controller.dart';
import 'package:gibe_market/controllers/theme_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Ensure InitialController is always available
    Get.put<InitialController>(InitialController(), permanent: true);
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.put<SignUpController>(SignUpController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);

    Get.lazyPut<DrawerController>(() => DrawerController(), fenix: true);
  }
}
