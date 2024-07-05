import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:temple_ui_tools/utils/utils.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/util/alignment_extensions.dart';
import '../../../core/util/spacing_widgets.dart';
import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/ta_image.dart';
import '../models/marketing.dart';
import '../widgets/marketing_content_entry_bottom_sheet.dart';

class MarketingView extends StatefulWidget {
  const MarketingView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => const MarketingView(),
      );

  @override
  State<MarketingView> createState() => _MarketingViewState();
}

class _MarketingViewState extends State<MarketingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Marketing'),
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('marketing').doc('marketing').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
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
              return SizedBox(
                height: Screen.height,
                child: const Text(
                  'Marketing Gallery is empty',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ).center,
              );
            }

            Marketing? marketing = Marketing.fromJson(data as Map<String, dynamic>);

            if ((marketing.marketingElements ?? []).isEmpty) {
              return SizedBox(
                height: Screen.height,
                child: const Text(
                  'Marketing Gallery is empty',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ).center,
              );
            }
            return Column(
              children: [
                Spacing.h10,
                ...(marketing.marketingElements ?? []).map(
                  (element) => buildMarketingCard(
                    element: element,
                    index: (marketing.marketingElements ?? []).indexOf(element),
                  ).paddingOnly(top: 20),
                ),
                Spacing.h30,
              ],
            ).scrollable;
          },
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }

  Widget buildMarketingCard({required MarketingElement element, required int index}) {
    return Container(
      width: Screen.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(offset: const Offset(1, 3), spreadRadius: 2, color: Colors.grey.shade100),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              buildPreviewImage(url: element.url, urlType: element.type),
              Spacing.h10,
              buildDeleteEditIcons(index: index, marketingElement: element),
            ],
          ),
          Spacing.w20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.h5,
              buildContent(
                value: (element.name ?? 'Untitled').capitalizeFirst,
                fontSize: 16,
                color: Colors.black,
              ),
              Spacing.h10,
              buildContent(value: element.type),
              Spacing.h5,
              buildContent(value: element.url),
              Spacing.h5,
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.nunito,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.grey,
                  ),
                  children: [
                    const TextSpan(text: 'Displays for '),
                    TextSpan(
                      text: ' ${element.duration} secs',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Spacing.h5,
              RichText(
                text: TextSpan(
                  text: 'Created By : ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.nunito,
                    color: Colors.grey,
                  ),
                  children: <TextSpan>[
                    TextSpan(style: TextStyle(color: AppColors.text.black), text: element.createdBy ?? '-'),
                  ],
                ),
              ).left,
            ],
          ),
        ],
      ).paddingAll(10),
    );
  }

  Widget buildPreviewImage({required String url, required String urlType}) {
    getPreviewWidget() {
      if (urlType == 'Image') {
        return TAImage(
          url,
          fit: BoxFit.cover,
        );
      } else if (urlType == 'Video') {
        return TAImage(
          AppImages.icons.video,
          fit: BoxFit.cover,
        );
      } else {
        return Lottie.network(
          url,
          fit: BoxFit.cover,
        );
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 100,
        height: 93,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: getPreviewWidget(),
      ),
    );
  }

  Widget buildDeleteEditIcons({required int index, required MarketingElement marketingElement}) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildIcons(
            icon: Icons.delete,
            onTap: () {
              deleteDialog(context, index: index, marketingElement: marketingElement);
            },
          ),
          buildIcons(
            icon: Icons.edit,
            onTap: () {
              MarketingContentEntryBottomSheet.show(
                context,
                elementIndex: index,
                marketingElementModel: marketingElement,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> deleteDialog(
    BuildContext context, {
    required int index,
    required MarketingElement marketingElement,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Text(
            '${marketingElement.type} will be completely deleted',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () {
                onDeletePressed(index);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  onDeletePressed(int index) async {
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('marketing').doc('marketing').get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    Marketing marketing = Marketing.fromJson(data);
    marketing.marketingElements?.removeAt(index);
    await FirebaseFirestore.instance.collection('marketing').doc('marketing').set(marketing.toJson());
  }

  Widget buildIcons({required IconData icon, required Function onTap}) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: AppColors.text.lightSkyBlue,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        splashRadius: 20,
        iconSize: 15,
        onPressed: () {
          onTap();
          log('tapped');
        },
        icon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildContent({required String? value, double fontSize = 12, Color color = Colors.grey}) {
    return SizedBox(
      width: Screen.width - 190,
      child: Text(
        (value != null && value.isNotEmpty) ? value : 'Untitled',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          fontFamily: AppFonts.nunito,
          overflow: TextOverflow.ellipsis,
          color: color,
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        MarketingContentEntryBottomSheet.show(context);
      },
      backgroundColor: AppColors.background.black,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
