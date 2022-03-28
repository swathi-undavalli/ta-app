import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_installer/flutter_app_installer.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:ota_update/ota_update.dart';
import 'package:path_provider/path_provider.dart';

class AutoUpdateView extends StatelessWidget {
  AutoUpdateView({Key key}) : super(key: key);
  static const String id = "AutoUpdateView";

  final AutoUpdateLogic logic = AutoUpdateLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(),
            GetBuilder<AutoUpdateController>(builder: (controller) {
              if (controller.currentEvent != null)
                return Text(
                    'OTA status: ${controller.currentEvent.status} : ${controller.currentEvent.value} \n');
              return SizedBox();
            }),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  logic.checkForUpdate();
                },
                child: Text("Do"),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class AutoUpdateLogic {
  AutoUpdateController controller = Get.put(AutoUpdateController());

  Future<void> tryOtaUpdate() async {
    try {
      //LINK CONTAINS APK OF FLUTTER HELLO WORLD FROM FLUTTER SDK EXAMPLES
      OtaUpdate()
          .execute('https://internal1.4q.sk/flutter_hello_world.apk',
              destinationFilename: 'flutter_hello_world.apk',
              //FOR NOW ANDROID ONLY - ABILITY TO VALIDATE CHECKSUM OF FILE:
              sha256checksum:
                  'd6da28451a1e15cf7a75f2c3f151befad3b80ad0bb232ab15c20897e54f21478')
          .listen((OtaEvent event) {
        controller.currentEvent = event;
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }

  try2() async {
    log("loading");
    final byteData =
        await rootBundle.load('images/assets/flutter_hello_world.apk');
    log("1");
    final buffer = byteData.buffer;
    log("2");
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    log("3");
    var filePath = tempPath + '/app.apk';
    log("writing");
    await File(filePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    log("installing");
    try {
      FlutterAppInstaller.installApk(filePath: filePath);
    } catch (e) {
      log(e);
    }
  }

  @override
  void checkForUpdate() async {
    log("checking");
    try {
      log("started");
      final AppUpdateInfo response = await InAppUpdate.checkForUpdate();

      log(response.toString());
      if (response.updateAvailability == 2) {
        log("update available");
        await InAppUpdate.performImmediateUpdate();
      }
      log("done");
    } catch (e) {
      log("Got an error");
      log(e.toString());
    }
  }
}

class AutoUpdateController extends GetxController {
  OtaEvent _currentEvent;

  OtaEvent get currentEvent => _currentEvent;

  set currentEvent(OtaEvent value) {
    _currentEvent = value;
    update();
  }
}
