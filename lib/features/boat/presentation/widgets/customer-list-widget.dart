import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/booking-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/home/model/colors_data.dart';

class CustomerListWidget extends StatefulWidget {
  final List<ItemModel>? items;
  bool searchBar = true;
  Function? onSearchTap;

  CustomerListWidget({this.items, this.onSearchTap, required this.searchBar});

  @override
  State<CustomerListWidget> createState() => _CustomerListWidgetState();
}

class _CustomerListWidgetState extends State<CustomerListWidget> {
  final CustomerListWidgetLogic logic = CustomerListWidgetLogic();

  final CustomerSearchController searchController =
      Get.put(CustomerSearchController());

  DateTime date = DateTime.now();

  List<Widget> expansions = [];

  TextEditingController searchTED = TextEditingController();

  BookingsCalenderWidgetLogicNew bookingCalenderLogicNew =
      BookingsCalenderWidgetLogicNew();

  generateList(List<ItemModel> itemsList, BuildContext context) {
    if (itemsList.isEmpty) return [Text("No Results Found")];
    logic.controller.isExpanded = [];
    expansions = [];
    for (int i = 0; i < itemsList.length; i++) {
      logic.controller.isExpanded.add(false);
      expansions
          .add(buildCustomer(itemModel: itemsList[i], i: i, context: context));
    }
    return expansions;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerSearchController>(builder: (controller) {
      return Column(
        children: [
          if (widget.searchBar == true) buildSearchBar(),
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

  ///====================UI==================///
  Widget buildCustomer(
      {ItemModel? itemModel, int? i, required BuildContext context}) {
    getColor() {
      if (itemModel!.bookingModel?.cancelBooking == true) {
        return Color(0xffEE9A9D);
      } else {
        String cc = '';

        if (colorsData!.blue.contains(itemModel.activity))
          cc = "Blue";
        else if (colorsData!.purple.contains(itemModel.activity))
          cc = "Purple";
        else if (colorsData!.red.contains(itemModel.activity))
          cc = "Red";
        else if (colorsData!.green.contains(itemModel.activity))
          cc = "Green";
        else if (colorsData!.white.contains(itemModel.activity)) cc = "White";

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

    return GetBuilder<CustomerListWidgetController>(builder: (controller) {
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
            // color: getColor(),
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
                          width: Get.width - 173,
                          child: Text(
                            "${itemModel!.name!.toLowerCase().capitalizeFirst!}  x  ${(itemModel.bookingModel!.noOfPersons.toString())}",
                            style: TextStyle(
                                color: AppColors.text.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 18,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildCustomerStatus(AppColors.text.green),
                              buildCustomerStatus(AppColors.text.grey),
                              buildCustomerStatus(AppColors.text.skyBlue),
                              buildCustomerStatus(Colors.yellow),
                            ],
                          ),
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
                        if (snapshot.connectionState == ConnectionState.done) {
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
                              buildKeyValuePairs(
                                  "Course Name", itemModel.activity),
                              buildKeyValuePairs(
                                "Balance",
                                "${getBalance(itemModel.bookingModel!.payments!, double.parse(itemModel.paid).roundToDouble(), double.parse(itemModel.cost).roundToDouble())} / -",
                              ),
                              buildKeyValuePairs("Session", itemModel.session),
                              buildKeyValuePairs(
                                "Registered",
                                "${itemModel.bookingModel!.pax!.length - 1} / ${itemModel.bookingModel!.noOfPersons}",
                                isDanger:
                                    ((itemModel.bookingModel!.pax!.length -
                                            1) !=
                                        (itemModel.bookingModel!.noOfPersons)),
                              ),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      ...List.generate(
                                        controller.customerStatus.length,
                                        (index) => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                buildCircle(
                                                    color: statusColor(),
                                                    onTap: () {
                                                      setState(() {
                                                        controller
                                                                .customerStatus[
                                                            index] = !controller
                                                                .customerStatus[
                                                            index];
                                                        log(controller
                                                            .customerStatus
                                                            .toString());
                                                      });
                                                    }),
                                                if (index != 3)
                                                  SizedBox(
                                                    width: 13,
                                                    child: Center(
                                                      child: Container(
                                                          height: 40,
                                                          width: 1,
                                                          color: statusColor()),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Container(
                                              height: 15,
                                              child: Center(
                                                child: Text(
                                                  progress(),
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  PopupMenuButton<String>(
                                    child: (logic.controller.boatTED.text == "")
                                        ? Column(
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  "No boat selected",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                height: 31,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Center(
                                                  child: Text("Select Boat",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white)),
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
                                                  fontWeight: FontWeight.bold,
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
                                                logic.controller.boatTED.text =
                                                    e;
                                              });
                                            },
                                            child: Text(
                                              e,
                                              style: TextStyle(fontSize: 12),
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
                                                style: TextStyle(fontSize: 12),
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
                                  SizedBox(width: 30),
                                ],
                              ),
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
    }).paddingSymmetric(vertical: 10);
  }

  String progress() {
    if (logic.controller.customerStatus[0]) {
      return "Paper work";
    } else if (logic.controller.customerStatus[1]) {
      return "Pool Session";
    } else if (logic.controller.customerStatus[2]) {
      return "Dive Session";
    } else if (logic.controller.customerStatus[3]) {
      return "Left dive enter";
    } else {
      return "";
    }
  }

  Color statusColor() {
    if (logic.controller.customerStatus[0]) {
      return AppColors.text.black;
    } else if (logic.controller.customerStatus[1]) {
      return AppColors.text.skyBlue;
    } else if (logic.controller.customerStatus[2]) {
      return AppColors.text.red;
    } else if (logic.controller.customerStatus[3]) {
      return Colors.yellow;
    } else {
      return Colors.grey.shade500;
    }
  }

  Widget buildCircle({required Color color, required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      splashColor: Colors.grey,
      radius: 40,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 13,
        height: 13,
        decoration: BoxDecoration(
            border: Border.all(color: color), shape: BoxShape.circle),
        child: Center(
          child: Icon(
            Icons.circle,
            size: 10,
            color: color,
          ),
        ),
      ),
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    payments.forEach((payment) {
      t += payment.amount!;
    });
    return (total - t).toInt().toString();
  }

  Widget buildKeyValuePairs(String key, String value, {bool isDanger = false}) {
    return Row(
      children: [
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

  Widget buildCustomerStatus(Color color) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    ).paddingSymmetric(horizontal: 3);
  }

  Widget buildSearchBar() {
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

class CustomerListWidgetLogic {
  CustomerListWidgetController controller =
      Get.put(CustomerListWidgetController());
}

class CustomerListWidgetController extends GetxController {
  TextEditingController customTED = TextEditingController();
  List<bool> isExpanded = [];
  TextEditingController boatTED = TextEditingController();
  List<bool> customerStatus = [false, false, false, false];
  List<String> allBoats = [
    "Tucy",
    "007",
    "Batman",
    "Ranga",
    "Traveller",
    "Class Room",
  ];
}

class CustomerSearchController extends GetxController {
  bool _showSearchField = true;

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    update();
  }
}
