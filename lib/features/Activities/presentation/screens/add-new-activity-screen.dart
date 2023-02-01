import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/Activities/controller/add-new-activity-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class AddNewActivityScreen extends StatelessWidget {
  static const String id = "AddNewActivityScreen";
  final AddNewActivityLogic logic = AddNewActivityLogic();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: WillPopScope(
        onWillPop: () async {
          logic.controller.reset();
          return true;
        },
        child: SafeArea(
          child: GetBuilder<AddNewActivityController>(builder: (controller) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildTextFields(
                          name: "Name",
                          textEditingController: controller.nameTED,
                          focusNode: controller.nameNode,
                          nextFocusNode: controller.priceNode),
                      buildTextFields(
                        name: "Price",
                        textEditingController: controller.priceTED,
                        focusNode: controller.priceNode,
                        nextFocusNode: controller.priorityNode,
                        keyBoardType: TextInputType.number,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          children: [
                            buildSubtitle("Priority"),
                            buildPriority(),
                            buildSubtitle("Color Code"),
                            buildColorCode(),
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildCancelButton(),
                          buildSubmitButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  ///===========UI============///

  Widget buildSubtitle(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 30),
      child: Container(
        width: Get.size.width,
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black54,
            fontFamily: AppFonts.nunito,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget buildPriority() {
    return GetBuilder<AddNewActivityController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DropdownButton(
          focusNode: controller.priorityNode,
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: controller.priorityTED.text.isNotEmpty
              ? controller.priorityTED.text
              : null,
          onChanged: (dynamic priority) {
            controller.priorityTED.text = priority;
            controller.update();
          },
          items: controller.priority.map((priority) {
            return DropdownMenuItem(
              child: new Text(priority),
              value: priority,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildColorCode() {
    return GetBuilder<AddNewActivityController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DropdownButton(
          focusNode: controller.colorNode,
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: controller.colorTED.text.isNotEmpty
              ? controller.colorTED.text
              : null,
          onChanged: (dynamic newColor) {
            controller.colorTED.text = newColor;
            controller.update();
          },
          items: controller.colorCode.map((color) {
            return DropdownMenuItem(
              child: new Text(color),
              value: color,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTitle() {
    return Text(
      'Add Activity',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildCancelButton() {
    return Center(
      child: AppButton.flat(
        text: "Cancel",
        textColor: AppColors.text.black,
        color: AppColors.background.grey,
        onTap: () {
          logic.controller.reset();
          Get.back();
        },
      ),
    );
  }

  Widget buildSubmitButton() {
    return Center(
      child: AppButton.flat(
        text: "Submit",
        textColor: AppColors.text.white,
        color: AppColors.background.black,
        onTap: () {
          logic.onSubmit();
        },
      ),
    );
  }

  Widget buildTextFields(
      {String? name,
      TextEditingController? textEditingController,
      FocusNode? focusNode,
      FocusNode? nextFocusNode,
      TextInputType? keyBoardType}) {
    return GetBuilder<AddNewActivityController>(builder: (controller) {
      return AppTextField(
        hintText: name,
        controller: textEditingController,
        focusNode: focusNode,
        nextFocusNode: nextFocusNode,
        required: false,
        keyboardType: keyBoardType,
        onChangedCallBack: (_) {},
        errorValidator: () {
          return null;
        },
        validator: (_) {
          return null;
        },
      );
    });
  }
}
