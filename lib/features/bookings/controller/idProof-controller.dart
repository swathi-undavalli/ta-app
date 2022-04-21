import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temple_adventures/core/services/file-uploader.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class IDProofLogic {
  String bookingID;

  IDProofLogic({bookingID});

  IDProofController controller = Get.put(IDProofController());

  ImagePicker imagePicker = ImagePicker();
  Function onImagePicked;

  browseImage(bool isFront, ImageSource source) async {
    print("==========started");
    XFile pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 50);
    print("==========ended");
    if (pickedFile != null) {
      // ImageCropper imageCropper = ImageCropper();
      // File file = await imageCropper.cropImage(
      //   sourcePath: pickedFile.path,
      //   // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      //   compressQuality: 100,
      //   // maxHeight: 700,
      //   // maxWidth: 700,
      //   compressFormat: ImageCompressFormat.jpg,
      //   androidUiSettings: AndroidUiSettings(
      //     toolbarColor: Colors.white,
      //     toolbarTitle: "Image Cropper",
      //   ),
      // );
      if (isFront) {
        controller.showLoading = true;
        var link = await uploadImage(pickedFile);
        controller.pickedIDProofs.add(link);
        log(controller.pickedIDProofs.toString());
        print(bookingID);
        controller.update();
        controller.showLoading = false;
      }
    }
  }

  void showBottomSheet(bool isFront) {
    Get.bottomSheet(
      Container(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Photo Library'),
              tileColor: Colors.white,
              onTap: () async {
                Get.back();
                browseImage(isFront, ImageSource.gallery);
              },
            ),
            Divider(
              height: 0.5,
            ),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              tileColor: Colors.white,
              onTap: () async {
                Get.back();
                browseImage(isFront, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }

  uploadImage(XFile file) async {
    var link = await FileUploader.uploadIDProof(
        file: File(file.path), bookingID: "101");

    print(bookingID);
    print(link);
    return link;
  }
}

class IDProofController extends GetxController {
  // Uint8List _frontImage;
  // Uint8List _backImage;
  // bool _frontIDProofPicked = false;
  // bool _idProof = false;

  List<String> pickedIDProofs = [
    // "https://www.pandasecurity.com/en/mediacenter/src/uploads/2013/11/pandasecurity-facebook-photo-privacy.jpg",
    // "https://images.unsplash.com/photo-1517960413843-0aee8e2b3285?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8Mnx8fGVufDB8fHx8&w=1000&q=80",
    // "https://images.pexels.com/photos/1133957/pexels-photo-1133957.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    // "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg"
  ];
  bool _showLoading = false;
  bool _shareLoading = false;

  // Uint8List get frontImage => _frontImage;
  //
  // set frontImage(Uint8List value) {
  //   _frontImage = value;
  //   update();
  // }
  //
  // bool get frontIDProofPicked => _frontIDProofPicked;
  //
  // bool get idProof => _idProof;

  bool get showLoading => _showLoading;

  bool get shareLoading => _shareLoading;

  set shareLoading(bool value) {
    _shareLoading = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  // set idProof(bool value) {
  //   _idProof = value;
  //   update();
  // }
  //
  // set frontIDProofPicked(bool value) {
  //   _frontIDProofPicked = value;
  //   update();
  // }
  //
  // Uint8List get backImage => _backImage;
  //
  // set backImage(Uint8List value) {
  //   _backImage = value;
  //   update();
  // }
}
