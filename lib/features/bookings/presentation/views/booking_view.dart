import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import '../../../../core/widgets/bookings_calender_widget/bookings_calender_widget_new.dart';
import '../../controller/booking_controller.dart';
import 'add_customer_details_view.dart';

// ignore: must_be_immutable
class BookingView extends StatelessWidget {
  final BookingScreenLogic logic = BookingScreenLogic();
  final AutoScrollController autoScrollController = AutoScrollController();
  var bookings = [DateTime.now()];
  BookingsCalenderWidgetLogicNew calenderLogic = BookingsCalenderWidgetLogicNew();
  ScrollController scrollController = ScrollController();
  late BookingsCalenderWidgetNew bookingsCalenderWidget;

  BookingView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => BookingView(),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingScreenController>(
      builder: (controller) {
        bookingsCalenderWidget = BookingsCalenderWidgetNew(
          onDateTimeSelected: (DateTime selectedDate) {},
          onSearchTap: () {
            scrollController.jumpTo(200);
          },
          autoScrollController: autoScrollController,
          showDetails: true,
          startDate: DateTime.now().subtract(const Duration(days: 50)),
          isDiveSession: true,
          isBookingScreen: true,
        );
        return Scaffold(
          backgroundColor: AppColors.background.lightBlue,
          floatingActionButton: EmployeeAccess(
            access: AccessRights.createBookings,
            child: buildFloatingActionButton(context),
          ),
          body: RefreshIndicator(
            color: AppColors.iconColor.black,
            onRefresh: () async {
              bookingsCalenderWidget.scrollToIndex(50);
              await calenderLogic.onDateSelected(DateTime.now());
            },
            child: SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GetBuilder<BookingsCalenderWidgetControllerNew>(
                      builder: (controller) {
                        DateTime date = controller.selectedDate;
                        String formattedDate = DateFormat('dd-MMM-yyyy').format(date);
                        return Row(
                          children: [
                            buildTitle('Calendar'),
                            const Spacer(),
                            Text(formattedDate),
                            buildCalendarIcon(context, controller),
                          ],
                        );
                      },
                    ),
                    bookingsCalenderWidget,
                    Spacing.h100,
                    Spacing.h100,
                  ],
                ).paddingSymmetric(horizontal: 20, vertical: 40),
              ),
            ),
          ),
        );
      },
    );
  }

  ///===============UI==============///

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        Navigator.push(context, AddCustomerDetailsView.route());
      },
      backgroundColor: AppColors.background.black,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget buildCalendarIcon(
    BuildContext context,
    BookingsCalenderWidgetControllerNew controller,
  ) {
    return IconButton(
      splashRadius: 20,
      onPressed: () {
        selectDate(context, controller);
      },
      icon: const Icon(
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
          fontFamily: AppFonts.nunito,
        ),
      ),
    );
  }

  selectDate(
    BuildContext context,
    BookingsCalenderWidgetControllerNew controller,
  ) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
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
                foregroundColor: AppColors.text.black,
                textStyle: const TextStyle(fontWeight: FontWeight.w500), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && selected != controller.selectedDate) {
      var dif = controller.startDate!.difference(selected).inDays;
      if (dif < 0) {
        dif = dif * -1;
        bookingsCalenderWidget.scrollToIndex(dif);
      } else {
        bookingsCalenderWidget.scrollToIndex(dif);
      }
      calenderLogic.onDateSelected(selected);
      controller.selectedDate = selected;
    }
    controller.update();
  }
}
