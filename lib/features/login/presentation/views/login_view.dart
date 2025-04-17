import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginScreenLogic logic = LoginScreenLogic();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: (MediaQuery.of(context).viewInsets.bottom == 0)
          ? (FloatingActionButtonLocation.centerFloat)
          : (FloatingActionButtonLocation.endFloat),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: Screen.height - 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 20),
                  buildHowdy(),
                  buildAppLogo(),
                  buildWelcomeMessage(),
                  buildOTPStatus(),
                  buildOtpField(),
                  buildEmployeeID(),
                  const SizedBox(height: 60),
                  buildResendButton(),
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
    return GetBuilder<LoginScreenController>(
      builder: (controller) {
        if (controller.showPhoneNumber) {
          return SizedBox(
            width: 150,
            child: TextField(
              controller: controller.employeeIdTED,
              style: const TextStyle(
                fontSize: 50,
              ),
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Employee ID',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 3),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.background.skyBlue,
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget buildResendButton() {
    return GetBuilder<LoginScreenController>(
      builder: (controller) {
        if (controller.showResend == true && controller.showFab == false) {
          return AppButton.flat(
            text: 'Resend',
            onTap: () {
              logic.resendOTP(context);
            },
            color: AppColors.background.black,
            textColor: AppColors.text.white,
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget buildOtpField() {
    return SizedBox(
      width: 300,
      child: GetBuilder<LoginScreenController>(
        builder: (controller) {
          if (!controller.showPhoneNumber) {
            return PinCodeTextField(
              length: 6,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                borderWidth: 1,
                fieldHeight: 48,
                fieldWidth: 43.33,
                activeFillColor: Colors.white,
                activeColor: AppColors.background.lightBlue,
                inactiveColor: const Color(0x33000000),
                inactiveFillColor: Theme.of(context).cardColor,
                selectedFillColor: AppColors.background.lightBlue.withOpacity(0.3),
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              enableActiveFill: true,
              autoFocus: true,
              //textInputType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                logic.controller.otp = v;
              },
              onChanged: (value) {
                logic.controller.otp = value;
              },
              beforeTextPaste: (text) {
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
              appContext: context,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget buildOTPStatus() {
    return GetBuilder<LoginScreenController>(
      builder: (controller) {
        if (controller.otpStatus.isNotEmpty) {
          return SizedBox(
            width: 347,
            child: Text(
              controller.otpStatus,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSize.message,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.skyBlue,
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget buildWelcomeMessage() {
    return SizedBox(
      width: 347,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'On behalf of the whole department welcome',
              style: TextStyle(
                fontSize: FontSize.message,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.black,
              ),
            ),
            TextSpan(
              text: ' aboard.',
              style: TextStyle(
                fontSize: FontSize.message,
                fontFamily: AppFonts.nunito,
                color: AppColors.text.skyBlue,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildAppLogo() {
    return SizedBox(
      width: 150,
      height: 150,
      child: Image.asset(
        'images/AppLogoPondy.png',
      ),
    );
  }

  Widget buildHowdy() {
    return SizedBox(
      width: Screen.width,
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
    return GetBuilder<LoginScreenController>(
      builder: (controller) {
        if (controller.showFab && controller.showResend == false) {
          return FloatingActionButton(
            onPressed: () {
              logic.signInWithPhoneNumber(context);
            },
            elevation: 0,
            backgroundColor: AppColors.iconColor.black,
            child: (controller.showLoading)
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white54,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
