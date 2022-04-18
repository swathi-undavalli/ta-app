import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boatWidget.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/d1.dart';
import 'package:temple_adventures/d2.dart';
import 'package:temple_adventures/features/boat/controller/boat-controller.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';
import 'package:temple_adventures/features/boat/presentation/screens/editBoat-page.dart';
import 'package:temple_adventures/features/boat/presentation/screens/newBoat-page.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:url_launcher/url_launcher.dart';

class BoatPage extends StatelessWidget {
  final BoatLogic logic = BoatLogic();
  final DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Get.toNamed(NewBoatPage.id);
          // Get.toNamed(W2.id);
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
            ),
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     SizedBox(height: 35),
            //     Text(
            //       DateFormat('dd-MMM-yyyy').format(date),
            //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            //     ),
            //     SizedBox(height: 20),
            //     ...List.generate(
            //       logic.controller.boatsList.length,
            //       (index) {
            //         print(index);
            //         return buildExpansion(
            //             i: index,
            //             name: logic.controller.boatsList[index].boatName,
            //             boatsModel: logic.controller.boatsList[index]);
            //       },
            //     ).toList(),
            //     SizedBox(height: 50),
            //   ],
            // ),
            child: GetBuilder<BoatController>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 50),
                  Container(
                    width: 103,
                    child: Text(
                      DateFormat('dd-MMM-yyyy').format(date),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 20),
                  ...List.generate(controller.boatsCount.boat, (index) {
                    log(index.toString());
                    return BoatWidget(index + 1);
                  }),
                  // BoatWidget(1),
                  // BoatWidget(2),
                  // BoatWidget(3),
                  // BoatWidget(4),
                  SizedBox(height: 50),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  ///================UI=============///

// Widget buildExpansion(
//     {@required int i,
//     @required String name,
//     @required BoatsModel boatsModel}) {
//   return GetBuilder<BoatController>(builder: (controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 200),
//         curve: Curves.easeInCubic,
//         alignment: Alignment.topCenter,
//         height: controller.isExpanded[i] ? 400 : 50,
//         width: 350,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           // border: Border.all(color: AppColors.text.grey),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.only(left: 25),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         width: 100,
//                         child: Text(
//                           name,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               color: AppColors.text.black,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                       Spacer(),
//                       EmployeeAccess(
//                         access: AccessRights.editBookings,
//                         child: IconButton(
//                           splashRadius: 20,
//                           icon: Icon(Icons.edit,
//                               color: AppColors.background.black),
//                           iconSize: 12,
//                           onPressed: () {
//                             Get.toNamed(EditBoatPage.id,
//                                 arguments: boatsModel);
//                           },
//                         ),
//                       ),
//                       IconButton(
//                         splashRadius: 20,
//                         iconSize: 23,
//                         icon: Icon(controller.isExpanded[i]
//                             ? Icons.keyboard_arrow_up_rounded
//                             : Icons.keyboard_arrow_down_rounded),
//                         onPressed: () {
//                           controller.isExpanded[i] =
//                               !controller.isExpanded[i];
//                           log(controller.isExpanded.toString());
//                           controller.update();
//                         },
//                       ),
//                     ]),
//                 controller.isExpanded[i]
//                     ? FutureBuilder(
//                         future: Future.delayed(Duration(milliseconds: 200)),
//                         initialData: SizedBox(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.done)
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 SizedBox(height: 30),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Stack(
//                                       children: [
//                                         TAImage(AppImages.icon.boat),
//                                         Positioned(
//                                           left: 10,
//                                           top: 6,
//                                           child: Container(
//                                             height: 400,
//                                             width: 105,
//                                             child: Wrap(
//                                                 direction: Axis.horizontal,
//                                                 verticalDirection:
//                                                     VerticalDirection.down,
//                                                 children: [
//                                                   ...List.generate(
//                                                       controller
//                                                           .passengerModel[i]
//                                                           .passengers
//                                                           .length, (index) {
//                                                     return buildSeat(
//                                                         borderColor: AppColors
//                                                             .text.skyBlue,
//                                                         color: AppColors.text
//                                                             .lightSkyBlue);
//                                                   }),
//                                                   ...List.generate(
//                                                       (controller.boatsList[i]
//                                                               .capacity -
//                                                           controller
//                                                               .passengerModel[
//                                                                   i]
//                                                               .passengers
//                                                               .length),
//                                                       (index) {
//                                                     return buildSeat(
//                                                         borderColor:
//                                                             Color(0xff5BFF62),
//                                                         color: Color(
//                                                             0xffD1FFBB));
//                                                   }),
//                                                 ]),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                     SizedBox(width: 15),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(height: 10),
//                                         buildCaptainName(
//                                             icon: AppImages.icon.captain,
//                                             name: controller
//                                                 .boatsList[i].captainName),
//                                         SizedBox(height: 20),
//                                         buildCaptainPhone(
//                                             icon: Icons.phone,
//                                             phoneNumber: controller
//                                                 .boatsList[i].phoneNumber),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 40),
//                                 buildBoatStatus(),
//                                 SizedBox(height: 10),
//                                 buildStatusHistory(),
//                                 SizedBox(height: 40),
//                                 seatsAvailability(
//                                     name: "Filled : ",
//                                     value: controller
//                                         .passengerModel[i].passengers.length
//                                         .toString(),
//                                     fontSize: 13,
//                                     valueColour: AppColors.text.skyBlue),
//                                 SizedBox(height: 10),
//                                 seatsAvailability(
//                                     name: "Available : ",
//                                     value: (controller.boatsList[i].capacity -
//                                             controller.passengerModel[i]
//                                                 .passengers.length)
//                                         .toString(),
//                                     fontSize: 13,
//                                     valueColour: Color(0xff00CF2E)),
//                                 SizedBox(height: 40),
//                                 seatsAvailability(
//                                     name: "Status : ",
//                                     value: "About to Start in 15 min",
//                                     valueColour: Color(0xff00CF2E),
//                                     fontSize: 15),
//                               ],
//                             );
//                           return SizedBox();
//                         })
//                     : SizedBox(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   });
// }
//
// Widget buildSeat({Color borderColor, Color color}) {
//   return Padding(
//     padding: const EdgeInsets.only(left: 3.5, top: 6),
//     child: Container(
//       height: 12,
//       width: 7,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadiusDirectional.circular(2),
//           border: Border.all(color: borderColor, width: 1),
//           color: color),
//     ),
//   );
// }
//
// Widget buildStatusHistory() {
//   return Row(
//     children: [
//       buildStatusName(title: "Started"),
//       SizedBox(width: 80),
//       buildStatusName(title: "Diving"),
//       SizedBox(width: 80),
//       buildStatusName(title: "Reached"),
//     ],
//   );
// }
//
// Widget buildStatusName({@required String title}) {
//   return Text(
//     title,
//     style: TextStyle(
//         fontSize: FontSize.small,
//         fontWeight: FontWeight.w600,
//         color: Colors.grey),
//   );
// }
//
// Widget seatsAvailability(
//     {@required String name,
//     @required String value,
//     @required double fontSize,
//     @required Color valueColour}) {
//   return Text.rich(
//     TextSpan(
//       children: [
//         TextSpan(
//           text: name,
//           style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w700,
//               color: AppColors.text.black),
//         ),
//         TextSpan(
//           text: value,
//           style: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.w600,
//               color: valueColour),
//         ),
//       ],
//     ),
//     textAlign: TextAlign.center,
//   );
// }
//
// Widget buildUpdateButton() {
//   return Container(
//     child: AppButton.miniFlat(
//       onTap: () {},
//       text: "Update",
//     ),
//     alignment: Alignment.centerRight,
//   );
// }
//
// Widget buildCaptainName({@required String icon, @required String name}) {
//   return Row(
//     children: [
//       TAImage(
//         icon,
//         height: 20,
//         width: 20,
//       ),
//       SizedBox(width: 10),
//       Container(
//         width: 85,
//         child: Text(
//           name,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontSize: FontSize.small, fontWeight: FontWeight.w700),
//         ),
//       )
//     ],
//   );
// }
//
// Widget buildCaptainPhone(
//     {@required IconData icon, @required String phoneNumber}) {
//   return GestureDetector(
//     onTap: () {
//       makingPhoneCall(phoneNumber);
//     },
//     child: Row(
//       children: [
//         Icon(icon, size: 15),
//         SizedBox(width: 10),
//         Text(
//           phoneNumber,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//               fontSize: FontSize.small, fontWeight: FontWeight.w700),
//         )
//       ],
//     ),
//   );
// }
//
// makingPhoneCall(String phoneNumber) async {
//   String url = 'tel:$phoneNumber';
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
//
// Widget buildBoatStatus({String totalAmount, List<double> payments}) {
//   return GetBuilder<BoatController>(builder: (controller) {
//     return Row(
//       children: [
//         buildCircle(),
//         buildLine(),
//         buildCircle(),
//         buildLine(),
//         buildCircle(),
//       ],
//     );
//   });
// }
//
// Widget buildCircle({Color color}) {
//   return Icon(
//     Icons.circle,
//     size: 10,
//     color: Colors.grey,
//   );
// }
//
// Widget buildLine() {
//   return Center(
//     child: Stack(
//       children: [
//         Container(
//           height: 2,
//           width: 120,
//           decoration: BoxDecoration(
//             color: AppColors.text.grey,
//           ),
//         ),
//         // AnimatedContainer(
//         //   duration: Duration(seconds: 1),
//         //   height: 2,
//         //   // height: (color == AppColors.background.black) ? 50 : 0,
//         //   width: 100,
//         //   decoration: BoxDecoration(
//         //     color: Colors.black,
//         //   ),
//         // ),
//       ],
//     ),
//   );
// }

}
