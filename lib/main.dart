import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:temple_adventures/features/Freelancers/presentation/screens/add-freelance-screen.dart';
import 'package:temple_adventures/features/Freelancers/presentation/screens/all-freelancers-screen.dart';
import 'package:temple_adventures/features/Freelancers/presentation/screens/freelance-details-screen.dart';
import 'package:temple_adventures/features/admin-portal/presentation/admin-portal-screen.dart';
import 'package:temple_adventures/features/admin-portal/presentation/image-view-page.dart';
import 'package:temple_adventures/features/boat/presentation/screens/all-boats-page.dart';
import 'package:temple_adventures/features/boat/presentation/screens/chooseBoat-page.dart';
import 'package:temple_adventures/auto-update.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/d1.dart';
import 'package:temple_adventures/d2.dart';
import 'package:temple_adventures/features/Activities/presentation/screens/activity-edit-screen.dart';
import 'package:temple_adventures/features/Activities/presentation/screens/add-new-activity-screen.dart';
import 'package:temple_adventures/features/all-bookings/presentation/screens/all-bookings-screen.dart';
import 'package:temple_adventures/features/boat/presentation/screens/editBoat-page.dart';
import 'package:temple_adventures/features/boat/presentation/screens/newBoat-page.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/IDProofScreen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add-guest-details-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add-payments-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/all-idProofs-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/edit-payments-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/guests-edit-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/payment-details-screen.dart';
import 'package:temple_adventures/features/dashboard/presentation/screens/dashboard-screen.dart';
import 'package:temple_adventures/features/edit-booking/presentation/screens/edit-booking-new-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/add-an-employee-screen.dart';
import 'package:temple_adventures/features/employees/presentation/screens/all-employees-screen.dart';
import 'package:temple_adventures/features/attendance/attendance-page.dart';
import 'package:temple_adventures/features/logs/presentation/screens/details-screen.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import 'package:temple_adventures/features/messaging/firebase_messaging_controller.dart';
import 'package:temple_adventures/features/messaging/notification_service.dart';
import 'package:temple_adventures/features/splash/view/splash-screen.dart';
import 'package:temple_adventures/features/welcome/presentation/screens/welome-page.dart';
import 'package:temple_adventures/notification-screen.dart';
import 'features/Activities/presentation/screens/all-activities-screen.dart';
import 'features/conditions/screens/add-conditions-screen.dart';
import 'features/dashboard/controller/dashboard-controller.dart';
import 'features/employees/presentation/screens/employee-details-screen.dart';
import 'features/employees/presentation/screens/employee-profile-screen.dart';
import 'features/login/presentation/screens/login-page.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print("called onBackgroundMessage");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService.initialize();
  await Firebase.initializeApp();
  // if (Platform.isIOS) {
  //   await Firebase.initializeApp(
  //       options: const FirebaseOptions(
  //           apiKey: "AIzaSyAJFHDoc1lfQtTRtEpRmCJue2kwfB5jUh8",
  //           appId: "1:671883511961:ios:99961ae0cf633ff7b05008",
  //           messagingSenderId: "671883511961",
  //           iosClientId: "671883511961-m5tbun1ohi774cfkrd2f15m2l6s4j6tg.apps.googleusercontent.com",
  //           projectId: "seismic-glow-283418"));
  // } else {
  //   await Firebase.initializeApp();
  // }

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
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.black,
  //   statusBarColor: Colors.white,
  //   statusBarBrightness: Brightness.light,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarIconBrightness: Brightness.dark,
  // ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessagingLogic();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(DashBoardScreenController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          // FirebaseAuthentication.isUserLoggedIn()
          //     ? DashBoardScreen.id
          //     : LoginScreen.id,
          SplashScreen.id,
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
        AllActivitiesScreen.id: (context) => AllActivitiesScreen(),
        EditBoatPage.id: (context) => EditBoatPage(),
        NewBoatPage.id: (context) => NewBoatPage(),
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
        GuestsEditScreen.id: (context) => GuestsEditScreen(),
        AddCustomerDetailsScreen.id: (context) => AddCustomerDetailsScreen(),
        AllEmployeesScreen.id: (context) => AllEmployeesScreen(),
        LogScreen.id: (context) => LogScreen(),
        EmployeeProfileScreen.id: (context) => EmployeeProfileScreen(),
        EmployeeDetailsScreen.id: (context) => EmployeeDetailsScreen(),
        AutoUpdateView.id: (context) => AutoUpdateView(),
        Dummy.id: (context) => Dummy(),
        ChooseBoatPage.id: (context) => ChooseBoatPage(),
        D2.id: (context) => D2(),
        IDProofScreen.id: (context) => IDProofScreen(),
        AllIDProofsScreen.id: (context) => AllIDProofsScreen(),
        GuestDetailsScreen.id: (context) => GuestDetailsScreen(),
        AllFreelancersScreen.id: (context) => AllFreelancersScreen(),
        AddFreelanceScreen.id: (context) => AddFreelanceScreen(),
        FreelanceDetailsScreen.id: (context) => FreelanceDetailsScreen(),
        AllBoatsPage.id: (context) => AllBoatsPage(),
        AddPaymentsScreen.id: (context) => AddPaymentsScreen(),
        EditPaymentsScreen.id: (context) => EditPaymentsScreen(),
        AdminPortalScreen.id: (context) => AdminPortalScreen(),
        ImageViewPage.id: (context) => ImageViewPage(),
        NotificationsScreen.id: (context) => NotificationsScreen(),
        DetailsScreen.id: (context) => DetailsScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        AddConditionsScreen.id: (context) => AddConditionsScreen(),
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
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      Get.toNamed(NotificationsScreen.id, arguments: message);
      LocalNotificationService.display(message);
    }
  }

  static backgroundHandler(RemoteMessage message) {}
}
