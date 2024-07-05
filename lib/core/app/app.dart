import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/splash/view/splash_view.dart';
import '../constants/constants.dart';
import 'package:temple_adventures/core/app/providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DashBoardScreenController());
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: AppFonts.nunito),
          displayMedium: TextStyle(fontFamily: AppFonts.nunito),
          displaySmall: TextStyle(fontFamily: AppFonts.nunito),
          headlineMedium: TextStyle(fontFamily: AppFonts.nunito),
          headlineSmall: TextStyle(fontFamily: AppFonts.nunito),
          titleLarge: TextStyle(fontFamily: AppFonts.nunito),
          titleMedium: TextStyle(fontFamily: AppFonts.nunito),
          titleSmall: TextStyle(fontFamily: AppFonts.nunito),
          bodyLarge: TextStyle(fontFamily: AppFonts.nunito),
          bodyMedium: TextStyle(fontFamily: AppFonts.nunito),
          bodySmall: TextStyle(fontFamily: AppFonts.nunito),
          labelLarge: TextStyle(fontFamily: AppFonts.nunito),
          labelSmall: TextStyle(fontFamily: AppFonts.nunito),
        ),
      ),
    );
  }
}
