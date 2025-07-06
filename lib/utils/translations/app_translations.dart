import 'package:get/get.dart';
import 'package:gibe_market/utils/translations/en.dart';
import 'package:gibe_market/utils/translations/am.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': enTranslations,
    'am': amTranslations,
  };
}

