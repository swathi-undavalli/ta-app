import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../core/authentication/firebase_authentication.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/services/auto_update.dart';
import '../../dashboard/presentation/views/dashboard_view.dart';
import '../../employees/repository/employee_repo.dart';
import '../../login/presentation/views/login_view.dart';

String lastLoginTime = 'lastLoginTime';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const SplashView(),
      );

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
      AutoUpdateLogic autoUpdateLogic = AutoUpdateLogic();
      bool updateRequired = false;
      if (mounted) {
        updateRequired = await autoUpdateLogic.updateRequired();
      }

      if (updateRequired) {
        if (mounted) Navigator.pushReplacement(context, AutoUpdateView.route());
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;
      //login expired
      if (user == null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            LoginView.route(),
            (Route<dynamic> route) => false,
          );
        }
      }

      //login not expired
      else {
        final prefs = await SharedPreferences.getInstance();
        DateTime? lastLogin = DateTime.tryParse(prefs.getString(lastLoginTime) ?? '');
        //check expiry
        if ((lastLogin?.difference(DateTime.now()).inDays ?? 16) > 15) {
          await FirebaseAuthentication.logout();
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              LoginView.route(),
              (Route<dynamic> route) => false,
            );
          }
          return;
        }

        await EmployeeRepo.synchronise();

        if (mounted) Navigator.pushReplacement(context, DashBoardView.route());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      body: Container(
        width: Screen.width,
        height: Screen.height,
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
