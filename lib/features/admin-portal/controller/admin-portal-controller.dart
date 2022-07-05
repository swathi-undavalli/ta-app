import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AdminPortalLogic {
  AdminPortalController controller = Get.put(AdminPortalController());
  ImagePicker imagePicker = ImagePicker();

  browseImage(bool isFront, ImageSource source) async {
    print("==========started");
    XFile pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 50);
    print("==========ended");

    if (pickedFile != null) {
      // if (isFront) controller.idProofFile = pickedFile;
      // var link = await uploadImage(pickedFile);
      // controller.idProofs.add(pickedFile);
      // controller.update();
      uploadImage(pickedFile);
      // controller.idProofLink = null;
      // controller.uploadedImageUrl = null;
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
    var link = File(file.path);

    controller.pickedFile.add(link.path);
    controller.update();
    // print(link);
    // return link;
  }

  void removeAtIndex(int index) {
    controller.pickedFile.removeAt(index);
    controller.update();
  }
}

class AdminPortalController extends GetxController {
  // XFile _idProofFile;

  TextEditingController titleTED = TextEditingController();

  List<XFile> idProofs = [];

  List<File> pdfs = [];

  List<String> pickedFile = [];

  TextEditingController pdfName = TextEditingController();

  // XFile get idProofFile => _idProofFile;

  // set idProofFile(XFile value) {
  //   _idProofFile = value;
  //   update();
  // }
}
