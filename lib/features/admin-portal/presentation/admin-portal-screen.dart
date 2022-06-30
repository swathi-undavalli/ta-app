import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/features/admin-portal/presentation/image-view-page.dart';
import 'package:temple_adventures/features/admin-portal/presentation/pdf-viewer-page.dart';
import '../../../core/constants/constants.dart';
import '../../../core/widgets/app-button.dart';
import '../controller/admin-portal-controller.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class AdminPortalScreen extends StatelessWidget {
  static const String id = "CreateCirculars";
  AdminPortalLogic logic = AdminPortalLogic();

  Future<firebase_storage.UploadTask> uploadFile(File file) async {
    if (file == null) {
      print("No file was picked");
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('pdfs')
        .child('/"${logic.controller.pdfName.text}".pdf');

    print(file.path);
    final metaData = firebase_storage.SettableMetadata(
        contentType: 'file/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("uploading...");
    uploadTask = ref.putData(await file.readAsBytes(), metaData);
    print("Done...!");
    return Future.value(uploadTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                GetBuilder<AdminPortalController>(builder: (controller) {
                  return Column(
                    children: [
                      ...logic.controller.path.map((e) {
                        if (e.endsWith(".pdf")) {
                          return buildPDF(context, File(e));
                        }
                        return buildIDProof(image: e);
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///==============UI===============///

  Widget buildPDF(BuildContext context, File file) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PDFViewerPage(file: file);
        }));
      },
      child: Container(
        height: Get.height * 0.075,
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: AppColors.background.lightSkyBlue),
              child: Center(
                child: Text("PDF",
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
            SizedBox(width: 28),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width * 0.61,
                  child: Text(
                    "${basename(file.path)}",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Text(
                  "Modified  " +
                      DateFormat.yMMMd().format(
                        DateTime.now(),
                      ),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Expanded(child: Container(color: Colors.transparent)),
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    buildPDFBottomSheet(file),
                  );
                },
                splashRadius: 20,
                icon: Icon(Icons.more_vert, size: 22)),
          ],
        ),
      ),
    );
  }

  Widget buildPDFBottomSheet(File file) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: AppColors.background.lightSkyBlue),
                    child: Center(
                      child: Text("PDF",
                          style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${basename(file.path)}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.grey.shade300),
          SizedBox(height: 20),
          Container(
            height: 60,
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share_rounded, size: 19),
                  SizedBox(width: 20),
                  Text("Share",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<File> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) {
      return null;
    } else
      return File(result.paths.first);
  }

  Widget buildIcon({IconData icon, Function onTap, String text}) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: AppColors.background.lightSkyBlue,
              border: Border.all(color: AppColors.background.lightSkyBlue)),
          child: IconButton(
            onPressed: onTap,
            icon: Icon(icon, size: 20),
          ),
        ),
        SizedBox(height: 10),
        Text(
          text,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  Widget buildIDProof({BuildContext context, String image}) {
    return GetBuilder<AdminPortalController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(ImageViewPage.id, arguments: image);
        },
        child: Container(
          height: Get.height * 0.075,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(File(image)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      // "${basename(image)}",
                      "Image",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "Modified  " +
                        DateFormat.yMMMd().format(
                          DateTime.now(),
                        ),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Expanded(child: Container(color: Colors.transparent)),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert, size: 22),
                  splashRadius: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        Get.bottomSheet(Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text("Upload", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildIcon(
                      icon: Icons.image,
                      text: "Image",
                      onTap: () {
                        logic.showBottomSheet(true);
                      }),
                  buildIcon(
                      icon: Icons.upload_file,
                      text: "File",
                      onTap: () async {
                        final file = await pickFile();
                        if (file == null) return;

                        logic.controller.path.add(file.path);
                        logic.controller.update();

                        // openPDF(context, file);
                        // Get.defaultDialog(
                        //   title: "\nEnter PdfName",
                        //   titleStyle: TextStyle(
                        //       color: AppColors.text.black,
                        //       fontFamily: AppFonts.nunito,
                        //       fontSize: 16,
                        //       fontWeight: FontWeight.bold),
                        //   content: Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: TextField(
                        //       controller: logic.controller.pdfName,
                        //       decoration:
                        //           InputDecoration(label: Text("name")),
                        //     ),
                        //   ),
                        //   radius: 10,
                        //   confirm: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       AppButton.miniText(
                        //         text: 'Cancel',
                        //         onTap: () {
                        //           Get.back();
                        //         },
                        //       ),
                        //       AppButton.miniFlat(
                        //           text: 'OK',
                        //           onTap: () async {
                        //
                        //             // final path = await FlutterDocumentPicker
                        //             //     .openDocument();
                        //             // print(path);
                        //             // File file = File(path);
                        //             // if (logic.controller.pdfName.text != "") {
                        //             //   firebase_storage.UploadTask task =
                        //             //       await uploadFile(file);
                        //             //   print(task);
                        //             //   Get.back();
                        //
                        //
                        //           }
                        //           // },
                        //           ),
                        //     ],
                        //   ),
                        // );
                        // logic.controller.pdfName.text = "";
                      }),
                ],
              ),
            ],
          ),
        ));
      },
      backgroundColor: AppColors.background.black,
      child: Icon(Icons.add),
    );
  }
}
