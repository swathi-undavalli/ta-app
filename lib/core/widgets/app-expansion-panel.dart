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
import 'package:temple_adventures/d1.dart';
import 'package:temple_adventures/features/boat/presentation/screens/chooseBoat-page.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/select-seats-widget.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/IDProofScreen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/add-guest-details-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/edit-booking/presentation/screens/edit-booking-new-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bookings_calender_widget/bookings_calender_widget.dart';

class BookingsExpansionPanel extends StatelessWidget {
  final ExpansionPanelLogic logic = ExpansionPanelLogic();
  final SearchController searchController = Get.put(SearchController());
  final List<ItemModel> items;
  bool searchBar = true;
  DateTime date = DateTime.now();
  Function onDeletePressed;
  Function onSearchTap;
  List<Widget> expansions = [];
  TextEditingController depositTED = TextEditingController();

  TextEditingController searchTED = TextEditingController();
  BookingsCalenderWidgetLogic bookingCalenderLogic =
      BookingsCalenderWidgetLogic();

  BookingsExpansionPanel(
      {this.items,
      this.onDeletePressed,
      this.onSearchTap,
      @required this.searchBar});

  generateList(List<ItemModel> itemsList) {
    if (itemsList.isEmpty) return [Text("No Results Found")];
    logic.controller.isExpanded = [];
    expansions = [];
    for (int i = 0; i < itemsList.length; i++) {
      logic.controller.isExpanded.add(false);
      expansions.add(buildExpansion(itemModel: itemsList[i], i: i));
    }
    return expansions;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(builder: (controller) {
      return Column(
        children: [
          if (searchBar == true) buildSearchBar(),
          if (controller.showSearchField)
            ...generateList(items.where((ItemModel item) {
              if (item.bookingID.contains(searchTED.text.trim())) return true;
              if (item.name
                  .toLowerCase()
                  .contains(searchTED.text.trim().toLowerCase())) return true;
              return false;
            }).toList())
          else
            ...generateList(items)
        ],
      );
    });
  }

  Widget buildSearchBar() {
    return GetBuilder<SearchController>(builder: (controller) {
      return (controller.showSearchField && items.length > 5)
          ? Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: AnimatedContainer(
                width: controller.showSearchField ? 380 : 0,
                duration: const Duration(milliseconds: 500),
                height: 47,
                decoration: BoxDecoration(
                    color: AppColors.background.white,
                    // border: Border.all(color: Colors.black, width: 0.50),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search,
                        size: 20, color: AppColors.text.darkgrey),
                    SizedBox(width: 15),
                    Container(
                      width: controller.showSearchField ? 240 : 0,
                      child: TextField(
                        onTap: () {
                          onSearchTap();
                        },
                        decoration: InputDecoration(
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            disabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: 14, height: 1)),
                        controller: searchTED,
                        onChanged: (text) {
                          searchController.update();
                        },
                      ),
                    ),
                    (searchTED.text != "")
                        ? GestureDetector(
                            onTap: () {
                              searchTED.text = "";
                              searchController.update();
                            },
                            child: Icon(Icons.close_outlined,
                                size: 20, color: AppColors.text.darkgrey),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            )
          : SizedBox();
    });
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
          // height: controller.isExpanded[i] ? 400 : 50,
          constraints: BoxConstraints(
            minHeight: controller.isExpanded[i] ? 400 : 50,
          ),
          // height: controller.isExpanded[i] ? 470 : 50,
          width: 350,
          decoration: BoxDecoration(
            color: getColor(),
            borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: AppColors.text.grey),
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: controller.isExpanded[i] ? 400 : 50,
            ),
            decoration: BoxDecoration(
              color: getColor(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                              color: getBalance(
                                          items[i].bookingModel.payments,
                                          double.parse(items[i].paid)
                                              .roundToDouble(),
                                          double.parse(items[i].cost)
                                              .roundToDouble()) ==
                                      "0"
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  itemModel.name
                                      .trim()
                                      .toLowerCase()
                                      .capitalizeFirst,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppColors.text.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                " x " +
                                    (itemModel.bookingModel.noOfPersons
                                        .toString()),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.text.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        // Spacer(),
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
                            //log("tapped");
                            controller.isExpanded[i] =
                                !controller.isExpanded[i];
                            //log(controller.isExpanded.toString());
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
                                      "Total Cost",
                                      double.parse(items[i].cost)
                                          .roundToDouble()
                                          .toString()),
                                  buildKeyValuePairs(
                                      "Deposit",
                                      double.parse(items[i].paid)
                                          .roundToDouble()
                                          .toString()),
                                  buildKeyValuePairs(
                                    "Balance",
                                    getBalance(
                                        items[i].bookingModel.payments,
                                        double.parse(items[i].paid)
                                            .roundToDouble(),
                                        double.parse(items[i].cost)
                                            .roundToDouble()),
                                  ),
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
                                  SizedBox(height: 30),
                                  buildPaymentStatus(
                                    totalAmount:
                                        items[i].bookingModel.totalCost,
                                    payments: [
                                      PaymentModel(
                                        amount: double.parse(items[i].paid)
                                            .roundToDouble(),
                                        collectedBy: items[i].employeeName,
                                        reciptNo: "-",
                                        referenceNo: "-",
                                        remarks: "-",
                                        paymentMode: "-",
                                        time: items[i].bookingModel.createdAt,
                                      ),
                                      ...items[i].bookingModel.payments
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      if (bookingCalenderLogic
                                                  .controller.selectedType ==
                                              FilterType.Dive &&
                                          items[i].bookingModel.pax.length -
                                                  1 ==
                                              items[i].bookingModel.noOfPersons)
                                        SelectSeatsWidget(
                                            items[i].bookingModel),
                                      Spacer(),
                                      Container(
                                        child: AppButton.miniFlat(
                                          text: "Add Payment",
                                          onTap: () {
                                            Get.defaultDialog(
                                              contentPadding: EdgeInsets.only(
                                                  left: 30,
                                                  right: 30,
                                                  top: 20,
                                                  bottom: 30),
                                              title: "\n Add Payment",
                                              content: TextField(
                                                controller: depositTED,
                                                cursorColor:
                                                    AppColors.text.darkgrey,
                                                cursorHeight: 17,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Deposit",
                                                  labelStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                      items[i]
                                                          .bookingModel
                                                          .payments
                                                          .add(
                                                            PaymentModel(
                                                              amount:
                                                                  double.parse(
                                                                      depositTED
                                                                          .text),
                                                              collectedBy:
                                                                  currentEmployee
                                                                      .name,

                                                              //TODO:: FIX THE BELOW URGENT !!!!!.

                                                              reciptNo: "-",
                                                              referenceNo: "-",
                                                              paymentMode: "-",
                                                              time: DateTime
                                                                  .now(),
                                                            ),
                                                          );

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "bookings")
                                                          .doc(items[i]
                                                              .bookingModel
                                                              .id)
                                                          .set(items[i]
                                                              .bookingModel
                                                              .toMap());
                                                      Get.back();
                                                      depositTED.text = "";
                                                      BookingsCalenderWidgetLogic
                                                          bookingCalenderLogic =
                                                          BookingsCalenderWidgetLogic();
                                                      bookingCalenderLogic
                                                          .onDateSelected(
                                                        bookingCalenderLogic
                                                            .controller
                                                            .lastDateIndex,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              barrierDismissible: false,
                                              radius: 10,
                                            );

                                            // Get.toNamed(IDProofScreen.id,
                                            //     arguments:
                                            //         items[i].bookingModel);
                                            // Get.toNamed(W2.id);
                                          },
                                        ).paddingOnly(right: 15),
                                        // alignment: Alignment.centerRight,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
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
                                      // AppButton.miniFlat(
                                      //   text: "Get Link",
                                      //   onTap: () async {
                                      //     String link =
                                      //         "https://seismic-glow-283418.web.app/?booking=${items[i].bookingModel.id}";
                                      //     await Clipboard.setData(
                                      //         ClipboardData(text: link));
                                      //     Fluttertoast.showToast(
                                      //         msg: "Link copied to Clipboard");
                                      //   },
                                      // ).paddingOnly(right: 15),
                                      (items[i].bookingModel.pax.length - 1) !=
                                              (items[i]
                                                  .bookingModel
                                                  .noOfPersons)
                                          ? AppButton.miniFlat(
                                              text: "Add Info",
                                              onTap: () {
                                                Get.toNamed(
                                                    GuestDetailsScreen.id,
                                                    arguments:
                                                        items[i].bookingModel);
                                              },
                                            ).paddingOnly(right: 15)
                                          : SizedBox(),
                                    ],
                                  ),
                                  SizedBox(height: 20),
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

  Widget buildKeyValuePairs(String key, String value, {bool isDanger = false}) {
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

  Widget buildPaymentStatus({
    @required double totalAmount,
    @required List<PaymentModel> payments,
  }) {
    double deposits = 0.0;

    payments.forEach((payment) {
      deposits += payment.amount;
    });

    int n = payments.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: (totalAmount == deposits)
                        ? Colors.green.shade400
                        : Colors.black,
                  ),
                ),
              ],
            ).paddingOnly(top: 7, left: 16, right: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: n,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(n, (i) {
                      return buildCircle(color: Colors.black);
                    }),
                  ),
                ),
                (totalAmount == deposits)
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
                    flex: 1,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: n,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(n, (i) {
                      return buildNumber(
                          text: payments[i].amount.round().toString(),
                          fontWeight: FontWeight.normal,
                          color: Colors.black);
                    }),
                  ),
                ),
                (totalAmount == deposits)
                    ? SizedBox()
                    : Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildNumber(
                                text:
                                    (totalAmount - deposits).round().toString(),
                                // text: "16000",
                                color: Colors.red.shade300,
                                fontWeight: FontWeight.normal),
                          ],
                        )),
                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildNumber(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            text: totalAmount.toString()),
                      ],
                    )),
              ],
            ).paddingOnly(top: 20),
          ],
        ).paddingOnly(right: 20),
        SizedBox(height: 20),
        ...List.generate(
          payments.length,
          (index) {
            return buildTransactions(payment: payments[index]);
          },
        )
      ],
    );
  }

  Widget buildTransactions({PaymentModel payment}) {
    DateTime now = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
        ).paddingOnly(top: 2),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Paid ${payment.amount.round()} to ${payment.collectedBy}",
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w600, wordSpacing: 2),
            ),
            SizedBox(height: 2),
            if (payment.time != null &&
                now.day == payment.time.day &&
                now.month == payment.time.month &&
                now.year == payment.time.year)
              Text(
                "Today - ${DateFormat("hh:mm a").format(payment.time)}",
                style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
              )
            else if (payment.time != null)
              Text(
                DateFormat("EEE dd MMM yy - hh:mm a").format(payment.time),
                style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
              )
            else
              Text(
                "Initial Deposit",
                style: TextStyle(fontSize: 10, color: AppColors.text.darkgrey),
              ),
          ],
        ),
      ],
    ).paddingOnly(bottom: 10);
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
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 10, fontWeight: fontWeight, color: color),
        ),
      ),
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    payments.forEach((payment) {
      t += payment.amount;
    });
    return (total - t).toInt().toString();
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

    //log(bookingModel.balance.toString());
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

class SearchController extends GetxController {
  bool _showSearchField = true;

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    update();
  }
}
