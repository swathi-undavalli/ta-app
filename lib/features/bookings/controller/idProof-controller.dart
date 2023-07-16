import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temple_adventures/core/services/file-uploader.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class IDProofLogic {
  BookingModel? bookingModel;

  IDProofController controller = Get.put(IDProofController());

  ImagePicker imagePicker = ImagePicker();
  Function? onImagePicked;

  browseImage(bool isFront, ImageSource source) async {
    //print("==========started");
    XFile? pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 50);
    //print("==========ended");
    if (pickedFile != null) {
      if (isFront) {
        controller.showLoading = true;
        var link = await uploadImage(pickedFile);
        controller.idProofs!.add(link);
        bookingModel!.idProofs = controller.idProofs;
        FirebaseFirestore.instance
            .collection("bookings")
            .doc(bookingModel!.id)
            .set(bookingModel!.toMap());
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
        file: File(file.path), bookingID: bookingModel!.id);

    //print(bookingModel.id);
    // print(link);
    return link;
  }
}

class IDProofController extends GetxController {
  List<String?>? idProofs = [];
  bool _showLoading = false;
  bool _shareLoading = false;

  reset() {
    idProofs = [];
  }

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
}
