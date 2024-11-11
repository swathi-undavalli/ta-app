import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../core/util/utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../employees/model/employee.dart';
import '../../employees/repository/employee_repo.dart';
import '../../splash/view/splash_view.dart';
import '../../welcome/presentation/views/welome_view.dart';

// LoginScreenLogic logic = LoginScreenLogic();

class LoginScreenLogic {
  LoginScreenController controller = Get.put(LoginScreenController());

  getPhoneNumber() {
    String phoneNumber = controller.phoneNumberTED.text;
    if (phoneNumber.length > 5) {
      controller.showFab = true;
      return phoneNumber;
    } else {
      controller.showFab = false;
    }
  }

  getEmployeeId() {
    String code = controller.employeeIdTED.text;
    return code;
  }

  getOTP() {
    if (controller.otp.length == 6) {
      controller.showFab = true;
    } else {
      controller.showFab = false;
    }
    return controller.otp;
  }

  getFilledOTP() async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (getOTP().length == 6) return getOTP();
    }
  }

  verifyEmployeeID() async {
    try {
      currentEmployee = await EmployeeRepo.getEmployee(getEmployeeId());
      controller.phoneNumberTED.text = currentEmployee!.authPhone;
      getPhoneNumber();
      EmployeeRepo.employeeID = getEmployeeId();
      return true;
    } catch (e) {
      showToast(e.toString());
      return false;
    }
  }

  signInWithPhoneNumber(BuildContext context) async {
    if (controller.employeeIdTED.text.isNotEmpty) {
      controller.showFab = false;
      controller.showLoading = true;
      controller.showPhoneNumber = false;
      if (await verifyEmployeeID()) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          timeout: const Duration(seconds: 60),
          phoneNumber: getPhoneNumber(),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              EmployeeRepo.initiateRepo(currentEmployee!.id);
              controller.reset();
              controller.update();
              if (context.mounted) {
                Navigator.pushReplacement(context, WelcomeView.route());
              }
            } else {
              //log('Failed');
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            //log(e.toString());
          },
          codeSent: (String verificationId, int? resendToken) async {
            controller.otpStatus = 'OTP has been sent to ${getPhoneNumber()}';
            startTimer();
            String smsCode = await getFilledOTP();
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: smsCode,
            );
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              EmployeeRepo.initiateRepo(currentEmployee!.id);
              controller.reset();
              controller.update();
              storeDateTime();
              if (context.mounted) {
                Navigator.pushReplacement(context, WelcomeView.route());
              }
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
        // }
      } else {
        Get.defaultDialog(
          contentPadding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 40),
          title: '\n Oops!',
          middleText: 'you are not Authorized to use this app.',
          backgroundColor: Colors.white,
          titleStyle: TextStyle(
            color: AppColors.text.black,
            fontFamily: AppFonts.nunito,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          middleTextStyle: TextStyle(
            color: AppColors.text.black,
            fontFamily: AppFonts.nunito,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          cancel: AppButton.miniFlat(
            text: 'OK',
            onTap: () {
              Navigator.pop(context);
              controller.showPhoneNumber = true;
              controller.showLoading = false;
              controller.countryCodeTED.text = '';
              controller.phoneNumberTED.text = '';
            },
          ),
          barrierDismissible: false,
          radius: 10,
        );
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid Employee');
    }
  }

  Future<void> storeDateTime() async {
    final prefs = await SharedPreferences.getInstance();
    String dateTimeString = DateTime.now().toIso8601String();
    await prefs.setString(lastLoginTime, dateTimeString);
  }

  resendOTP(BuildContext context) async {
    controller.otpStatus = '';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: getPhoneNumber(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          controller.reset();
          controller.update();
          if (context.mounted) {
            Navigator.push(context, WelcomeView.route());
          }
        } else {
          //log('Failed');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        //log(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) async {
        controller.otpStatus = 'OTP has been Resent';
        String smsCode = await getFilledOTP();
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          controller.reset();
          controller.update();
          if (context.mounted) {
            Navigator.push(context, WelcomeView.route());
          }
        } else {
          //log('Failed');
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void startTimer() {
    controller.showResend = true;
    controller.showFab = false;
    Future.delayed(const Duration(seconds: 60)).whenComplete(() {});
  }
}

class LoginScreenController extends GetxController {
  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController employeeIdTED = TextEditingController();

  String _otpStatus = '';
  bool _showFab = true;
  bool _showPhoneNumber = true;
  bool _showLoading = false;
  bool _showResend = false;

  bool _otpSent = false;

  reset() {
    showFab = true;
    showResend = false;
    showLoading = false;
    otpStatus = '';
    showPhoneNumber = true;
    employeeIdTED.text = '';
    otp = '';
  }

  String otp = '';

  bool get showResend => _showResend;

  bool get showFab => _showFab;

  bool get showPhoneNumber => _showPhoneNumber;

  bool get showLoading => _showLoading;

  bool get otpSent => _otpSent;

  String get otpStatus => _otpStatus;

  set otpStatus(String value) {
    _otpStatus = value;
    update();
  }

  set otpSent(bool value) {
    _otpSent = value;
    update();
  }

  set showResend(bool value) {
    _showResend = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  set showPhoneNumber(bool value) {
    _showPhoneNumber = value;
    update();
  }

  set showFab(bool value) {
    _showFab = value;
    update();
  }
}
