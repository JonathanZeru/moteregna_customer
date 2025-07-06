import 'package:get/get.dart';
import 'package:gibe_market/controllers/initial_controller.dart';
import 'package:gibe_market/controllers/login_controller.dart';
import 'package:gibe_market/controllers/signup_controller.dart';
import 'package:gibe_market/views/home/home.dart';
import 'package:gibe_market/views/initial.dart';
import 'package:gibe_market/views/login/login.dart';
import 'package:gibe_market/views/main_screen.dart';
import 'package:gibe_market/views/sign_up/sign_up.dart';
import 'package:gibe_market/views/splash.dart';

import '../views/package/package_list_screen.dart';

class AppRoutes {
  AppRoutes._(); // Private constructor
  
  // Route names
  static const String initial = '/initial';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String mainScreen = '/mainScreen';
  static const String packageList = '/packageList';
  // Route pages
  static final List<GetPage> pages = [
    GetPage(
      name: initial, 
      page: () => const InitialScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<InitialController>(() => InitialController());
      }),
    ),
    GetPage(
      name: signIn, 
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
    GetPage(
      name: signUp, 
      page: () => SignUpScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SignUpController>(() => SignUpController());
      }),
    ),
    GetPage(
      name: mainScreen, 
      page: () => MainScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SignUpController>(() => SignUpController());
      }),
    ),
    GetPage(
      name: home, 
      page: () => CreatePackageScreen(),
    ),
    GetPage(
      name: packageList,
      page: () => PackageListScreen(isHomeFrom: false,),
    ),

  ];
}