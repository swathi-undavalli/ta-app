import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/features/login/controller/login-controller.dart';

class LoginScreen extends StatelessWidget {
  static const String id = "LoginScreen";
  final LoginScreenLogic logic = LoginScreenLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: (Get.mediaQuery.viewInsets.bottom == 0)
          ? (FloatingActionButtonLocation.centerFloat)
          : (FloatingActionButtonLocation.endFloat),
      backgroundColor: AppColors.background.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: Get.size.height - 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 20),
                  buildHowdy(),
                  buildAppLogo(),
                  buildWelcomeMessage(),
                  buildOTPStatus(),
                  // buildPhoneNumberTextField(),
                  buildPhoneNumber(),
                  buildEmployeeID(),
                  SizedBox(height: 60),
                  buildResendButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///================UI==================///

  Widget buildEmployeeID() {
    return GetBuilder<LoginScreenController>(builder: (controller) {
      if (controller.showPhoneNumber)
        return SizedBox(
          width: 150,
          child: TextField(
            controller: controller.employeeIdTED,
            style: TextStyle(
              fontSize: 50,
            ),
            textAlign: TextAlign.center,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              labelText: "Employee ID",
              labelStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 3)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black, width: 3, style: BorderStyle.solid)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.background.skyBlue,
                      width: 3,
                      style: BorderStyle.solid)),
            ),
          ),
        );
      return SizedBox();
    });
  }

  Widget buildPhoneNumberTextField() {
    return IntlPhoneField(
      initialCountryCode: 'IN',
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
          fontWeight: FontWeight.bold,
          fontSize: 14),
      searchText: "Search",
      onSubmitted: (_) {
        logic.signInWithPhoneNumber();
      },
      onChanged: (phone) {
        logic.controller.phoneNumberTED.text = phone.number;
        logic.controller.countryCodeTED.text = phone.countryCode;
        print(phone.number);
        print(phone.countryCode);
      },
    );
  }

  Widget buildResendButton() {
    return GetBuilder<LoginScreenController>(builder: (controller) {
      if (controller.showResend == true && controller.showFab == false)
        return AppButton.flat(
          text: 'Resend',
          onTap: () {
            logic.resendOTP();
          },
          color: AppColors.background.black,
          textColor: AppColors.text.white,
        );
      return SizedBox();
    });
  }

  Widget buildPhoneNumber() {
    return Container(
      width: 300,
      child: GetBuilder<LoginScreenController>(builder: (controller) {
        if (!controller.showPhoneNumber)
          // return buildPhoneNumberTextField();
          // else
          return Row(
            children: logic.getOtpFields(),
          );
        return SizedBox();
      }),
    );
  }

  Widget buildOTPStatus() {
    return GetBuilder<LoginScreenController>(builder: (controller) {
      if (controller.otpStatus.length != 0)
        return Container(
          width: 347,
          child: Text(
            controller.otpStatus,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: FontSize.message,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.skyBlue),
          ),
        );
      return SizedBox();
    });
  }

  Widget buildWelcomeMessage() {
    return GetBuilder<LoginScreenController>(builder: (controller) {
      if (controller.otpSent == false)
        return Container(
          width: 347,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'On behalf of the whole department welcome',
                  style: TextStyle(
                      fontSize: FontSize.message,
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.black),
                ),
                TextSpan(
                  text: ' aboard.',
                  style: TextStyle(
                      fontSize: FontSize.message,
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.skyBlue),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        );
      return SizedBox();
    });
  }

  Widget buildAppLogo() {
    return Container(
      width: 150,
      height: 150,
      child: Image.asset(
        'images/AppLogoPondy.png',
      ),
    );
  }

  Widget buildHowdy() {
    return Container(
      width: Get.size.width,
      child: Text(
        'Howdy,',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: FontSize.title,
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return GetBuilder<LoginScreenController>(builder: (controller) {
      if (controller.showFab && controller.showResend == false)
        return FloatingActionButton(
          onPressed: () {
            logic.signInWithPhoneNumber();
          },
          elevation: 0,
          backgroundColor: AppColors.IconColor.black,
          child: (controller.showLoading)
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white54,
                    strokeWidth: 2,
                  ),
                )
              : Icon(Icons.check),
        );
      else
        return Container();
    });
    // else
    //   return Container();
  }
}
