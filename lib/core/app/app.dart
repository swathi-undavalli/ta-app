import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/equipment/Repository/equipment.repository.dart';
import '../../features/equipment/models/timestamp_mapper.dart';
import '../../features/equipment/provider/equipment.provider.dart';
import '../../features/maps/providers/maps_provider.dart';
import '../../features/maps/repository/maps_repo.dart';
import '../../features/splash/view/splash_view.dart';
import '../constants/constants.dart';
import '../services/location_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

    //For firebase Timestamp.
    MapperContainer.globals.use(TimestampMapper());
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EquipmentProvider(EquipmentRepository()),
        ),
        ChangeNotifierProvider<MapsProvider>(
          create: (_) => MapsProvider(
            mapsRepository: MapsRepository(),
            locationService: LocationService(),
          ),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
        theme: ThemeData(
          useMaterial3: false,
          brightness: Brightness.light,
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
      ),
    );
  }
}
