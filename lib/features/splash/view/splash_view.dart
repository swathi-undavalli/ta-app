import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/authentication/firebase_authentication.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/repository/employee_repo.dart';
import '../../../core/services/auto_update.dart';
import '../../../core/util/app_measurements.dart';
import '../../login/presentation/views/login_view.dart';

String lastLoginTime = 'lastLoginTime';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);
  static const String id = 'SplashScreen';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
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
        Get.offAllNamed(LoginView.id);
      } else {
        final prefs = await SharedPreferences.getInstance();
        DateTime? lastLogin = DateTime.tryParse(prefs.getString(lastLoginTime) ?? '');
        if ((lastLogin?.difference(DateTime.now()).inDays ?? 16) > 15) {
          FirebaseAuthentication.logout();
          Get.offAllNamed(LoginView.id);
          return;
        }
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
