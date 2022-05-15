// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/core/util/validator.dart';
// import 'package:temple_adventures/features/bookings/controller/customer-registration-controller.dart';
// import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
//
// class NewCustomerScreen extends StatelessWidget {
//   static const String id = "CustomerEmailEntryScreen";
//   final CustomerRegistrationLogic logic = CustomerRegistrationLogic();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: buildFloatingActionButton(),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       backgroundColor: AppColors.background.lightBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 50),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               buildHii(),
//               SizedBox(height: 20),
//               AppTextField(
//                 hintText: "Enter your mail",
//                 controller: logic.controller.emailTED,
//                 required: false,
//                 errorValidator: () {
//                   return Validator.validateEmail(
//                       logic.controller.emailTED.text);
//                 },
//                 validator: (email) {
//                   return Validator.validateEmail(email);
//                 },
//               ),
//               SizedBox(height: 40),
//               buildMessage()
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildHii() {
//     return Container(
//       width: Get.size.width,
//       child: Text(
//         'Hi,',
//         style: TextStyle(
//           fontSize: FontSize.title,
//           color: AppColors.text.black,
//           fontFamily: AppFonts.nunito,
//           fontWeight: FontWeight.w700,
//         ),
//       ),
//     );
//   }
//
//   Widget buildFloatingActionButton() {
//     // if (Get.mediaQuery.viewInsets.bottom == 0)
//     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
//       return FloatingActionButton(
//         onPressed: () {
//           logic.onArrowPressed();
//         },
//         elevation: 0,
//         backgroundColor: AppColors.IconColor.black,
//         child: Icon(Icons.arrow_forward_ios_outlined),
//       );
//     });
//     // else
//     //   return Container();
//   }
//
//   Widget buildMessage() {
//     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
//       return Container(
//         width: Get.width,
//         child: Text(
//           controller.statusMsg,
//           style: TextStyle(
//               color: AppColors.text.skyBlue, fontSize: FontSize.textSize),
//           textAlign: TextAlign.center,
//         ),
//       );
//     });
//   }
// }
// // class NewCustomerScreen extends StatelessWidget {
// //   static const String id = "CustomerEmailEntryScreen";
// //   final CustomerRegistrationLogic logic = CustomerRegistrationLogic();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       floatingActionButton: buildFloatingActionButton(),
// //       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
// //       backgroundColor: AppColors.background.lightBlue,
// //       body: SafeArea(
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 50),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               buildHii(),
// //               SizedBox(height: 20),
// //               AppTextField(
// //                 hintText: "Enter your mail",
// //                 controller: logic.controller.emailTED,
// //                 required: false,
// //                 errorValidator: () {
// //                   return Validator.validateEmail(
// //                       logic.controller.emailTED.text);
// //                 },
// //                 validator: (email) {
// //                   return Validator.validateEmail(email);
// //                 },
// //               ),
// //               SizedBox(height: 40),
// //               buildMessage()
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget buildHii() {
// //     return Container(
// //       width: Get.size.width,
// //       child: Text(
// //         'Hi,',
// //         style: TextStyle(
// //           fontSize: FontSize.title,
// //           color: AppColors.text.black,
// //           fontFamily: AppFonts.nunito,
// //           fontWeight: FontWeight.w700,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget buildFloatingActionButton() {
// //     // if (Get.mediaQuery.viewInsets.bottom == 0)
// //     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
// //       return FloatingActionButton(
// //         onPressed: () {
// //           logic.onArrowPressed();
// //         },
// //         elevation: 0,
// //         backgroundColor: AppColors.IconColor.black,
// //         child: Icon(Icons.arrow_forward_ios_outlined),
// //       );
// //     });
// //     // else
// //     //   return Container();
// //   }
// //
// //   Widget buildMessage() {
// //     return GetBuilder<CustomerRegistrationController>(builder: (controller) {
// //       return Container(
// //         width: Get.width,
// //         child: Text(
// //           controller.statusMsg,
// //           style: TextStyle(
// //               color: AppColors.text.skyBlue, fontSize: FontSize.textSize),
// //           textAlign: TextAlign.center,
// //         ),
// //       );
// //     });
// //   }
// // }
