import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/util/ta-image.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/bookings/controller/idProof-controller.dart';
import 'package:http/http.dart' as http;

class AllIDProofsScreen extends StatelessWidget {
  static const String id = "AllIDProofsScreen";
  final imageID = Get.arguments;

  IDProofLogic logic = IDProofLogic();
  final PageController controller = PageController();

  AllIDProofsScreen() {
    Future.delayed(Duration(microseconds: 300)).whenComplete(() =>
        controller.animateToPage(imageID,
            duration: Duration(milliseconds: 500), curve: Curves.easeOut));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: buildAppBar(),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child:
                  GetBuilder<IDProofController>(builder: (idProofController) {
                return Column(
                  children: [
                    Container(
                      height: Get.height - 200,
                      width: Get.width,
                      child: PageView(
                        controller: controller,
                        children: <Widget>[
                          ...idProofController.idProofs.map(
                            (e) {
                              return buildIDProof(image: e);
                            },
                          ),
                          // ...List.generate(
                          //     idProofController.pickedIDProofs.length,
                          //     (index) => buildIDProof(
                          //         image: idProofController
                          //             .pickedIDProofs[imageID]))
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildIcons(
                            icon: Icons.share,
                            onTap: () async {
                              idProofController.shareLoading = true;
                              final urlImage = idProofController
                                  .idProofs[controller.page.toInt()];
                              final url = Uri.parse(urlImage);
                              final response = await http.get(url);
                              final bytes = response.bodyBytes;

                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.jpg';
                              File(path).writeAsBytesSync(bytes);
                              await Share.shareFiles([path]);
                              idProofController.shareLoading = false;
                            },
                            iconName: "Share"),
                        buildIcons(
                            icon: Icons.download,
                            onTap: () async {
                              // final ByteData imageData =
                              //     await NetworkAssetBundle(Uri.parse(
                              //             "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg"))
                              //         .load("");
                              // final Uint8List bytes =
                              //     imageData.buffer.asUint8List();
                              // Image.memory(bytes);
                              // showToast("Downloaded Successfully");
                              // var storagePermission =
                              //     await Permission.storage.status;
                              // log(storagePermission.toStr;
                              // log("storageeeeee");
                              // if (storagePermission.isGranted) {
                              //   await Permission.storage.request();
                              // }
                              String url = idProofController
                                  .idProofs[controller.page.toInt()];
                              // String url =
                              //     "https://media.wired.com/photos/5fb70f2ce7b75db783b7012c/master/pass/Gear-Photos-597589287.jpg";
                              GallerySaver.saveImage(url).then((value) {
                                showToast("Downloaded successfully");
                              });
                            },
                            iconName: "Download"),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                );
              }),
            ),
          ),
        ),
        buildShowLoading(),
      ],
    );
  }

  Widget buildIcons({IconData icon, Function onTap, String iconName}) {
    return Column(
      children: [
        IconButton(
          iconSize: 20,
          icon: Icon(icon),
          color: AppColors.text.black,
          onPressed: onTap,
        ),
        Text(
          iconName,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildIDProof({String image}) {
    return GestureDetector(
      onTap: () {
        // Get.bottomSheet(
        //     Container(
        //       height: 60,
        //       width: Get.width,
        //       child: Padding(
        //         padding: const EdgeInsets.only(left: 30.0, right: 30),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             buildBottomSheetIcons(
        //                 icon: Icons.share_outlined, iconName: "Share"),
        //             buildBottomSheetIcons(
        //                 icon: Icons.delete_outlined, iconName: "Delete"),
        //           ],
        //         ),
        //       ),
        //     ),
        //     barrierColor: Colors.transparent,
        //     backgroundColor: Colors.white);
      },
      child: Container(
        decoration: BoxDecoration(
          // image: image != null
          //     ? DecorationImage(
          //         image: MemoryImage(image),
          //         fit: BoxFit.scaleDown,
          //       )
          //     : null,
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(4, 4),
            ),
          ],
          color: AppColors.text.white,
        ),
        child: (image != null) ? TAImage(image.toString()) : null,
      ),
    );
  }

  Widget buildShowLoading() {
    return GetBuilder<IDProofController>(builder: (controller) {
      if (controller.shareLoading)
        return Container(
          color: Colors.black38,
          height: Get.height,
          width: Get.width,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
        );
      else
        return Container();
    });
  }

// Widget buildBottomSheetIcons({IconData icon, String iconName}) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Icon(
  //         icon,
  //         // Icons.share_outlined,
  //         color: AppColors.text.black,
  //         size: 20,
  //       ),
  //       SizedBox(height: 5),
  //       Text(
  //         iconName,
  //         style: TextStyle(color: Colors.black38, fontSize: 10),
  //       ),
  //     ],
  //   );
  // }
}
