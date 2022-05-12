// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:temple_adventures/access_levels.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
//
// class BotExpansionPanel extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 200),
//           curve: Curves.easeInCubic,
//           alignment: Alignment.topCenter,
//           height: controller.isExpanded[i] ? 380 : 50,
//           // height: controller.isExpanded[i] ? 470 : 50,
//           width: 350,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             // border: Border.all(color: AppColors.text.grey),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: Column(
//                 children: [
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           width: 100,
//                           child: Text(
//                             "King Fisher",
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: AppColors.text.black,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                         Spacer(),
//                         EmployeeAccess(
//                           access: AccessRights.editBookings,
//                           child: IconButton(
//                             splashRadius: 20,
//                             icon: Icon(Icons.edit,
//                                 color: AppColors.background.black),
//                             iconSize: 15,
//                             onPressed: () {},
//                           ),
//                         ),
//                         IconButton(
//                           splashRadius: 20,
//                           icon: Icon(controller.isExpanded[i]
//                               ? Icons.keyboard_arrow_up_rounded
//                               : Icons.keyboard_arrow_down_rounded),
//                           onPressed: () {
//                             //log("tapped");
//                             controller.isExpanded[i] =
//                                 !controller.isExpanded[i];
//                             //log(controller.isExpanded.toString());
//                             controller.update();
//                           },
//                         ),
//                       ]),
//                   controller.isExpanded[i]
//                       ? FutureBuilder(
//                           future: Future.delayed(Duration(milliseconds: 200)),
//                           initialData: SizedBox(),
//                           builder: (context, snapshot) {
//                             if (snapshot.connectionState ==
//                                 ConnectionState.done)
//                               return Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[Text("Hello")],
//                               );
//                             return SizedBox();
//                           })
//                       : SizedBox(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class BoatExpansionPanelLogic {
//   BoatExpansionPanelController controller =
//       Get.put(BoatExpansionPanelController());
// }
//
// class BoatExpansionPanelController {
//   List<bool> isExpanded = [false];
// }
