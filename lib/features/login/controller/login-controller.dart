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
  String _otp = "";

  List<Widget> getOtpFields() {
    List<Widget> list = [];
    for (int i = 0; i < 6; i++) {
      list.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Column(
              children: [
                RawKeyboardListener(
                  onKey: (value) {
                    if (value.logicalKey == LogicalKeyboardKey.backspace) {
                      if (controller.textEditingControllersOTP[i].text.length ==
                          0) {
                        if (i != 0)
                          controller.focusNodesOTP[i - 1].requestFocus();
                      }
                    }
                  },
                  focusNode: controller.keyboardFocusNodesOTP[i],
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: controller.textEditingControllersOTP[i],
                    focusNode: controller.focusNodesOTP[i],
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                        fontFamily: AppFonts.nunito,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    onChanged: (_) {
                      getOTP();
                      bool isNum = false;
                      controller.update();

                      try {
                        int a = int.parse(
                            controller.textEditingControllersOTP[i].text);
                        //print(a);
                        isNum = true;
                      } catch (e) {
                        isNum = false;
                      }

                      if (isNum) {
                        if (controller.textEditingControllersOTP[5].text !=
                                '' &&
                            controller
                                    .textEditingControllersOTP[5].text.length >=
                                1) {
                          controller.textEditingControllersOTP[5].text =
                              controller.textEditingControllersOTP[5].text[0];
                          disposeKeyboard();
                          return;
                        }
                        if (controller
                                .textEditingControllersOTP[i].text.length ==
                            1) {
                          controller.focusNodesOTP[i + 1].requestFocus();
                        }
                        if (controller
                                .textEditingControllersOTP[i].text.length >
                            1) {
                          controller.textEditingControllersOTP[i + 1].text =
                              controller.textEditingControllersOTP[i].text[1];
                          controller.textEditingControllersOTP[i].text =
                              controller.textEditingControllersOTP[i].text[0];
                          controller.focusNodesOTP[i + 1].requestFocus();
                        }
                      } else {
                        controller.textEditingControllersOTP[i].clear();
                        controller.focusNodesOTP[i].requestFocus();
                      }
                    },
                  ),
                ),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color:
                        controller.textEditingControllersOTP[i].text.length == 1
                            ? Colors.black
                            : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return list;
  }

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
    _otp = '';
    for (int i = 0; i < 6; i++) {
      _otp = _otp + controller.textEditingControllersOTP[i].text;
    }
    if (_otp.length == 6) {
      controller.showFab = true;
    } else {
      controller.showFab = false;
    }
    return _otp;
  }

  getFilledOTP() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 100));
      if (getOTP().length == 6) return getOTP();
    }
  }

  verifyEmployeeID() async {
    //print("verifyEmployeeID");
    try {
      currentEmployee = await EmployeeRepo.getEmployee(getEmployeeId());
      controller.phoneNumberTED.text = currentEmployee.authPhone;
      getPhoneNumber();
      EmployeeRepo.employeeID = getEmployeeId();
      //print("Done");
      return true;
    } catch (e) {
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
              EmployeeRepo.initiateRepo(currentEmployee.id);
              Get.offAndToNamed(WelcomeScreen.id);
            } else {
              //log('Failed');
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            //log(e.toString());
          },
          codeSent: (String verificationId, int resendToken) async {
            controller.otpStatus = "OTP has been sent to ${getPhoneNumber()}";
            startTimer();
            String smsCode = await getFilledOTP();
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: smsCode);
            await FirebaseAuth.instance.signInWithCredential(credential);
            if (FirebaseAuth.instance.currentUser != null) {
              EmployeeRepo.initiateRepo(currentEmployee.id);
              Get.offAndToNamed(WelcomeScreen.id);
            } else {
              //log('Failed');
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
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
      codeSent: (String verificationId, int resendToken) async {
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

  FocusNode phoneNumberNode;
  FocusNode countryCodeNode;

  String _otpStatus = "";
  bool _showFab = true;
  bool _showPhoneNumber = true;
  bool _showLoading = false;
  bool _showResend = false;

  bool _otpSent = false;

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
