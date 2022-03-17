import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebaseMessagingLogic {
  FirebaseMessagingController controller =
      Get.put(FirebaseMessagingController());

  FirebaseMessagingLogic() {
    getToken();
    configureFirebaseListeners();
  }

  getToken() async {
    // firebaseMessaging.getToken().then((deviceToken) {
    //   print("Device Token : $deviceToken");
    // });
    var deviceToken = await FirebaseMessaging.instance.getToken();
    log("DeviceToken : $deviceToken");
  }

  configureFirebaseListeners() {
    ///app is open

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Hello mawa notification ochinda");
      log("onMessage data: ${message}");
    });

    ///completely terminated

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) async {
      log('onLaunch data: ${message}');
    });

    ///app is in Background

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('onMessageOpenedApp data:${message}');
    });
  }
}

class FirebaseMessagingController extends GetxController {}
