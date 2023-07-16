import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'package:temple_adventures/features/boat/controller/manage-boats-controller.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ManageBoatsPage extends StatelessWidget {
  static const String id = "ManageBoatsPage";
  final ManageBoatsLogic logic = ManageBoatsLogic();
  final AutoScrollController autoScrollController = AutoScrollController();
  var bookings = [DateTime.now()];
  BookingsCalenderWidgetLogicNew calenderLogic =
      BookingsCalenderWidgetLogicNew();
  ScrollController scrollController = ScrollController();
  late BookingsCalenderWidgetNew bookingsCalenderWidget;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageBoatsController>(builder: (controller) {
      bookingsCalenderWidget = BookingsCalenderWidgetNew(
        onDateTimeSelected: (DateTime selectedDate) {},
        onSearchTap: () {
          scrollController.jumpTo(200);
        },
        autoScrollController: autoScrollController,
        showDetails: true,
        startDate: DateTime.now().subtract(Duration(days: 50)),
        isDiveSession: true,
        isBookingScreen: false,
      );
      return Scaffold(
        backgroundColor: AppColors.background.lightBlue,
        body: EmployeeAccess(
          access: AccessRights.boatPlan,
          showMessage: true,
          child: RefreshIndicator(
            color: Colors.black,
            onRefresh: () async {
              if (calenderLogic.controller.lastSelectedIndex == null)
                calenderLogic.controller.lastSelectedIndex = 50;
              bookingsCalenderWidget
                  .scrollToIndex(calenderLogic.controller.lastSelectedIndex!);
              await calenderLogic
                  .onDateSelected(calenderLogic.controller.lastSelectedIndex!);
            },
            child: SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 40, bottom: 50),
                  child: Column(
                    children: [
                      GetBuilder<BookingsCalenderWidgetControllerNew>(
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
    });
  }

  ///=========================UI========================///

  Widget buildCalendarIcon(
      BuildContext context, BookingsCalenderWidgetControllerNew controller) {
    return IconButton(
      splashRadius: 20,
      onPressed: () {
        onSelectDataPressed(context, controller);
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

  void onSelectDataPressed(BuildContext context,
      BookingsCalenderWidgetControllerNew controller) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
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
          child: child!,
        );
      },
    );
    if (selected != null && selected != controller.selectedDate) {
      var dif = controller.startDate!.difference(selected).inDays;
      if (dif < 0) {
        dif = dif * -1;
        bookingsCalenderWidget.scrollToIndex(dif);
        // calenderLogic.scrollToIndex(dif);
      } else
        // calenderLogic.scrollToIndex(dif);
        bookingsCalenderWidget.scrollToIndex(dif);
      calenderLogic.onDateSelected(dif);

      //log("=============$dif");
      controller.selectedDate = selected;
    }
    controller.update();
  }
}
