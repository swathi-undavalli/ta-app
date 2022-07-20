import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:temple_adventures/core/services/file-uploader.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/admin-portal/models/adminPortal-model.dart';
import 'package:temple_adventures/features/admin-portal/presentation/image-view-page.dart';
import 'package:temple_adventures/features/admin-portal/presentation/pdf-viewer-page.dart';
import '../../../core/constants/constants.dart';
import '../../../core/util/app-func.dart';
import '../../../pdf_api.dart';
import '../../counter-model.dart';
import '../controller/admin-portal-controller.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AdminPortalScreen extends StatelessWidget {
  static const String id = "CreateCirculars";
  AdminPortalLogic logic = AdminPortalLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: BackNavigationIcon(),
        elevation: 0,
        backgroundColor: AppColors.background.white,
      ),
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: 20),
                GetBuilder<AdminPortalController>(builder: (controller) {
                  return Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("adminPortal")
                            .orderBy("id")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            );
                          }
                          return Column(
                            children: [
                              ...snapshot.data.docs.map(
                                (document) {
                                  AdminPortalModel adminPortalModel =
                                      AdminPortalModel.fromMap(document.data());
                                  log(adminPortalModel.filename);
                                  if (adminPortalModel.filename
                                      .endsWith(".pdf")) {
                                    return buildPDF(
                                        context: context,
                                        adminPortalModel: adminPortalModel);
                                  }
                                  return buildIDProof(
                                      adminPortalModel: adminPortalModel);
                                },
                              ).toList(),
                            ],
                          );
                        },
                      )
                      // buildCheckFirebase(),
                      // ...logic.controller.pickedFile.map((e) {
                      //   if (e.endsWith(".pdf")) {
                      //     return buildPDF(context: context, file: File(e));
                      //   }
                      //   return buildIDProof(image: e);
                      // }),
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

  ///==============UI=============== ///

  Widget buildCheckFirebase() {
    return Expanded(
      child: GetBuilder<AdminPortalController>(builder: (controller) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection("adminPortal").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                AdminPortalModel adminPortalModel =
                    AdminPortalModel.fromMap(snapshot.data.docs[index].data());
                log(adminPortalModel.path);
                if (adminPortalModel.path.endsWith(".pdf")) {
                  return buildPDF(
                      context: context, adminPortalModel: adminPortalModel);
                }
                return buildIDProof(adminPortalModel: adminPortalModel);
              },
            );
          },
        );
      }),
    );
  }

  Widget buildTitle() {
    return Text(
      'Resources',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildPDF({BuildContext context, AdminPortalModel adminPortalModel}) {
    return GestureDetector(
      onTap: () async {
        final file = await PdfAPi.loadNetwork(adminPortalModel.path);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return PDFViewerPage(
            adminPortalModel: adminPortalModel,
            file: file,
          );
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
                    adminPortalModel.filename,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Text(
                  "Modified  " +
                      DateFormat.yMMMd()
                          .format(adminPortalModel.timeStamp.toDate()),
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            Expanded(child: Container(color: Colors.transparent)),
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    buildPDFOptions(adminPortalModel),
                  );
                },
                splashRadius: 20,
                icon: Icon(Icons.more_vert, size: 22)),
          ],
        ),
      ),
    );
  }

  Widget buildPDFOptions(AdminPortalModel adminPortalModel) {
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        adminPortalModel.filename,
                        // "${basename(file.path)}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            "Uploaded By: ",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            adminPortalModel.createdBy,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.grey.shade300),
          SizedBox(height: 20),
          buildOptions(
              name: "Share",
              icon: Icons.share_rounded,
              onTap: () async {
                print(adminPortalModel.path);
                print("==============================");
                final urlPath = adminPortalModel.path;
                final url = Uri.parse(urlPath);
                print(url);
                final response = await http.get(url);
                final bytes = response.bodyBytes;

                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/${adminPortalModel.filename}';
                File(path).writeAsBytesSync(bytes);
                await Share.shareFiles([path]);
                showToast("Sharing");
              }),
          buildOptions(
              name: "Download",
              icon: Icons.file_download,
              onTap: () async {
                var storage = await Permission.storage.status;

                if(storage.isGranted){
                  await Permission.storage.request();
                }

                var appDocDir = await DownloadsPathProvider.downloadsDirectory;
                String url = adminPortalModel.path;
                String savePath =
                    appDocDir.path + "/${adminPortalModel.filename}";
                await Dio().download(url, savePath);
                showToast("Downloaded Successfully");
              }),
        ],
      ),
    );
  }

  Widget buildOptions({String name, IconData icon, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 19),
              SizedBox(width: 20),
              Text(name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Expanded(child: Container(color: Colors.transparent)),
            ],
          ),
        ),
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

  Widget buildIDProof(
      {BuildContext context, AdminPortalModel adminPortalModel}) {
    return GetBuilder<AdminPortalController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(ImageViewPage.id, arguments: adminPortalModel);
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
                  image: adminPortalModel.path != null
                      ? DecorationImage(
                          image: NetworkImage(adminPortalModel.path),
                          // FileImage(
                          //   File(adminPortalModel.path),
                          // ),
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
                  onPressed: () {
                    Get.bottomSheet(
                      buildIDProofOptions(adminPortalModel),
                    );
                  },
                  splashRadius: 20,
                  icon: Icon(Icons.more_vert, size: 22)),
            ],
          ),
        ),
      );
    });
  }

  Widget buildIDProofOptions(AdminPortalModel adminPortalModel) {
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 25,
                    width: 25,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: adminPortalModel.path != null
                            ? DecorationImage(
                                image: NetworkImage(adminPortalModel.path),

                                // FileImage(File(adminPortalModel.path)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Image",
                        // "${basename(image)}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            "Uploaded By: ",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            adminPortalModel.createdBy,
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.grey.shade300),
          SizedBox(height: 20),
          buildOptions(
              name: "Share",
              icon: Icons.share_rounded,
              onTap: () async {
                print(adminPortalModel.path);
                print("==============================");
                // idProofController.shareLoading = true;
                final urlImage = adminPortalModel.path;
                final url = Uri.parse(urlImage);
                print(url);
                final response = await http.get(url);
                final bytes = response.bodyBytes;

                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/image.jpg';
                File(path).writeAsBytesSync(bytes);
                await Share.shareFiles([path]);
                showToast("Sharing");

                // idProofController.shareLoading = false;
              }),
          buildOptions(
              name: "Download",
              icon: Icons.file_download,
              onTap: () async {
                String url = adminPortalModel.path;
                GallerySaver.saveImage(url).then((value) {
                  showToast("Downloaded successfully");
                });
              }),
        ],
      ),
    );
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
              GetBuilder<AdminPortalController>(builder: (controller) {
                return Row(
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
                        if (file == null) {
                          return;
                        } else {
                          File pdfFile = File(file.path);

                          var filePath =
                              await FileUploader.uploadPDFFile(file: pdfFile);
                          controller.adminPortalModel = AdminPortalModel(
                              path: filePath,
                              filename: basename(file.path),
                              id: (counterModel.files + 1).toString());
                          log("aklsnasd");
                          FirebaseFirestore.instance
                              .collection("adminPortal")
                              .doc((counterModel.files + 1).toString())
                              .set(controller.adminPortalModel.toMap());

                          counterModel.files++;

                          FirebaseFirestore.instance
                              .collection("counter")
                              .doc("count")
                              .set(counterModel.toMap());

                          controller.update();
                          controller.pickedFile.add(pdfFile.path);
                          controller.update();
                        }
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ));
      },
      backgroundColor: AppColors.background.black,
      child: Icon(Icons.add),
    );
  }
}
