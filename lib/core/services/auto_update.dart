import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:temple_ui_tools/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../main.dart';
import '../authentication/firebase_authentication.dart';
import '../widgets/app_button.dart';

class AutoUpdateView extends StatelessWidget {
  bool firstRun = true;

  AutoUpdateView({Key? key}) : super(key: key);

  final AutoUpdateLogic logic = AutoUpdateLogic();

  static Route route() => MaterialPageRoute(
        builder: (context) => AutoUpdateView(),
      );

  @override
  Widget build(BuildContext context) {
    String latestIosVersion = '${logic.controller.iosVersionNumber}';
    String currentAndroidVersion = '${logic.controller.version}+${logic.controller.buildNumber}';
    String latestAndroidVersion = '${logic.controller.latestVersionNumber}';

    logout();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            if (!logic.controller.criticalUpdate!)
              Container(
                width: Screen.width,
                alignment: Alignment.topRight,
                child: AppButton.miniFlat(
                  text: 'Skip',
                  textColor: Colors.white,
                  onTap: () async {
                    Navigator.pushReplacement(context, DashBoardView.route());
                  },
                ),
              ).paddingOnly(right: 20),
            const SizedBox(height: 50),
            SizedBox(
              height: 150,
              child: Image.asset(
                'images/AppLogoPondy.png',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Update !!!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: SizedBox(
                width: 300,
                child: Text(
                  'An New Update has been available for the app. Please download and install it.',
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Current version : ${(isIos) ? currentIosVersion : currentAndroidVersion}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Latest version : ${(isIos) ? latestIosVersion : latestAndroidVersion}',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            if (isIos)
              const Text(
                'Please install the latest update from the TestFlight App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.bold,
                ),
              )
            else
              AppButton.flat(
                text: 'Update',
                color: Colors.black,
                textColor: Colors.white,
                onTap: () async {
                  logic.openLink();
                },
              ),
          ],
        ),
      ),
    );
  }

  void logout() {
    if (!firstRun) {
      return;
    }
    firstRun = false;
    if (logic.controller.criticalUpdate == true && logic.controller.forceLogout == true) {
      FirebaseAuthentication.logout();
    }
  }
}

class AutoUpdateLogic {
  AutoUpdateController controller = Get.put(AutoUpdateController());

  openLink() async {
    try {
      Uri? uri = Uri.tryParse(controller.downloadLink ?? '');
      if (uri != null) {
        await launchUrl(uri);
      }
    } catch (e) {
      Get.defaultDialog(
        title: '\nError Occured',
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        middleText: '\n\nError occurred while auto-update. Please contact developer.\n\n',
        middleTextStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        radius: 10,
      );
    }
  }

  Future<bool> updateRequired() async {
    var data = await FirebaseFirestore.instance.collection('ota_update').doc('version').get();

    controller.latestVersionNumber = data.data()!['number'];
    controller.downloadLink = data.data()!['downloadLink'];
    controller.criticalUpdate = data.data()!['critical_update'];
    controller.iosVersionNumber = data.data()!['iosNumber'];
    controller.forceLogout = data.data()!['force_logout'];

    if (isIos) {
      if (currentIosVersion != controller.iosVersionNumber) {
        return true;
      }
      return false;
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    controller.version = packageInfo.version;
    controller.buildNumber = packageInfo.buildNumber;

    if (controller.latestVersionNumber != '${controller.version!}+${controller.buildNumber!}') {
      return true;
    } else {
      return false;
    }
  }
}

class AutoUpdateController extends GetxController {
  String? latestVersionNumber, version, buildNumber, downloadLink, iosVersionNumber;

  bool? criticalUpdate = false;
  bool? forceLogout = false;
}
