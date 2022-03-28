import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/edit-booking/presentation/screens/edit-booking-new-screen.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingsExpansionPanel extends StatelessWidget {
  final ExpansionPanelLogic logic = ExpansionPanelLogic();

  final List<ItemModel> items;
  Function onDeletePressed;
  List<Widget> expansions = [];
  TextEditingController amount = TextEditingController();

  BookingsExpansionPanel({this.items, this.onDeletePressed}) {
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
        return Color(0xffA9EBF8).withOpacity(0.3);
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
          height: controller.isExpanded[i] ? 380 : 50,
          // height: controller.isExpanded[i] ? 470 : 50,
          width: 350,
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: AppColors.text.grey),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: getColor(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          child: Text(
                            itemModel.name.capitalizeFirst +
                                " x " +
                                (itemModel.bookingModel.noOfPersons.toString()),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.text.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          splashRadius: 20,
                          icon: Icon(Icons.call_rounded,
                              color: AppColors.background.black),
                          iconSize: 15,
                          onPressed: () {
                            makingPhoneCall(itemModel.phone);
                          },
                        ),
                        EmployeeAccess(
                          access: AccessRights.editBookings,
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
                                        LogModel logModel = LogModel(
                                            type: LogType.bookingDeleted,
                                            bookingId:
                                                itemModel.bookingModel.id);
                                        FirebaseFirestore.instance
                                            .collection("logs")
                                            .doc()
                                            .set(logModel.toMap());

                                        Get.back();
                                        onDeletePressed();
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
                        EmployeeAccess(
                          access: AccessRights.editBookings,
                          child: IconButton(
                            splashRadius: 20,
                            icon: Icon(Icons.edit,
                                color: AppColors.background.black),
                            iconSize: 15,
                            onPressed: () {
                              var model = itemModel.bookingModel;
                              Get.toNamed(EditBookingNewScreen.id,
                                  arguments: model);
                            },
                          ),
                        ),
                        IconButton(
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
                      ]),
                  controller.isExpanded[i]
                      ? FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 200)),
                          initialData: SizedBox(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done)
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  buildKeyValuePairs(
                                      "Booking Id", items[i].bookingID),
                                  buildKeyValuePairs(
                                      "Activity", items[i].activity),
                                  buildKeyValuePairs(
                                      "Total Cost", items[i].cost),
                                  buildKeyValuePairs("Deposit", items[i].paid),
                                  buildKeyValuePairs(
                                      "Balance", items[i].balance),
                                  buildKeyValuePairs(
                                      "Pax",
                                      items[i]
                                          .bookingModel
                                          .noOfPersons
                                          .toString()),
                                  ((items[i] != null) &&
                                          (items[i].receiptNo != null))
                                      ? buildKeyValuePairs(
                                          "Invoice no", items[i].receiptNo)
                                      : buildKeyValuePairs("Invoice no", "-"),
                                  (items[i].remarks == "")
                                      ? buildKeyValuePairs("Remarks", "-")
                                      : buildKeyValuePairs("Remarks",
                                          items[i].remarks.toString()),
                                  buildKeyValuePairs("Phone", items[i].phone),
                                  buildKeyValuePairs("Email", items[i].email),
                                  buildKeyValuePairs("Time", items[i].time),
                                  buildKeyValuePairs("Date", items[i].date),
                                  buildKeyValuePairs(
                                      "Session", items[i].session),
                                  buildKeyValuePairs(
                                    "Registered",
                                    "${items[i].bookingModel.pax.length - 1} / ${items[i].bookingModel.noOfPersons}",
                                    isDanger: ((items[i]
                                                .bookingModel
                                                .pax
                                                .length -
                                            1) !=
                                        (items[i].bookingModel.noOfPersons)),
                                  ),
                                  SizedBox(height: 20),
                                  //TODO ::

                                  // SizedBox(
                                  //   width: Get.width - 100,
                                  //   child: buildPaymentStatus(
                                  //       totalAmount: items[i].cost.toString(),
                                  //       payments:
                                  //           items[i].bookingModel.payments),
                                  // ),
                                  // SizedBox(
                                  //     height:
                                  //         (double.parse(items[i].balance) == 0)
                                  //             ? 30
                                  //             : 10),
                                  // (double.parse(items[i].balance) == 0)
                                  //     ? SizedBox()
                                  //     : Container(
                                  //         child: AppButton.miniFlat(
                                  //           text: "Add Payment",
                                  //           onTap: () {
                                  //             Get.defaultDialog(
                                  //               contentPadding: EdgeInsets.only(
                                  //                   left: 30,
                                  //                   right: 30,
                                  //                   top: 20,
                                  //                   bottom: 30),
                                  //               title:
                                  //                   "\n ${itemModel.name.capitalizeFirst + " x " + (itemModel.bookingModel.noOfPersons.toString())} ",
                                  //               content: Column(
                                  //                 children: [
                                  //                   TextField(
                                  //                     decoration:
                                  //                         InputDecoration(
                                  //                       labelText:
                                  //                           'Enter Amount',
                                  //                     ),
                                  //                     controller: amount,
                                  //                   ),
                                  //                   SizedBox(height: 30),
                                  //                   Row(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .spaceBetween,
                                  //                     children: [
                                  //                       Text(
                                  //                         "Balance :",
                                  //                         style: TextStyle(
                                  //                             fontSize: FontSize
                                  //                                 .small,
                                  //                             color: AppColors
                                  //                                 .text
                                  //                                 .darkgrey),
                                  //                       ),
                                  //                       Text(
                                  //                         "${items[i].balance}/-",
                                  //                         style: TextStyle(
                                  //                             fontSize: FontSize
                                  //                                 .textSize,
                                  //                             fontWeight:
                                  //                                 FontWeight
                                  //                                     .w600),
                                  //                       )
                                  //                     ],
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //               backgroundColor: Colors.white,
                                  //               titleStyle: TextStyle(
                                  //                   color: AppColors.text.black,
                                  //                   fontFamily: AppFonts.nunito,
                                  //                   fontSize: 16,
                                  //                   fontWeight:
                                  //                       FontWeight.bold),
                                  //               confirm: Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: [
                                  //                   AppButton.miniText(
                                  //                     text: 'Cancel',
                                  //                     onTap: () {
                                  //                       Get.back();
                                  //                     },
                                  //                   ),
                                  //                   //TODO ::
                                  //                   // AppButton.miniFlat(
                                  //                   //   text: 'OK',
                                  //                   //   onTap: () {
                                  //                   //     items[i]
                                  //                   //         .bookingModel
                                  //                   //         .payments
                                  //                   //         .add(double.parse(
                                  //                   //             amount.text));
                                  //                   //
                                  //                   //     var list = items[i]
                                  //                   //         .bookingModel
                                  //                   //         .payments;
                                  //                   //
                                  //                   //     double totalDeposit = 0;
                                  //                   //     list.forEach((element) {
                                  //                   //       totalDeposit +=
                                  //                   //           element;
                                  //                   //     });
                                  //                   //
                                  //                   //     FirebaseFirestore
                                  //                   //         .instance
                                  //                   //         .collection(
                                  //                   //             "bookings")
                                  //                   //         .doc(items[i]
                                  //                   //             .bookingModel
                                  //                   //             .id)
                                  //                   //         .set(
                                  //                   //             {
                                  //                   //           "payments": items[
                                  //                   //                   i]
                                  //                   //               .bookingModel
                                  //                   //               .payments,
                                  //                   //           "paid":
                                  //                   //               totalDeposit,
                                  //                   //         },
                                  //                   //             SetOptions(
                                  //                   //                 merge:
                                  //                   //                     true));
                                  //                   //     Get.back();
                                  //                   //     amount.text = "";
                                  //                   //     BookingsCalenderWidgetLogic
                                  //                   //         bookingCalenderLogic =
                                  //                   //         BookingsCalenderWidgetLogic();
                                  //                   //     bookingCalenderLogic
                                  //                   //         .onDateSelected(
                                  //                   //             bookingCalenderLogic
                                  //                   //                 .controller
                                  //                   //                 .lastDateIndex);
                                  //                   //   },
                                  //                   // ),
                                  //                 ],
                                  //               ),
                                  //               barrierDismissible: false,
                                  //               radius: 10,
                                  //             );
                                  //           },
                                  //         ).paddingOnly(right: 15),
                                  //         alignment: Alignment.centerRight,
                                  //       ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      (items[i].employeeName != null)
                                          ? Container(
                                              alignment: Alignment.centerRight,
                                              child: RichText(
                                                text: TextSpan(
                                                  text: "Created By : ",
                                                  style: TextStyle(
                                                    fontFamily: AppFonts.nunito,
                                                    color:
                                                        AppColors.text.darkgrey,
                                                    fontSize: 10,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          items[i].employeeName,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff484646),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      AppButton.miniFlat(
                                        text: "Get Link",
                                        onTap: () async {
                                          String link =
                                              "https://seismic-glow-283418.web.app/?booking=${items[i].bookingModel.id}";
                                          await Clipboard.setData(
                                              ClipboardData(text: link));
                                          Fluttertoast.showToast(
                                              msg: "Link copied to Clipboard");
                                        },
                                      ).paddingOnly(right: 15),
                                    ],
                                  ),
                                ],
                              );
                            return SizedBox();
                          })
                      : SizedBox(),
                ],
              ),
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

  Widget buildKeyValuePairs(String key, String value,
      {bool isDanger = false, TextOverflow overflow}) {
    return Row(
      children: [
        SizedBox(
          width: 80,
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
          child: Container(
            height: 16,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isDanger ? Colors.red : Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  height: 1.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentStatus({String totalAmount, List<double> payments}) {
    var list = payments;
    var total = totalAmount;
    double deposits = 0.0;
    list.forEach((element) {
      deposits += element;
    });
    int n = list.length;
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              // flex: n,
              child: Container(
                height: 1,
                color: (double.parse(total) == deposits)
                    ? Colors.green.shade400
                    : Colors.black,
              ),
            ),
          ],
        ).paddingOnly(top: 6, left: 16, right: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            flex: n,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List<Widget>.generate(n, (i) {
                return Row(
                  children: [
                    buildCircle(color: Colors.black),
                  ],
                );
              }),
            ),
          ),
          (double.parse(total) == deposits)
              ? SizedBox()
              : Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildCircle(color: Colors.red.shade300),
                    ],
                  ),
                ),
          Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 39,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          color: AppColors.text.skyBlue,
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.text.black,
                      ),
                    ),
                  ),
                ],
              )),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: n,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List<Widget>.generate(n, (i) {
                  return buildNumber(
                      text: list[i].toString(),
                      fontWeight: FontWeight.normal,
                      color: Colors.black);
                }),
              ),
            ),
            (double.parse(total) == deposits)
                ? SizedBox()
                : Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildNumber(
                            text: (double.parse(total) - deposits).toString(),
                            color: Colors.red.shade300,
                            fontWeight: FontWeight.normal),
                      ],
                    )),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildNumber(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        text: totalAmount),
                  ],
                )),
          ],
        ).paddingOnly(top: 20),
      ],
    );
  }

  Widget buildCircle({Color color}) {
    return SizedBox(
      width: 39,
      child: Icon(
        Icons.circle,
        size: 10,
        color: color,
      ),
    );
  }

  Widget buildNumber({FontWeight fontWeight, Color color, String text}) {
    return SizedBox(
      width: 39,
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: fontWeight, color: color),
      ),
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
  final String bookingID;
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
  final String receiptNo;
  final String employeeName;
  BookingModel bookingModel;

  ItemModel({
    @required this.phone,
    @required this.activity,
    @required this.bookingID,
    @required this.colorCode,
    @required this.price,
    @required this.time,
    @required this.session,
    @required this.date,
    @required this.cost,
    @required this.paid,
    @required this.receiptNo,
    @required this.balance,
    @required this.remarks,
    @required this.registration,
    this.expanded = false,
    @required this.name,
    @required this.employeeName,
    @required this.pax,
    @required this.email,
    this.bookingModel,
  });

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
      if (bookingModel.theoryDate != null && bookingModel.theoryDate.isNotEmpty)
        d = d + DateFormat("hh:mm").format(bookingModel.theoryDate[0]) + ", ";
      if (bookingModel.poolDate != null && bookingModel.poolDate.isNotEmpty)
        d = d + DateFormat("hh:mm").format(bookingModel.poolDate[0]) + ", ";
      if (bookingModel.diveDate != null && bookingModel.diveDate.isNotEmpty)
        d = d + DateFormat("hh:mm").format(bookingModel.diveDate[0]) + ", ";
      return d.substring(0, d.length - 2);
    }

    log(bookingModel.balance.toString());
    return ItemModel(
      phone: bookingModel.pax[0]["countryCode"] +
          bookingModel.pax[0]["phoneNumber"],
      bookingID: bookingModel.id,
      activity: bookingModel.activity[0].name.toString(),
      price: bookingModel.activity[0].price.toString(),
      colorCode: bookingModel.activity[0].color.toString(),
      date: bookingModel.bookingDate[0],
      cost: bookingModel.totalCost.toString(),
      paid: bookingModel.paid.toString(),
      balance: bookingModel.balance.toString(),
      registration: true,
      receiptNo: bookingModel.receiptNo,
      name: bookingModel.pax[0]["first-name"],
      pax: bookingModel.noOfPersons,
      email: bookingModel.pax[0]["email"],
      remarks: bookingModel.remarks,
      time: getTime(),
      session: getSessions(),
      employeeName: bookingModel.employeeName,
      bookingModel: bookingModel,
    );
  }
}
