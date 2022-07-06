import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ota_update/ota_update.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'notification-screen.dart';

class AutoUpdateView extends StatelessWidget {
  AutoUpdateView({Key key}) : super(key: key);
  static const String id = "AutoUpdateView";

  final AutoUpdateLogic logic = AutoUpdateLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              child: Image.asset(
                "images/AppLogoPondy.png",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Update !!!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 300,
                child: Text(
                  "An New Update has been available for the app. Please download and install it.",
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Current version : ${logic.controller.version}+${logic.controller.buildNumber}",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Latest version : ${logic.controller.latestVersionNumber}",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            AppButton.flat(
              text: "Update",
              color: Colors.black,
              textColor: Colors.white,
              onTap: () async {
                logic.openLink();
              },
            )
          ],
        ),
      ),
    );
  }
}

class AutoUpdateLogic {
  AutoUpdateController controller = Get.put(AutoUpdateController());

  openLink() async {
    try {
      await launch(controller.downloadLink);
    } catch (e) {
      Get.defaultDialog(
        title: "\nError Occured",
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        middleText:
            "\n\nError occurred while auto-update. Please contact developer.\n\n",
        middleTextStyle: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        radius: 10,
      );
    }
  }

  checkForUpdate() async {
    ///completely terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.notification != null) {
        Get.toNamed(NotificationsScreen.id, arguments: message);
      }
    });

    var data = await FirebaseFirestore.instance
        .collection("ota_update")
        .doc("version")
        .get();
    controller.latestVersionNumber = data.data()["number"];
    controller.downloadLink = data.data()["downloadLink"];

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    controller.version = packageInfo.version;
    controller.buildNumber = packageInfo.buildNumber;

    if (controller.latestVersionNumber !=
        controller.version + "+" + controller.buildNumber) {
      Get.offAllNamed(AutoUpdateView.id);
    }
  }

  // Future<void> tryOtaUpdate() async {
  //   try {
  //     //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
  //     OtaUpdate()
  //         .execute('https://internal1.4q.sk/flutter_hello_world.apk',
  //             destinationFilename: 'flutter_hello_world.apk',
  //             //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
  //             sha256checksum:
  //                 'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478')
  //         .listen((OtaEvent event) {
  //       controller.currentEvent = event;
  //     });
  //     // ignore: avoid_catches_without_on_clauses
  //   } catch (e) {
  //     //print('Failed to make OTA update. Details: $e');
  //   }
  // }
  //
  // try2() async {
  //   //log("loading");
  //   final byteData =
  //       await rootBundle.load('images/assets/flutter_hello_world.apk');
  //   //log("1");
  //   final buffer = byteData.buffer;
  //   //log("2");
  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   //log("3");
  //   var filePath = tempPath + '/app.apk';
  //   //log("writing");
  //   await File(filePath).writeAsBytes(
  //       buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   //log("installing");
  //   try {
  //     FlutterAppInstaller.installApk(filePath: filePath);
  //   } catch (e) {
  //     //log(e);
  //   }
  // }
  //
  // @override
  // void checkForUpdate() async {
  //   //log("checking");
  //   try {
  //     //log("started");
  //     final AppUpdateInfo response = await InAppUpdate.checkForUpdate();
  //
  //     //log(response.toString());
  //     if (response.updateAvailability == 2) {
  //       //log("update available");
  //       await InAppUpdate.performImmediateUpdate();
  //     }
  //     //log("done");
  //   } catch (e) {
  //     //log("Got an error");
  //     //log(e.toString());
  //   }
  // }
}

class AutoUpdateController extends GetxController {
  String latestVersionNumber, version, buildNumber, downloadLink;

  OtaEvent _currentEvent;

  OtaEvent get currentEvent => _currentEvent;

  set currentEvent(OtaEvent value) {
    _currentEvent = value;
    update();
  }
}
