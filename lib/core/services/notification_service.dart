import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../features/messaging/notification_screen.dart';

class FirebaseNotificationService {
  static handleNavigation(RemoteMessage message) {
    if (Get.context != null) {
      Navigator.push(Get.context!, NotificationsScreen.route(message));
    }
    LocalNotificationService.display(message);
  }

  static handleTerminatedNavigation() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      if (Get.context != null) {
        Navigator.push(Get.context!, NotificationsScreen.route(message));
      }
      LocalNotificationService.display(message);
    }
  }

  static backgroundHandler(RemoteMessage message) {}
}

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() async {
    var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
    //New Added
    DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: initializationSettingsIOS,
    );
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    await _notificationsPlugin.initialize(
      initializationsSettings,
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'easyapproach',
          'easyapproach channel',
          channelDescription: 'this is our channel',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(''),
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        notificationDetails,
      );
    } catch (e) {}
  }
}
