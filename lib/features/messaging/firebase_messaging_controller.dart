import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../../core/services/notification_service.dart';
import '../bookings/models/booking_model.dart';

class FirebaseMessagingLogic {
  FirebaseMessagingLogic() {
    configureFirebaseListeners();
  }

  configureFirebaseListeners() {
    ///completely terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {}
    });

    ///app is open
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {}
      LocalNotificationService.display(message);
    });

    ///app is in Background

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  }
}

class NotificationsLogic {
  NotificationController controller = Get.put(NotificationController());
}

class NotificationController extends GetxController {
  Booking? bookingModel;
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    update();
  }
}
