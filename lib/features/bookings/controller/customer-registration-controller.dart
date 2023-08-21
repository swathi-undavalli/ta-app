// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/core/services/firebase_api.dart';
// import 'package:temple_adventures/core/util/utils.dart';
// import 'package:temple_adventures/features/bookings/models/customer-model.dart';
// import 'package:temple_adventures/features/bookings/presentation/screens/customer-registration-screen.dart';
// import 'package:temple_adventures/features/bookings/presentation/screens/paper_work_screen.dart';
// import 'package:temple_adventures/features/bookings/presentation/widgets/image-picker.dart';
//
// class CustomerRegistrationLogic {
//   CustomerRegistrationController controller =
//       Get.put(CustomerRegistrationController());
//
//   DateTime dob = DateTime.now();
//
//   final picker = ImagePicker();
//
//   final IDProofPicker iDProofPicker = IDProofPicker();
//
//   datePicker(context) {
//     DatePicker.showDatePicker(context,
//         showTitleActions: true,
//         minTime: DateTime.now().subtract(Duration(days: 36500)),
//         maxTime: DateTime.now(), onChanged: (date) {
//       //print('change $date');
//       dob = date;
//       controller.dateOfBirthTED.text = DateFormat("d MMM yyyy").format(date);
//     }, onConfirm: (date) {
//       //print('confirm $date');
//       dob = date;
//       controller.dateOfBirthTED.text = DateFormat("d MMM yyyy").format(date);
//     },
//         currentTime: dob,
//         theme: DatePickerTheme(
//           cancelStyle: TextStyle(
//             fontFamily: AppFonts.nunito,
//             color: Colors.black87,
//           ),
//           doneStyle: TextStyle(
//             fontFamily: AppFonts.nunito,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//           itemStyle: TextStyle(
//             fontFamily: AppFonts.nunito,
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ));
//   }
//
//   onContinuePressed(context) async {
//     if (controller.customer.idProof == null &&
//         iDProofPicker.controller.image == null) {
//       showToast("Please upload ID proof");
//       return;
//     }
//     if (controller.selectedActivity != [] &&
//         controller.emailTED.text != "" &&
//         controller.firstNameTED.text != "" &&
//         controller.lastNameTED.text != "" &&
//         controller.dateOfBirthTED.text != "" &&
//         controller.addressLine1TED.text != "" &&
//         controller.countryCodeTED.text != "" &&
//         controller.countryTED.text != "" &&
//         controller.stateTED.text != "" &&
//         controller.cityTED.text != "" &&
//         controller.pinCodeTED.text != "" &&
//         controller.phoneNumberTED.text != "" &&
//         controller.genderTED.text != "") {
//       controller.customer = CustomerModel(
//         email: controller.emailTED.text.toLowerCase().trim(),
//         fistName: controller.firstNameTED.text,
//         middleName: controller.middleNameTED.text,
//         lastName: controller.lastNameTED.text,
//         dob: controller.dateOfBirthTED.text,
//         addressLine1: controller.addressLine1TED.text,
//         addressLine2: controller.addressLine2TED.text,
//         country: controller.countryTED.text,
//         state: controller.stateTED.text,
//         city: controller.cityTED.text,
//         pinCode: controller.pinCodeTED.text,
//         countryCode: controller.countryCodeTED.text,
//         phoneNumber: controller.phoneNumberTED.text,
//         gender: controller.genderTED.text,
//       );
//       controller.showLoading = true;
//       if (iDProofPicker.controller.image == null)
//         await FirebaseApi.uploadIdProof(
//             iDProofPicker.controller.image, controller.customer.email, (link) {
//           controller.customer.idProof = link;
//         });
//       Fluttertoast.showToast(msg: "Saved");
//       disposeKeyboard();
//       controller.showLoading = false;
//       Get.toNamed(PaperWorkScreen.id);
//     } else {
//       Fluttertoast.showToast(msg: "Invalid Input");
//     }
//   }
//
//   void showDocument(BuildContext context) async {
//     final bytes =
//         await DefaultAssetBundle.of(context).load("assets/PDFs/Document.pdf");
//     final list = bytes.buffer.asUint8List();
//
//     // final tempDir = await Pspdfkit.getTemporaryDirectory();
//     // final tempDocumentPath = '${tempDir.path}/${"assets/PDFs/Document.pdf"}';
//
//     // final file = await File(tempDocumentPath).create(recursive: true);
//     // file.writeAsBytesSync(list);
//
//     // await Pspdfkit.present(tempDocumentPath);
//   }
//
//   onArrowPressed() async {
//     disposeKeyboard();
//     if (controller.emailTED.text != "") {
//       controller.statusMsg = "Fetching Details....";
//       if (await checkFirebase())
//         controller.statusMsg = "Details Found";
//       else
//         controller.statusMsg = "No Details Found";
//       await Future.delayed(Duration(milliseconds: 300));
//       controller.statusMsg = "";
//       Get.toNamed(CustomerRegistrationScreen.id);
//     }
//   }
//
//   checkFirebase() async {
//     var data = await FirebaseFirestore.instance
//         .collection('customers')
//         .doc(controller.emailTED.text.toLowerCase().trim())
//         .get();
//     if (data.data() != null) {
//       CustomerModel customer = CustomerModel.fromMap(data.data());
//       controller.firstNameTED.text = customer.fistName;
//       controller.middleNameTED.text = customer.middleName;
//       controller.lastNameTED.text = customer.lastName;
//       controller.dateOfBirthTED.text = customer.dob;
//       controller.addressLine1TED.text = customer.addressLine1;
//       controller.addressLine2TED.text = customer.addressLine2;
//       controller.countryCodeTED.text = customer.countryCode;
//       controller.countryTED.text = customer.country;
//       controller.stateTED.text = customer.state;
//       controller.cityTED.text = customer.city;
//       controller.pinCodeTED.text = customer.pinCode;
//       controller.phoneNumberTED.text = customer.phoneNumber;
//       controller.genderTED.text = customer.gender;
//       controller.customer = CustomerModel.fromMap(data.data());
//       return true;
//     } else
//       return false;
//   }
//
//   onChooseFilePressed() async {
//     iDProofPicker.showBottomSheet();
//     iDProofPicker.onImagePicked = () async {
//       //print("=============picked");
//       controller.iDProofPicked = true;
//     };
//   }
// }
//
// class CustomerRegistrationController extends GetxController {
//   CustomerModel _customer;
//
//   FocusNode emailNode = FocusNode();
//   FocusNode firstNameNode = FocusNode();
//   FocusNode middleNameNode = FocusNode();
//   FocusNode lastNameNode = FocusNode();
//   FocusNode dateOfBirthNode = FocusNode();
//   FocusNode addressLine1Node = FocusNode();
//   FocusNode addressLine2Node = FocusNode();
//   FocusNode countryCodeNode = FocusNode();
//   FocusNode countryNode = FocusNode();
//   FocusNode stateNode = FocusNode();
//   FocusNode cityNode = FocusNode();
//   FocusNode pinCodeNode = FocusNode();
//   FocusNode phoneNumberNode = FocusNode();
//   FocusNode genderNode = FocusNode();
//
//   TextEditingController emailTED = TextEditingController();
//   TextEditingController firstNameTED = TextEditingController();
//   TextEditingController middleNameTED = TextEditingController();
//   TextEditingController lastNameTED = TextEditingController();
//   TextEditingController dateOfBirthTED = TextEditingController();
//   TextEditingController addressLine1TED = TextEditingController();
//   TextEditingController addressLine2TED = TextEditingController();
//   TextEditingController countryCodeTED = TextEditingController();
//   TextEditingController countryTED = TextEditingController();
//   TextEditingController stateTED = TextEditingController();
//   TextEditingController cityTED = TextEditingController();
//   TextEditingController pinCodeTED = TextEditingController();
//   TextEditingController phoneNumberTED = TextEditingController();
//   TextEditingController genderTED = TextEditingController();
//
//   List<String> gender = ['Male', 'Female'];
//   List<String> selectedActivity = [];
//   List<String> activities = [
//     "Discover Scuba Diving",
//     "Open Water",
//     "Advanced Open Water",
//     "Nitrox",
//     "Boat Ride",
//     "Fun Diving",
//     "Bubblemaker",
//     "Deep Diver Speciality",
//     "Underwater Navigator Speciality",
//     "Wreck Diver Speciality",
//     "Search & Recovery Diver Speciality",
//     "Peak Performance Buoyancy Diver Speciality",
//     "Night Diver Speciality",
//     "Multilevel Diver Speciality",
//     "Ice Diver Speciality",
//     "Fish Identification Speciality",
//     "Digital Underwater Videographer",
//     "Digital Underwater Photographer Speciality",
//     "Dry Suit Diver Speciality",
//     "Drift Diver Speciality",
//     "DPV Diver Speciality",
//     "Cavern Diver Speciality",
//     "Boat Diver Speciality",
//     "Altitude Diver Speciality",
//     "Dolphin Atlantis Semi CCR Speciality",
//     "Ray Semi CCR Speciality",
//   ];
//
//   reset() {
//     emailTED.text = "";
//     firstNameTED.text = "";
//     middleNameTED.text = "";
//     lastNameTED.text = "";
//     dateOfBirthTED.text = "";
//     addressLine1TED.text = "";
//     addressLine2TED.text = "";
//     countryCodeTED.text = "";
//     countryTED.text = "";
//     stateTED.text = "";
//     cityTED.text = "";
//     pinCodeTED.text = "";
//     phoneNumberTED.text = "";
//     genderTED.text = "";
//     iDProofPicked = false;
//   }
//
//   bool _iDProofUploaded = false;
//   bool _showLoading = false;
//
//   bool get showLoading => _showLoading;
//
//   set showLoading(bool value) {
//     _showLoading = value;
//     update();
//   }
//
//   CustomerModel get customer => _customer;
//
//   set customer(CustomerModel value) {
//     _customer = value;
//     update();
//   }
//
//   bool get iDProofPicked => _iDProofUploaded;
//
//   set iDProofPicked(bool value) {
//     _iDProofUploaded = value;
//     update();
//   }
//
//   String _statusMsg = "";
//
//   String get statusMsg => _statusMsg;
//
//   set statusMsg(String value) {
//     _statusMsg = value;
//     update();
//   }
// }
//
// /// TODO :: Check Please
// /*
// class CustomerRegistrationLogic {
//   CustomerRegistrationController controller =
//       Get.put(CustomerRegistrationController());
//
//   DateTime dob = DateTime.now();
//
//   final picker = ImagePicker();
//
//   final IDProofPicker iDProofPicker = IDProofPicker();
//
//   datePicker(context) {
//     DatePicker.showDatePicker(context,
//         showTitleActions: true,
//         minTime: DateTime.now().subtract(Duration(days: 36500)),
//         maxTime: DateTime.now(), onChanged: (date) {
//       //print('change $date');
//       dob = date;
//       controller.dateOfBirthTED.text = DateFormat("d MMM yyyy").format(date);
//     }, onConfirm: (date) {
//       //print('confirm $date');
//       dob = date;
//       controller.dateOfBirthTED.text = DateFormat("d MMM yyyy").format(date);
//     },
//         currentTime: dob,
//         theme: DatePickerTheme(
//           cancelStyle: TextStyle(
//             fontFamily: AppFonts.nunito,
//             color: Colors.black87,
//           ),
//           doneStyle: TextStyle(
//             fontFamily: AppFonts.nunito,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//           itemStyle: TextStyle(
//             fontFamily: AppFonts.nunito,
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ));
//   }
//
//   onContinuePressed(context) async {
//     if (controller.customer.idProof == null &&
//         iDProofPicker.controller.image == null) {
//       showToast("Please upload ID proof");
//       return;
//     }
//     if (controller.selectedActivity != [] &&
//         controller.emailTED.text != "" &&
//         controller.firstNameTED.text != "" &&
//         controller.lastNameTED.text != "" &&
//         controller.dateOfBirthTED.text != "" &&
//         controller.addressLine1TED.text != "" &&
//         controller.countryCodeTED.text != "" &&
//         controller.countryTED.text != "" &&
//         controller.stateTED.text != "" &&
//         controller.cityTED.text != "" &&
//         controller.pinCodeTED.text != "" &&
//         controller.phoneNumberTED.text != "" &&
//         controller.genderTED.text != "") {
//       controller.customer = CustomerModel(
//         email: controller.emailTED.text.toLowerCase().trim(),
//         fistName: controller.firstNameTED.text,
//         middleName: controller.middleNameTED.text,
//         lastName: controller.lastNameTED.text,
//         dob: controller.dateOfBirthTED.text,
//         addressLine1: controller.addressLine1TED.text,
//         addressLine2: controller.addressLine2TED.text,
//         country: controller.countryTED.text,
//         state: controller.stateTED.text,
//         city: controller.cityTED.text,
//         pinCode: controller.pinCodeTED.text,
//         countryCode: controller.countryCodeTED.text,
//         phoneNumber: controller.phoneNumberTED.text,
//         gender: controller.genderTED.text,
//       );
//       controller.showLoading = true;
//       if (iDProofPicker.controller.image == null)
//         await FirebaseApi.uploadIdProof(
//             iDProofPicker.controller.image, controller.customer.email, (link) {
//           controller.customer.idProof = link;
//         });
//       Fluttertoast.showToast(msg: "Saved");
//       disposeKeyboard();
//       controller.showLoading = false;
//       Get.toNamed(PaperWorkScreen.id);
//     } else {
//       Fluttertoast.showToast(msg: "Invalid Input");
//     }
//   }
//
//   void showDocument(BuildContext context) async {
//     final bytes =
//         await DefaultAssetBundle.of(context).load("assets/PDFs/Document.pdf");
//     final list = bytes.buffer.asUint8List();
//
//     final tempDir = await Pspdfkit.getTemporaryDirectory();
//     final tempDocumentPath = '${tempDir.path}/${"assets/PDFs/Document.pdf"}';
//
//     final file = await File(tempDocumentPath).create(recursive: true);
//     file.writeAsBytesSync(list);
//
//     await Pspdfkit.present(tempDocumentPath);
//   }
//
//   onArrowPressed() async {
//     disposeKeyboard();
//     if (controller.emailTED.text != "") {
//       controller.statusMsg = "Fetching Details....";
//       if (await checkFirebase())
//         controller.statusMsg = "Details Found";
//       else
//         controller.statusMsg = "No Details Found";
//       await Future.delayed(Duration(milliseconds: 300));
//       controller.statusMsg = "";
//       Get.toNamed(CustomerRegistrationScreen.id);
//     }
//   }
//
//   checkFirebase() async {
//     var data = await FirebaseFirestore.instance
//         .collection('customers')
//         .doc(controller.emailTED.text.toLowerCase().trim())
//         .get();
//     if (data.data() != null) {
//       CustomerModel customer = CustomerModel.fromMap(data.data());
//       controller.firstNameTED.text = customer.fistName;
//       controller.middleNameTED.text = customer.middleName;
//       controller.lastNameTED.text = customer.lastName;
//       controller.dateOfBirthTED.text = customer.dob;
//       controller.addressLine1TED.text = customer.addressLine1;
//       controller.addressLine2TED.text = customer.addressLine2;
//       controller.countryCodeTED.text = customer.countryCode;
//       controller.countryTED.text = customer.country;
//       controller.stateTED.text = customer.state;
//       controller.cityTED.text = customer.city;
//       controller.pinCodeTED.text = customer.pinCode;
//       controller.phoneNumberTED.text = customer.phoneNumber;
//       controller.genderTED.text = customer.gender;
//       controller.customer = CustomerModel.fromMap(data.data());
//       return true;
//     } else
//       return false;
//   }
//
//   onChooseFilePressed() async {
//     iDProofPicker.showBottomSheet();
//     iDProofPicker.onImagePicked = () async {
//       //print("=============picked");
//       controller.iDProofPicked = true;
//     };
//   }
//
//   void getDocument() {}
//
//   void onCheckPressed() {
//
//
//
//   }
// }
//
// class CustomerRegistrationController extends GetxController {
//   CustomerModel _customer;
//
//   FocusNode emailNode = FocusNode();
//   FocusNode firstNameNode = FocusNode();
//   FocusNode middleNameNode = FocusNode();
//   FocusNode lastNameNode = FocusNode();
//   FocusNode dateOfBirthNode = FocusNode();
//   FocusNode addressLine1Node = FocusNode();
//   FocusNode addressLine2Node = FocusNode();
//   FocusNode countryCodeNode = FocusNode();
//   FocusNode countryNode = FocusNode();
//   FocusNode stateNode = FocusNode();
//   FocusNode cityNode = FocusNode();
//   FocusNode pinCodeNode = FocusNode();
//   FocusNode phoneNumberNode = FocusNode();
//   FocusNode genderNode = FocusNode();
//
//   TextEditingController emailTED = TextEditingController();
//   TextEditingController firstNameTED = TextEditingController();
//   TextEditingController middleNameTED = TextEditingController();
//   TextEditingController lastNameTED = TextEditingController();
//   TextEditingController dateOfBirthTED = TextEditingController();
//   TextEditingController addressLine1TED = TextEditingController();
//   TextEditingController addressLine2TED = TextEditingController();
//   TextEditingController countryCodeTED = TextEditingController();
//   TextEditingController countryTED = TextEditingController();
//   TextEditingController stateTED = TextEditingController();
//   TextEditingController cityTED = TextEditingController();
//   TextEditingController pinCodeTED = TextEditingController();
//   TextEditingController phoneNumberTED = TextEditingController();
//   TextEditingController genderTED = TextEditingController();
//
//   List<String> gender = ['Male', 'Female'];
//   List<String> selectedActivity = [];
//   List<String> activities = [
//     "Discover Scuba Diving",
//     "Open Water",
//     "Advanced Open Water",
//     "Nitrox",
//     "Boat Ride",
//     "Fun Diving",
//     "Bubblemaker",
//     "Deep Diver Speciality",
//     "Underwater Navigator Speciality",
//     "Wreck Diver Speciality",
//     "Search & Recovery Diver Speciality",
//     "Peak Performance Buoyancy Diver Speciality",
//     "Night Diver Speciality",
//     "Multilevel Diver Speciality",
//     "Ice Diver Speciality",
//     "Fish Identification Speciality",
//     "Digital Underwater Videographer",
//     "Digital Underwater Photographer Speciality",
//     "Dry Suit Diver Speciality",
//     "Drift Diver Speciality",
//     "DPV Diver Speciality",
//     "Cavern Diver Speciality",
//     "Boat Diver Speciality",
//     "Altitude Diver Speciality",
//     "Dolphin Atlantis Semi CCR Speciality",
//     "Ray Semi CCR Speciality",
//   ];
//
//   reset() {
//     emailTED.text = "";
//     firstNameTED.text = "";
//     middleNameTED.text = "";
//     lastNameTED.text = "";
//     dateOfBirthTED.text = "";
//     addressLine1TED.text = "";
//     addressLine2TED.text = "";
//     countryCodeTED.text = "";
//     countryTED.text = "";
//     stateTED.text = "";
//     cityTED.text = "";
//     pinCodeTED.text = "";
//     phoneNumberTED.text = "";
//     genderTED.text = "";
//     iDProofPicked = false;
//   }
//
//   bool _iDProofUploaded = false;
//   bool _showLoading = false;
//
//   bool get showLoading => _showLoading;
//
//   set showLoading(bool value) {
//     _showLoading = value;
//     update();
//   }
//
//   CustomerModel get customer => _customer;
//
//   set customer(CustomerModel value) {
//     _customer = value;
//     update();
//   }
//
//   bool get iDProofPicked => _iDProofUploaded;
//
//   set iDProofPicked(bool value) {
//     _iDProofUploaded = value;
//     update();
//   }
//
//   String _statusMsg = "";
//
//   String get statusMsg => _statusMsg;
//
//   set statusMsg(String value) {
//     _statusMsg = value;
//     update();
//   }
// }
// */
