import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'core/app/app.dart';
import 'core/services/notification_service.dart';
import 'features/messaging/firebase_messaging_controller.dart';

String currentIosVersion = '1.1.3+42';

bool get isIos => Platform.isIOS;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    LocalNotificationService.initialize();
  } catch (e) {
    if (kDebugMode) {
      print('error starting notification listener');
    }
  }
  if (isIos) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAJFHDoc1lfQtTRtEpRmCJue2kwfB5jUh8',
        appId: '1:671883511961:ios:99961ae0cf633ff7b05008',
        messagingSenderId: '671883511961',
        iosClientId:
            '671883511961-m5tbun1ohi774cfkrd2f15m2l6s4j6tg.apps.googleusercontent.com',
        projectId: 'seismic-glow-283418',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  ///app is open
  FirebaseMessaging.onMessage.listen((message) {
    FirebaseNotificationService.handleNavigation(message);
    LocalNotificationService.display(message);
  });

  ///app is in Background
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    FirebaseNotificationService.handleNavigation(message);
  });

  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessagingLogic();

  runApp(const MyApp());
}
