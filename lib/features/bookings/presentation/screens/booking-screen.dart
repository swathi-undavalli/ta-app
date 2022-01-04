import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:temple_adventures/features/bookings/controller/booking-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

class BookingScreen extends StatelessWidget {
  static const String id = "BookingPage";
  final BookingScreenLogic logic = BookingScreenLogic();
  final AutoScrollController autoScrollController = AutoScrollController();
  var bookings = [DateTime.now()];
  BookingsCalenderWidgetLogic calenderLogic = BookingsCalenderWidgetLogic();

  BookingsCalenderWidget bookingsCalenderWidget;

  @override
  Widget build(BuildContext context) {
    print("building bro");
    bookingsCalenderWidget = BookingsCalenderWidget(
      onDateTimeSelected: (DateTime selectedDate) {
        print(selectedDate.toString());
      },
      autoScrollController: autoScrollController,
      showDetails: true,
      startDate: DateTime.now().subtract(Duration(days: 50)),
      isDiveSession: true,
    );
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      floatingActionButton: EmployeeAccess(
        access: AccessRights.createBookings,
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Get.toNamed(AddCustomerDetailsScreen.id);
            // Get.toNamed(CustomerRegistrationScreen.id);
          },
          backgroundColor: AppColors.background.black,
          child: Icon(Icons.add),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.IconColor.black,
        onRefresh: () async {
          if (calenderLogic.controller.lastSelectedIndex == null)
            calenderLogic.controller.lastSelectedIndex = 50;
          bookingsCalenderWidget
              .scrollToIndex(calenderLogic.controller.lastSelectedIndex);
          await calenderLogic
              .onDateSelected(calenderLogic.controller.lastSelectedIndex);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 40, bottom: 50),
              child: Column(
                children: [
                  GetBuilder<BookingsCalenderWidgetController>(
                      builder: (controller) {
                    DateTime date = controller.selectedDate;
                    String formattedDate =
                        DateFormat('dd-MMM-yyyy').format(date);
                    return Row(
                      children: [
                        buildTitle("Calendar"),
                        Spacer(),
                        Text(formattedDate),
                        buildCalendarIcon(context, controller),
                      ],
                    );
                  }),
                  bookingsCalenderWidget,
                  // BookingsCalenderWidget(
                  //   onDateTimeSelected: (DateTime selectedDate) {
                  //     print(selectedDate.toString());
                  //   },
                  //   autoScrollController: autoScrollController,
                  //   showDetails: true,
                  //   startDate: DateTime.now().subtract(Duration(days: 50)),
                  //   isDiveSession: true,
                  // ),
                  SizedBox(
                    height: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///===============UI==============///

  Widget buildCalendarIcon(
      BuildContext context, BookingsCalenderWidgetController controller) {
    return IconButton(
      splashRadius: 20,
      onPressed: () {
        selectDate(context, controller);
      },
      icon: Icon(
        Icons.calendar_today_outlined,
        size: 17,
      ),
    );
  }

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

  selectDate(
      BuildContext context, BookingsCalenderWidgetController controller) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.black,
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.text.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.text.black,
                textStyle:
                    TextStyle(fontWeight: FontWeight.w500), // button text color
              ),
            ),
          ),
          child: child,
        );
      },
    );
    if (selected != null && selected != controller.selectedDate) {
      var dif = controller.startDate.difference(selected).inDays;
      if (dif < 0) {
        dif = dif * -1;
        bookingsCalenderWidget.scrollToIndex(dif);
        // calenderLogic.scrollToIndex(dif);
      } else
        // calenderLogic.scrollToIndex(dif);
        bookingsCalenderWidget.scrollToIndex(dif);
      calenderLogic.onDateSelected(dif);

      log("=============$dif");
      controller.selectedDate = selected;
    }
    controller.update();
  }
}
