import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/validator.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/bookings/controller/customer-registration-controller.dart';
import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class AddCustomerDetailsScreen extends StatelessWidget {
  static const String id = "AddCustomerDetailsScreen";
  final NewBookingLogic logic = NewBookingLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: AppColors.background.lightBlue,
      body: WillPopScope(
        onWillPop: () async {
          logic.controller.reset();
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // buildHii(),
                // SizedBox(height: 20),
                Row(
                  children: [
                    AppTextField(
                      width: (Get.width / 2) - 55,
                      hintText: "First Name",
                      controller: logic.controller.fNameTED,
                      focusNode: logic.controller.fNameNode,
                      nextFocusNode: logic.controller.lNameNode,
                      required: false,
                      onChangedCallBack: (_) {},
                      errorValidator: () {
                        return null;
                        // return Validator.validateName(
                        //     logic.controller.fNameTED.text);
                      },
                      validator: (email) {
                        return null;
                        // return Validator.validateName(email);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AppTextField(
                      width: (Get.width / 2) - 55,
                      hintText: "Last Name",
                      controller: logic.controller.lNameTED,
                      focusNode: logic.controller.lNameNode,
                      nextFocusNode: logic.controller.emailNode,
                      required: false,
                      onChangedCallBack: (_) {},
                      errorValidator: () {
                        return null;
                        // return Validator.validateName(
                        //     logic.controller.lNameTED.text);
                      },
                      validator: (email) {
                        return null;
                        // return Validator.validateName(email);
                      },
                    ),
                  ],
                ),
                buildEmailID(),
                buildNoOfPersons(),
                buildPhoneNumber(),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNoOfPersons() {
    return AppTextField(
      hintText: "No of Persons",
      controller: logic.controller.paxTED,
      focusNode: logic.controller.noOfPersonsNode,
      nextFocusNode: logic.controller.phoneNumberNode,
      keyboardType: TextInputType.number,
      required: false,
      onChangedCallBack: (_) {},
      isStrictNumber: true,
      errorValidator: () {
        return null;
        // return Validator.validateEmail(
        //     logic.controller.emailTED.text);
      },
      validator: (email) {
        return null;
        // return Validator.validateEmail(email);
      },
    );
  }

  Widget buildEmailID() {
    return AppTextField(
      hintText: "Enter Customer Email ID",
      controller: logic.controller.emailTED,
      focusNode: logic.controller.emailNode,
      nextFocusNode: logic.controller.noOfPersonsNode,
      keyboardType: TextInputType.emailAddress,
      onChangedCallBack: (_) {},
      required: false,
      errorValidator: () {
        return Validator.validateEmail(logic.controller.emailTED.text);
      },
      validator: (email) {
        return Validator.validateEmail(email);
      },
    );
  }

  ///======================UI==============///

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget buildPhoneNumber() {
    return GetBuilder<NewBookingController>(builder: (controller) {
      return IntlPhoneField(
        autoValidate: true,
        focusNode: controller.phoneNumberNode,
        initialCountryCode: controller.isoCode,
        showCountryFlag: false,
        initialValue: controller.phoneNumberTED.text,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        onSubmitted: (_) {},
        onChanged: (phone) {
          controller.countryCodeTED.text = phone.countryCode;
          controller.phoneNumberTED.text = phone.number;
          controller.isoCode = phone.countryISOCode;
          //print(phone.number);
          //print(phone.countryCode);
          //print(phone.countryISOCode);
        },
      );
    });
  }

  Widget buildHii() {
    return Container(
      width: Get.size.width,
      child: Text(
        'Hi,',
        style: TextStyle(
          fontSize: FontSize.title,
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        //print("clicked");
        logic.onCheckPressed();
      },
      elevation: 0,
      backgroundColor: AppColors.IconColor.black,
      child: Icon(Icons.check),
    );
    // else
    //   return Container();
  }

  // Widget buildMessage() {
  //   return GetBuilder<CustomerRegistrationController>(builder: (controller) {
  //     return Container(
  //       width: Get.width,
  //       child: Text(
  //         controller.statusMsg,
  //         style: TextStyle(
  //             color: AppColors.text.skyBlue, fontSize: FontSize.textSize),
  //         textAlign: TextAlign.center,
  //       ),
  //     );
  //   });
  // }
}
