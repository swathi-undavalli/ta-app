import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:temple_adventures/core/util/app-func.dart';

class FileUploader {
  static Future<String> uploadIDProof({
    File file,
    String bookingID,
  }) async {
    String fileExtension = file.path.split('.').last;
    String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + "." + fileExtension;

    final metadata = SettableMetadata(
        contentType: lookupMimeType(file.path),
        customMetadata: {'picked-file-path': file.path});

    UploadTask task = FirebaseStorage.instance
        .ref("IdProofs")
        .child("/${bookingID}")
        .child("/$fileName")
        .putFile(file, metadata);
    task.then((p0) {
      return p0.ref.getDownloadURL().toString()
       ;
    });
    // .then((TaskSnapshot v) async {
    //   return await v.ref.getDownloadURL();
    // })
    //       .whenComplete(() => showToast("Image Upload SuccessFull".tr))
    //       .onError((dynamic error, stackTrace) async {
    //         showToast(error.toString());
    //       })
    //       .catchError((error) => showToast(error.toString()));
  }

  // static Future<String> uploadIDProofs(Uint8List image) async {
  //   log("started.....");
  //   var request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse("https://staging-api.diversdashboard.com/Kd/api/image_upload"),
  //   );
  //   var picture =
  //   http.MultipartFile.fromBytes('image', image, filename: 'image.png');
  //   request.files.add(picture);
  //   var response = await request.send();
  //   var responseData = await response.stream.toBytes();
  //
  //   Map<String, dynamic> result =
  //   json.decode(String.fromCharCodes(responseData));
  //
  //   return result["file_name"];
  // }

  // static Future<String> uploadVideo(Uint8List video) async {
  //   log("started.....");
  //   var request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse("https://staging-api.diversdashboard.com/Kd/api/video_upload"),
  //   );
  //   var picture =
  //   http.MultipartFile.fromBytes('video', video, filename: 'video.mp4');
  //   request.files.add(picture);
  //   var response = await request.send();
  //   var responseData = await response.stream.toBytes();
  //   print("------------------------");
  //   print(responseData);
  //   Map<String, dynamic> result =
  //   json.decode(String.fromCharCodes(responseData));
  //   return result["file_name"];
  // }

  // static uploadProfileImage(XFile file, Function onSuccess) async {
  //   String fileExtension = file.path.split('.').last;
  //   String fileName =
  //       DateTime.now().millisecondsSinceEpoch.toString() + "." + fileExtension;
  //
  //   final metadata = SettableMetadata(
  //       contentType: lookupMimeType(file.path),
  //       customMetadata: {'picked-file-path': file.path});
  //
  //   Uint8List imageBytes = await file.readAsBytes();
  //
  //   FirebaseStorage.instance
  //       .ref("users")
  //       .child("/${currentUser.id}")
  //       .child("/profilePhotos")
  //       .child("/$fileName")
  //       .putData(imageBytes, metadata)
  //       .then((TaskSnapshot v) async {
  //     onSuccess(await v.ref.getDownloadURL());
  //   })
  //       .whenComplete(() => Utils.showToast("Image Uploaded Successfully"))
  //       .onError((error, stackTrace) async {
  //     Utils.showToast(error.toString());
  //   })
  //       .catchError((error) {
  //     log(error.toString());
  //     Utils.showToast(error.toString());
  //   });
  // }

  // static uploadPDF(Uint8List mediaFile) async {
  //   log("started.....");
  //   var request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse(
  //         "https://diversdashboard.atlassian.net/wiki/spaces/API/pages/122290187/PDF+Upload"),
  //   );
  //   var picture =
  //   http.MultipartFile.fromBytes('pdf', mediaFile, filename: 'doc.pdf');
  //   request.files.add(picture);
  //   var response = await request.send();
  //   var responseData = await response.stream.toBytes();
  //   print("------------------------");
  //   print(responseData);
  //   Map<String, dynamic> result =
  //   json.decode(String.fromCharCodes(responseData));
  //   return result["file_name"];
  // }
}
