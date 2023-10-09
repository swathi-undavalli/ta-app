import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/alignment_extensions.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/core/widgets/ta-image.dart';
import 'package:temple_adventures/features/Marketing/controllers/marketing-controller.dart';
import 'package:temple_adventures/features/Marketing/models/marketing-model.dart';
import 'package:temple_adventures/features/Marketing/widgets/marketing-content-entry-bottomSheet.dart';

import '../../../core/widgets/app-button.dart';

class MarketingView extends StatefulWidget {
  const MarketingView({Key? key}) : super(key: key);
  static const String id = "MarketingView";

  @override
  State<MarketingView> createState() => _MarketingViewState();
}

class _MarketingViewState extends State<MarketingView> {
  MarketingLogic logic = MarketingLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        child: GetBuilder<MarketingController>(builder: (controller) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance.collection("marketing").doc("marketing").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  );
                }
                final data = snapshot.data?.data();

                if (data == null) {
                  return Container(
                    height: Get.height,
                    child: Text(
                      'Marketing Gallery is empty',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ).center,
                  );
                }

                Marketing? marketing = Marketing.fromJson(data as Map<String, dynamic>);

                if ((marketing.marketingGallery ?? []).isEmpty) {
                  return Container(
                    height: Get.height,
                    child: Text(
                      'Marketing Gallery is empty',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ).center,
                  );
                }
                return Column(
                  children: (marketing.marketingGallery ?? [])
                      .map(
                        (element) => Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(offset: Offset(1, 3), spreadRadius: 2, color: Colors.grey.shade100),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  buildPreviewImage(url: element.url, urlType: element.type),
                                  Spacing.w20,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      buildDeleteEditIcons(
                                          index: (marketing.marketingGallery ?? []).indexOf(element),
                                          marketingElement: element),
                                      Spacing.h10,
                                      buildContent(title: "Name : ", value: element.name ?? "-"),
                                      buildContent(title: "URL : ", value: element.url),
                                      buildContent(title: "Type : ", value: element.type),
                                      if (element.type == "Image")
                                        buildContent(title: "Delay : ", value: "${element.delay.toString()} sec"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ).paddingAll(10),
                        ).paddingOnly(bottom: 20),
                      )
                      .toList(),
                ).scrollable;
              });
        }).paddingSymmetric(horizontal: 20, vertical: 30),
      ),
    );
  }

  Widget buildPreviewImage({required String url, required String urlType}) {
    getPreviewWidget() {
      if (urlType == "Image") {
        return TAImage(
          url,
          fit: BoxFit.contain,
        );
      } else if (urlType == "Video") {
        return TAImage(
          AppImages.icons.video,
          fit: BoxFit.contain,
        );
      } else {
        return Lottie.network(url);
      }
    }

    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: getPreviewWidget().paddingAll(5),
    );
  }

  Widget buildDeleteEditIcons({required int index, required MarketingElement marketingElement}) {
    return SizedBox(
      width: Get.width - 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildIcons(
              icon: Icons.delete,
              color: Colors.red.shade500,
              onTap: () {
                deleteDialog(context, index: index, marketingElement: marketingElement);
              }),
          buildIcons(
              icon: Icons.edit,
              color: Colors.black,
              onTap: () {
                MarketingContentEntryBottomSheet.show(
                  context,
                  elementIndex: index,
                  marketingElementModel: marketingElement,
                );
              }),
        ],
      ),
    );
  }

  Future<void> deleteDialog(BuildContext context,
      {required int index, required MarketingElement marketingElement}) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Are you sure?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            content: Text(
              "${marketingElement.type} will be completely deleted",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            actions: <Widget>[
              AppButton.miniText(
                text: "Cancel",
                onTap: () {
                  Get.back();
                },
              ),
              AppButton.miniFlat(
                text: "Okay",
                onTap: () {
                  logic.onDeletePressed(index);
                  Get.back();
                },
              ),
            ],
          );
        });
  }

  Widget buildIcons({required IconData icon, required Color color, required Function onTap}) {
    return IconButton(
        onPressed: () {
          onTap();
          log("tapped");
        },
        icon: Icon(
          icon,
          color: color,
          size: 20,
        ));
  }

  Widget buildContent({required String title, required String? value}) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: 130,
          child: Text(
            (value != null && value.isNotEmpty) ? value : " --",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 10);
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        MarketingContentEntryBottomSheet.show(context);
      },
      backgroundColor: AppColors.background.black,
      child: Icon(Icons.add),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'Marketing',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.0,
        ),
      ),
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.text.black,
          size: 17,
        ),
      ),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
