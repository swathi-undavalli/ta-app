import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/booking-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/customer-expansion-panel-controller.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/employee-selector-bottomSheet.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/home/model/colors_data.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class CustomersExpansionPanel extends StatefulWidget {
  final List<ItemModel>? items;
  final bool showSearchBar;
  final Function? onSearchTap;

  CustomersExpansionPanel(
      {this.items, this.onSearchTap, this.showSearchBar = true});

  @override
  State<CustomersExpansionPanel> createState() =>
      _CustomersExpansionPanelState();
}

class _CustomersExpansionPanelState extends State<CustomersExpansionPanel> {
  final CustomerExpansionPanelLogic logic = CustomerExpansionPanelLogic();

  final CustomerSearchController searchController =
      Get.put(CustomerSearchController());

  DateTime date = DateTime.now();

  List<Widget> expansions = [];

  TextEditingController searchTED = TextEditingController();

  BookingsCalenderWidgetLogicNew bookingCalenderLogicNew =
      BookingsCalenderWidgetLogicNew();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerSearchController>(builder: (controller) {
      return Column(
        children: [
          if (widget.showSearchBar == true) _buildSearchBar(),
          if (controller.showSearchField)
            ...generateList(
                widget.items!.where((ItemModel item) {
                  if (item.bookingID!.contains(searchTED.text.trim()))
                    return true;
                  if (item.name!
                      .toLowerCase()
                      .contains(searchTED.text.trim().toLowerCase()))
                    return true;
                  return false;
                }).toList(),
                context)
          else
            ...generateList(widget.items!, context)
        ],
      );
    });
  }

  List<Widget> generateList(List<ItemModel> itemsList, BuildContext context) {
    if (itemsList.isEmpty) return [Text("No Results Found")];
    logic.controller.isExpanded = [];
    expansions = [];
    for (int i = 0; i < itemsList.length; i++) {
      logic.controller.isExpanded.add(false);
      expansions.add(_buildCustomerDetails(
          bookingItemModel: itemsList[i], i: i, context: context));
    }
    return expansions;
  }

  Widget _buildCustomerDetails(
      {ItemModel? bookingItemModel, int? i, required BuildContext context}) {
    getColor() {
      if (bookingItemModel!.bookingModel?.cancelBooking == true) {
        return Color(0xffEE9A9D);
      } else {
        String cc = '';

        if (colorsData!.blue.contains(bookingItemModel.activity))
          cc = "Blue";
        else if (colorsData!.purple.contains(bookingItemModel.activity))
          cc = "Purple";
        else if (colorsData!.red.contains(bookingItemModel.activity))
          cc = "Red";
        else if (colorsData!.green.contains(bookingItemModel.activity))
          cc = "Green";
        else if (colorsData!.white.contains(bookingItemModel.activity))
          cc = "White";

        if (cc == "Blue")
          return Color(0xffA9EBF8).withOpacity(0.3);
        else if (cc == "Purple")
          return Color(0xffDDB3FF);
        else if (cc == "Red")
          return Color(0xffF8FF96);
        else if (cc == "Green")
          return Color(0xff96F1BD);
        else if (cc == "White") return Color(0xffE0E0E0);
      }
    }

    final DocumentReference bookingDoc = FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingItemModel?.bookingID);
    log("aggipetti");
    return GetBuilder<CustomerExpansionPanelController>(builder: (controller) {
      return StreamBuilder(
        stream: bookingDoc.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }
          final data = snapshot.data?.data();

          if (data == null) {
            return Text('Document does not exist');
          }
          BookingModel bookingModel =
              BookingModel.fromMap(data as Map<String, dynamic>);
          log("booking model ${bookingModel.toMap()}");
          ItemModel itemModel = ItemModel.fromBookings(bookingModel);
          log("item model ${itemModel}");

          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInCubic,
            alignment: Alignment.topCenter,
            constraints: BoxConstraints(
              minHeight: controller.isExpanded[i!] ? 500 : 50,
            ),
            width: Get.width,
            decoration: BoxDecoration(
              color: getColor(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: Get.width - 103,
                        child: Row(
                          children: [
                            SizedBox(
                              width: Get.width - 200,
                              child: Text(
                                "${itemModel.name!.toLowerCase().capitalizeFirst!}  x  ${(itemModel.bookingModel!.noOfPersons.toString())}",
                                style: TextStyle(
                                    color: AppColors.text.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 18,
                              decoration: BoxDecoration(
                                  color: getProgressColor(
                                      controller.customerStatus),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Center(
                                child: Text(
                                  controller
                                      .bookingStatus[controller.customerStatus],
                                  style: TextStyle(
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w600),
                                ),
                              ).paddingSymmetric(horizontal: 3),
                            ),
                          ],
                        ),
                      ).paddingOnly(left: 15),
                      Spacer(),
                      IconButton(
                        splashRadius: 20,
                        icon: Icon(controller.isExpanded[i]
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded),
                        onPressed: () {
                          controller.isExpanded[i] = !controller.isExpanded[i];
                          controller.update();
                        },
                      ),
                    ],
                  ).paddingSymmetric(vertical: 3),
                  controller.isExpanded[i]
                      ? FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 200)),
                          initialData: SizedBox(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Text(
                                    "Booking Details : ",
                                    style: TextStyle(
                                        fontSize: FontSize.textSize,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 10),
                                  _buildKeyValuePairs(
                                      "Course Name", itemModel.activity),
                                  _buildKeyValuePairs(
                                    "Balance",
                                    "${getBalance(itemModel.bookingModel!.payments!, double.parse(itemModel.paid).roundToDouble(), double.parse(itemModel.cost).roundToDouble())} / -",
                                  ),
                                  _buildKeyValuePairs(
                                      "Session", itemModel.session),
                                  _buildKeyValuePairs(
                                    "Registered",
                                    "${itemModel.bookingModel!.pax!.length - 1} / ${itemModel.bookingModel!.noOfPersons}",
                                    isDanger: ((itemModel
                                                .bookingModel!.pax!.length -
                                            1) !=
                                        (itemModel.bookingModel!.noOfPersons)),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Get.width - 170,
                                        child: Text(
                                          "Instructors / Dive-Buddies :",
                                          style: TextStyle(
                                            fontSize: FontSize.textSize,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          List<Instructor>? instructors =
                                              await EmpSelectorBottomSheet.show(
                                            context,
                                            initialSelectedEmployees: itemModel
                                                    .bookingModel
                                                    ?.boatDetails
                                                    ?.instructors ??
                                                [],
                                          );

                                          log("lajshjc  $instructors");

                                          BoatDetails? boatDetails = itemModel
                                              .bookingModel?.boatDetails
                                              ?.copyWith(
                                                  instructors: instructors);
                                          if (boatDetails == null) {
                                            boatDetails = BoatDetails(
                                              instructors: instructors,
                                            );
                                          }

                                          log("lajshjc  $boatDetails");

                                          await FirebaseFirestore.instance
                                              .collection('bookings')
                                              .doc(itemModel.bookingModel?.id ??
                                                  "")
                                              .set({
                                            "boatDetails": boatDetails.toMap()
                                          }, SetOptions(merge: true));

                                          controller.update();
                                        },
                                        child: Container(
                                          height: 31,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Manage",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  if (itemModel.bookingModel?.boatDetails
                                          ?.instructors !=
                                      null)
                                    ...itemModel
                                        .bookingModel!.boatDetails!.instructors!
                                        .map(
                                      (e) {
                                        return _buildDiverName(
                                                e.name,
                                                itemModel.bookingModel!
                                                    .boatDetails!.instructors!
                                                    .indexOf(e))
                                            .paddingOnly(bottom: 6);
                                      },
                                    ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      _buildBookingStatus(controller),
                                      Spacer(),
                                      PopupMenuButton<String>(
                                        child: (logic.controller.boatTED.text ==
                                                "")
                                            ? Column(
                                                children: [
                                                  Container(
                                                    height: 31,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Center(
                                                      child: Text("Select Boat",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
                                                  Text(
                                                    "Selected Boat :",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // decoration: TextDecoration.underline
                                                    ),
                                                  ).paddingAll(5),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        logic.controller.boatTED
                                                            .text,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          // fontWeight: FontWeight.bold,
                                                        ),
                                                      ).paddingAll(5),
                                                      Text(
                                                        "Change",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.blue,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                      ).paddingOnly(
                                                          left: 10, right: 7),
                                                      Icon(
                                                        Icons.edit,
                                                        size: 12,
                                                        color: Colors.blue,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            ...logic.controller.allBoats.map(
                                              (e) => PopupMenuItem<String>(
                                                value: e,
                                                onTap: () {
                                                  setState(() {
                                                    logic.controller.boatTED
                                                        .text = e;
                                                  });
                                                },
                                                child: Text(
                                                  e,
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem<String>(
                                              value: "Add custom",
                                              onTap: () {},
                                              child: Column(
                                                children: [
                                                  Divider(
                                                    color: Colors.black26,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    "Add custom",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ).paddingOnly(bottom: 2),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                        onSelected: (String value) {
                                          if (value == 'Add custom') {
                                            showTextFieldDialog(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  AppTextField(
                                    hintText: "Equipment Notes",
                                    errorValidator: () {
                                      return null;
                                    },
                                    validator: (_) {
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(height: 20),
                                ],
                              ).paddingSymmetric(horizontal: 15);
                            }
                            return SizedBox();
                          })
                      : SizedBox(),
                ],
              ),
            ),
          );
        },
      );
    }).paddingSymmetric(vertical: 10);
  }

  Widget _buildBookingStatus(CustomerExpansionPanelController controller) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            logic.onBookingStatusLeftArrowPressed();
            controller.update();
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: getProgressColor(controller.customerStatus),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
            ),
            child: Icon(
              Icons.arrow_left,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 2),
        Container(
          height: 33,
          decoration: BoxDecoration(
            color: getProgressColor(controller.customerStatus),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
          ),
          child: Text(
            controller.bookingStatus[controller.customerStatus],
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w600),
          ).paddingOnly(left: 15, right: 15, top: 8),
        ),
        SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            logic.onBookingStatusRightArrowPressed();
            controller.update();
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: getProgressColor(controller.customerStatus),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4)),
            ),
            child: Icon(
              Icons.arrow_right,
              size: 16,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDiverName(String text, int index) {
    return RichText(
      text: TextSpan(
        text: (index + 1).toString(),
        style: TextStyle(
          color: Colors.grey[700],
          fontFamily: "Nunito",
          fontSize: 13,
          letterSpacing: 0.3,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        children: <TextSpan>[
          TextSpan(
            text: "   $text",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color getProgressColor(int index) {
    if (index == 0) {
      return Colors.white70;
    } else if (index == 1) {
      return Colors.black26;
    } else if (index == 2) {
      return AppColors.text.skyBlue.withOpacity(0.5);
    } else if (index == 3) {
      return Colors.red.withOpacity(0.7);
    } else if (index == 4) {
      return Colors.yellow.withOpacity(0.7);
    } else {
      return Colors.white70;
    }
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    payments.forEach((payment) {
      t += payment.amount!;
    });
    return (total - t).toInt().toString();
  }

  Widget _buildKeyValuePairs(
    String key,
    String value, {
    bool isDanger = false,
    bool shrinkKey = false,
  }) {
    return Row(
      children: [
        if (shrinkKey)
          Text(
            key,
            style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
                letterSpacing: 0.3,
                fontWeight: FontWeight.w600,
                height: 1.3),
          ).paddingOnly(right: 10)
        else
          Expanded(
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
        Container(
          height: 16,
          width: 170,
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
      ],
    ).paddingOnly(bottom: 6);
  }

  void showTextFieldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Boat'),
          content: AppTextField(
            controller: logic.controller.customTED,
            hintText: "Add",
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Get.back();
                logic.controller.customTED.text = "";
              },
            ),
            TextButton(
              child: Text('Ok', style: TextStyle(color: Colors.black)),
              onPressed: () {
                logic.controller.allBoats.add(logic.controller.customTED.text);
                Get.back();
                logic.controller.customTED.text = "";
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return GetBuilder<CustomerSearchController>(builder: (controller) {
      return (controller.showSearchField && widget.items!.length > 5)
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
                          widget.onSearchTap!();
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
}

int getCount() {
  if (counterModel != null && counterModel!.employee != null)
    return counterModel?.employee ?? 100;
  return 100;
}

class CustomerSearchController extends GetxController {
  bool _showSearchField = true;

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    update();
  }
}
