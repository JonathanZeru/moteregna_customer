import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
 
  final _box = GetStorage();
  final _key = 'isDarkMode';

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
    _loadOnlineStatusFromStorage();
  }

  void _loadThemeFromStorage() {
    final savedTheme = _box.read(_key);
    if (savedTheme != null) {
      _themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleTheme() {
    _themeMode.value = _themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _box.write(_key, _themeMode.value == ThemeMode.dark ? 'dark' : 'light');
  }

 
 
  final _onlineKey = 'isOnline';

  // Observable variables
  final RxBool _isOnline = true.obs;

  // Getters
  bool get isOnline => _isOnline.value;

  // Load saved online status from storage
  void _loadOnlineStatusFromStorage() {
    final savedOnlineStatus = _box.read(_onlineKey);
    if (savedOnlineStatus != null) {
      _isOnline.value = savedOnlineStatus as bool;
    }
  }
  // Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _saveThemeToStorage();
    update(); // Notify listeners
  }

  // Save theme to storage
  void _saveThemeToStorage() {
    _box.write(_key, _themeMode.value == ThemeMode.dark 
        ? 'dark' 
        : _themeMode.value == ThemeMode.light 
            ? 'light' 
            : 'system');
  }

  // Toggle online status
  void toggleOnlineStatus() {
    _isOnline.value = !_isOnline.value;
    _saveOnlineStatusToStorage();
    update(); // Notify listeners
  }

  // Set specific online status
  void setOnlineStatus(bool status) {
    _isOnline.value = status;
    _saveOnlineStatusToStorage();
    update(); // Notify listeners
  }

  // Save online status to storage
  void _saveOnlineStatusToStorage() {
    _box.write(_onlineKey, _isOnline.value);
  }
}
