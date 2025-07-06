import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();
  
  final _storage = GetStorage();
  final storageKey = 'language_code';
  
  // Observable variables
  final RxString _currentLanguage = 'en'.obs;
  final RxBool _isAmharic = false.obs;
  
  // Getters
  String get currentLanguage => _currentLanguage.value;
  bool get isAmharic => _isAmharic.value;
  
  @override
  void onInit() {
    super.onInit();
    // Load saved language from storage
    String? savedLang = _storage.read<String>(storageKey);
    if (savedLang != null) {
      _currentLanguage.value = savedLang;
      _isAmharic.value = savedLang == 'am';
      updateLocale(savedLang);
    }
  }
  
  // Change language
  void changeLanguage(String langCode) {
    _currentLanguage.value = langCode;
    _isAmharic.value = langCode == 'am';
    _storage.write(storageKey, langCode);
    updateLocale(langCode);
    
    // Close any open dialogs or sheets
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }
  
  // Update app locale
  void updateLocale(String langCode) {
    Get.updateLocale(Locale(langCode));
  }
  
  // Get appropriate font family based on language
  String getFontFamily() {
    return isAmharic ? 'Nyala' : 'Poppins';
  }
  
  // Get appropriate text direction
  TextDirection getTextDirection() {
    return isAmharic ? TextDirection.ltr : TextDirection.ltr; // Amharic is LTR like English
  }
}

