import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/messaging/notification_service.dart';

class FirebaseMessagingLogic {
  FirebaseMessagingController controller =
      Get.put(FirebaseMessagingController());

  FirebaseMessagingLogic() {
    // getToken();
    configureFirebaseListeners();
  }

  // getToken() async {
  //   // firebaseMessaging.getToken().then((deviceToken) {
  //   //   //print("Device Token : $deviceToken");
  //   // });
  //   var deviceToken = await FirebaseMessaging.instance.getToken();
  //   //log("DeviceToken : $deviceToken");
  // }

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

class FirebaseMessagingController extends GetxController {}
