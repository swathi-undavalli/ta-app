import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/repository/employee_repo.dart';
import '../../../core/services/auto_update.dart';
import '../../../core/util/app_measurements.dart';
import '../../login/presentation/screens/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id = 'SplashScreen';

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
    await Future.delayed(const Duration(microseconds: 500));

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
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppMeasures.init(context);
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,

      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
              AppImages.icons.appLogo,
            ),
          ),
        ),
      ),
    );
  }
}
