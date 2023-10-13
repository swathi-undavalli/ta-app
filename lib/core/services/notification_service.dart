import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/messaging/notification-screen.dart';
import 'package:temple_adventures/features/messaging/notification_service.dart';

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
