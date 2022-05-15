// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:dio/dio.dart';
// import 'package:dio/dio.dart' as d;
// import 'package:http/http.dart' as http;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/core/services/firebase_api.dart';
// import 'package:temple_adventures/core/widgets/app-button.dart';
// import 'package:temple_adventures/features/bookings/controller/customer-registration-controller.dart';
// import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
// // import 'package:pspdfkit_flutter/src/main.dart';
// import 'package:temple_adventures/features/bookings/models/customer-model.dart';
//
// class PaperWorkLogic {
//   PaperWorkController controller = Get.put(PaperWorkController());
//   CustomerRegistrationLogic registration = CustomerRegistrationLogic();
//   NewBookingLogic booking = NewBookingLogic();
//
//   PaperWorkLogic() {
//     downloadPDF();
//   }
//
//   Future<String> getPDFlink() async {
//     CustomerModel customer = registration.controller.customer;
//
//     String api = "https://templeadventures.com/api/v1/generatePdf/";
//
//     var body = {
//       "email": "sidd.jha1@gmail.com",
//       "Activity": ["Open Water"],
//       "Location": "Puducherry",
//       "first-name": "Siddharth",
//       "last-name": "Jha",
//       "Birthday": "1993-07-26",
//       "Address-1": "TEST",
//       "Address-2": "TEST",
//       "Country": "India",
//       "State": "Maharashtra",
//       "City": "Mumbai",
//       "Pin-Code": "411015",
//       "Phone": "8329889224",
//       "Gender": "Male",
//     };
//
//     //print(body);
//
//     var dio = d.Dio();
//     try {
//       //print("started");
//       d.FormData formData = new d.FormData.fromMap(body);
//       var response = await dio.post(api, data: formData);
//       var data = jsonDecode(response.data);
//       //print(data[0]);
//       return data[0];
//       //print("ended");
//     } catch (e) {
//       //print(e);
//     }
//     return "no data found";
//   }
//
//   Future<File> _fileFromUrl(Uri uri) async {
//     //print("_fileFromUrl");
//
//     var response = await http.get(uri);
//
//     var documentDirectory = await getTemporaryDirectory();
//
//     var file = File(join(documentDirectory.path,
//         '${DateTime.now().microsecondsSinceEpoch}.pdf'));
//
//     //print(1);
//     file.writeAsBytesSync(response.bodyBytes);
//     //print(2);
//     return file;
//   }
//
//   uploadPDF() async {
//     //print("uploadPDF");
//     await FirebaseApi.uploadPDF(
//         controller.Pdf, registration.controller.customer.email, (link) {
//       // if (booking.controller.bookingModel.paperWork == null)
//       //   booking.controller.bookingModel.paperWork = [];
//       // booking.controller.bookingModel.paperWork.add(link);
//     });
//   }
//
//   downloadPDF() async {
//     //print("downloadPDF");
//     controller.pdfDownloaded = false;
//     String link = await getPDFlink();
//     controller.Pdf = await _fileFromUrl(Uri.parse(link));
//     controller.pdfDownloaded = true;
//   }
//
//   showDocument() async {
//     // await Pspdfkit.present(controller.Pdf.path);
//     showFab();
//   }
//
//   showFab() async {
//     await Future.delayed(Duration(seconds: 5));
//     controller.showFAB = true;
//   }
//
//   onCheckFABPressed() async {
//     //print("onCheckFABPressed");
//     createCustomer();
//     Get.defaultDialog(
//       contentPadding: EdgeInsets.only(left: 20, right: 20),
//       title: "",
//       content: GetBuilder<PaperWorkController>(builder: (controller) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             SizedBox(height: 20),
//             if (controller.customerCreated)
//               Text(
//                 "Registered Successfully",
//                 style: TextStyle(
//                   color: AppColors.text.skyBlue,
//                 ),
//               )
//             else
//               Text("Registering.."),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 AppButton.miniFlat(
//                   enable: controller.customerCreated,
//                   text: "Go Back",
//                   onTap: () {
//                     registration.controller.reset();
//                     Get.back();
//                     Get.back();
//                     Get.back();
//                     Get.back();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   createCustomer() async {
//     //print("createCustomer");
//     controller.customerCreated = false;
//     await uploadPDF();
//     await FirebaseFirestore.instance
//         .collection('customers')
//         .doc(registration.controller.customer.email)
//         .set(registration.controller.customer.toMap());
//
//     if (booking.controller.bookingModel.pax == null)
//       booking.controller.bookingModel.pax = [];
//     // booking.controller.bookingModel.paxTED
//     //     .add(registration.controller.customer.email);
//     booking.controller.update();
//     controller.customerCreated = true;
//   }
// }
//
// class PaperWorkController extends GetxController {
//   File Pdf;
//   bool _showFAB = false;
//   bool _pdfDownloaded = false;
//   bool _customerCreated = false;
//
//   bool get showFAB => _showFAB;
//
//   bool get pdfDownloaded => _pdfDownloaded;
//
//   bool get customerCreated => _customerCreated;
//
//   set customerCreated(bool value) {
//     _customerCreated = value;
//     update();
//   }
//
//   set pdfDownloaded(bool value) {
//     _pdfDownloaded = value;
//     update();
//   }
//
//   set showFAB(bool value) {
//     _showFAB = value;
//     update();
//   }
// }
//
// ///TODO ::  Check Please
// /*class PaperWorkLogic {
//   PaperWorkController controller = Get.put(PaperWorkController());
//   CustomerRegistrationLogic registration = CustomerRegistrationLogic();
//   NewBookingLogic booking = NewBookingLogic();
//
//   PaperWorkLogic() {
//     downloadPDF();
//   }
//
//   Future<String> getPDFlink() async {
//     CustomerModel customer = registration.controller.customer;
//
//     String api = "https://templeadventures.com/api/v1/generatePdf/";
//     var body = {
//       "email": "sidd.jha1@gmail.com",
//       "Activity": ["Open Water"],
//       "Location": "Puducherry",
//       "first-name": "Siddharth",
//       "last-name": "Jha",
//       "Birthday": "1993-07-26",
//       "Address-1": "TEST",
//       "Address-2": "TEST",
//       "Country": "India",
//       "State": "Maharashtra",
//       "City": "Mumbai",
//       "Pin-Code": "411015",
//       "Phone": "8329889224",
//       "Gender": "Male",
//     };
//
//     var nosid = {
//       "email": customer.email,
//       "Activity":
//           booking.controller.selectedActivity.map((e) => e.name).toList(),
//       "Location": booking.controller.locationTED.text,
//       "first-name": customer.fistName,
//       "last-name": customer.lastName,
//       "Birthday": customer.dob,
//       "Address-1": customer.addressLine1,
//       "Address-2": customer.addressLine2,
//       "Country": customer.country,
//       "State": customer.state,
//       "City": customer.city,
//       "Pin-Code": customer.pinCode,
//       "Phone": customer.phoneNumber,
//       "Gender": customer.gender,
//     };
//     //print(body);
//
//     var dio = d.Dio();
//     try {
//       //print("started");
//       d.FormData formData = new d.FormData.fromMap(body);
//       var response = await dio.post(api, data: formData);
//       var data = jsonDecode(response.data);
//       //print(data[0]);
//       return data[0];
//       //print("ended");
//     } catch (e) {
//       //print(e);
//     }
//     return "no data found";
//   }
//
//   Future<File> _fileFromUrl(Uri uri) async {
//     //print("_fileFromUrl");
//
//     var response = await http.get(uri);
//
//     var documentDirectory = await getTemporaryDirectory();
//
//     var file = File(join(documentDirectory.path,
//         '${DateTime.now().microsecondsSinceEpoch}.pdf'));
//
//     //print(1);
//     file.writeAsBytesSync(response.bodyBytes);
//     //print(2);
//     return file;
//   }
//
//   uploadPDF() async {
//     //print("uploadPDF");
//     await FirebaseApi.uploadPDF(
//         controller.Pdf, registration.controller.customer.email, (link) {
//       // if (booking.controller.bookingModel.paperWork == null)
//       //   booking.controller.bookingModel.paperWork = [];
//       // booking.controller.bookingModel.paperWork.add(link);
//     });
//   }
//
//   downloadPDF() async {
//     //print("downloadPDF");
//     controller.pdfDownloaded = false;
//     String link = await getPDFlink();
//     controller.Pdf = await _fileFromUrl(Uri.parse(link));
//     controller.pdfDownloaded = true;
//   }
//
//   showDocument() async {
//     await Pspdfkit.present(controller.Pdf.path);
//     showFab();
//   }
//
//   showFab() async {
//     await Future.delayed(Duration(seconds: 5));
//     controller.showFAB = true;
//   }
//
//   onCheckFABPressed() async {
//     //print("onCheckFABPressed");
//     createCustomer();
//     Get.defaultDialog(
//       contentPadding: EdgeInsets.only(left: 20, right: 20),
//       title: "",
//       content: GetBuilder<PaperWorkController>(builder: (controller) {
//         return Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             SizedBox(height: 20),
//             if (controller.customerCreated)
//               Text(
//                 "Registered Successfully",
//                 style: TextStyle(
//                   color: AppColors.text.skyBlue,
//                 ),
//               )
//             else
//               Text("Registering.."),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 AppButton.miniFlat(
//                   enable: controller.customerCreated,
//                   text: "Go Back",
//                   onTap: () {
//                     registration.controller.reset();
//                     Get.back();
//                     Get.back();
//                     Get.back();
//                     Get.back();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   createCustomer() async {
//     //print("createCustomer");
//     controller.customerCreated = false;
//     await uploadPDF();
//     await FirebaseFirestore.instance
//         .collection('customers')
//         .doc(registration.controller.customer.email)
//         .set(registration.controller.customer.toMap());
//
//     if (booking.controller.bookingModel.pax == null)
//       booking.controller.bookingModel.pax = [];
//     // booking.controller.bookingModel.paxTED
//     //     .add(registration.controller.customer.email);
//     booking.controller.update();
//     controller.customerCreated = true;
//   }
// }
//
// class PaperWorkController extends GetxController {
//   File Pdf;
//   bool _showFAB = false;
//   bool _pdfDownloaded = false;
//   bool _customerCreated = false;
//
//   bool get showFAB => _showFAB;
//
//   bool get pdfDownloaded => _pdfDownloaded;
//
//   bool get customerCreated => _customerCreated;
//
//   set customerCreated(bool value) {
//     _customerCreated = value;
//     update();
//   }
//
//   set pdfDownloaded(bool value) {
//     _pdfDownloaded = value;
//     update();
//   }
//
//   set showFAB(bool value) {
//     _showFAB = value;
//     update();
//   }
// }*/
