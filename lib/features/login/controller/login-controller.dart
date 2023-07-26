import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/repository/employee_repo.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/welcome/presentation/screens/welome-page.dart';

LoginScreenLogic logic = LoginScreenLogic();

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
      await Future.delayed(Duration(milliseconds: 100));
      if (getOTP().length == 6) return getOTP();
    }
  }

  verifyEmployeeID() async {
    log("verifyEmployeeID");
    try {
      currentEmployee = await EmployeeRepo.getEmployee(getEmployeeId());
      controller.phoneNumberTED.text = currentEmployee!.authPhone;
      getPhoneNumber();
      EmployeeRepo.employeeID = getEmployeeId();
      print("Done");
      return true;
    } catch (e) {
      showToast(e.toString());
      return false;
    }
  }

  signInWithPhoneNumber() async {
    if (controller.employeeIdTED.text.isNotEmpty) {
      controller.showFab = false;
      controller.showLoading = true;
      controller.showPhoneNumber = false;
      if (await verifyEmployeeID()) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          timeout: Duration(seconds: 60),
          phoneNumber: getPhoneNumber(),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              EmployeeRepo.initiateRepo(currentEmployee!.id);
              Get.offAndToNamed(WelcomeScreen.id);
            } else {
              //log('Failed');
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            //log(e.toString());
          },
          codeSent: (String verificationId, int? resendToken) async {
            controller.otpStatus = "OTP has been sent to ${getPhoneNumber()}";
            startTimer();
            String smsCode = await getFilledOTP();
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              EmployeeRepo.initiateRepo(currentEmployee!.id);
              Get.offAndToNamed(WelcomeScreen.id);
            } else {
              //log('Failed');
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
        // }
      } else {
        Get.defaultDialog(
          contentPadding:
              EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 40),
          title: "\n Oops!",
          middleText: "you are not Authorized to use this app.",
          backgroundColor: Colors.white,
          titleStyle: TextStyle(
              color: AppColors.text.black,
              fontFamily: AppFonts.nunito,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          middleTextStyle: TextStyle(
              color: AppColors.text.black,
              fontFamily: AppFonts.nunito,
              fontSize: 16,
              fontWeight: FontWeight.bold),
          cancel: AppButton.miniFlat(
            text: 'OK',
            onTap: () {
              Get.back();
              controller.showPhoneNumber = true;
              controller.showLoading = false;
              controller.countryCodeTED.text = "";
              controller.phoneNumberTED.text = "";
            },
          ),
          barrierDismissible: false,
          radius: 10,
        );
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid Employee");
    }
  }

  resendOTP() async {
    controller.otpStatus = "";
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: getPhoneNumber(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          Get.offAndToNamed(WelcomeScreen.id);
        } else {
          //log('Failed');
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        //log(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) async {
        controller.otpStatus = "OTP has been Resent";
        String smsCode = await getFilledOTP();
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (FirebaseAuth.instance.currentUser != null) {
          Get.offAndToNamed(WelcomeScreen.id);
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
    Future.delayed(Duration(seconds: 60)).whenComplete(() {});
  }
}

class LoginScreenController extends GetxController {
  List<FocusNode> keyboardFocusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<TextEditingController> textEditingControllersOTP = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<FocusNode> focusNodesOTP = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<FocusNode> keyboardFocusNodesOTP = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController employeeIdTED = TextEditingController();

  FocusNode? phoneNumberNode;
  FocusNode? countryCodeNode;

  String _otpStatus = "";
  bool _showFab = true;
  bool _showPhoneNumber = true;
  bool _showLoading = false;
  bool _showResend = false;

  bool _otpSent = false;

  String otp = "";

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
