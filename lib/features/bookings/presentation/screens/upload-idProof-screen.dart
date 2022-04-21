// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share/share.dart';
// import 'package:temple_adventures/core/constants/assets.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/core/util/ta-image.dart';
// import 'package:temple_adventures/core/widgets/app-button.dart';
// import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
// import 'package:temple_adventures/features/bookings/controller/idProof-controller.dart';
// import 'package:temple_adventures/features/bookings/models/booking-model.dart';
//
// class UploadIDProofScreen extends StatelessWidget {
//   static const String id = "UploadIDProofScreen";
//   IDProofLogic logic = IDProofLogic();
//   final BookingModel bookingArg = Get.arguments;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: AppColors.background.lightBlue,
//           appBar: buildAppBar(),
//           body: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: SafeArea(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 20),
//                         buildIDUploaded(),
//                         SizedBox(height: 40),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             buildCardFrontSide(),
//                             SizedBox(width: 10),
//                             buildCardBackSide(),
//                           ],
//                         ),
//                         SizedBox(height: 50),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                               width: 300,
//                               child: Wrap(
//                                   spacing: 40,
//                                   runSpacing: 20,
//                                   direction: Axis.horizontal,
//                                   verticalDirection: VerticalDirection.down,
//                                   children: [
//                                     ...List.generate(bookingArg.noOfPersons,
//                                         (index) {
//                                       return buildIdProofs(
//                                           // image: AppImages.icon.boat,
//                                           name: (index == 0)
//                                               ? bookingArg.pax[0]["first-name"]
//                                               : "");
//                                     })
//                                   ]),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 180),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       buildCancelButton(
//                         text: "Cancel",
//                         onTap: () {
//                           Get.back();
//                         },
//                       ),
//                       buildSubmitButton(text: "Submit", onTap: () {}),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         buildExpandedID(image: AppImages.icon.boat)
//       ],
//     );
//   }
//
//   Widget buildIDUploaded() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0),
//       child: Row(
//         children: [
//           Text.rich(
//             TextSpan(
//               children: [
//                 TextSpan(
//                   text: '1',
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontFamily: AppFonts.nunito,
//                       color: AppColors.text.black,
//                       fontWeight: FontWeight.w600),
//                 ),
//                 TextSpan(
//                   text: '/${bookingArg.noOfPersons}',
//                   style: TextStyle(
//                       fontSize: 10,
//                       fontFamily: AppFonts.nunito,
//                       color: AppColors.text.black,
//                       fontWeight: FontWeight.w600),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 10),
//           Container(
//             alignment: Alignment.bottomCenter,
//             height: 27,
//             child: Text(
//               "Uploaded",
//               style: TextStyle(
//                 color: AppColors.text.skyBlue,
//                 fontSize: 10,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildExpandedID({String image}) {
//     return GetBuilder<IDProofController>(builder: (controller) {
//       if (controller.idProof)
//         return Container(
//           color: Colors.white70.withOpacity(0.8),
//           height: Get.height,
//           width: Get.width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 90),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 20.0, right: 20, top: 20, bottom: 10),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Container(
//                         height: 400,
//                         width: 270,
//                         decoration: BoxDecoration(
//                             boxShadow: [
//                               BoxShadow(
//                                 // color: Color(0x19000000),
//                                 color: Colors.black26,
//                                 blurRadius: 15,
//                                 offset: Offset(4, 4),
//                               ),
//                             ],
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(20)),
//                         child: TAImage(image),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 90),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   buildCancelButton(
//                       text: "Close",
//                       onTap: () {
//                         controller.idProof = false;
//                       }),
//                   SizedBox(width: 20),
//                   buildSubmitButton(
//                       text: "Share",
//                       onTap: () async {
//                         ByteData imagebyte =
//                             await rootBundle.load(AppImages.icon.appLogo);
//                         final temp = await getTemporaryDirectory();
//                         final path = '${temp.path}/AppLogoPondy.png';
//                         File(path)
//                             .writeAsBytesSync(imagebyte.buffer.asUint8List());
//                         await Share.shareFiles([path], text: 'Image Shared');
//                       }),
//                 ],
//               )
//             ],
//           ),
//         );
//       return SizedBox();
//     });
//   }
//
//   Widget buildCardBackSide() {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           logic.showBottomSheet(false);
//         },
//         child: GetBuilder<IDProofController>(builder: (controller) {
//           return Container(
//             width: 136,
//             height: 94,
//             decoration: BoxDecoration(
//               image: controller.backImage != null
//                   ? DecorationImage(
//                       image: MemoryImage(controller.backImage),
//                       fit: BoxFit.fill,
//                     )
//                   : null,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   offset: Offset(0, 5),
//                   color: Colors.black12,
//                   blurRadius: 20,
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Center(
//               child: Text(
//                 controller.backImage == null ? 'Back' : '',
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget buildCardFrontSide() {
//     return Center(
//       child: GestureDetector(
//         onTap: () {
//           logic.showBottomSheet(true);
//         },
//         child: GetBuilder<IDProofController>(builder: (controller) {
//           return Container(
//             width: 136,
//             height: 94,
//             decoration: BoxDecoration(
//               image: controller.frontImage != null
//                   ? DecorationImage(
//                       image: MemoryImage(controller.frontImage),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   offset: Offset(0, 5),
//                   color: Colors.black12,
//                   blurRadius: 20,
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Center(
//               child: Text(
//                 controller.frontImage == null ? 'Front' : '',
//                 style: TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget buildCancelButton({String text, Function onTap}) {
//     return Center(
//       child: AppButton.flat(
//           text: text,
//           textColor: AppColors.text.black,
//           color: AppColors.background.grey,
//           onTap: onTap),
//     );
//   }
//
//   Widget buildSubmitButton({String text, Function onTap}) {
//     return Center(
//       child: AppButton.flat(
//           text: text,
//           textColor: AppColors.text.white,
//           color: AppColors.background.black,
//           onTap: onTap),
//     );
//   }
//
//   Widget buildIdProofs({String name}) {
//     return GetBuilder<IDProofController>(builder: (controller) {
//       return GestureDetector(
//         onTap: () {
//           controller.idProof = !controller.idProof;
//         },
//         child: Column(
//           children: [
//             Container(
//               height: 58,
//               width: 73,
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: Color(0x19000000),
//                     blurRadius: 15,
//                     offset: Offset(4, 4),
//                   ),
//                 ],
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Icon(Icons.add, size: 10),
//               // child: Padding(
//               //   padding: const EdgeInsets.all(5.0),
//               //   child: TAImage(image),
//               // ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               name,
//               style: TextStyle(fontSize: 14),
//             )
//           ],
//         ),
//       );
//     });
//   }
//
//   // Widget buildFront() {
//   //   return Container(
//   //     width: 136,
//   //     height: 94,
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(15),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Color(0x19000000),
//   //           blurRadius: 15,
//   //           offset: Offset(4, 4),
//   //         ),
//   //       ],
//   //       color: Colors.white,
//   //     ),
//   //     child: Center(
//   //       child: Text(
//   //         "Front",
//   //         style: TextStyle(color: Colors.grey),
//   //       ),
//   //     ),
//   //   );
//   // }
//   //
//   // Widget buildBack() {
//   //   return Container(
//   //     width: 136,
//   //     height: 94,
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(15),
//   //       boxShadow: [
//   //         BoxShadow(
//   //           color: Color(0x19000000),
//   //           blurRadius: 15,
//   //           offset: Offset(4, 4),
//   //         ),
//   //       ],
//   //       color: Colors.white,
//   //     ),
//   //     child: Center(
//   //       child: Text(
//   //         "Back",
//   //         style: TextStyle(color: Colors.grey),
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget buildAppBar() {
//     return AppBar(
//       toolbarHeight: 70,
//       centerTitle: true,
//       title: Text(
//         "Manage ID Proofs",
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//           letterSpacing: 1.2,
//         ),
//       ),
//       leading: BackNavigationIcon(),
//       elevation: 0,
//       backgroundColor: AppColors.background.white,
//     );
//   }
// }
