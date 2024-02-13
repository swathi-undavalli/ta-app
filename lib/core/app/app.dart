import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/offers/presentation/views/add_offers_view.dart';

import '../../features/activities/presentation/screens/activity_edit_screen.dart';
import '../../features/activities/presentation/screens/add_new_activity_screen.dart';
import '../../features/activities/presentation/screens/all_activities_screen.dart';
import '../../features/all_bookings/presentation/screens/all_bookings_screen.dart';
import '../../features/board_plan/presentation/views/board_plan_view.dart';
import '../../features/boat/presentation/screens/manage_boats_page.dart';
import '../../features/boat/presentation/screens/manage_general_info.dart';
import '../../features/bookings/presentation/screens/add_customer_details_screen.dart';
import '../../features/bookings/presentation/screens/dive_log_view.dart';
import '../../features/bookings/presentation/screens/add_payments_screen.dart';
import '../../features/bookings/presentation/screens/book_date_time_screen.dart';
import '../../features/bookings/presentation/screens/booking_screen.dart';
import '../../features/bookings/presentation/screens/edit_payments_screen.dart';
import '../../features/bookings/presentation/screens/new_booking_screen.dart';
import '../../features/bookings/presentation/screens/payment_details_screen.dart';
import '../../features/conditions/screens/add_conditions_screen.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dive_checklist/views/screens/dive_checklist_view.dart';
import '../../features/dive_checklist/views/screens/new_checklist_view.dart';
import '../../features/edit_booking/presentation/screens/edit_booking_new_screen.dart';
import '../../features/employees/presentation/screens/add_an_employee_screen.dart';
import '../../features/employees/presentation/screens/all_employees_screen.dart';
import '../../features/employees/presentation/screens/employee_details_screen.dart';
import '../../features/employees/presentation/screens/employee_profile_screen.dart';
import '../../features/events/views/events_view.dart';
import '../../features/login/presentation/screens/login_page.dart';
import '../../features/logs/presentation/screens/details_screen.dart';
import '../../features/logs/presentation/screens/log_screen.dart';
import '../../features/messaging/notification_screen.dart';
import '../../features/offers/presentation/views/offers_view.dart';
import '../../features/screen_saver/views/marketing_view.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/welcome/presentation/screens/welome_page.dart';
import '../constants/constants.dart';
import '../services/auto_update.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DashBoardScreenController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
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
      routes: {
        AllActivitiesScreen.id: (context) => AllActivitiesScreen(),
        AddNewActivityScreen.id: (context) => AddNewActivityScreen(),
        ActivityEditScreen.id: (context) => ActivityEditScreen(),
        AllBookingsScreen.id: (context) => const AllBookingsScreen(),
        BookingScreen.id: (context) => BookingScreen(),
        PaymentDetailsScreen.id: (context) => PaymentDetailsScreen(),
        BookDateTime.id: (context) => BookDateTime(),
        NewBookingScreen.id: (context) => NewBookingScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        EditBookingNewScreen.id: (context) => EditBookingNewScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        DashBoardScreen.id: (context) => DashBoardScreen(),
        AddAnEmployeeScreen.id: (context) => AddAnEmployeeScreen(),
        AddCustomerDetailsScreen.id: (context) => AddCustomerDetailsScreen(),
        AllEmployeesScreen.id: (context) => const AllEmployeesScreen(),
        LogScreen.id: (context) => const LogScreen(),
        EmployeeProfileScreen.id: (context) => const EmployeeProfileScreen(),
        EmployeeDetailsScreen.id: (context) => EmployeeDetailsScreen(),
        AutoUpdateView.id: (context) => AutoUpdateView(),
        AddPaymentsScreen.id: (context) => AddPaymentsScreen(),
        EditPaymentsScreen.id: (context) => EditPaymentsScreen(),
        NotificationsScreen.id: (context) => NotificationsScreen(),
        DetailsScreen.id: (context) => DetailsScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
        AddConditionsScreen.id: (context) => const AddConditionsScreen(),
        ManageBoatsPage.id: (context) => ManageBoatsPage(),
        ManageGeneralInfo.id: (context) => const ManageGeneralInfo(),
        BoardPlanView.id: (context) => const BoardPlanView(),
        DiveChecklistView.id: (context) => const DiveChecklistView(),
        NewChecklistView.id: (context) => const NewChecklistView(),
        MarketingView.id: (context) => const MarketingView(),
        EventsView.id: (context) => const EventsView(),
        AddOffersView.id: (context) => const AddOffersView(),
        OffersView.id: (context) => const OffersView(),
        DiveLogView.id: (context) => DiveLogView(),
      },
    );
  }
}
