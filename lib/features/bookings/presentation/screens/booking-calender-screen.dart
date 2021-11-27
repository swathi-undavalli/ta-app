import 'package:flutter/material.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/features/bookings/controller/booking-calender-controller.dart';

class BookingCalender extends StatelessWidget {
  static const String id = "BookingCalender";
  final BookingCalenderLogic logic = BookingCalenderLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
            child: Column(
              children: [
                buildTitle("Calender"),
                BookingsCalenderWidget(
                  onDateTimeSelected: (DateTime selectedDate){
                    print(selectedDate.toString());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  ///===============UI==============///



  Widget buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.text.black,
            fontFamily: AppFonts.nunito),
      ),
    );
  }


}

