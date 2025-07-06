import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:gibe_market/utils/translations/am.dart';
import 'package:gibe_market/utils/translations/en.dart';
import 'package:gibe_market/utils/translations/om.dart';
import 'package:gibe_market/utils/translations/ti.dart';

class LocalizationManager extends Translations {
  // Prevent creating instance
  LocalizationManager._();

  static LocalizationManager? _instance;

  static LocalizationManager getInstance() {
    _instance ??= LocalizationManager._();
    return _instance!;
  }

  // Default language
  static Locale defaultLanguage = supportedLanguages['en']!;

  // Supported languages
  static Map<String, Locale> supportedLanguages = {
    'en': const Locale('en', 'US'),
    'am': const Locale('am'),
    'om': const Locale('en', 'AU'),
    'ti': const Locale('en', 'GB'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
    // 'en_US': englishLocalization,
    // 'am': amharicLocalization,
    // 'en_AU': oromifaLocalization,
    // 'en_GB': tigrinyanLocalization,
  };

  /// Check if the language is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.keys.contains(languageCode);
  }

  /// Update app language by language code (e.g., 'en', 'am', etc.)
  static Future<void> updateLanguage(String languageCode) async {
    // Check if the language is supported
    if (!isLanguageSupported(languageCode)) return;

    // Update current language in shared preferences
    await ConfigPreference.setCurrentLanguage(languageCode);

    // Update the app locale
    Get.updateLocale(supportedLanguages[languageCode]!);
  }

  /// Get current locale
  static Locale getCurrentLocal() => ConfigPreference.getCurrentLocal();
}
