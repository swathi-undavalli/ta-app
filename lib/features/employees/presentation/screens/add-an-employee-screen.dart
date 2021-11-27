import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/employees/controllers/add-an-employee-controller.dart';

class AddAnUser extends StatelessWidget {
  static const String id = "AddAnUser";
  final AddAnUserLogic logic = AddAnUserLogic();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        logic.controller.reset();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: buildTitle(),
          leading: BackNavigationIcon(),
          elevation: 0,
          backgroundColor: AppColors.background.white,
        ),
        backgroundColor: AppColors.background.lightBlue,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildEmployeeID(),
                        Row(
                          children: [
                            Expanded(
                              child: buildFirstName(),
                              flex: 1,
                            ),
                            Expanded(
                              child: buildLastName(),
                              flex: 1,
                            ),
                          ],
                        ),
                        buildShiftTimePicker(context),
                        buildPhoneNumber(),
                        buildSubtitle("Role *"),
                        buildRolesList(),
                        buildSubtitle("Gender *"),
                        buildGender(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 30, bottom: 20),
                          child: Container(
                            width: Get.size.width,
                            child: Text(
                              "Access Levels",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: AppFonts.nunito,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        GetBuilder<AddAnUserController>(builder: (controller) {
                          return buildSwitch(
                              text: "Booking",
                              switchValue: controller.bookingSwitch,
                              onChanged: (value) {
                                controller.bookingSwitch = value;
                                print("VALUE : ${controller.bookingSwitch}");
                              });
                        }),
                        GetBuilder<AddAnUserController>(builder: (controller) {
                          return buildSwitch(
                            text: "Attendance",
                            switchValue: controller.attendanceSwitch,
                            onChanged: (value) {
                              controller.attendanceSwitch = value;
                              print("VALUE : ${controller.attendanceSwitch}");
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildCancelButton(),
                      buildSubmitButton(),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///===============UI==============///

  Widget buildSwitch({String text, Function onChanged, bool switchValue}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: FontSize.small, color: AppColors.text.darkgrey),
            ),
          ),
          Switch(
            value: switchValue,
            onChanged: onChanged,
            activeColor: AppColors.text.black,
            inactiveThumbColor: AppColors.text.grey,
          ),
        ],
      ),
    );
  }

  Widget buildPhoneNumber() {
    return IntlPhoneField(
      initialCountryCode: logic.controller.countryISoCOde,
      controller: logic.controller.phoneNumberTED,
      showCountryFlag: false,
      decoration: InputDecoration(
        labelText: "Phone Number",
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
      onSubmitted: (_) {
        logic.controller.roleNode.requestFocus();
      },
      onChanged: (phone) {
        logic.controller.phoneNumberTED.text = phone.number;
        logic.controller.countryCodeTED.text = phone.countryCode;
        print(phone.number);
        print(phone.countryISOCode);
        print(phone.countryCode);
      },
    );
  }

  Widget buildShiftTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        logic.timePicker(context);
      },
      child: AbsorbPointer(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: AppTextField(
            width: 320,
            hintText: 'Shift Time',
            controller: logic.controller.shiftTimeTED,
            focusNode: logic.controller.shiftTimeNode,
            nextFocusNode: logic.controller.genderNode,
            required: true,
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget buildFirstName() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: AppTextField(
        width: Get.width / 3,
        hintText: 'First Name',
        controller: logic.controller.firstNameTED,
        focusNode: logic.controller.firstNameNode,
        nextFocusNode: logic.controller.lastNameNode,
        required: true,
        errorValidator: () {
          return null;
        },
        validator: (firstName) {
          return null;
        },
      ),
    );
  }

  Widget buildLastName() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: AppTextField(
        width: Get.width / 3,
        hintText: 'Last Name',
        controller: logic.controller.lastNameTED,
        focusNode: logic.controller.lastNameNode,
        nextFocusNode: logic.controller.employeeIdNode,
        required: false,
        errorValidator: () {
          return null;
        },
        validator: (firstName) {
          return null;
        },
      ),
    );
  }

  Widget buildEmployeeID() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: AppTextField(
        width: 320,
        hintText: 'EmployeeID',
        controller: logic.controller.employeeIdTED,
        focusNode: logic.controller.employeeIdNode,
        nextFocusNode: logic.controller.countryCodeNode,
        required: true,
        errorValidator: () {
          return null;
        },
        validator: (firstName) {
          return null;
        },
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      'Employee Details',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

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

  Widget buildRolesList() {
    return GetBuilder<AddAnUserController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DropdownButton(
          focusNode: controller.roleNode,
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: controller.roleTED.text.isNotEmpty
              ? controller.roleTED.text
              : null,
          onChanged: (newRole) {
            controller.roleTED.text = newRole;
            controller.update();
          },
          items: controller.roles.map((role) {
            return DropdownMenuItem(
              child: new Text(role),
              value: role,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildGender() {
    return GetBuilder<AddAnUserController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: DropdownButton(
          focusNode: controller.genderNode,
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: controller.genderTED.text.isNotEmpty
              ? controller.genderTED.text
              : null,
          onChanged: (newGender) {
            controller.genderTED.text = newGender;
            controller.update();
          },
          items: controller.gender.map((gender) {
            return DropdownMenuItem(
              child: new Text(gender),
              value: gender,
            );
          }).toList(),
        ),
      );
    });
  }

  Widget buildCancelButton() {
    return Center(
      child: AppButton.flat(
        text: "Cancel",
        textColor: AppColors.text.black,
        color: AppColors.background.white,
        onTap: () {
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
}
