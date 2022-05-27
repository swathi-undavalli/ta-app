import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/bookings/controller/guest-edit-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/models/customer-model.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class GuestsEditScreen extends StatelessWidget {
  static const String id = "GuestsEditScreen";
  CustomerModel customerArg = Get.arguments[0] as CustomerModel;
  BookingModel bookingArg = Get.arguments[1] as BookingModel;
  GuestsEditLogic logic = GuestsEditLogic();

  GuestsEditScreen() {
    logic.controller.customerModel = customerArg;
    logic.controller.bookingModel = bookingArg;
    logic.controller.firstNameTED.text = customerArg.firstName;
    logic.controller.lastNameTED.text = customerArg.lastName;
    logic.controller.emailTED.text = customerArg.email;
    logic.controller.phoneTED.text = customerArg.phoneNumber;
    logic.controller.countryCodeTED.text = customerArg.countryCode ?? "+91";
    logic.controller.genderTED.text = customerArg.gender;
    logic.controller.idProofLink = customerArg.idProof;
    // logic.controller.isoCode = "+91";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            centerTitle: true,
            title: buildTitle(),
            leading: TextButton(
              onPressed: () {
                // logic.controller.reset();
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.text.black,
                size: 17,
              ),
            ),
            elevation: 0,
            backgroundColor: AppColors.background.white,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 25),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        // ElevatedButton(
                        //     onPressed: () {
                        //       logic.updateCoastGuardSlip();
                        //     },
                        //     child: Text("Do")),
                        buildEmailTF(),
                        Row(
                          children: [
                            Expanded(
                              child: buildFirstName(),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: buildLastName(),
                            ),
                          ],
                        ),
                        buildPhoneNumber(),
                        buildSubtitle("Gender"),
                        buildGender(),
                        SizedBox(height: 30),
                        buildIDProof(),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                  buildCancelSubmitButtons(),
                ],
              ),
            ),
          ),
        ),
        buildShowLoading(),
      ],
    );
  }

  Widget buildShowLoading() {
    return GetBuilder<GuestsEditController>(builder: (controller) {
      if (controller.pageLoading)
        return Material(
          color: Colors.transparent,
          child: Container(
            color: Colors.black54,
            height: Get.height,
            width: Get.width,
            child: Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )),
          ),
        );
      else
        return SizedBox();
    });
  }

  Widget buildCancelSubmitButtons() {
    return GetBuilder<GuestsEditController>(builder: (controller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppButton.flat(
            text: "Cancel",
            textColor: AppColors.text.black,
            color: AppColors.background.white,
            onTap: () {
              Get.back();
              logic.controller.reset();
            },
          ),
          AppButton.flat(
            text: "Submit",
            textColor: AppColors.text.white,
            color: AppColors.background.black,
            onTap: () {
              logic.onSubmitPressed();
            },
          ),
        ],
      );
    });
  }

  Widget buildIDProof() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          child: Center(
            child: Text(
              "Upload ID Proof  *",
              style: TextStyle(
                  fontSize: FontSize.small, color: AppColors.text.darkgrey),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              logic.showBottomSheet(true);
            },
            child: GetBuilder<GuestsEditController>(builder: (controller) {
              return Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: getImage(controller),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 5),
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    controller.idProofFile == null ? Icons.add : null,
                    size: 15,
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  getImage(GuestsEditController controller) {
    if (controller.idProofLink != null && controller.idProofLink.isNotEmpty)
      return DecorationImage(
        image: NetworkImage(controller.idProofLink),
        fit: BoxFit.cover,
      );
    if (controller.idProofFile != null)
      return DecorationImage(
        image: FileImage(File(controller.idProofFile.path)),
        fit: BoxFit.cover,
      );
  }

  Widget buildSubtitle(String name) {
    return Container(
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
    );
  }

  Widget buildGender() {
    return GetBuilder<GuestsEditController>(builder: (controller) {
      return DropdownButton(
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
      );
    });
  }

  Widget buildPhoneNumber() {
    return GetBuilder<GuestsEditController>(builder: (controller) {
      return IntlPhoneField(
        autoValidate: true,
        initialCountryCode: controller.isoCode,
        showCountryFlag: false,
        focusNode: controller.phoneNode,
        initialValue: controller.phoneTED.text,
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
          // controller.customerModel. = phone.countryISOCode;
          controller.customerModel.phoneNumber = phone.number;
          controller.customerModel.countryCode = phone.countryCode;
        },
      );
    });
  }

  Widget buildEmailTF() {
    return buildTextFields(
      text: "Email",
      textEditingController: logic.controller.emailTED,
      keyBoardType: TextInputType.emailAddress,
      focus: logic.controller.emailNode,
      nextFocus: logic.controller.phoneNode,
      onChangedCallBack: (email) {
        logic.controller.customerModel.email = email;
      },
    );
  }

  Widget buildTitle() {
    return Text(
      'Edit Guest',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildFirstName() {
    return buildTextFields(
        text: "First Name",
        textEditingController: logic.controller.firstNameTED,
        focus: logic.controller.firstNameNode,
        nextFocus: logic.controller.lastNameNode,
        onChangedCallBack: (newName) {
          logic.controller.customerModel.firstName = newName;
        });
  }

  Widget buildLastName() {
    return buildTextFields(
        text: "Last Name",
        textEditingController: logic.controller.lastNameTED,
        focus: logic.controller.lastNameNode,
        nextFocus: logic.controller.phoneNode,
        onChangedCallBack: (newName) {
          logic.controller.customerModel.lastName = newName;
        });
  }

  Widget buildTextFields({
    String text,
    TextEditingController textEditingController,
    TextInputType keyBoardType,
    FocusNode focus,
    FocusNode nextFocus,
    Function(String) onChangedCallBack,
  }) {
    return Container(
      child: AppTextField(
        width: Get.width,
        hintText: text,
        controller: textEditingController,
        keyboardType: keyBoardType,
        focusNode: focus,
        nextFocusNode: nextFocus,
        onChangedCallBack: (_) {
          onChangedCallBack(_);
        },
        errorValidator: () {
          return null;
        },
        validator: (_) {
          return null;
        },
      ),
    );
  }
}
