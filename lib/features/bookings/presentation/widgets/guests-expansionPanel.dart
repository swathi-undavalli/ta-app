// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:temple_adventures/access_levels.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/features/boat/models/boat-passengers-model.dart';
// import 'package:temple_adventures/features/bookings/models/booking-model.dart';
// import 'package:temple_adventures/features/bookings/models/customer-model.dart';
// import 'package:temple_adventures/features/bookings/presentation/screens/guests-edit-screen.dart';
//
// // ignore: must_be_immutable
// class GuestsExpansionPanel extends StatefulWidget {
//   GuestsExpansionPanel({required this.customer,required this.booking});
//
//   CustomerModel customer;
//   Booking? booking;
//
//   @override
//   State<GuestsExpansionPanel> createState() => _GuestsExpansionPanelState();
// }
//
// class _GuestsExpansionPanelState extends State<GuestsExpansionPanel> {
//   bool isExpanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 200),
//       curve: Curves.easeInCubic,
//       alignment: Alignment.topCenter,
//       constraints: BoxConstraints(
//         minHeight: isExpanded ? 200 : 50,
//       ),
//       width: 400,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         // border: Border.all(color: AppColors.text.grey),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 25.0),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: 100,
//                       child: Row(
//                         children: [
//                           Flexible(
//                             child: Text(
//                               (widget.customer.firstName! +
//                                       " ${widget.customer.lastName}")
//                                   .trim()
//                                   .toLowerCase()
//                                   .capitalizeFirst!,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                   color: AppColors.text.black,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Spacer(),
//                     EmployeeAccess(
//                       access: AccessRights.editBookings,
//                       child: IconButton(
//                         splashRadius: 20,
//                         icon:
//                             Icon(Icons.edit, color: AppColors.background.black),
//                         iconSize: 15,
//                         onPressed: () {
//                           // var model = itemModel.bookingModel;
//                           Get.toNamed(GuestsEditScreen.id,
//                               arguments: [widget.customer,widget.booking]);
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       splashRadius: 20,
//                       iconSize: 23,
//                       icon: Icon(isExpanded
//                           ? Icons.keyboard_arrow_up_rounded
//                           : Icons.keyboard_arrow_down_rounded),
//                       onPressed: () {
//                         setState(() {
//                           isExpanded = !isExpanded;
//                           //log(isExpanded.toString());
//                         });
//                       },
//                     ),
//                   ]),
//             ),
//             if (isExpanded)
//               Padding(
//                 padding: const EdgeInsets.only(left: 25, right: 25),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(height: 20),
//                     buildKeyValuePairs(
//                         "First Name   ", widget.customer.firstName!),
//                     buildKeyValuePairs(
//                         "Last Name   ", widget.customer.lastName!),
//                     buildKeyValuePairs("Email  ", widget.customer.email!),
//                     buildKeyValuePairs(
//                         "Phone  ",
//                         widget.customer.countryCode! +
//                             widget.customer.phoneNumber!),
//                     buildKeyValuePairs("Gender  ", widget.customer.gender!),
//                   ],
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildKeyValuePairs(String key, String value, {bool isDanger = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 3.0),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               key,
//               style: TextStyle(
//                   color: Colors.grey[700],
//                   fontSize: 13,
//                   letterSpacing: 0.3,
//                   fontWeight: FontWeight.w600,
//                   height: 1.3),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: 16,
//               child: Text(
//                 value,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                     color: isDanger ? Colors.red : Colors.black,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.3,
//                     height: 1.3),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
