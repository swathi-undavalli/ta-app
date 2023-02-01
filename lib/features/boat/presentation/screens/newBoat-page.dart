import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/boat/controller/boat-controller.dart';
import 'package:temple_adventures/features/boat/controller/newBoat-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class NewBoatPage extends StatelessWidget {
  static const String id = "NewBoatPage";
  final NewBoatLogic logic = NewBoatLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: WillPopScope(
          onWillPop: () async {
            logic.controller.reset();
            return true;
          },
          child: SafeArea(
            child: GetBuilder<NewBoatController>(builder: (controller) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    buildSwitch(
                      text: (controller.diveType) ? "Ocean" : "Lake",
                      switchValue: controller.diveType,
                      onChanged: (value) {
                        controller.diveType = !controller.diveType;
                        // controller.diveType = value;
                        log(value.toString());
                      },
                    ),
                    buildTextFields(
                        name: (controller.diveType)
                            ? "Boat Name"
                            : "Vehicle Name",
                        textEditingController: controller.boatNameTED,
                        focusNode: controller.boatNameNode,
                        nextFocusNode: controller.boatCapacityNode,
                        keyBoardType: TextInputType.text),
                    buildTextFields(
                        name: (controller.diveType)
                            ? "Boat Capacity"
                            : "Vehicle Capacity",
                        textEditingController: controller.boatCapacityTED,
                        focusNode: controller.boatCapacityNode,
                        nextFocusNode: controller.captainNameNode,
                        keyBoardType: TextInputType.number),
                    buildTextFields(
                        name: (controller.diveType)
                            ? "Captain Name"
                            : "Driver Name",
                        textEditingController: controller.captainNameTED,
                        focusNode: controller.captainNameNode,
                        nextFocusNode: controller.phoneNode,
                        keyBoardType: TextInputType.text),
                    // buildSubtitle("Captain Name"),
                    // SizedBox(height: 5),
                    // buildCaptainName(),
                    buildPhoneNumber(),
                    SizedBox(height: 120),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildCancelButton(),
                        buildSubmitButton(),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget buildSubtitle(String name) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30),
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

  Widget buildCaptainName() {
    return GetBuilder<NewBoatController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: DropdownButton(
          focusNode: controller.captainNameNode,
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: controller.captainNameTED.text.isNotEmpty
              ? controller.captainNameTED.text
              : null,
          onChanged: (dynamic employee) {
            controller.captainNameTED.text = employee;
            controller.update();
          },
          items: controller.allEmployeesList.map((employee) {
            return DropdownMenuItem(
              child: new Text(employee.name),
              value: employee,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildPhoneNumber() {
    return GetBuilder<NewBoatController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: IntlPhoneField(
          autoValidate: true,
          focusNode: controller.phoneNode,
          initialCountryCode: controller.isoCode,
          showCountryFlag: false,
          initialValue: controller.phoneTED.text,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText:
                (controller.diveType) ? "Captain Phone No" : "Driver Phone No",
            labelStyle: TextStyle(
              fontSize: FontSize.small,
              fontFamily: AppFonts.nunito,
            ),
          ),
          style: TextStyle(
              fontFamily: AppFonts.nunito,
              fontWeight: FontWeight.normal,
              fontSize: 14),
          searchText: "Search",
          onSubmitted: (_) {},
          onChanged: (phone) {
            controller.countryCodeTED.text = phone.countryCode;
            controller.phoneTED.text = phone.number!;
            controller.isoCode = phone.countryISOCode;
            //print(phone.number);
            //print(phone.countryCode);
            //print(phone.countryISOCode);
          },
        ),
      );
    });
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

  Widget buildSwitch({required String text, Function? onChanged, required bool switchValue}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Row(
        children: [
          Spacer(),
          Text(
            text,
            style: TextStyle(
                fontSize: FontSize.textSize,
                fontWeight: FontWeight.w600,
                color: AppColors.text.darkgrey),
          ),
          Switch(
            value: switchValue,
            onChanged: onChanged as void Function(bool)?,
            activeColor: AppColors.text.skyBlue,
            inactiveThumbColor: AppColors.text.grey,
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        "Add New Boat",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTextFields(
      {String? name,
      TextEditingController? textEditingController,
      FocusNode? focusNode,
      FocusNode? nextFocusNode,
      TextInputType? keyBoardType}) {
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
  }
}
