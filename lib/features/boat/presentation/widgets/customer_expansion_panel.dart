import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'customer_expandable_list_tile.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import 'customer_expansion_panel_controller.dart';

class CustomersExpansionPanel extends StatefulWidget {
  final List<ItemModel>? items;
  final bool showSearchBar;
  final Function? onSearchTap;
  final DateTime selectedDate;

  const CustomersExpansionPanel({Key? key, this.items, this.onSearchTap, this.showSearchBar = true, required this.selectedDate}) : super(key: key);

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
                  if (item.bookingID!.contains(searchTED.text.trim())) {
                    return true;
                  }
                  if (item.name!
                      .toLowerCase()
                      .contains(searchTED.text.trim().toLowerCase())) {
                    return true;
                  }
                  return false;
                }).toList(),
                context,)
          else
            ...generateList(widget.items!, context)
        ],
      );
    },);
  }

  List<Widget> generateList(List<ItemModel> itemsList, BuildContext context) {
    if (itemsList.isEmpty) return [const Text('No Results Found')];
    logic.controller.isExpanded = [];
    expansions = [];
    for (int i = 0; i < itemsList.length; i++) {
      logic.controller.isExpanded.add(false);
      expansions.add(_buildCustomerDetails(
          itemModel: itemsList[i], i: i, context: context,),);
    }
    return expansions;
  }

  Widget _buildCustomerDetails(
      {required ItemModel itemModel, int? i, required BuildContext context,}) {
    return CustomerExpandableListTile(
      title:
          '${itemModel.name!.toLowerCase().capitalizeFirst!}  x  ${(itemModel.bookingModel!.noOfPersons.toString())}',
      color: getBookingColor(itemModel),
      itemModel: itemModel,
      selectedDate: widget.selectedDate,
    ).paddingSymmetric(vertical: 10);
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
                    borderRadius: BorderRadius.circular(10),),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search,
                        size: 20, color: AppColors.text.darkgrey,),
                    const SizedBox(width: 15),
                    SizedBox(
                      width: controller.showSearchField ? 240 : 0,
                      child: TextField(
                        onTap: () {
                          widget.onSearchTap!();
                        },
                        decoration: const InputDecoration(
                            enabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            focusedBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            disabledBorder:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Search...',
                            hintStyle: TextStyle(fontSize: 14, height: 1),),
                        controller: searchTED,
                        onChanged: (text) {
                          searchController.update();
                        },
                      ),
                    ),
                    (searchTED.text != '')
                        ? GestureDetector(
                            onTap: () {
                              searchTED.text = '';
                              searchController.update();
                            },
                            child: Icon(Icons.close_outlined,
                                size: 20, color: AppColors.text.darkgrey,),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            )
          : const SizedBox();
    },);
  }
}

class CustomerSearchController extends GetxController {
  bool _showSearchField = true;

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    update();
  }
}
