import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:temple_adventures/D/d.dart';
import 'package:temple_adventures/auto-update.dart';
import 'package:temple_adventures/core/authentication/firebase-authentication.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/Activities/presentation/screens/activity-edit-screen.dart';
import 'package:temple_adventures/features/Activities/presentation/screens/add-new-activity-screen.dart';
import 'package:temple_adventures/features/all-bookings/presentation/screens/all-bookings-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-customer-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/customer-registration-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/paper_work_screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/payment-details-screen.dart';
import 'package:temple_adventures/features/compressor/presentation/compressor.dart';
import 'package:temple_adventures/features/dashboard/presentation/screens/dashboard-screen.dart';
import 'package:temple_adventures/features/edit-booking/presentation/screens/edit-booking-new-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/add-an-employee-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import 'package:temple_adventures/features/attendance/attendance-page.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import 'package:temple_adventures/features/messaging/firebase_messaging_controller.dart';
import 'package:temple_adventures/features/messaging/notification_service.dart';
import 'package:temple_adventures/features/welcome/presentation/screens/welome-page.dart';
import 'features/Activities/presentation/screens/all-activities-screen.dart';
import 'features/dashboard/controller/dashboard-controller.dart';
import 'features/employees/presentation/screens/employee-details-screen.dart';
import 'features/employees/presentation/screens/employee-profile-screen.dart';
import 'features/login/presentation/screens/login-page.dart';

// final FlutterLocalNotificationsPlugin notificationsPlugin =
//     FlutterLocalNotificationsPlugin();
//
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   importance: Importance.high,
//   playSound: true,
// );

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  ///completely terminated
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      log('onLaunch data: ${message}');
    }
  });

  ///app is open
  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification != null) {
      log("Hello mawa notification ochindi");
      log("onMessage data: ${message.notification.body}");
    }
    LocalNotificationService.display(message);
  });

  ///app is in Background

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('onMessageOpenedApp data:${message.data}');
  });

  // var data = notificationsPlugin.resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>();
  //
  // if (data != null) data.createNotificationChannel(channel);
  //
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // await FirebaseMessaging.instance.subscribeToTopic('admin');

  // FirebaseMessaging.onBackgroundMessage(
  //   (_) {
  //     print("message");
  //     return ;
  //   },
  // );

  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.white,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessagingLogic();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser == null);
    Get.put(DashBoardScreenController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuthentication.isUserLoggedIn()
          ? DashBoardScreen.id
          : LoginScreen.id,
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: AppFonts.nunito),
          headline2: TextStyle(fontFamily: AppFonts.nunito),
          headline3: TextStyle(fontFamily: AppFonts.nunito),
          headline4: TextStyle(fontFamily: AppFonts.nunito),
          headline5: TextStyle(fontFamily: AppFonts.nunito),
          headline6: TextStyle(fontFamily: AppFonts.nunito),
          subtitle1: TextStyle(fontFamily: AppFonts.nunito),
          subtitle2: TextStyle(fontFamily: AppFonts.nunito),
          bodyText1: TextStyle(fontFamily: AppFonts.nunito),
          bodyText2: TextStyle(fontFamily: AppFonts.nunito),
          caption: TextStyle(fontFamily: AppFonts.nunito),
          button: TextStyle(fontFamily: AppFonts.nunito),
          overline: TextStyle(fontFamily: AppFonts.nunito),
        ),
      ),
      routes: {
        CustomerRegistrationScreen.id: (context) =>
            CustomerRegistrationScreen(),
        NewCustomerScreen.id: (context) => NewCustomerScreen(),
        AllActivitiesScreen.id: (context) => AllActivitiesScreen(),
        // FirebaseMessagingDemo.id: (context) => FirebaseMessagingDemo(),
        // D.id: (context) => D(),
        AddNewActivityScreen.id: (context) => AddNewActivityScreen(),
        ActivityEditScreen.id: (context) => ActivityEditScreen(),
        AllBookingsScreen.id: (context) => AllBookingsScreen(),
        BookingScreen.id: (context) => BookingScreen(),
        PaymentDetailsScreen.id: (context) => PaymentDetailsScreen(),
        BookDateTime.id: (context) => BookDateTime(),
        NewBookingScreen.id: (context) => NewBookingScreen(),
        AttendancePage.id: (context) => AttendancePage(),
        LoginScreen.id: (context) => LoginScreen(),
        EditBookingNewScreen.id: (context) => EditBookingNewScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        DashBoardScreen.id: (context) => DashBoardScreen(),
        AddAnUser.id: (context) => AddAnUser(),
        PaperWorkScreen.id: (context) => PaperWorkScreen(),
        AddCustomerDetailsScreen.id: (context) => AddCustomerDetailsScreen(),
        AllEmployeesScreen.id: (context) => AllEmployeesScreen(),
        LogScreen.id: (context) => LogScreen(),
        EmployeeProfileScreen.id: (context) => EmployeeProfileScreen(),
        EmployeeDetailsScreen.id: (context) => EmployeeDetailsScreen(),
        CompressorScreen.id: (context) => CompressorScreen(),
        AutoUpdateView.id: (context) => AutoUpdateView(),
      },
    );
  }
}
