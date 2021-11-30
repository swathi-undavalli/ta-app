import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/edit-booking-details.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingsExpansionPanel extends StatelessWidget {
  final ExpansionPanelLogic logic = ExpansionPanelLogic();

  final List<ItemModel> items;
  List<Widget> expansions = [];

  BookingsExpansionPanel({this.items}) {
    logic.controller.isExpanded = [];
    for (int i = 0; i < items.length; i++) {
      logic.controller.isExpanded.add(false);
      expansions.add(buildExpansion(itemModel: items[i], i: i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: expansions,
    );
  }

  Widget buildExpansion({ItemModel itemModel, int i}) {
    getColor() {
      if (itemModel.colorCode == "Blue")
        return Color(0xffA9EBF8);
      else if (itemModel.colorCode == "Purple")
        return Color(0xffBCB8F5);
      else if (itemModel.colorCode == "Red")
        return Color(0xffF6B2B2);
      else if (itemModel.colorCode == "Green")
        return Color(0xff96F1BD);
      else
        return Colors.white;
    }

    return GetBuilder<ExpansionPanelController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInCubic,
          alignment: Alignment.topCenter,
          height: controller.isExpanded[i] ? 240 : 50,
          width: 350,
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: AppColors.text.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 6),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        itemModel.name.capitalizeFirst +
                            " x " +
                            (itemModel.pax.toString()),
                        style: TextStyle(
                            color: AppColors.text.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Material(
                        color: getColor(),
                        child: IconButton(
                          splashRadius: 20,
                          icon: Icon(Icons.call_rounded,
                              color: AppColors.background.black),
                          iconSize: 15,
                          onPressed: () {
                            makingPhoneCall(itemModel.phone);
                          },
                        ),
                      ),
                      EmployeeAccess(
                        access: currentEmployee.accessLevels.editBookings,
                        child: Material(
                          color: getColor(),
                          child: IconButton(
                            splashRadius: 20,
                            icon: Icon(Icons.delete,
                                color: AppColors.background.black),
                            iconSize: 15,
                            onPressed: () {
                              Get.defaultDialog(
                                contentPadding: EdgeInsets.only(
                                    left: 30, right: 30, top: 20, bottom: 30),
                                title: "\nAre You Sure ? ",
                                middleText:
                                    "Booking will Be Deleted Permanently.",
                                backgroundColor: Colors.white,
                                titleStyle: TextStyle(
                                    color: AppColors.text.black,
                                    fontFamily: AppFonts.nunito,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                middleTextStyle: TextStyle(
                                    color: AppColors.text.black,
                                    fontFamily: AppFonts.nunito,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                                confirm: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppButton.miniText(
                                      text: 'Cancel',
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                    AppButton.miniFlat(
                                      text: 'OK',
                                      onTap: () {
                                        FirebaseFirestore.instance
                                            .collection("bookings")
                                            .doc(itemModel.bookingModel.id)
                                            .delete();
                                        Get.back();
                                        BookingsCalenderWidgetLogic
                                            bookingCalenderLogic =
                                            BookingsCalenderWidgetLogic();
                                        bookingCalenderLogic.onDateSelected(
                                            bookingCalenderLogic
                                                .controller.lastDateIndex);
                                      },
                                    ),
                                  ],
                                ),
                                barrierDismissible: false,
                                radius: 10,
                              );
                            },
                          ),
                        ),
                      ),
                      EmployeeAccess(
                        access: currentEmployee.accessLevels.editBookings,
                        child: Material(
                          color: getColor(),
                          child: IconButton(
                            splashRadius: 20,
                            icon: Icon(Icons.edit,
                                color: AppColors.background.black),
                            iconSize: 15,
                            onPressed: () {
                              Get.toNamed(EditBookingDetailsScreen.id,
                                  arguments: itemModel.bookingModel);
                            },
                          ),
                        ),
                      ),
                      Material(
                        color: getColor(),
                        child: IconButton(
                          splashRadius: 20,
                          icon: Icon(controller.isExpanded[i]
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded),
                          onPressed: () {
                            print("tapped");
                            controller.isExpanded[i] =
                                !controller.isExpanded[i];
                            controller.update();
                          },
                        ),
                      ),
                    ]),
                controller.isExpanded[i]
                    ? FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 200)),
                        initialData: SizedBox(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done)
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                buildKeyValuePairs(
                                    "Activity", items[i].activity),
                                buildKeyValuePairs("Deposit", items[i].paid),
                                buildKeyValuePairs("Balance", items[i].balance),
                                buildKeyValuePairs(
                                    "PAX", items[i].pax.toString()),
                                buildKeyValuePairs(
                                    "Remarks", items[i].remarks.toString()),
                                buildKeyValuePairs("Phone", items[i].phone),
                                buildKeyValuePairs("Email", items[i].email),
                                buildKeyValuePairs("Time", items[i].time),
                                buildKeyValuePairs("Session", items[i].session),
                              ],
                            );
                          return SizedBox();
                        })
                    : SizedBox(),
              ],
            ),
          ),
        ),
      );
    });
  }

  makingPhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildKeyValuePairs(String key, String value) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            key,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
                height: 1.3),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                height: 1.3),
          ),
        ),
      ],
    );
  }
}

class ExpansionPanelLogic {
  ExpansionPanelController controller = Get.put(ExpansionPanelController());
}

class ExpansionPanelController extends GetxController {
  List<bool> isExpanded = [];

  BookingModel bookingModel;
}

class ItemModel {
  bool expanded;
  final String name;
  String time;
  String session;
  final String email;
  final String phone;
  final String activity;
  final String colorCode;
  final String price;
  final String date;
  final String cost;
  final String paid;
  final String balance;
  final String remarks;
  final int pax;
  final bool registration;
  BookingModel bookingModel;

  ItemModel(
      {@required this.phone,
      @required this.activity,
      @required this.colorCode,
      @required this.price,
      @required this.time,
      @required this.session,
      @required this.date,
      @required this.cost,
      @required this.paid,
      @required this.balance,
      @required this.remarks,
      @required this.registration,
      this.expanded = false,
      @required this.name,
      @required this.pax,
      @required this.email,
      this.bookingModel});

  // factory ItemModel.fromBookings(BookingModel bookingModel) {
  //   getSessions() {
  //     var d = "";
  //     if (bookingModel.theoryDate != null) d = d + "Theory, ";
  //     if (bookingModel.poolDate != null) d = d + "Pool, ";
  //     if (bookingModel.diveDate != null) d = d + "Dive, ";
  //     return d.substring(0, d.length - 2);
  //   }
  //
  //   getTime() {
  //     var d = "";
  //     if (bookingModel.theoryDate != null)
  //       d = d + DateFormat("HH:mm").format(bookingModel.theoryDate) + ", ";
  //     if (bookingModel.poolDate != null)
  //       d = d + DateFormat("HH:mm").format(bookingModel.poolDate) + ", ";
  //     if (bookingModel.diveDate != null)
  //       d = d + DateFormat("HH:mm").format(bookingModel.diveDate) + ", ";
  // ItemModel({
  //   @required this.phone,
  //   @required this.activity,
  //   @required this.time,
  //   @required this.session,
  //   @required this.date,
  //   @required this.cost,
  //   @required this.paid,
  //   @required this.balance,
  //   @required this.remarks,
  //   @required this.registration,
  //   this.expanded = false,
  //   @required this.name,
  //   @required this.pax,
  //   @required this.email,
  // });

  factory ItemModel.fromBookings(BookingModel bookingModel) {
    getSessions() {
      var d = "";
      if (bookingModel.theoryDate != null) d = d + "Theory, ";
      if (bookingModel.poolDate != null) d = d + "Pool, ";
      if (bookingModel.diveDate != null) d = d + "Dive, ";
      return d.substring(0, d.length - 2);
    }

    getTime() {
      var d = "";
      if (bookingModel.theoryDate != null)
        d = d + DateFormat("hh:mm").format(bookingModel.theoryDate) + ", ";
      if (bookingModel.poolDate != null)
        d = d + DateFormat("hh:mm").format(bookingModel.poolDate) + ", ";
      if (bookingModel.diveDate != null)
        d = d + DateFormat("hh:mm").format(bookingModel.diveDate) + ", ";
      return d.substring(0, d.length - 2);
    }

    return ItemModel(
      phone: bookingModel.pax[0]["countryCode"] +
          bookingModel.pax[0]["phoneNumber"],
      activity: bookingModel.activity[0].name.toString(),
      price: bookingModel.activity[0].price.toString(),
      colorCode: bookingModel.activity[0].color.toString(),
      date: bookingModel.bookingDate[0],
      cost: bookingModel.totalCost.toString(),
      paid: bookingModel.payingNow.toString(),
      balance: bookingModel.balance.toString(),
      registration: true,
      name: bookingModel.pax[0]["first-name"],
      pax: bookingModel.noOfPersons,
      email: bookingModel.pax[0]["email"],
      remarks: bookingModel.pax[0]["remarks"],
      time: getTime(),
      session: getSessions(),
      bookingModel: bookingModel,
    );
  }
}
