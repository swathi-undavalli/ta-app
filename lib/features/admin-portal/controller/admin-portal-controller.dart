// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:temple_adventures/core/services/file-uploader.dart';
// import 'package:temple_adventures/features/admin-portal/models/adminPortal-model.dart';
// import 'package:path/path.dart';
// import 'package:temple_adventures/features/counter-model.dart';
//
// class AdminPortalLogic {
//   AdminPortalController controller = Get.put(AdminPortalController());
//   ImagePicker imagePicker = ImagePicker();
//   static final storage = FirebaseStorage.instance;
//   static final storageRef = FirebaseStorage.instance.ref();
//
//   browseImage(bool isFront, ImageSource source) async {
//     print("==========started");
//     XFile? pickedFile =
//         await imagePicker.pickImage(source: source, imageQuality: 50);
//     print("==========ended");
//
//     if (pickedFile != null) {
//       uploadImage(pickedFile);
//     }
//   }
//
//   void showBottomSheet(bool isFront) {
//     Get.bottomSheet(
//       Container(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.photo_library),
//               title: Text('Photo Library'),
//               tileColor: Colors.white,
//               onTap: () async {
//                 Get.back();
//                 browseImage(isFront, ImageSource.gallery);
//               },
//             ),
//             Divider(
//               height: 0.5,
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_camera),
//               title: Text('Camera'),
//               tileColor: Colors.white,
//               onTap: () async {
//                 Get.back();
//                 browseImage(isFront, ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//       barrierColor: Colors.black.withOpacity(0.3),
//     );
//   }
//
//   uploadImage(XFile file) async {
//     var link = File(file.path);
//     var imageLink = await FileUploader.uploadFile(file: link);
//     log(imageLink!);
//
//     controller.adminPortalModel = AdminPortalModel(
//         path: imageLink,
//         filename: basename(file.path),
//         id: (counterModel!.files! + 1).toString());
//
//     FirebaseFirestore.instance
//         .collection("adminPortal")
//         .doc((counterModel!.files! + 1).toString())
//         .set(controller.adminPortalModel.toMap());
//
//     if (counterModel!.files != null) {
//       counterModel!.files = counterModel!.files! + 1;
//     }
//
//     FirebaseFirestore.instance
//         .collection("counter")
//         .doc("count")
//         .set(counterModel!.toMap());
//
//     controller.update();
//     log("ended===========");
//     controller.pickedFile.add(link.path);
//     controller.update();
//     // print(link);
//     // return link;
//   }
//
//   void removeAtIndex(int index) {
//     controller.pickedFile.removeAt(index);
//     controller.update();
//   }
// }
//
// class AdminPortalController extends GetxController {
//   // XFile _idProofFile;
//
//   late AdminPortalModel adminPortalModel;
//
//   TextEditingController titleTED = TextEditingController();
//
//   List<XFile> idProofs = [];
//
//   List<File> pdfs = [];
//
//   List<String> pickedFile = [];
//
//   TextEditingController pdfName = TextEditingController();
//
// // XFile get idProofFile => _idProofFile;
//
// // set idProofFile(XFile value) {
// //   _idProofFile = value;
// //   update();
// // }
// }
