import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/booking-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boat-selector.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/customer-booking-status.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/customer-expansion-panel-controller.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/customer-expandable-listTile.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/employee-selector-bottomSheet.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/home/model/colors_data.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

import '../../../conditions/controller/conditions-controller.dart';

class CustomersExpansionPanel extends StatefulWidget {
  final List<ItemModel>? items;
  final bool showSearchBar;
  final Function? onSearchTap;
  final DateTime selectedDate;

  CustomersExpansionPanel(
      {this.items,
      this.onSearchTap,
      this.showSearchBar = true,
      required this.selectedDate});

  @override
  State<CustomersExpansionPanel> createState() =>
      _CustomersExpansionPanelState();
}

class _CustomersExpansionPanelState extends State<CustomersExpansionPanel> {
  final CustomerExpansionPanelLogic logic = CustomerExpansionPanelLogic();

  final CustomerSearchController searchController =
      Get.put(CustomerSearchController());

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
    Color getColor() {
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
      return Colors.white;
    }

    final DocumentReference bookingDoc = FirebaseFirestore.instance
        .collection('bookings')
        .doc(bookingItemModel?.bookingID);
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

        return ExpandableListTile(
          expandedChild: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                "Booking Details : ",
                style: TextStyle(
                    fontSize: FontSize.textSize, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              _buildKeyValuePairs("Course Name", itemModel.activity),
              _buildKeyValuePairs(
                "Balance",
                "${getBalance(itemModel.bookingModel!.payments!, double.parse(itemModel.paid).roundToDouble(), double.parse(itemModel.cost).roundToDouble())} / -",
              ),
              _buildKeyValuePairs("Session", itemModel.session),
              _buildKeyValuePairs(
                "Registered",
                "${itemModel.bookingModel!.pax!.length - 1} / ${itemModel.bookingModel!.noOfPersons}",
                isDanger: ((itemModel.bookingModel!.pax!.length - 1) !=
                    (itemModel.bookingModel!.noOfPersons)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        initialSelectedEmployees:
                            itemModel.bookingModel?.boatDetails?.instructors ??
                                [],
                      );

                      await updateBoatDetails(itemModel,
                          instructors: instructors);
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
              if (itemModel.bookingModel?.boatDetails?.instructors != null)
                ...itemModel.bookingModel!.boatDetails!.instructors!.map(
                  (e) {
                    return _buildDiverName(
                            e.name,
                            itemModel.bookingModel!.boatDetails!.instructors!
                                .indexOf(e))
                        .paddingOnly(bottom: 6);
                  },
                ),
              SizedBox(height: 20),
              Row(
                children: [
                  BookingStatus(
                    initialStatus: bookingModel.boatDetails?.bookingStatus ?? 0,
                    onChanged: (int status) async {
                      await updateBoatDetails(itemModel, bookingStatus: status);
                    },
                  ),
                  Spacer(),
                  BoatSelector(
                    boatName: bookingModel.boatDetails?.boatName ?? "",
                    boatId: bookingModel.boatDetails?.boatId ?? "",
                    onChanged: (List<String> boatDetails) async {
                      await updateBoatDetails(itemModel,
                          boatId: boatDetails[0], boatName: boatDetails[1]);
                    },
                    selectedDate: widget.selectedDate,
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
          ),
          title:
              "${itemModel.name!.toLowerCase().capitalizeFirst!}  x  ${(itemModel.bookingModel!.noOfPersons.toString())}",
          color: getColor(),
        );
      },
    ).paddingSymmetric(vertical: 10);
  }

  Future<void> updateBoatDetails(
    ItemModel itemModel, {
    String? boatId,
    String? boatName,
    int? bookingStatus,
    String? employeeNotes,
    List<Instructor>? instructors,
  }) async {
    BoatDetails? boatDetails = itemModel.bookingModel?.boatDetails?.copyWith(
      instructors: instructors,
      boatId: boatId,
      boatName: boatName,
      employeeNotes: employeeNotes,
      bookingStatus: bookingStatus,
    );

    if (boatDetails == null) {
      boatDetails = BoatDetails(
        instructors: instructors,
      );
    }

    log("lajshjc  $boatDetails");

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(itemModel.bookingModel?.id ?? "")
        .set({"boatDetails": boatDetails.toMap()}, SetOptions(merge: true));
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
