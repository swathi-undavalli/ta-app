import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/repository/employee_repo.dart';
import 'package:temple_adventures/core/services/auto-update.dart';
import 'package:temple_adventures/features/login/presentation/screens/login-page.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);
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
    log("in splash screen");
    await Future.delayed(Duration(microseconds: 500));

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAllNamed(LoginScreen.id);
      } else {
        await EmployeeRepo.synchronise();
        AutoUpdateLogic autoUpdateLogic = AutoUpdateLogic();
        await autoUpdateLogic.checkForUpdate();
      }
    } catch (e) {
      print(e);
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
