// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/core/util/validator.dart';
// import 'package:temple_adventures/core/widgets/app-button.dart';
// import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
// import 'package:temple_adventures/core/widgets/csc_picker/csc_picker.dart';
// import 'package:temple_adventures/core/widgets/phone_number/intl_phone_field.dart';
// import 'package:temple_adventures/features/bookings/controller/customer-registration-controller.dart';
// import 'package:temple_adventures/features/bookings/models/customer-model.dart';
// import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
//
// class CustomerRegistrationScreen extends StatelessWidget {
//   static const String id = "CustomerRegistrationScreen";
//   final CustomerRegistrationLogic logic = CustomerRegistrationLogic();
//   final CustomerModel customerModel = Get.arguments as CustomerModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 70,
//         centerTitle: true,
//         title: buildTitle(),
//         leading: BackNavigationIcon(),
//         elevation: 0,
//         backgroundColor: AppColors.background.white,
//       ),
//       backgroundColor: AppColors.background.lightBlue,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
//             child: Container(
//               height: 1400,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   SizedBox(height: 20),
//                   buildNameFields(),
//                   buildDOBPicker(context),
//                   buildAddressLineFields(),
//                   buildCountryStateCityPicker(),
//                   buildPinCodeTextField(),
//                   buildPhoneNumber(),
//                   buildGenderSelector(),
//                   SizedBox(height: 20),
//                   buildIDProof(),
//                   SizedBox(height: 30),
//                   buildContinueButton(context),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///===================UI===================///
//
//   Widget buildPinCodeTextField() {
//     return AppTextField(
//       hintText: 'PinCode',
//       controller: logic.controller.pinCodeTED,
//       focusNode: logic.controller.pinCodeNode,
//       nextFocusNode: logic.controller.countryCodeNode,
//       keyboardType: TextInputType.number,
//       required: true,
//       errorValidator: () {
//         return Validator.validatePinCode(logic.controller.pinCodeTED.text);
//       },
//       validator: (pinCode) {
//         return Validator.validatePinCode(pinCode);
//       },
//     );
//   }
//
//   Widget buildAddressLineFields() {
//     return Column(
//       children: [
//         AppTextField(
//           hintText: 'Address Line 1',
//           minLines: 5,
//           maxLines: 10,
//           controller: logic.controller.addressLine1TED,
//           focusNode: logic.controller.addressLine1Node,
//           nextFocusNode: logic.controller.addressLine2Node,
//           // required: true,
//           errorValidator: () {
//             return null;
//             // return Validator.validateName(
//             //     logic.controller.addressLine1TED.text);
//           },
//           validator: (addressLine1) {
//             return null;
//
//             // return Validator.validateName(addressLine1);
//           },
//         ),
//         AppTextField(
//           minLines: 5,
//           maxLines: 10,
//           hintText: 'Address Line 2',
//           controller: logic.controller.addressLine2TED,
//           focusNode: logic.controller.addressLine2Node,
//           nextFocusNode: logic.controller.countryNode,
//           // required: true,
//           errorValidator: () {
//             return null;
//             // return Validator.validateName(
//             //     logic.controller.addressLine2TED.text);
//           },
//           validator: (addressLine2) {
//             return null;
//             // return Validator.validateName(addressLine2);
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget buildNameFields() {
//     return Column(
//       children: [
//         AppTextField(
//           hintText: 'First name',
//           controller: logic.controller.firstNameTED,
//           focusNode: logic.controller.firstNameNode,
//           nextFocusNode: logic.controller.middleNameNode,
//           required: true,
//           errorValidator: () {
//             return null;
//             // return Validator.validateName(
//             //     logic.controller.firstNameTED.text);
//           },
//           validator: (firstName) {
//             return null;
//             // return Validator.validateName(firstName);
//           },
//         ),
//         AppTextField(
//           hintText: 'Middle name',
//           controller: logic.controller.middleNameTED,
//           focusNode: logic.controller.middleNameNode,
//           nextFocusNode: logic.controller.lastNameNode,
//           required: false,
//           errorValidator: () {
//             return null;
//             // return Validator.validateName(
//             //     logic.controller.middleNameTED.text);
//           },
//           validator: (middleName) {
//             return null;
//             // return Validator.validateName(middleName);
//           },
//         ),
//         AppTextField(
//           hintText: 'Last name',
//           controller: logic.controller.lastNameTED,
//           focusNode: logic.controller.lastNameNode,
//           required: true,
//           errorValidator: () {
//             return null;
//             // return Validator.validateName(
//             //     logic.controller.lastNameTED.text);
//           },
//           validator: (lastName) {
//             return null;
//             // return Validator.validateName(lastName);
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget buildIDProof() {
//     return Column(
//       children: [
//         Text(
//           "ID Proof (Passport, Drivers Licence, Aadhaar Card, Pan Card, Voters ID Acceptable)",
//           style: TextStyle(fontSize: FontSize.small),
//         ),
//         SizedBox(height: 10),
//         Row(
//           children: [
//             ElevatedButton(
//                 style: ButtonStyle(
//                     elevation: MaterialStateProperty.all(0),
//                     backgroundColor:
//                         MaterialStateProperty.all(AppColors.background.grey)),
//                 onPressed: () {
//                   logic.onChooseFilePressed();
//                 },
//                 child: Text(
//                   "Choose File",
//                   style: TextStyle(color: AppColors.text.black),
//                 )),
//             SizedBox(width: 10),
//             GetBuilder<CustomerRegistrationController>(
//               builder: (controller) {
//                 return Text(
//                   (controller.iDProofPicked ||
//                           controller.customer.idProof != null)
//                       ? "File Picked"
//                       : "No file chosen",
//                   style: TextStyle(color: AppColors.text.black),
//                 );
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget buildPhoneNumber() {
//     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
//       return IntlPhoneField(
//         initialCountryCode: 'IN',
//         showCountryFlag: false,
//         initialValue: controller.phoneNumberTED.text,
//         decoration: InputDecoration(
//           labelText: "Phone Number",
//           labelStyle: TextStyle(
//             fontSize: FontSize.small,
//             fontFamily: AppFonts.nunito,
//           ),
//         ),
//         style: TextStyle(
//             fontFamily: AppFonts.nunito,
//             fontWeight: FontWeight.normal,
//             fontSize: 14),
//         searchText: "Search",
//         onSubmitted: (_) {
//           controller.genderNode.requestFocus();
//         },
//         onChanged: (phone) {
//           controller.phoneNumberTED.text = phone.number;
//           controller.countryCodeTED.text = phone.countryCode;
//           //print(phone.number);
//           //print(phone.countryCode);
//         },
//       );
//     });
//   }
//
//   Widget buildGenderSelector() {
//     return Container(
//       width: 320,
//       child: Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 12, top: 20),
//               child: Container(
//                 width: Get.width,
//                 alignment: Alignment.centerLeft,
//                 child: buildSubTitle("Gender*"),
//               ),
//             ),
//           ),
//           Container(
//             width: 215,
//             child: buildGender(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildDOBPicker(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         logic.datePicker(context);
//       },
//       child: AbsorbPointer(
//         child: AppTextField(
//           hintText: 'Date of Birth',
//           controller: logic.controller.dateOfBirthTED,
//           focusNode: logic.controller.dateOfBirthNode,
//           nextFocusNode: logic.controller.addressLine1Node,
//           required: true,
//           errorValidator: () {
//             return null;
//           },
//           validator: (_) {
//             return null;
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget buildGender() {
//     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
//       return Padding(
//         padding: const EdgeInsets.only(left: 13),
//         child: DropdownButton(
//           focusNode: controller.genderNode,
//           underline: Container(height: 1, color: Colors.black45),
//           isExpanded: true,
//           value: controller.genderTED.text.isNotEmpty
//               ? controller.genderTED.text
//               : null,
//           onChanged: (newGender) {
//             controller.genderTED.text = newGender;
//             controller.update();
//           },
//           items: controller.gender.map((gender) {
//             return DropdownMenuItem(
//               child: new Text(
//                 gender,
//                 style: TextStyle(fontWeight: FontWeight.normal),
//               ),
//               value: gender,
//             );
//           }).toList(),
//         ),
//       );
//     });
//   }
//
//   Widget buildContinueButton(context) {
//     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
//       return Container(
//         alignment: Alignment.centerRight,
//         width: Get.width,
//         child: AppButton.flat(
//             text: "Continue",
//             textColor: AppColors.text.white,
//             color: AppColors.background.black,
//             onTap: () {
//               logic.onContinuePressed(context);
//             }),
//       );
//     });
//   }
//
//   Widget buildTitle() {
//     return Text(
//       'Registration',
//       style: TextStyle(
//         color: AppColors.text.black,
//         fontSize: 20,
//         fontFamily: AppFonts.nunito,
//         fontWeight: FontWeight.normal,
//         letterSpacing: 1.2,
//       ),
//     );
//   }
//
//   Widget buildSubTitle(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         color: AppColors.text.black,
//         fontSize: 16,
//         fontFamily: AppFonts.nunito,
//         fontWeight: FontWeight.normal,
//         letterSpacing: 1.2,
//       ),
//     );
//   }
//
//   Widget buildCountryStateCityPicker() {
//     return Container(
//       padding: EdgeInsets.only(top: 7),
//       width: Get.width - 30,
//       child: CSCPicker(
//         showStates: true,
//         showCities: true,
//         flagState: CountryFlag.DISABLE,
//         countryPlaceHolder: logic.controller.countryTED.text,
//         statePlaceHolder: logic.controller.stateTED.text,
//         cityPlaceHolder: logic.controller.cityTED.text,
//         dropdownDecoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(width: 1, color: Colors.grey),
//           ),
//         ),
//         disabledDropdownDecoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           color: Colors.grey.shade50,
//         ),
//         selectedItemStyle: TextStyle(
//           color: AppColors.text.black,
//           fontWeight: FontWeight.normal,
//           fontSize: 14,
//         ),
//         dropdownHeadingStyle: TextStyle(
//             color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
//         dropdownItemStyle: TextStyle(
//           color: Colors.black,
//           fontSize: 14,
//         ),
//         dropdownDialogRadius: 10.0,
//         searchBarRadius: 10.0,
//         onCountryChanged: (value) {
//           logic.controller.countryTED.text = value;
//           logic.controller.cityTED.text = '';
//           logic.controller.stateTED.text = '';
//         },
//         onStateChanged: (value) {
//           logic.controller.stateTED.text = value;
//           logic.controller.cityTED.text = '';
//         },
//         onCityChanged: (value) {
//           logic.controller.cityTED.text = value;
//         },
//       ),
//     );
//   }
// }
//
// // class CustomerRegistrationScreen extends StatelessWidget {
// //   static const String id = "CustomerRegistrationScreen";
// //   final CustomerRegistrationLogic logic = CustomerRegistrationLogic();
// //   final CustomerModel customerModel = Get.arguments as CustomerModel;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         toolbarHeight: 70,
// //         centerTitle: true,
// //         title: buildTitle(),
// //         leading: BackNavigationIcon(),
// //         elevation: 0,
// //         backgroundColor: AppColors.background.white,
// //       ),
// //       backgroundColor: AppColors.background.lightBlue,
// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           physics: BouncingScrollPhysics(),
// //           child: Padding(
// //             padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
// //             child: Container(
// //               height: 1400,
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                 children: [
// //                   SizedBox(height: 20),
// //                   buildNameFields(),
// //                   buildDOBPicker(context),
// //                   buildAddressLineFields(),
// //                   buildCountryStateCityPicker(),
// //                   buildPinCodeTextField(),
// //                   buildPhoneNumber(),
// //                   buildGenderSelector(),
// //                   SizedBox(height: 20),
// //                   buildIDProof(),
// //                   SizedBox(height: 30),
// //                   buildContinueButton(context),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //
// //   ///===================UI===================///
// //
// //
// //   Widget buildPinCodeTextField() {
// //     return AppTextField(
// //       hintText: 'PinCode',
// //       controller: logic.controller.pinCodeTED,
// //       focusNode: logic.controller.pinCodeNode,
// //       nextFocusNode: logic.controller.countryCodeNode,
// //       keyboardType: TextInputType.number,
// //       required: true,
// //       errorValidator: () {
// //         return Validator.validatePinCode(logic.controller.pinCodeTED.text);
// //       },
// //       validator: (pinCode) {
// //         return Validator.validatePinCode(pinCode);
// //       },
// //     );
// //   }
// //
// //   Widget buildAddressLineFields() {
// //     return Column(
// //       children: [
// //         AppTextField(
// //           hintText: 'Address Line 1',
// //           minLines: 5,
// //           maxLines: 10,
// //           controller: logic.controller.addressLine1TED,
// //           focusNode: logic.controller.addressLine1Node,
// //           nextFocusNode: logic.controller.addressLine2Node,
// //           // required: true,
// //           errorValidator: () {
// //             return null;
// //             // return Validator.validateName(
// //             //     logic.controller.addressLine1TED.text);
// //           },
// //           validator: (addressLine1) {
// //             return null;
// //
// //             // return Validator.validateName(addressLine1);
// //           },
// //         ),
// //         AppTextField(
// //           minLines: 5,
// //           maxLines: 10,
// //           hintText: 'Address Line 2',
// //           controller: logic.controller.addressLine2TED,
// //           focusNode: logic.controller.addressLine2Node,
// //           nextFocusNode: logic.controller.countryNode,
// //           // required: true,
// //           errorValidator: () {
// //             return null;
// //             // return Validator.validateName(
// //             //     logic.controller.addressLine2TED.text);
// //           },
// //           validator: (addressLine2) {
// //             return null;
// //             // return Validator.validateName(addressLine2);
// //           },
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget buildNameFields() {
// //     return Column(
// //       children: [
// //         AppTextField(
// //           hintText: 'First name',
// //           controller: logic.controller.firstNameTED,
// //           focusNode: logic.controller.firstNameNode,
// //           nextFocusNode: logic.controller.middleNameNode,
// //           required: true,
// //           errorValidator: () {
// //             return null;
// //             // return Validator.validateName(
// //             //     logic.controller.firstNameTED.text);
// //           },
// //           validator: (firstName) {
// //             return null;
// //             // return Validator.validateName(firstName);
// //           },
// //         ),
// //         AppTextField(
// //           hintText: 'Middle name',
// //           controller: logic.controller.middleNameTED,
// //           focusNode: logic.controller.middleNameNode,
// //           nextFocusNode: logic.controller.lastNameNode,
// //           required: false,
// //           errorValidator: () {
// //             return null;
// //             // return Validator.validateName(
// //             //     logic.controller.middleNameTED.text);
// //           },
// //           validator: (middleName) {
// //             return null;
// //             // return Validator.validateName(middleName);
// //           },
// //         ),
// //         AppTextField(
// //           hintText: 'Last name',
// //           controller: logic.controller.lastNameTED,
// //           focusNode: logic.controller.lastNameNode,
// //           required: true,
// //           errorValidator: () {
// //             return null;
// //             // return Validator.validateName(
// //             //     logic.controller.lastNameTED.text);
// //           },
// //           validator: (lastName) {
// //             return null;
// //             // return Validator.validateName(lastName);
// //           },
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget buildIDProof() {
// //     return Column(
// //       children: [
// //         Text(
// //           "ID Proof (Passport, Drivers Licence, Aadhaar Card, Pan Card, Voters ID Acceptable)",
// //           style: TextStyle(fontSize: FontSize.small),
// //         ),
// //         SizedBox(height: 10),
// //         Row(
// //           children: [
// //             ElevatedButton(
// //                 style: ButtonStyle(
// //                     elevation: MaterialStateProperty.all(0),
// //                     backgroundColor:
// //                         MaterialStateProperty.all(AppColors.background.grey)),
// //                 onPressed: () {
// //                   logic.onChooseFilePressed();
// //                 },
// //                 child: Text(
// //                   "Choose File",
// //                   style: TextStyle(color: AppColors.text.black),
// //                 )),
// //             SizedBox(width: 10),
// //             GetBuilder<CustomerRegistrationController>(
// //               builder: (controller) {
// //                 return Text(
// //                   (controller.iDProofPicked ||
// //                           controller.customer.idProof != null)
// //                       ? "File Picked"
// //                       : "No file chosen",
// //                   style: TextStyle(color: AppColors.text.black),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget buildPhoneNumber() {
// //     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
// //       return IntlPhoneField(
// //         initialCountryCode: 'IN',
// //         showCountryFlag: false,
// //         initialValue: controller.phoneNumberTED.text,
// //         decoration: InputDecoration(
// //           labelText: "Phone Number",
// //           labelStyle: TextStyle(
// //             fontSize: FontSize.small,
// //             fontFamily: AppFonts.nunito,
// //           ),
// //         ),
// //         style: TextStyle(
// //             fontFamily: AppFonts.nunito,
// //             fontWeight: FontWeight.normal,
// //             fontSize: 14),
// //         searchText: "Search",
// //         onSubmitted: (_) {
// //           controller.genderNode.requestFocus();
// //         },
// //         onChanged: (phone) {
// //           controller.phoneNumberTED.text = phone.number;
// //           controller.countryCodeTED.text = phone.countryCode;
// //           //print(phone.number);
// //           //print(phone.countryCode);
// //         },
// //       );
// //     });
// //   }
// //
// //   Widget buildGenderSelector() {
// //     return Container(
// //       width: 320,
// //       child: Row(
// //         children: [
// //           Expanded(
// //             child: Padding(
// //               padding: const EdgeInsets.only(right: 12, top: 20),
// //               child: Container(
// //                 width: Get.width,
// //                 alignment: Alignment.centerLeft,
// //                 child: buildSubTitle("Gender*"),
// //               ),
// //             ),
// //           ),
// //           Container(
// //             width: 215,
// //             child: buildGender(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget buildDOBPicker(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         logic.datePicker(context);
// //       },
// //       child: AbsorbPointer(
// //         child: AppTextField(
// //           hintText: 'Date of Birth',
// //           controller: logic.controller.dateOfBirthTED,
// //           focusNode: logic.controller.dateOfBirthNode,
// //           nextFocusNode: logic.controller.addressLine1Node,
// //           required: true,
// //           errorValidator: () {
// //             return null;
// //           },
// //           validator: (_) {
// //             return null;
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget buildGender() {
// //     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
// //       return Padding(
// //         padding: const EdgeInsets.only(left: 13),
// //         child: DropdownButton(
// //           focusNode: controller.genderNode,
// //           underline: Container(height: 1, color: Colors.black45),
// //           isExpanded: true,
// //           value: controller.genderTED.text.isNotEmpty
// //               ? controller.genderTED.text
// //               : null,
// //           onChanged: (newGender) {
// //             controller.genderTED.text = newGender;
// //             controller.update();
// //           },
// //           items: controller.gender.map((gender) {
// //             return DropdownMenuItem(
// //               child: new Text(
// //                 gender,
// //                 style: TextStyle(fontWeight: FontWeight.normal),
// //               ),
// //               value: gender,
// //             );
// //           }).toList(),
// //         ),
// //       );
// //     });
// //   }
// //
// //   Widget buildContinueButton(context) {
// //     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
// //       return Container(
// //         alignment: Alignment.centerRight,
// //         width: Get.width,
// //         child: AppButton.flat(
// //             text: "Continue",
// //             textColor: AppColors.text.white,
// //             color: AppColors.background.black,
// //             onTap: () {
// //               logic.onContinuePressed(context);
// //             }),
// //       );
// //     });
// //   }
// //
// //   Widget buildTitle() {
// //     return Text(
// //       'Registration',
// //       style: TextStyle(
// //         color: AppColors.text.black,
// //         fontSize: 20,
// //         fontFamily: AppFonts.nunito,
// //         fontWeight: FontWeight.normal,
// //         letterSpacing: 1.2,
// //       ),
// //     );
// //   }
// //
// //   Widget buildSubTitle(String text) {
// //     return Text(
// //       text,
// //       style: TextStyle(
// //         color: AppColors.text.black,
// //         fontSize: 16,
// //         fontFamily: AppFonts.nunito,
// //         fontWeight: FontWeight.normal,
// //         letterSpacing: 1.2,
// //       ),
// //     );
// //   }
// //
// //   Widget buildCountryStateCityPicker() {
// //     return Container(
// //       padding: EdgeInsets.only(top: 7),
// //       width: Get.width - 30,
// //       child: CSCPicker(
// //         showStates: true,
// //         showCities: true,
// //         flagState: CountryFlag.DISABLE,
// //         countryPlaceHolder: logic.controller.countryTED.text,
// //         statePlaceHolder: logic.controller.stateTED.text,
// //         cityPlaceHolder: logic.controller.cityTED.text,
// //         dropdownDecoration: BoxDecoration(
// //           border: Border(
// //             bottom: BorderSide(width: 1, color: Colors.grey),
// //           ),
// //         ),
// //         disabledDropdownDecoration: BoxDecoration(
// //           borderRadius: BorderRadius.all(Radius.circular(10)),
// //           color: Colors.grey.shade50,
// //         ),
// //         selectedItemStyle: TextStyle(
// //           color: AppColors.text.black,
// //           fontWeight: FontWeight.normal,
// //           fontSize: 14,
// //         ),
// //         dropdownHeadingStyle: TextStyle(
// //             color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
// //         dropdownItemStyle: TextStyle(
// //           color: Colors.black,
// //           fontSize: 14,
// //         ),
// //         dropdownDialogRadius: 10.0,
// //         searchBarRadius: 10.0,
// //         onCountryChanged: (value) {
// //           logic.controller.countryTED.text = value;
// //           logic.controller.cityTED.text = '';
// //           logic.controller.stateTED.text = '';
// //         },
// //         onStateChanged: (value) {
// //           logic.controller.stateTED.text = value;
// //           logic.controller.cityTED.text = '';
// //         },
// //         onCityChanged: (value) {
// //           logic.controller.cityTED.text = value;
// //         },
// //       ),
// //     );
// //   }
// // }
