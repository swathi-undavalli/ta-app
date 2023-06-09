import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/home/model/colors_data.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class CustomersExpansionPanel extends StatefulWidget {
  final List<ItemModel>? items;
  bool searchBar = true;
  Function? onSearchTap;

  CustomersExpansionPanel({this.items, this.onSearchTap, required this.searchBar});

  @override
  State<CustomersExpansionPanel> createState() => _CustomersExpansionPanelState();
}

class _CustomersExpansionPanelState extends State<CustomersExpansionPanel> {
  final CustomerListWidgetLogic logic = CustomerListWidgetLogic();

  final CustomerSearchController searchController = Get.put(CustomerSearchController());

  DateTime date = DateTime.now();

  List<Widget> expansions = [];

  TextEditingController searchTED = TextEditingController();

  BookingsCalenderWidgetLogicNew bookingCalenderLogicNew = BookingsCalenderWidgetLogicNew();

  generateList(List<ItemModel> itemsList, BuildContext context) {
    if (itemsList.isEmpty) return [Text("No Results Found")];
    logic.controller.isExpanded = [];
    expansions = [];
    for (int i = 0; i < itemsList.length; i++) {
      logic.controller.isExpanded.add(false);
      expansions.add(buildCustomerDetails(itemModel: itemsList[i], i: i, context: context));
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
                  if (item.bookingID!.contains(searchTED.text.trim())) return true;
                  if (item.name!.toLowerCase().contains(searchTED.text.trim().toLowerCase())) return true;
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
  Widget buildCustomerDetails({ItemModel? itemModel, int? i, required BuildContext context}) {
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
                          width: Get.width - 200,
                          child: Text(
                            "${itemModel!.name!.toLowerCase().capitalizeFirst!}  x  ${(itemModel.bookingModel!.noOfPersons.toString())}",
                            style: TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 18,
                          decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(3)),
                          child: Center(
                            child: Text(
                              controller.bookingStatus[controller.customerStatus],
                              style: TextStyle(fontSize: FontSize.small, fontWeight: FontWeight.w600),
                            ),
                          ).paddingSymmetric(horizontal: 3),
                        ),
                      ],
                    ),
                  ).paddingOnly(left: 15),
                  Spacer(),
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                        controller.isExpanded[i] ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
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
                                style: TextStyle(fontSize: FontSize.textSize, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              buildKeyValuePairs("Course Name", itemModel.activity),
                              buildKeyValuePairs(
                                "Balance",
                                "${getBalance(itemModel.bookingModel!.payments!, double.parse(itemModel.paid).roundToDouble(), double.parse(itemModel.cost).roundToDouble())} / -",
                              ),
                              buildKeyValuePairs("Session", itemModel.session),
                              buildKeyValuePairs(
                                "Registered",
                                "${itemModel.bookingModel!.pax!.length - 1} / ${itemModel.bookingModel!.noOfPersons}",
                                isDanger: ((itemModel.bookingModel!.pax!.length - 1) !=
                                    (itemModel.bookingModel!.noOfPersons)),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Instructors / Dive-Buddies :",
                                    style: TextStyle(
                                      fontSize: FontSize.textSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (BuildContext context) {
                                          return EmpSelectorBottomSheet();
                                        },
                                      );
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
                              buildDiverName().paddingOnly(bottom: 6),
                              buildDiverName().paddingOnly(bottom: 6),
                              buildDiverName().paddingOnly(bottom: 6),
                              buildDiverName().paddingOnly(bottom: 6),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 33,
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                                        ),
                                        child: Text(
                                          controller.bookingStatus[controller.customerStatus],
                                          style: TextStyle(fontSize: FontSize.small, fontWeight: FontWeight.w600),
                                        ).paddingOnly(left: 15, right: 15, top: 8),
                                      ),
                                      SizedBox(width: 2),
                                      GestureDetector(
                                        onTap: () {
                                          logic.onBookingStatusPressed();
                                          controller.update();
                                        },
                                        child: Container(
                                          height: 33,
                                          width: 27,
                                          decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                                          ),
                                          child: Icon(
                                            Icons.arrow_right,
                                            size: 16,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  PopupMenuButton<String>(
                                    child: (logic.controller.boatTED.text == "")
                                        ? Column(
                                            children: [
                                              // SizedBox(
                                              //   child: Text(
                                              //     "No boat selected",
                                              //     textAlign: TextAlign.center,
                                              //   ),
                                              // ),
                                              // SizedBox(height: 10),
                                              Container(
                                                height: 31,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: Colors.black, borderRadius: BorderRadius.circular(20)),
                                                child: Center(
                                                  child: Text("Select Boat",
                                                      style: TextStyle(fontSize: 12, color: Colors.white)),
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
                                                    logic.controller.boatTED.text,
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
                                                        decoration: TextDecoration.underline),
                                                  ).paddingOnly(left: 10, right: 7),
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
                                                logic.controller.boatTED.text = e;
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

  Widget buildDiverName() {
    return RichText(
      text: TextSpan(
        text: '1   ',
        style: TextStyle(
          color: Colors.grey[700],
          fontFamily: "Nunito",
          fontSize: 13,
          letterSpacing: 0.3,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        children: const <TextSpan>[
          TextSpan(
            text: 'Mohana',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String progress(int index) {
    if (index == 0) {
      return "Paper work";
    } else if (index == 1) {
      return "Pool Session";
    } else if (index == 2) {
      return "Dive Session";
    } else if (index == 3) {
      return "Left dive center";
    } else {
      return "";
    }
  }

  Widget buildCircle({required Color color}) {
    return Container(
      width: 13,
      height: 13,
      decoration: BoxDecoration(border: Border.all(color: color), shape: BoxShape.circle),
      child: Center(
        child: Icon(
          Icons.circle,
          size: 10,
          color: color,
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

  Widget buildKeyValuePairs(
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
                color: Colors.grey[700], fontSize: 13, letterSpacing: 0.3, fontWeight: FontWeight.w600, height: 1.3),
          ).paddingOnly(right: 10)
        else
          Expanded(
            child: Text(
              key,
              style: TextStyle(
                  color: Colors.grey[700], fontSize: 13, letterSpacing: 0.3, fontWeight: FontWeight.w600, height: 1.3),
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
                    Icon(Icons.search, size: 20, color: AppColors.text.darkgrey),
                    SizedBox(width: 15),
                    Container(
                      width: controller.showSearchField ? 240 : 0,
                      child: TextField(
                        onTap: () {
                          widget.onSearchTap!();
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
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
                            child: Icon(Icons.close_outlined, size: 20, color: AppColors.text.darkgrey),
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

class EmpSelectorBottomSheet extends StatefulWidget {
  const EmpSelectorBottomSheet({
    Key? key,
  }) : super(key: key);

  static show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EmpSelectorBottomSheet();
      },
    );
  }

  @override
  State<EmpSelectorBottomSheet> createState() => _EmpSelectorBottomSheetState();
}

class _EmpSelectorBottomSheetState extends State<EmpSelectorBottomSheet> {
  final CollectionReference employeesCollection = FirebaseFirestore.instance.collection('employees');
  List<Employee> selectedEmployees = [];

  @override
  Widget build(BuildContext context) {
    print(selectedEmployees);
    return Container(
      height: 700,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 30,
              ),
              Text(
                "Manage Divers",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ).paddingOnly(top: 8),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          if (selectedEmployees.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: selectedEmployees
                  .map((e) => InkWell(
                        onTap: () {
                          selectedEmployees.remove(e);
                          setState(() {});
                        },
                        child: Container(
                          height: 30,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e.name),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              spacing: 10,
              runSpacing: 10,
            ).paddingOnly(left: 15, top: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: employeesCollection.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Text('No employees found.');
                }

                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    try {
                      Employee employee = Employee.fromMap(document.data() as Map<String, dynamic>);

                      return InkWell(
                        onTap: () {
                          if (selectedEmployees.contains(employee)) {
                            selectedEmployees.remove(employee);
                          } else {
                            selectedEmployees.add(employee);
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            Container(
                              child: Text(
                                employee.name,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ).paddingOnly(
                                left: 30,
                                top: 10,
                                bottom: 10,
                              ),
                            ),
                            Spacer(),
                            if (selectedEmployees.contains(employee))
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      return SizedBox();
                    }
                  }).toList(),
                ).paddingOnly(top: 20);
              },
            ),
          ),
        ],
      ),
    );
  }
}

int getCount() {
  if (counterModel != null && counterModel!.employee != null) return counterModel?.employee ?? 100;
  return 100;
}

class CustomerListWidgetLogic {
  CustomerListWidgetController controller = Get.put(CustomerListWidgetController());

  void onBookingStatusPressed() {
    if (controller.customerStatus < 4) {
      controller.customerStatus += 1;
      print(controller.customerStatus);
    } else {
      controller.customerStatus = 0;
    }
  }
}

class CustomerListWidgetController extends GetxController {
  TextEditingController customTED = TextEditingController();
  List<bool> isExpanded = [];
  int customerStatus = 0;
  TextEditingController boatTED = TextEditingController();
  List<String> allBoats = [
    "Tucy",
    "007",
    "Batman",
    "Ranga",
    "Traveller",
    "Class Room",
  ];
  List<String> bookingStatus = ["Booking Done", "Paper work", "Pool Session", "Dive Session", "Left Dive Center"];
}

class CustomerSearchController extends GetxController {
  bool _showSearchField = true;

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    update();
  }
}
