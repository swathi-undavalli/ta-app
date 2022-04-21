// //
// // {
// // "left": ["Day","Weak","First"],
// // "right": ["Last","Strong","Night"],
// // "answers": {"Day":"Night","Weak":"Strong","First":"Last"},
// // }
// //
// // {
// // "left": ["Fast","Big","Heavy"],
// // "right": ["Slow","Light","Small"],
// // "answers": {"Fast":"Slow","Big":"Small","Heavy":"Light"},
// // }
// //
// // {
// // "left": ["Open","Rich","Full"],
// // "right": ["Empty","Close","Poor"],
// // "answers": {"Open":"Close","Rich":"Poor","Full":"Empty"},
// // }
// //
//
// import 'package:flutter/material.dart';
// import 'package:temple_adventures/d1.dart';
//
// class W2 extends StatelessWidget {
//   static const String id = "W2";
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             W1(),
//             W1(),
//             W1(),
//             W1(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class W2 extends StatefulWidget {
//   static const String id = "W2";
//
//   @override
//   State<W2> createState() => _W2State();
// }
//
// class _W2State extends State<W2> {
//   final ImagePicker imgpicker = ImagePicker();
//   List<XFile> imagefiles;
//
//   openImages() async {
//     try {
//       var pickedfiles = await imgpicker.pickMultiImage();
//       if (pickedfiles != null) {
//         imagefiles = pickedfiles;
//         setState(() {});
//       } else {
//         print("No image is selected.");
//       }
//     } catch (e) {
//       print("error while picking file.");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           title: Text("Multiple Image Picker Flutter"),
//           backgroundColor: Colors.deepPurpleAccent,
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: EdgeInsets.all(20),
//           child: Column(
//             children: [
//               //open button ----------------
//               ElevatedButton(
//                   onPressed: () {
//                     openImages();
//                   },
//                   child: Text("Open Images")),
//
//               Divider(),
//               Text("Picked Files:"),
//               Divider(),
//
//               imagefiles != null
//                   ? Wrap(
//                       children: imagefiles.map((imageone) {
//                         return Container(
//                             child: Card(
//                           child: Container(
//                             height: 100,
//                             width: 100,
//                             child: Image.file(File(imageone.path)),
//                           ),
//                         ));
//                       }).toList(),
//                     )
//                   : Container()
//             ],
//           ),
//         ));
//   }
// }
