import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:temple_adventures/features/messaging/notification_service.dart';

class FirebaseMessagingLogic {
  FirebaseMessagingLogic() {
    configureFirebaseListeners();
  }


  configureFirebaseListeners() {

    ///completely terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
      }
    });

    ///app is open
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
      }
      LocalNotificationService.display(message);
    });

    ///app is in Background

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
    });
  }
}