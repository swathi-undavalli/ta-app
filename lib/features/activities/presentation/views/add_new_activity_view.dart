import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../controller/add_new_activity_controller.dart';

class AddNewActivityView extends StatelessWidget {
  static const String id = 'AddNewActivityScreen';
  final AddNewActivityLogic logic = AddNewActivityLogic();

  AddNewActivityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Add Activity'),
      body: WillPopScope(
        onWillPop: () async {
          logic.controller.reset();
          return true;
        },
        child: SafeArea(
          child: GetBuilder<AddNewActivityController>(
            builder: (controller) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        buildTextFields(
                          name: 'Name',
                          textEditingController: controller.nameTED,
                          focusNode: controller.nameNode,
                          nextFocusNode: controller.shortNameNode,
                        ),
                        buildTextFields(
                          name: 'Short name',
                          textEditingController: controller.shortNameTED,
                          focusNode: controller.shortNameNode,
                          nextFocusNode: controller.priceNode,
                        ),
                        buildTextFields(
                          name: 'Price',
                          textEditingController: controller.priceTED,
                          focusNode: controller.priceNode,
                          nextFocusNode: controller.priorityNode,
                          keyBoardType: TextInputType.number,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              buildSubtitle('Priority'),
                              buildPriority(),
                              buildSubtitle('Color Code'),
                              buildColorCode(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
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
            },
          ),
        ),
      ),
    );
  }

  ///===========UI============///

  Widget buildSubtitle(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 30),
      child: SizedBox(
        width: Get.size.width,
        child: Text(
          name,
          style: const TextStyle(
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
    return GetBuilder<AddNewActivityController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: DropdownButton(
            focusNode: controller.priorityNode,
            underline: Container(height: 1, color: Colors.grey),
            isExpanded: true,
            value: controller.priorityTED.text.isNotEmpty ? controller.priorityTED.text : null,
            onChanged: (dynamic priority) {
              controller.priorityTED.text = priority;
              controller.update();
            },
            items: controller.priority.map((priority) {
              return DropdownMenuItem(
                value: priority,
                child: Text(priority),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildColorCode() {
    return GetBuilder<AddNewActivityController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: DropdownButton(
            focusNode: controller.colorNode,
            underline: Container(height: 1, color: Colors.grey),
            isExpanded: true,
            value: controller.colorTED.text.isNotEmpty ? controller.colorTED.text : null,
            onChanged: (dynamic newColor) {
              controller.colorTED.text = newColor;
              controller.update();
            },
            items: controller.colorCode.map((color) {
              return DropdownMenuItem(
                value: color,
                child: Text(color),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildCancelButton() {
    return Center(
      child: AppButton.flat(
        text: 'Cancel',
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
        text: 'Submit',
        textColor: AppColors.text.white,
        color: AppColors.background.black,
        onTap: () {
          logic.onSubmit();
        },
      ),
    );
  }

  Widget buildTextFields({
    String? name,
    TextEditingController? textEditingController,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    TextInputType? keyBoardType,
  }) {
    return GetBuilder<AddNewActivityController>(
      builder: (controller) {
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
      },
    );
  }
}
