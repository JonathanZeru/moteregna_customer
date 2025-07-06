import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isOnline = true;
  
  ThemeMode get themeMode => _themeMode;
  bool get isOnline => _isOnline;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  // Initialize from shared preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeMode = prefs.getString('theme_mode');
    final savedOnlineStatus = prefs.getBool('is_online');
    
    if (savedThemeMode != null) {
      _themeMode = savedThemeMode == 'dark' 
          ? ThemeMode.dark 
          : savedThemeMode == 'light' 
              ? ThemeMode.light 
              : ThemeMode.system;
    }
    
    if (savedOnlineStatus != null) {
      _isOnline = savedOnlineStatus;
    }
    
    notifyListeners();
  }
  
  // Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
    
    notifyListeners();
  }
  
  // Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode', 
      mode == ThemeMode.dark 
          ? 'dark' 
          : mode == ThemeMode.light 
              ? 'light' 
              : 'system'
    );
    
    notifyListeners();
  }
  
  // Toggle online status
  Future<void> toggleOnlineStatus() async {
    _isOnline = !_isOnline;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_online', _isOnline);
    
    notifyListeners();
  }
  
  // Set specific online status
  Future<void> setOnlineStatus(bool status) async {
    _isOnline = status;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_online', status);
    
    notifyListeners();
  }
}

