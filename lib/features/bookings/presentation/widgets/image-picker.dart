import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class IDProofPicker {
  ImagePicker imagePicker = ImagePicker();
  Function onImagePicked;

  GalleryImagePickerController1 controller =
      Get.put(GalleryImagePickerController1());

  IDProofPicker();
  browseImage(ImageSource source) async {
    XFile pickedFile =
        await imagePicker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      ImageCropper imageCropper = ImageCropper();
      File file = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: "Image Cropper",
        ),
      );
      controller.image = file;
      onImagePicked();
    }
  }

  void showBottomSheet() {
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
                browseImage(ImageSource.gallery);
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
                browseImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.3),
    );
  }
}

class GalleryImagePickerController1 extends GetxController {
  File _image;

  set image(File value) {
    _image = value;
    update();
  }

  File get image => _image;

  reset() {
    _image = null;
  }
}
