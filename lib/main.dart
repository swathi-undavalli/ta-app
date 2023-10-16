import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/services/auto-update.dart';
import 'package:temple_adventures/features/Marketing/views/marketing-view.dart';
import 'package:temple_adventures/features/all-bookings/presentation/screens/all-bookings-screen.dart';
import 'package:temple_adventures/features/board-plan/presentation/views/board-plan-view.dart';
import 'package:temple_adventures/features/boat/presentation/screens/manage-boats-page.dart';
import 'package:temple_adventures/features/boat/presentation/screens/manage-general-info.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add-payments-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/edit-payments-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/payment-details-screen.dart';
import 'package:temple_adventures/features/dashboard/presentation/screens/dashboard-screen.dart';
import 'package:temple_adventures/features/edit-booking/presentation/screens/edit-booking-new-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/add-an-employee-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import 'package:temple_adventures/features/events/views/events-view.dart';
import 'package:temple_adventures/features/logs/presentation/screens/details-screen.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import 'package:temple_adventures/features/messaging/firebase_messaging_controller.dart';
import 'package:temple_adventures/features/messaging/notification-screen.dart';
import 'package:temple_adventures/features/messaging/notification_service.dart';
import 'package:temple_adventures/features/splash/view/splash-screen.dart';
import 'package:temple_adventures/features/welcome/presentation/screens/welome-page.dart';
import 'features/activities/presentation/screens/activity-edit-screen.dart';
import 'features/activities/presentation/screens/add-new-activity-screen.dart';
import 'features/activities/presentation/screens/all-activities-screen.dart';
import 'features/conditions/screens/add-conditions-screen.dart';
import 'features/dashboard/controller/dashboard-controller.dart';
import 'features/dive-checklist/views/screens/dive-checklist-view.dart';
import 'features/employees/presentation/screens/employee-details-screen.dart';
import 'features/employees/presentation/screens/employee-profile-screen.dart';
import 'features/login/presentation/screens/login-page.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("called onBackgroundMessage");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    LocalNotificationService.initialize();
  } catch (e) {
    print("error starting notification listener");
  }
  if (Platform.isIOS) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAJFHDoc1lfQtTRtEpRmCJue2kwfB5jUh8",
            appId: "1:671883511961:ios:99961ae0cf633ff7b05008",
            messagingSenderId: "671883511961",
            iosClientId: "671883511961-m5tbun1ohi774cfkrd2f15m2l6s4j6tg.apps.googleusercontent.com",
            projectId: "seismic-glow-283418"));
  } else {
    await Firebase.initializeApp();
  }

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  ///app is open
  FirebaseMessaging.onMessage.listen((message) {
    FirebaseNotificationService.handleNavigation(message);
    LocalNotificationService.display(message);
  });

  ///app is in Background
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("called onMessageOpenedApp");
    FirebaseNotificationService.handleNavigation(message);
  });

  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessagingLogic();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("building MyApp");
    Get.put(DashBoardScreenController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      theme: ThemeData(
        textTheme: TextTheme(
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
      routes: {
        AllActivitiesScreen.id: (context) => AllActivitiesScreen(),
        AddNewActivityScreen.id: (context) => AddNewActivityScreen(),
        ActivityEditScreen.id: (context) => ActivityEditScreen(),
        AllBookingsScreen.id: (context) => AllBookingsScreen(),
        BookingScreen.id: (context) => BookingScreen(),
        PaymentDetailsScreen.id: (context) => PaymentDetailsScreen(),
        BookDateTime.id: (context) => BookDateTime(),
        NewBookingScreen.id: (context) => NewBookingScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        EditBookingNewScreen.id: (context) => EditBookingNewScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        DashBoardScreen.id: (context) => DashBoardScreen(),
        AddAnEmployeeScreen.id: (context) => AddAnEmployeeScreen(),
        AddCustomerDetailsScreen.id: (context) => AddCustomerDetailsScreen(),
        AllEmployeesScreen.id: (context) => AllEmployeesScreen(),
        LogScreen.id: (context) => LogScreen(),
        EmployeeProfileScreen.id: (context) => EmployeeProfileScreen(),
        EmployeeDetailsScreen.id: (context) => EmployeeDetailsScreen(),
        AutoUpdateView.id: (context) => AutoUpdateView(),
        AddPaymentsScreen.id: (context) => AddPaymentsScreen(),
        EditPaymentsScreen.id: (context) => EditPaymentsScreen(),
        NotificationsScreen.id: (context) => NotificationsScreen(),
        DetailsScreen.id: (context) => DetailsScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        AddConditionsScreen.id: (context) => AddConditionsScreen(),
        ManageBoatsPage.id: (context) => ManageBoatsPage(),
        ManageGeneralInfo.id: (context) => ManageGeneralInfo(),
        BoardPlanView.id: (context) => BoardPlanView(),
        DiveChecklistView.id: (context) => DiveChecklistView(),
        MarketingView.id: (context) => MarketingView(),
        EventsView.id: (context) => EventsView(),
      },
    );
  }
}

class FirebaseNotificationService {
  static handleNavigation(RemoteMessage message) {
    Get.toNamed(NotificationsScreen.id, arguments: message);
    LocalNotificationService.display(message);
  }

  static handleTerminatedNavigation() async {
    RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      Get.toNamed(NotificationsScreen.id, arguments: message);
      LocalNotificationService.display(message);
    }
  }

  static backgroundHandler(RemoteMessage message) {}
}
