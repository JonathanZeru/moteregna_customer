import 'package:gibe_market/utils/storages.dart';
import 'package:gibe_market/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> initialize() async {
  await Hive.initFlutter();
  await Hive.openBox<TokenPair>(authTokenStorage);
  Hive.registerAdapter<TokenPair>(TokenPairTypeAdapter());

  logger.i('Initilizing The application');
}

Future<void> preStartTasks() async {}
