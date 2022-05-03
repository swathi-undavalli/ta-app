// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:temple_adventures/core/util/ta-image.dart';
//
// class D extends StatefulWidget {
//
//   String image;
//
//   D(this.image);
//
//   @override
//   State<D> createState() => _DState();
// }
//
// class _DState extends State<D> {
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         TAImage(
//           widget.image,
//           height: Get.height,
//           width: Get.width,
//           fit: BoxFit.cover,
//         ),
//         Positioned(
//           top: 100,
//           child: buildStory(),
//         ),
//         Container(
//           alignment: Alignment.bottomCenter,
//           child: ElevatedButton(
//               onPressed: () {
//                 // onStoryTapped();
//               },
//               child: Text("DO")),
//         ),
//       ],
//     );
//   }
//
//   buildStory() {
//     return Stack(
//       children: [
//         Container(
//           height: 4,
//           width: Get.width,
//           decoration: BoxDecoration(
//             color: const Color(0x49ffffff),
//             borderRadius: BorderRadius.circular(25),
//           ),
//         ),
//         AnimatedContainer(
//           duration: Duration(seconds: 5),
//           height: 4,
//           // width: DDMeasures.screenWidth,
//
//           width: Get.width,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25),
//             color: Colors.amber,
//           ),
//         ),
//       ],
//     );
//   }
// }
