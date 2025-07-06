import 'package:logger/logger.dart';
export 'files.dart';
export 'notifications.dart';
export 'network.dart';
export 'package:image_picker/image_picker.dart';

final logger = Logger(
  printer: PrettyPrinter(
    // methodCount: 5, // Number of method calls to be displayed
    // errorMethodCount: 8, // Number of method calls if stacktrace is provided
    // lineLength: 120, // Width of the output
    colors: true, // Colorful log messages
    printEmojis: true, // Print an emoji for each log message
    dateTimeFormat:
        DateTimeFormat.dateAndTime, // Should each log print contain a timestamp
  ),
);
