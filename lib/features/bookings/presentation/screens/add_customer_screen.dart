// <<<<<<< HEAD
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:temple_adventures/core/constants/constants.dart';
// // import 'package:temple_adventures/core/widgets/app-button.dart';
// // import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
// // import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
// // import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
// // import 'package:temple_adventures/features/bookings/presentation/screens/new-customer-screen.dart';
// //
// // class AddCustomersScreen extends StatelessWidget {
// //   static const String id = "AddCustomersScreen";
// //   final NewBookingLogic logic = NewBookingLogic();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Container(
// //           height: Get.height,
// //           child: Padding(
// //             padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Spacer(),
// //                 Center(
// //                   child: Text(
// //                     "No of Persons : ${logic.controller.bookingModel.noOfPersons}",
// //                     style: TextStyle(
// //                         fontSize: FontSize.textSize,
// //                         fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: 20,
// //                 ),
// //                 buildAddedUsers(),
// //                 Spacer(),
// //                 buildButton(),
// //                 SizedBox(
// //                   height: 40,
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   GetBuilder<NewBookingController> buildAddedUsers() {
// //     return GetBuilder<NewBookingController>(builder: (controller) {
// //       return Center(
// //         child: Column(
// //           children: controller.bookingModel.pax
// //               .map((e) => Padding(
// //                     padding: const EdgeInsets.only(top: 10),
// //                     child: Container(
// //                       height: 50,
// //                       width: 300,
// //                       decoration: BoxDecoration(
// //                           color: AppColors.background.lightSkyBlue,
// //                           borderRadius: BorderRadius.circular(10)),
// //                       child: Center(
// //                           child: Text(
// //                         e["email"],
// //                         style: TextStyle(color: AppColors.text.black),
// //                       )),
// //                     ),
// //                   ))
// //               .toList(),
// //         ),
// //       );
// //     });
// //   }
// //
// //   Widget buildButton() {
// //     return GetBuilder<NewBookingController>(builder: (controller) {
// //       if (controller.bookingModel.noOfPersons !=
// //           controller.bookingModel.pax.length)
// //         return Padding(
// //           padding: const EdgeInsets.only(left: 40, right: 40),
// //           child: GestureDetector(
// //             onTap: () {
// //               Get.toNamed(AddCustomerDetailsScreen.id);
// //             },
// //             child: Container(
// //               height: 50,
// //               width: 300,
// //               decoration: BoxDecoration(
// //                   color: AppColors.background.grey,
// //                   borderRadius: BorderRadius.circular(10)),
// //               child: Center(
// //                   child: Text(
// //                 "Add",
// //                 style: TextStyle(
// //                     color: AppColors.text.black, fontSize: FontSize.textSize),
// //               )),
// //             ),
// //           ),
// //         );
// //       return buildContinue();
// //     });
// //   }
// //
// //   Widget buildContinue() {
// //     return Center(
// //       child: AppButton.flat(
// //         text: "Continue",
// //         textColor: AppColors.text.white,
// //         color: AppColors.background.black,
// //         onTap: () {
// //           logic.onContinuePressedPaymentSuccessfulPage();
// //         },
// //       ),
// //     );
// //   }
// // }
// =======
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:temple_adventures/core/constants/constants.dart';
// // import 'package:temple_adventures/core/widgets/app-button.dart';
// // import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
// // import 'package:temple_adventures/features/bookings/presentation/screens/add_customer_details_screen.dart';
// // import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
// // import 'package:temple_adventures/features/bookings/presentation/screens/new-customer-screen.dart';
// //
// // class AddCustomersScreen extends StatelessWidget {
// //   static const String id = "AddCustomersScreen";
// //   final NewBookingLogic logic = NewBookingLogic();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Container(
// //           height: Get.height,
// //           child: Padding(
// //             padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Spacer(),
// //                 Center(
// //                   child: Text(
// //                     "No of Persons : ${logic.controller.bookingModel.noOfPersons}",
// //                     style: TextStyle(
// //                         fontSize: FontSize.textSize,
// //                         fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 SizedBox(
// //                   height: 20,
// //                 ),
// //                 buildAddedUsers(),
// //                 Spacer(),
// //                 buildButton(),
// //                 SizedBox(
// //                   height: 40,
// //                 )
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   GetBuilder<NewBookingController> buildAddedUsers() {
// //     return GetBuilder<NewBookingController>(builder: (controller) {
// //       return Center(
// //         child: Column(
// //           children: controller.bookingModel.pax
// //               .map((e) => Padding(
// //                     padding: const EdgeInsets.only(top: 10),
// //                     child: Container(
// //                       height: 50,
// //                       width: 300,
// //                       decoration: BoxDecoration(
// //                           color: AppColors.background.lightSkyBlue,
// //                           borderRadius: BorderRadius.circular(10)),
// //                       child: Center(
// //                           child: Text(
// //                         e["email"],
// //                         style: TextStyle(color: AppColors.text.black),
// //                       )),
// //                     ),
// //                   ))
// //               .toList(),
// //         ),
// //       );
// //     });
// //   }
// //
// //   Widget buildButton() {
// //     return GetBuilder<NewBookingController>(builder: (controller) {
// //       if (controller.bookingModel.noOfPersons !=
// //           controller.bookingModel.pax.length)
// //         return Padding(
// //           padding: const EdgeInsets.only(left: 40, right: 40),
// //           child: GestureDetector(
// //             onTap: () {
// //               Get.toNamed(AddCustomerDetailsScreen.id);
// //             },
// //             child: Container(
// //               height: 50,
// //               width: 300,
// //               decoration: BoxDecoration(
// //                   color: AppColors.background.grey,
// //                   borderRadius: BorderRadius.circular(10)),
// //               child: Center(
// //                   child: Text(
// //                 "Add",
// //                 style: TextStyle(
// //                     color: AppColors.text.black, fontSize: FontSize.textSize),
// //               )),
// //             ),
// //           ),
// //         );
// //       return buildContinue();
// //     });
// //   }
// //
// //   Widget buildContinue() {
// //     return Center(
// //       child: AppButton.flat(
// //         text: "Continue",
// //         textColor: AppColors.text.white,
// //         color: AppColors.background.black,
// //         onTap: () {
// //           logic.onContinuePressedPaymentSuccessfulPage();
// //         },
// //       ),
// //     );
// //   }
// >>>>>>> kamesh/attendance
// // }
