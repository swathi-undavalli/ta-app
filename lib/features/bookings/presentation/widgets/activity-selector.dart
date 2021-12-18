// import 'package:flutter/material.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/features/bookings/controller/new-booking-controller.dart';
// import 'package:temple_adventures/features/bookings/controller/customer-registration-controller.dart';
// import 'package:temple_adventures/features/bookings/models/activity-model.dart';
//
// class ActivitySelector extends StatefulWidget {
//   final List<ActivityModel> activityList;
//
//   ActivitySelector(this.activityList);
//
//   @override
//   _ActivitySelectorState createState() => new _ActivitySelectorState();
// }
//
// class _ActivitySelectorState extends State<ActivitySelector> {
//   List<String> selectedChoice = [];
//   NewBookingLogic logic = NewBookingLogic();
//   // _buildChoiceList() {
//   //   List<Widget> choices = [];
//   //   widget.activityList.forEach((item) {
//   //     choices.add(Container(
//   //       child: ChoiceChip(
//   //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//   //         label: Container(child: Text(item.name)),
//   //         labelStyle: TextStyle(
//   //           color: Colors.black,
//   //           fontSize: 12.0,
//   //         ),
//   //         shape: RoundedRectangleBorder(
//   //           borderRadius: BorderRadius.circular(30.0),
//   //         ),
//   //         backgroundColor: Colors.white,
//   //         selectedColor: AppColors.background.skyBlue,
//   //         selected: selectedChoice.contains(item.name),
//   //         onSelected: (selected) {
//   //           setState(() {
//   //             if (selected) {
//   //               selectedChoice.add(item.name);
//   //               logic.controller.selectedActivity.add(item);
//   //             } else {
//   //               selectedChoice.remove(item.name);
//   //               logic.controller.selectedActivity.remove(item);
//   //             }
//   //             selectedChoice.toSet().toList();
//   //             logic.controller.selectedActivity.toSet().toList();
//   //           });
//   //         },
//   //       ),
//   //     ));
//   //   });
//   //   return choices;
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black12, width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Wrap(
//         spacing: 10,
//         children: _buildChoiceList(),
//       ),
//     );
//   }
// }
