import 'dart:async'; 
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gibe_market/main.dart';
import 'package:gibe_market/utils/app_routes.dart';
import 'package:gibe_market/utils/config.dart';
import 'package:gibe_market/utils/storages.dart';
import 'package:gibe_market/views/home/notification_screen.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:get/get.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();
  final box = GetStorage();
  // Notification channel configuration for high priority notifications
  final _androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important delivery notifications.',
    importance: Importance.max,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('notification_sound'),
    vibrationPattern: Int64List.fromList([0, 500, 500, 500]),
    enableVibration: true,
    showBadge: true,
    enableLights: true,
    audioAttributesUsage: AudioAttributesUsage.notification,
    ledColor: Colors.redAccent
  );

  Future<void> init() async {
    try {
      // Request notification permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initLocalNotifications();

      // Set up message handlers
      await _setupMessageHandlers();

      // Get and log FCM token
      await _logFcmToken();

    } catch (e) {
      _logger.e("FirebaseService initialization error: $e");
    }
  }

  Future<void> _requestPermissions() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        try {
          if (details.payload != null) {
            final message = RemoteMessage.fromMap(jsonDecode(details.payload!) as Map<String, dynamic>);
            _handleNotification(message);
          }
        } catch (e) {
          _logger.e("Notification response error: $e");
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
    await platform?.requestNotificationsPermission();
  }

  Future<void> _setupMessageHandlers() async {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((message) {
      _logger.i("Foreground message received");
      _handleNotification(message);
      _showFullScreenNotification(message);
    });

    // Message opened from background state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotification);

    // Initial message when app is launched from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotification(initialMessage);
    }
  }

  Future<void> _logFcmToken() async {
    final token = await _firebaseMessaging.getToken();
    _logger.i("FCM Token: $token");
    if (ConfigPreference.getAccessToken() != null) {
      await registerFCMToken(token ?? "");
    }
  }
 Future<void> _showFullScreenNotification(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;

  final androidDetails = AndroidNotificationDetails(
    _androidChannel.id,
    _androidChannel.name,
    channelDescription: _androidChannel.description,
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true, // This brings app to foreground when locked
    playSound: true,
    enableVibration: true,
    icon: '@mipmap/launcher_icon',
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    vibrationPattern: Int64List.fromList([0, 500, 500, 500]),
    // Add these for better behavior when unlocked
    visibility: NotificationVisibility.public,
    // category: 'call', // Or 'message' depending on your use case
    timeoutAfter: 5000, // Auto-dismiss after 5 seconds if not interacted with
    actions: [
      AndroidNotificationAction(
        'open_app',
        'Open App',
        showsUserInterface: true,
        cancelNotification: true,
      ),
    ],
    color: Colors.red,
    category: AndroidNotificationCategory.call,
    colorized: true,
    channelShowBadge: true,
    styleInformation: BigTextStyleInformation(
      notification.body ?? '',
      contentTitle: notification.title,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    ),
    audioAttributesUsage: AudioAttributesUsage.notification,
    channelAction: AndroidNotificationChannelAction.update,
    

  );

  final platformDetails = NotificationDetails(android: androidDetails);

  // Show as heads-up notification when unlocked
  await _localNotifications.show(
    notification.hashCode,
    notification.title,
    notification.body,
    platformDetails,
    payload: jsonEncode(message.toMap()),
  );

  // Additional trigger to ensure app opens
  _handleNotification(message);
}
  void _handleNotification(RemoteMessage message) {
    _logger.i("Handling notification with data: ${message.data}");

    // Extract delivery data from notification
    final deliveryData = message.data;
    _navigateToHomeWithDeliveryData(deliveryData);
  }

  void _navigateToHomeWithDeliveryData(Map<String, dynamic> deliveryData) async {
    print("Navigating to package details screen");
    // Using GetX navigation
    if (Get.isDialogOpen == true) Get.back();
    if (Get.isBottomSheetOpen == true) Get.back();
    print("Navigating to home screen");
    // main();
 // Ensure the app is brought to foreground
  try {
    // For Android - bring to foreground
    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    // await androidPlugin?.requestPermission();

    // Use platform-specific code to bring app to foreground
    // if (Platform.isAndroid) {
    //   const methodChannel = MethodChannel('com.moteregna/notifications');
    //   await methodChannel.invokeMethod('bringToForeground');
    // }
print("Navigate to home screen with delivery data: $deliveryData");
     // Ensure the navigator key is available
     print("Navigator key state: ${navigatorKey.currentState}");
    //  if (navigatorKey.currentState == null) {
    //    _logger.w("Navigator state is null, cannot navigate");
    //    return;
    //  }

     // Clear any existing dialogs or bottom sheets
     if (Get.isDialogOpen == true) Get.back();
     if (Get.isBottomSheetOpen == true) Get.back();
    // Navigate to desired screen
     WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentState != null) {
          if (Get.isDialogOpen == true) Get.back();
          if (Get.isBottomSheetOpen == true) Get.back();
          
          Navigator.pushReplacement(
            navigatorKey.currentState!.context,
            MaterialPageRoute(
              builder: (context) => NotificationDeliveryScreen(
                notificationData: deliveryData,
              ),
            ),
          );
          // MaterialPageRoute(
          //   builder: (context) => NotificationDeliveryScreen(
          //     notificationData: deliveryData
          //   ),
          // );
          // Pass delivery data as arguments
          // navigatorKey.currentState?.pushNamedAndRemoveUntil(
          //   AppRoutes.notificationDeliveryScreen,
          //   (route) => false,
          //   arguments: deliveryData,
          // );
        }
      });
  } catch (e) {
    _logger.e("Error handling notification: $e");
  }
  }

  Future<String> getFCMToken() async {
    return await _firebaseMessaging.getToken() ?? "";
  }

   Future<void> registerFCMToken(String fcmToken) async {
    final Map<String, dynamic>? motorData = box.read('customerData');

    if (motorData == null) {
      _logger.w("No motor data found in storage");
      return;
    }

    final motorId = motorData['id'];
    if (motorId == null) {
      _logger.w("Motor ID not found in motor data");
      return;
    }

    try {
      final body = {
        "fcmToken": fcmToken,
        "customerId": motorId,
      };
      print(body);

      final response = await http.post(
        Uri.parse('$apiBaseUrl/customer/fcmToken'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ConfigPreference.getAccessToken()}',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        _logger.i("FCM token registered successfully");
      } else {
        _logger.e("Failed to register FCM token: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Error registering FCM token: $e");
    }
    }

  
}
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final service = FirebaseService();
  await service.init();
  
  // This will trigger the navigation when the app comes to foreground
  service._handleNotification(message);
  
  // Show the notification
  await service._showFullScreenNotification(message);
}

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   final service = FirebaseService();
//   await service.init();
//   service._handleNotification(message);
//   await service._showFullScreenNotification(message);
// }