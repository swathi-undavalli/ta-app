import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/validator.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: GetBuilder<NewBookingController>(builder: (controller) {
                return Column(
                  mainAxisAlignment: (controller.getDetailsPressed)
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (!controller.getDetailsPressed) ...[
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
                    ],
                    if (controller.getDetailsPressed) ...[
                      buildNameFields(),
                      buildEmailID(),
                      buildDOB(context),
                      buildNoOfPersons(),
                      buildPhoneNumber(),
                      SizedBox(height: 40),
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
                          ),
                        ),
                        height: 200,
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  ///======================UI==============///

  Widget buildNoOfPersons() {
    return AppTextField(
      hintText: "No of Persons",
      controller: logic.controller.paxTED,
      focusNode: logic.controller.noOfPersonsNode,
      nextFocusNode: logic.controller.phoneNumberNode,
      keyboardType: TextInputType.number,
      required: true,
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

  Widget buildDOB(BuildContext context) {
    return GetBuilder<NewBookingController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          logic.dobDatePicker(context);
        },
        child: AbsorbPointer(
          child: AppTextField(
            hintText: "Date of Birth",
            controller: logic.controller.dobTED,
            focusNode: logic.controller.dobNode,
            nextFocusNode: logic.controller.noOfPersonsNode,
            keyboardType: TextInputType.number,
            required: false,
            onChangedCallBack: (_) {},
            errorValidator: () {
              return null;
              // return Validator.validateEmail(
              //     logic.controller.emailTED.text);
            },
            validator: (email) {
              return null;
              // return Validator.validateEmail(email);
            },
          ),
        ),
      );
    });
  }

  Widget buildNameFields() {
    return Row(
      children: [
        AppTextField(
          width: (Get.width / 2) - 45,
          hintText: "First Name",
          controller: logic.controller.fNameTED,
          focusNode: logic.controller.fNameNode,
          nextFocusNode: logic.controller.lNameNode,
          required: true,
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
          width: (Get.width / 2) - 45,
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
    );
  }

  Widget buildEmailID() {
    return AppTextField(
      hintText: "Enter Customer Email ID",
      controller: logic.controller.emailTED,
      focusNode: logic.controller.emailNode,
      // nextFocusNode: logic.controller.noOfPersonsNode,
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

  Widget buildAppBar() {
    return AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: TextButton(
          onPressed: () {
            logic.controller.reset();
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white);
  }

  Widget buildTitle() {
    return Text(
      'New Booking',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.0,
      ),
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
    return GetBuilder<NewBookingController>(builder: (controller) {
      if (controller.getDetailsPressed)
        return FloatingActionButton(
          onPressed: () {
            logic.onCheckPressed();
          },
          elevation: 0,
          backgroundColor: AppColors.IconColor.black,
          child: Icon(Icons.check),
        );
      else
        return SizedBox();
    });
    // else
    //   return Container();
  }
}
