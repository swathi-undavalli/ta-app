import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/messaging/notification_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  static handleNavigation(RemoteMessage message) {
    Get.toNamed(NotificationsScreen.id, arguments: message);
    LocalNotificationService.display(message);
  }

  static handleTerminatedNavigation() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      Get.toNamed(NotificationsScreen.id, arguments: message);
      LocalNotificationService.display(message);
    }
  }

  static backgroundHandler(RemoteMessage message) {}
}

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize() async {
    var androidInitilize =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    //New Added
    DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationsSettings = InitializationSettings(
        android: androidInitilize, iOS: initializationSettingsIOS);
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    await _notificationsPlugin.initialize(
      initializationsSettings,
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "easyapproach",
            "easyapproach channel",
            channelDescription: "this is our channel",
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(''),
          ));

      await _notificationsPlugin.show(
        id,
        message.notification?.title ?? "",
        message.notification?.body ?? "",
        notificationDetails,
      );
    } catch (e) {
    }
  }
}