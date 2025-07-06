import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/components/themes.dart';
import 'package:gibe_market/controllers/auth_controller.dart';
import 'package:gibe_market/controllers/theme_controller.dart';
import 'package:gibe_market/controllers/language_controller.dart';
import 'package:gibe_market/firebase_options.dart';
import 'package:gibe_market/utils/app_routes.dart';
import 'package:gibe_market/utils/bindings.dart';
import 'package:gibe_market/utils/firebase_service.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:gibe_market/utils/translations/app_translations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  await ConfigPreference.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Service
  await FirebaseService().init();
  runApp(const MyApp());
  // For device preview (uncomment when needed)
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     builder: (context) => const MyApp(),
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final bool isFirstLaunch = ConfigPreference.isFirstLaunch();
        final String? token = ConfigPreference.getAccessToken();

        final String initialRoute = isFirstLaunch
            ? AppRoutes.initial
            : token == null
                ? AppRoutes.signIn
                : AppRoutes.mainScreen;

        return GetBuilder<ThemeController>(
          builder: (themeController) {
            return GetBuilder<LanguageController>(
              builder: (languageController) {
                return GetMaterialApp(
                  navigatorKey: navigatorKey, // Important for navigation from notifications
                  initialBinding: AppBindings(),
                  title: 'Moteregna Customer',
                  debugShowCheckedModeBanner: false,
                  
                  // Localization setup
                  translations: AppTranslations(),
                  locale: Locale(languageController.currentLanguage),
                  fallbackLocale: const Locale('am'),
                  
                  // Theme setup
                  theme: AppTheme.lightTheme(context),
                  darkTheme: AppTheme.darkTheme(context),
                  themeMode: ThemeMode.light,
                  
                  // Routing
                  getPages: AppRoutes.pages,
                  initialRoute: initialRoute,
                  unknownRoute: GetPage(
                    name: '/not-found',
                    page: () => Scaffold(
                      appBar: AppBar(title: Text('Not Found')),
                      body: Center(child: Text('Page not found')),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _initializeApp() async {
    Get.put(LanguageController());
    Get.put(ThemeController());
    Get.put(AuthController());
  }
}