import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/auto-update.dart';
import 'package:temple_adventures/core/authentication/firebase-authentication.dart';
import 'package:temple_adventures/features/login/presentation/screens/login-page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);
  static const String id = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await Future.delayed(Duration(microseconds: 500));

    if (FirebaseAuthentication.isUserLoggedIn()) {
      AutoUpdateLogic autoUpdateLogic = AutoUpdateLogic();
      autoUpdateLogic.checkForUpdate();
    } else {
      Get.toNamed(LoginScreen.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
              "images/AppLogoPondy.png",
            ),
          ),
        ),
      ),
    );
  }
}
