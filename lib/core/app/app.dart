import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../features/activities/presentation/views/activity_edit_view.dart';
import '../../features/activities/presentation/views/add_new_activity_view.dart';
import '../../features/activities/presentation/views/all_activities_view.dart';
import '../../features/all_bookings/presentation/views/all_bookings_view.dart';
import '../../features/board_plan/presentation/views/board_plan_view.dart';
import '../../features/boat/presentation/views/boats_view.dart';
import '../../features/bookings/presentation/views/add_customer_details_view.dart';
import '../../features/bookings/presentation/views/add_payments_view.dart';
import '../../features/bookings/presentation/views/book_date_time_view.dart';
import '../../features/bookings/presentation/views/booking_view.dart';
import '../../features/bookings/presentation/views/customer_logs_view.dart';
import '../../features/bookings/presentation/views/edit_payments_view.dart';
import '../../features/bookings/presentation/views/new_booking_view.dart';
import '../../features/bookings/presentation/views/payment_details_view.dart';
import '../../features/certifications/presentation/views/certification_details_view.dart';
import '../../features/certifications/presentation/views/certification_progress_view.dart';
import '../../features/coast_guard_slip/presentation/views/coast_guard_slip_view.dart';
import '../../features/conditions/presentation/views/add_conditions_view.dart';
import '../../features/dashboard/controller/dashboard_controller.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';
import '../../features/dive_checklist/presentation/views/dive_checklist_view.dart';
import '../../features/dive_checklist/presentation/views/new_checklist_view.dart';
import '../../features/bookings/presentation/views/edit_booking_view.dart';
import '../../features/employees/presentation/views/add_employee_view.dart';
import '../../features/employees/presentation/views/all_employees_view.dart';
import '../../features/employees/presentation/views/employee_details_view.dart';
import '../../features/employees/presentation/views/employee_profile_view.dart';
import '../../features/events/presentation/views/events_view.dart';
import '../../features/general_info/presentation/views/general_info_view.dart';
import '../../features/login/presentation/views/login_view.dart';
import '../../features/logs/presentation/views/notification_view.dart';
import '../../features/logs/presentation/views/log_view.dart';
import '../../features/messaging/notification_screen.dart';
import '../../features/offers/presentation/views/add_offers_view.dart';
import '../../features/offers/presentation/views/offers_view.dart';
import '../../features/roaster/presentation/views/roaster_view.dart';
import '../../features/screen_saver/views/marketing_view.dart';
import '../../features/splash/view/splash_view.dart';
import '../../features/welcome/presentation/views/welome_view.dart';
import '../constants/constants.dart';
import '../services/auto_update.dart';

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
      initialRoute: SplashView.id,
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
        AllActivitiesView.id: (context) => AllActivitiesView(),
        AddNewActivityView.id: (context) => AddNewActivityView(),
        ActivityEditView.id: (context) => ActivityEditView(),
        AllBookingsView.id: (context) => const AllBookingsView(),
        BookingView.id: (context) => BookingView(),
        PaymentDetailsView.id: (context) => PaymentDetailsView(),
        BookDateTimeView.id: (context) => BookDateTimeView(),
        NewBookingView.id: (context) => NewBookingView(),
        LoginView.id: (context) => const LoginView(),
        EditBookingView.id: (context) => EditBookingView(),
        WelcomeView.id: (context) => const WelcomeView(),
        DashBoardView.id: (context) => DashBoardView(),
        AddEmployeeView.id: (context) => AddEmployeeView(),
        AddCustomerDetailsView.id: (context) => AddCustomerDetailsView(),
        AllEmployeesView.id: (context) => const AllEmployeesView(),
        LogView.id: (context) => const LogView(),
        CustomerLogsView.id: (context) => const CustomerLogsView(),
        EmployeeProfileView.id: (context) => const EmployeeProfileView(),
        EmployeeDetailsView.id: (context) => EmployeeDetailsView(),
        AutoUpdateView.id: (context) => AutoUpdateView(),
        AddPaymentsView.id: (context) => AddPaymentsView(),
        EditPaymentsView.id: (context) => EditPaymentsView(),
        NotificationsScreen.id: (context) => NotificationsScreen(),
        NotificationView.id: (context) => NotificationView(),
        SplashView.id: (context) => const SplashView(),
        AddConditionsView.id: (context) => const AddConditionsView(),
        BoatsView.id: (context) => BoatsView(),
        GeneralInfoView.id: (context) => const GeneralInfoView(),
        BoardPlanView.id: (context) => const BoardPlanView(),
        DiveChecklistView.id: (context) => const DiveChecklistView(),
        NewChecklistView.id: (context) => const NewChecklistView(),
        MarketingView.id: (context) => const MarketingView(),
        EventsView.id: (context) => const EventsView(),
        AddOffersView.id: (context) => const AddOffersView(),
        OffersView.id: (context) => const OffersView(),
        CoastGuardSlipView.id: (context) => const CoastGuardSlipView(),
        RoasterView.id: (context) => const RoasterView(),
        CertificationProgressView.id: (context) => const CertificationProgressView(),
        CertificationDetailsView.id: (context) => CertificationDetailsView(),
      },
    );
  }
}
