import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/core/widgets/booking-expansion-panel.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/home/model/colors_data.dart';

class CustomerListWidget extends StatelessWidget {
  final CustomerListWidgetLogic logic = CustomerListWidgetLogic();

  final CustomerSearchController searchController =
      Get.put(CustomerSearchController());
  final List<ItemModel>? items;
  bool searchBar = true;
  DateTime date = DateTime.now();
  Function? onSearchTap;
  List<Widget> expansions = [];
  TextEditingController searchTED = TextEditingController();

  BookingsCalenderWidgetLogicNew bookingCalenderLogicNew =
      BookingsCalenderWidgetLogicNew();

  CustomerListWidget({this.items, this.onSearchTap, required this.searchBar});

  generateList(List<ItemModel> itemsList, BuildContext context) {
    if (itemsList.isEmpty) return [Text("No Results Found")];
    expansions = [];
    for (int i = 0; i < itemsList.length; i++) {
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
          if (searchBar == true) buildSearchBar(),
          if (controller.showSearchField)
            ...generateList(
                items!.where((ItemModel item) {
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
            ...generateList(items!, context)
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

    final button = PopupMenuButton<String>(
      icon: TAImage(
        AppImages.icon.add,
        color: Colors.black,
        height: 20,
        width: 20,
      ),
      itemBuilder: (BuildContext context) {
        return [
          ...logic.controller.allBoats.map(
            (e) => PopupMenuItem<String>(
              value: e,
              onTap: () {},
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
    );

    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: getColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
              SizedBox(height: 5),
              Container(
                width: Get.width - 103,
                child: Text(
                  itemModel.activity,
                  style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ).paddingOnly(left: 15),
          Spacer(),
          button,
        ],
      ).paddingSymmetric(vertical: 10),
    ).paddingSymmetric(vertical: 10);
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
      return (controller.showSearchField && items!.length > 5)
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
                          onSearchTap!();
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
