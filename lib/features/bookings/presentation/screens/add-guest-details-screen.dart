import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/validator.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/bookings/controller/guest-details-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';

class GuestDetailsScreen extends StatelessWidget {
  static const String id = "GuestDetailsScreen";

  final GuestDetailsLogic logic = GuestDetailsLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: BackNavigationIcon(),
        elevation: 0,
        backgroundColor: AppColors.background.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child:
                    GetBuilder<GuestDetailsController>(builder: (controller) {
                  return Column(
                    children: [
                      buildEmailID(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton.miniFlat(
                            text: "Get Details",
                            onTap: () {
                              logic.getDetailsPressed();
                            },
                          ),
                        ],
                      ),
                      if (controller.getDetailsPressed) ...[
                        buildName(),
                        buildPhoneNumber(),
                        buildSubtitle("Gender  *"),
                        buildGender(),
                        SizedBox(height: 30),
                        buildIDProof()
                      ],
                      if (controller.showLoading)
                        SizedBox(
                          child: Center(
                              child: SizedBox(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                            height: 20,
                            width: 20,
                          )),
                          height: 200,
                        ),
                    ],
                  );
                }),
              ),
              SizedBox(height: 70),
              buildCancelSubmitButtons(),
            ],
          ),
        ),
      ),
    );
  }

  GetBuilder<GuestDetailsController> buildCancelSubmitButtons() {
    return GetBuilder<GuestDetailsController>(builder: (controller) {
      if (controller.getDetailsPressed)
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
      return SizedBox();
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
            child: GetBuilder<GuestDetailsController>(builder: (controller) {
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

  getImage(GuestDetailsController controller) {
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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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

  Widget buildTitle() {
    return Text(
      'Guest Details',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildEmailID() {
    return AppTextField(
      hintText: "Enter Customer Email ID",
      controller: logic.controller.emailTED,
      focusNode: logic.controller.emailNode,
      nextFocusNode: logic.controller.nameNode,
      keyboardType: TextInputType.emailAddress,
      onChangedCallBack: (_) {},
      required: true,
      errorValidator: () {
        return Validator.validateEmail(logic.controller.emailTED.text);
      },
      validator: (email) {
        return Validator.validateEmail(email);
      },
    );
  }

  Widget buildName() {
    return AppTextField(
      hintText: 'Name',
      controller: logic.controller.nameTED,
      focusNode: logic.controller.nameNode,
      nextFocusNode: logic.controller.phoneNumberNode,
      required: true,
      errorValidator: () {
        return null;
      },
      validator: (firstName) {
        return null;
      },
    );
  }

  Widget buildPhoneNumber() {
    return IntlPhoneField(
      autoValidate: true,
      focusNode: logic.controller.phoneNumberNode,
      initialCountryCode: logic.controller.countryISoCOde,
      showCountryFlag: false,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: "Phone Number  *",
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
        logic.controller.genderNode.requestFocus();
      },
      controller: logic.controller.phoneNumberTED,
      onChanged: (phone) {
        // logic.controller.phoneNumberTED.text = phone.number;
        logic.controller.countryCodeTED.text = phone.countryCode;
        logic.controller.countryISoCOde = phone.countryISOCode;
        //print(phone.number);
        //print(phone.countryISOCode);
        //print(phone.countryCode);
      },
    );
  }

  Widget buildGender() {
    return GetBuilder<GuestDetailsController>(builder: (controller) {
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
}
