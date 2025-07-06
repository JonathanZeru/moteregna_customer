import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'localization_manager.dart'; // For RxBool (if you're using GetX)
import 'package:json_annotation/json_annotation.dart';
part 'storages.g.dart';

const authTokenStorage = 'auth_token_storage';

@JsonSerializable()
class Token {
  final DateTime iss;
  final DateTime exp;
  final String token;

  Token({required this.token, required this.iss, required this.exp});

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
  bool isExpired() {
    return DateTime.now().isAfter(exp);
  }
}

@JsonSerializable()
class TokenPair {
  final Token access;
  final Token refresh;
  TokenPair({required this.access, required this.refresh});
  Map<String, dynamic> toJson() => _$TokenPairToJson(this);
  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}

abstract class AuthStorage {
  Future<TokenPair?> readTokens();
  Future<void> writeTokens(TokenPair pair);
  Future<void> clear();
  void listen(void Function(BoxEvent) boxEvenHandler);
}

class HiveAuthStorage extends AuthStorage {
  @override
  Future<TokenPair?> readTokens() async {
    final box = Hive.box<TokenPair>(authTokenStorage);
    return box.get(authTokenStorage);
  }

  @override
  Future<void> writeTokens(TokenPair pair) {
    final box = Hive.box<TokenPair>(authTokenStorage);
    return box.put(authTokenStorage, pair);
  }

  @override
  void listen(void Function(BoxEvent event) boxEvenHandler) {
    final box = Hive.box<TokenPair>(authTokenStorage);
    box.watch(key: authTokenStorage).listen(boxEvenHandler);
  }

  @override
  Future<void> clear() {
    final box = Hive.box<TokenPair>(authTokenStorage);
    return box.delete(authTokenStorage);
  }
}

class TokenPairTypeAdapter implements TypeAdapter<TokenPair> {
  @override
  read(BinaryReader reader) {
    final json = reader.read() as Map<String, dynamic>;
    return TokenPair.fromJson(json);
  }

  @override
  int get typeId => 10;

  @override
  void write(BinaryWriter writer, obj) {
    writer.write(obj.toJson());
  }
}

class ConfigPreference {
  // Prevent instantiation
  ConfigPreference._();

  static const String _preferencesBox = 'preferences';
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _isFirstLaunchKey = 'is_first_launch';
  static const String _accessTokenKey = 'access_token';

  static RxBool hasConnection = true.obs;

  // Initialize Hive
  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);
    await Hive.openBox<dynamic>(_preferencesBox);
  }

  // Get Hive box
  static Box<dynamic> _getBox() {
    return Hive.box(_preferencesBox);
  }

  // Set theme to light/dark
  static Future<void> setThemeIsLight(bool lightTheme) async {
    await _getBox().put(_lightThemeKey, lightTheme);
  }

  // Get current theme (light or dark)
  static bool getThemeIsLight() {
    return _getBox().get(_lightThemeKey, defaultValue: true) as bool;
  }

  // Save current language
  static Future<void> setCurrentLanguage(String languageCode) async {
    await _getBox().put(_currentLocalKey, languageCode);
  }

  // Get current language
  static Locale getCurrentLocal() {
    String? langCode = _getBox().get(_currentLocalKey) as String?;
    return langCode == null
        ? LocalizationManager.defaultLanguage
        : LocalizationManager.supportedLanguages[langCode]!;
  }

  // Check if it's the first launch
  static bool isFirstLaunch() {
    return _getBox().get(_isFirstLaunchKey, defaultValue: true) as bool;
  }

  // Mark the app as launched
  static Future<void> markAppLaunched() async {
    await _getBox().put(_isFirstLaunchKey, false);
  }

  // Store access token
  static Future<void> storeAccessToken(String accessToken) async {
    await _getBox().put(_accessTokenKey, accessToken);
  }

  // Get access token
  static String? getAccessToken() {
    return _getBox().get(_accessTokenKey) as String?;
  }

  // Clear all stored data
  static Future<void> clear() async {
    await _getBox().clear();
  }
}
