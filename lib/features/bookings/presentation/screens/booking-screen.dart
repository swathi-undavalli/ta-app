import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/features/bookings/controller/booking-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-booking-screen.dart';

class BookingPage extends StatelessWidget {
  static const String id = "BookingPage";
  final BookingScreenLogic logic = BookingScreenLogic();
  var bookings = [DateTime.now()];
  BookingsCalenderWidgetLogic calenderLogic = BookingsCalenderWidgetLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Get.toNamed(AddCustomerDetailsScreen.id);
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        color: AppColors.IconColor.black,
        onRefresh: () async {
          await calenderLogic.getBookings(calenderLogic.controller.startDate);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    buildTitle("Calendar"),
                    BookingsCalenderWidget(
                      onDateTimeSelected: (DateTime selectedDate) {
                        print(selectedDate.toString());
                      },
                      showDetails: true,
                      startDate: DateTime.now().subtract(Duration(days: 4)),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///===============UI==============///

  Widget buildTitle(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.text.black,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.nunito),
      ),
    );
  }
}

// class BookingPage extends StatelessWidget {
//   static const String id = "BookingPage";
//   final BookingScreenLogic logic = BookingScreenLogic();
//   var bookings = [DateTime.now()];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background.lightBlue,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Get.toNamed(NewBookingScreen.id);
//         },
//         backgroundColor: AppColors.background.black,
//         child: Icon(Icons.add),
//       ),
//       body: RefreshIndicator(
//         color: AppColors.IconColor.black,
//         onRefresh: () async {
//           await Future.delayed(Duration(seconds: 2));
//         },
//         child: SafeArea(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 50),
//                 child: Column(
//                   children: [
//                     buildTitle("Calendar"),
//                     BookingsCalenderWidget(
//                       onDateTimeSelected: (DateTime selectedDate) {
//                         print(selectedDate.toString());
//                       },
//                       showDetails: true,
//                       startDate: DateTime.now().subtract(Duration(days: 4)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///===============UI==============///
//
//   Widget buildTitle(String text) {
//     return Container(
//       padding: const EdgeInsets.only(left: 20, right: 20),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 16,
//             color: AppColors.text.black,
//             fontWeight: FontWeight.bold,
//             fontFamily: AppFonts.nunito),
//       ),
//     );
//   }
// }
