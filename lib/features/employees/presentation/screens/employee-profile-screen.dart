import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:temple_adventures/features/employees/controllers/employee-profile-controller.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:intl/intl.dart';

class EmployeeProfileScreen extends StatelessWidget {
  static const String id = "EmployeeProfileScreen";
  EmployeeProfileLogic logic = EmployeeProfileLogic();

  @override
  Widget build(BuildContext context) {
    final DateTime date = currentEmployee.shiftTiming;
    final DateFormat formatter = DateFormat('HH-mm-ss');
    final String shiftTiming = formatter.format(date);
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: GetBuilder<EmployeeProfileController>(builder: (controller) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            onBackPressed();
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.text.black,
                            size: 17,
                          ),
                        ),
                      ),
                      buildEditButton(),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildUserProfile(),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 20),
                        (controller.isEditMode)
                            ? buildTitle("Edit Details")
                            : buildTitle("Employee Details"),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              buildEmployeeInfo(
                                  subHeading: "Name",
                                  text: currentEmployee.name),
                              buildEmployeeInfo(
                                  subHeading: "Phone Number",
                                  text: currentEmployee.countryCode +
                                      currentEmployee.phoneNumber),
                              buildEmployeeInfo(
                                  subHeading: "ShiftTiming", text: shiftTiming),
                              buildEmployeeInfo(
                                  subHeading: "Role",
                                  text: currentEmployee.role),
                            ],
                          ),
                        ),
                        buildTextFields(
                            hintText: "Name",
                            textEditingController: controller.nameTED,
                            focus: controller.nameNode,
                            nextFocus: controller.phoneNumberNode,
                            keyBoardType: TextInputType.text),
                        buildPhoneNumber(),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  buildButtons(),
                  SizedBox(height: 30),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  ///=====================UI=====================///

  onBackPressed() {
    if (logic.controller.isEditMode) {
      logic.controller.isEditMode = !logic.controller.isEditMode;
      logic.controller.reset();
    } else
      Get.back();
  }

  Widget buildPhoneNumber() {
    return GetBuilder<EmployeeProfileController>(builder: (controller) {
      if (controller.isEditMode)
        return IntlPhoneField(
          autoValidate: true,
          initialCountryCode: controller.isoCode,
          showCountryFlag: false,
          initialValue: controller.phoneNumberTED.text,
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
            controller.phoneNumberTED.text = phone.number;
            controller.countryCodeTED.text = phone.countryCode;
            print(phone.number);
            print(phone.countryCode);
          },
        );
      else
        return SizedBox();
    });
  }

  Widget buildButtons() {
    return GetBuilder<EmployeeProfileController>(builder: (controller) {
      if (controller.isEditMode)
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppButton.flat(
              height: 45,
              width: 140,
              color: AppColors.background.grey,
              text: "Cancel",
              textColor: AppColors.text.black,
              onTap: () {
                disposeKeyboard();
                controller.isEditMode = !controller.isEditMode;
              },
            ),
            AppButton.flat(
              height: 45,
              width: 140,
              color: AppColors.background.black,
              text: "Update",
              textColor: AppColors.text.white,
              onTap: () async {
                if (controller.nameTED.text != "")
                  currentEmployee.firstName = controller.nameTED.text;
                if (controller.phoneNumberTED.text != "") {
                  currentEmployee.countryIsoCode = controller.isoCode;
                  currentEmployee.countryCode = controller.countryCodeTED.text;
                  currentEmployee.phoneNumber = controller.phoneNumberTED.text;
                }
                FirebaseFirestore.instance
                    .collection("employees")
                    .doc(currentEmployee.id)
                    .collection("employeeFullInformation")
                    .doc("employeeData")
                    .set(currentEmployee.toMap());
                controller.isEditMode = !controller.isEditMode;
                controller.reset();
              },
            ),
          ],
        );
      else
        return SizedBox();
    });
  }

  Widget buildTextFields(
      {String hintText,
      TextEditingController textEditingController,
      FocusNode focus,
      FocusNode nextFocus,
      TextInputType keyBoardType}) {
    return GetBuilder<EmployeeProfileController>(builder: (controller) {
      if (controller.isEditMode)
        return Container(
          width: 280,
          child: AppTextField(
            hintText: hintText,
            keyboardType: keyBoardType,
            focusNode: focus,
            nextFocusNode: nextFocus,
            controller: textEditingController,
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
        );
      else
        return SizedBox();
    });
  }

  Widget buildEditButton() {
    bool enable = true;
    return EmployeeAccess(
      access: currentEmployee.accessLevels.personalProfileEdit,
      child: GetBuilder<EmployeeProfileController>(builder: (controller) {
        if (!controller.isEditMode)
          return TextButton(
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
              backgroundColor: MaterialStateProperty.all<Color>(enable
                  ? Colors.transparent
                  : Colors.transparent.withOpacity(0.5)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              minimumSize: MaterialStateProperty.all<Size>(Size(100, 31)),
            ),
            onPressed: () {
              if (enable) {
                controller.isEditMode = !controller.isEditMode;
              }
            },
            child: Text(
              "Edit",
              style: TextStyle(
                color: AppColors.text.black,
                fontSize: 14,
                fontFamily: AppFonts.nunito,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.60,
              ),
            ),
          );
        else
          return SizedBox();
      }),
    );
  }

  Widget buildEmployeeInfo({String subHeading, String text}) {
    return GetBuilder<EmployeeProfileController>(builder: (controller) {
      if (!controller.isEditMode)
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 320,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: Get.width,
                    child: Text(
                      subHeading,
                      style: TextStyle(
                          color: AppColors.text.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  width: 150,
                  child: Text(
                    ":      " + text,
                    style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      else
        return SizedBox();
    });
  }

  Widget buildTitle(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: AppColors.text.skyBlue,
            fontWeight: FontWeight.w700,
            fontFamily: AppFonts.nunito),
      ),
    );
  }

  Widget buildIcons(IconData icon, Function onTap) {
    return Center(
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon),
        iconSize: 20,
        color: AppColors.background.black,
      ),
    );
  }

  Widget buildUserProfile() {
    return GetBuilder<EmployeeProfileController>(builder: (controller) {
      return Center(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"),
                  ),
                ),
                if (controller.isEditMode)
                  Positioned(
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white54,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Text(
                          "Upload",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: FontSize.small),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

/// TODO:: CHECK PLEASE
// class EmployeeProfileScreen extends StatelessWidget {
//   static const String id = "EmployeeProfileScreen";
//   EmployeeProfileLogic logic = EmployeeProfileLogic();
//
//   @override
//   Widget build(BuildContext context) {
//     final DateTime date = currentEmployee.shiftTiming;
//     final DateFormat formatter = DateFormat('HH-mm-ss');
//     final String shiftTiming = formatter.format(date);
//     bool enable = true;
//     return WillPopScope(
//       onWillPop: () async {
//         onBackPressed();
//         return false;
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: GetBuilder<EmployeeProfileController>(builder: (controller) {
//               return Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         child: TextButton(
//                           onPressed: () {
//                             onBackPressed();
//                           },
//                           child: Icon(
//                             Icons.arrow_back_ios,
//                             color: AppColors.text.black,
//                             size: 17,
//                           ),
//                         ),
//                       ),
//                       buildEditButton(enable),
//                     ],
//                   ),
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         buildUserProfile(),
//                         SizedBox(height: 20),
//                         Divider(),
//                         SizedBox(height: 20),
//                         (controller.isEditMode)
//                             ? buildTitle("Edit Details")
//                             : buildTitle("Employee Details"),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 15, right: 15, top: 15),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               buildEmployeeInfo(
//                                   subHeading: "Name",
//                                   text: currentEmployee.name),
//                               buildEmployeeInfo(
//                                   subHeading: "Phone Number",
//                                   text: currentEmployee.countryCode +
//                                       currentEmployee.phoneNumber),
//                               buildEmployeeInfo(
//                                   subHeading: "ShiftTiming", text: shiftTiming),
//                               buildEmployeeInfo(
//                                   subHeading: "Role",
//                                   text: currentEmployee.role),
//                             ],
//                           ),
//                         ),
//                         buildTextFields(
//                             hintText: "Name",
//                             textEditingController: controller.nameTED,
//                             focus: controller.nameNode,
//                             nextFocus: controller.phoneNumberNode,
//                             keyBoardType: TextInputType.text),
//                         buildPhoneNumber(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   buildButtons(),
//                   SizedBox(height: 30),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///=====================UI=====================///
//
//   onBackPressed() {
//     if (logic.controller.isEditMode) {
//       logic.controller.isEditMode = !logic.controller.isEditMode;
//       logic.controller.reset();
//     } else
//       Get.back();
//   }
//
//   Widget buildPhoneNumber() {
//     return GetBuilder<EmployeeProfileController>(builder: (controller) {
//       if (controller.isEditMode)
//         return IntlPhoneField(
//           autoValidate: true,
//           initialCountryCode: controller.isoCode,
//           showCountryFlag: false,
//           initialValue: controller.phoneNumberTED.text,
//           decoration: InputDecoration(
//             labelText: "Phone Number",
//             labelStyle: TextStyle(
//               fontSize: FontSize.small,
//               fontFamily: AppFonts.nunito,
//             ),
//           ),
//           style: TextStyle(
//               fontFamily: AppFonts.nunito,
//               fontWeight: FontWeight.normal,
//               fontSize: 14),
//           searchText: "Search",
//           onSubmitted: (_) {},
//           onChanged: (phone) {
//             controller.phoneNumberTED.text = phone.number;
//             controller.countryCodeTED.text = phone.countryCode;
//             print(phone.number);
//             print(phone.countryCode);
//           },
//         );
//       else
//         return SizedBox();
//     });
//   }
//
//   Widget buildButtons() {
//     return GetBuilder<EmployeeProfileController>(builder: (controller) {
//       if (controller.isEditMode)
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             AppButton.flat(
//               height: 45,
//               width: 140,
//               color: AppColors.background.grey,
//               text: "Cancel",
//               textColor: AppColors.text.black,
//               onTap: () {
//                 disposeKeyboard();
//                 controller.isEditMode = !controller.isEditMode;
//               },
//             ),
//             AppButton.flat(
//               height: 45,
//               width: 140,
//               color: AppColors.background.black,
//               text: "Update",
//               textColor: AppColors.text.white,
//               onTap: () async {
//                 if (controller.nameTED.text != "")
//                   currentEmployee.firstName = controller.nameTED.text;
//                 if (controller.phoneNumberTED.text != "") {
//                   currentEmployee.countryIsoCode = controller.isoCode;
//                   currentEmployee.countryCode = controller.countryCodeTED.text;
//                   currentEmployee.phoneNumber = controller.phoneNumberTED.text;
//                 }
//                 FirebaseFirestore.instance
//                     .collection("employees")
//                     .doc(currentEmployee.id)
//                     .collection("employeeFullInformation")
//                     .doc("employeeData")
//                     .set(currentEmployee.toMap());
//                 controller.isEditMode = !controller.isEditMode;
//                 controller.reset();
//               },
//             ),
//           ],
//         );
//       else
//         return SizedBox();
//     });
//   }
//
//   Widget buildTextFields(
//       {String hintText,
//       TextEditingController textEditingController,
//       FocusNode focus,
//       FocusNode nextFocus,
//       TextInputType keyBoardType}) {
//     return GetBuilder<EmployeeProfileController>(builder: (controller) {
//       if (controller.isEditMode)
//         return Container(
//           width: 280,
//           child: AppTextField(
//             hintText: hintText,
//             keyboardType: keyBoardType,
//             focusNode: focus,
//             nextFocusNode: nextFocus,
//             controller: textEditingController,
//             errorValidator: () {
//               return null;
//             },
//             validator: (_) {
//               return null;
//             },
//           ),
//         );
//       else
//         return SizedBox();
//     });
//   }
//
//   Widget buildEditButton(bool enable) {
//     return GetBuilder<EmployeeProfileController>(builder: (controller) {
//       if (!controller.isEditMode)
//         return TextButton(
//           style: ButtonStyle(
//             overlayColor:
//                 MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
//             backgroundColor: MaterialStateProperty.all<Color>(enable
//                 ? Colors.transparent
//                 : Colors.transparent.withOpacity(0.5)),
//             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             minimumSize: MaterialStateProperty.all<Size>(Size(100, 31)),
//           ),
//           onPressed: () {
//             if (enable) {
//               controller.isEditMode = !controller.isEditMode;
//             }
//           },
//           child: Text(
//             "Edit",
//             style: TextStyle(
//               color: AppColors.text.black,
//               fontSize: 14,
//               fontFamily: AppFonts.nunito,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.60,
//             ),
//           ),
//         );
//       else
//         return SizedBox();
//     });
//   }
//
//   Widget buildEmployeeInfo({String subHeading, String text}) {
//     return GetBuilder<EmployeeProfileController>(builder: (controller) {
//       if (!controller.isEditMode)
//         return Padding(
//           padding: const EdgeInsets.all(5.0),
//           child: Container(
//             width: 320,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Container(
//                     width: Get.width,
//                     child: Text(
//                       subHeading,
//                       style: TextStyle(
//                           color: AppColors.text.black,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: 150,
//                   child: Text(
//                     ":      " + text,
//                     style: TextStyle(
//                         color: AppColors.text.black,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       else
//         return SizedBox();
//     });
//   }
//
//   Widget buildTitle(String text) {
//     return Container(
//       padding: const EdgeInsets.only(left: 20, right: 20),
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 16,
//             color: AppColors.text.skyBlue,
//             fontWeight: FontWeight.w700,
//             fontFamily: AppFonts.nunito),
//       ),
//     );
//   }
//
//   Widget buildIcons(IconData icon, Function onTap) {
//     return Center(
//       child: IconButton(
//         onPressed: () {},
//         icon: Icon(icon),
//         iconSize: 20,
//         color: AppColors.background.black,
//       ),
//     );
//   }
//
//   Widget buildUserProfile() {
//     return GetBuilder<EmployeeProfileController>(builder: (controller) {
//       return Center(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 SizedBox(
//                   height: 100,
//                   width: 100,
//                   child: CircleAvatar(
//                     backgroundImage: NetworkImage(
//                         "https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg"),
//                   ),
//                 ),
//                 if (controller.isEditMode)
//                   Positioned(
//                     child: Container(
//                       height: 100,
//                       width: 100,
//                       color: Colors.white54,
//                       child: CircleAvatar(
//                         backgroundColor: Colors.transparent,
//                         child: Text(
//                           "Upload",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.w700,
//                               fontSize: FontSize.small),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }
