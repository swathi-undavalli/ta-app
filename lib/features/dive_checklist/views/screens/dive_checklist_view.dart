import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/checklist_model.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/check_box_widget.dart';
import 'new_checklist_view.dart';

class DiveChecklistView extends StatefulWidget {
  static const String id = 'RecreationalStudentDiveChecklist';

  const DiveChecklistView({Key? key}) : super(key: key);

  @override
  State<DiveChecklistView> createState() => _DiveChecklistViewState();
}

class _DiveChecklistViewState extends State<DiveChecklistView> {
  var args = Get.arguments;

  late ChecklistElement checkListElement;

  late Checklist checklist;

  bool showLoading = false;

  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey widgetKey = GlobalKey();

  @override
  void initState() {
    checkListElement = args[0];
    checklist = args[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          await _captureAndShare();
        },
        child: const Icon(
          Icons.share,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: Get.height,
          child: Stack(
            children: [
              if (showLoading)
                Container(
                  height: Get.height,
                  color: Colors.grey.shade100,
                  child: const CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: Colors.grey,
                  ).center,
                ),
              Column(
                key: UniqueKey(),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepaintBoundary(
                    key: widgetKey,
                    child: _buildCheckList(),
                  ),
                  Spacing.h80,
                ],
              ).scrollable,
              Positioned(
                bottom: 20,
                width: Get.width,
                child: AppButton.flat(
                  text: 'Save',
                  onTap: () async {
                    showLoading = true;
                    setState(() {});

                    await FirebaseFirestore.instance
                        .collection('employeeChecklists')
                        .doc(checkListElement.employeeId)
                        .set(checklist.toMap());

                    showLoading = false;
                    setState(() {});

                    Get.back();
                  },
                  textColor: Colors.white,
                  color: Colors.black,
                ).center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndShare() async {
    try {
      RenderRepaintBoundary boundary = widgetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/screenshot.png';
      File(tempPath).writeAsBytesSync(pngBytes);
      shareImages([tempPath]);
    } catch (e) {
      log('Error while capturing and sharing the screenshot: $e');
    }
  }

  Future<void> shareImages(List<String> images) async {
    try {
      Share.shareFiles(images);
    } catch (e) {
      log('Error while sharing images $e');
    }
  }

  Widget _buildCheckList() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.h10,
          Text(
            checkListElement.title,
            style: TextStyle(
              color: AppColors.text.black,
              fontSize: 16,
              fontFamily: AppFonts.nunito,
              fontWeight: FontWeight.normal,
              letterSpacing: 1.2,
            ),
          ),
          _buildDescription(),
          ...checkListElement.items.map(
            (e) {
              return CheckBoxWidget(
                onChanged: (bool value) {
                  checkListElement.items[checkListElement.items.indexOf(e)].isChecked = value;
                  setState(() {});
                  log(
                    checkListElement.items.map((e) => e.isChecked).toList().toString(),
                  );
                },
                text: e.name,
                initialValue: e.isChecked,
              ).paddingOnly(bottom: 10);
            },
          ),
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 80,
      leading: Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          ),
        ),
      ),
      title: Text(
        'Checklist',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 16,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ).center,
      actions: [
        PopupMenuButton(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Colors.black,
          ),
          key: _menuKey,
          itemBuilder: (context) => <PopupMenuItem<String>>[
            PopupMenuItem<String>(
              child: const Text(
                'Edit',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () async {
                /// Delay is used because the PopupMenuButton closes automatically and because navigation happens to fast,it closes the new route instead of the menuButton.

                await Future.delayed(const Duration(milliseconds: 10));
                Get.toNamed(
                  NewChecklistView.id,
                  arguments: [checkListElement, TemplateType.existingChecklist],
                );
              },
            ),
            PopupMenuItem<String>(
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 12),
              ),
              onTap: () async {
                showLoading = true;
                setState(() {});

                log('started');

                checklist.checklistElement?.remove(checkListElement);

                await FirebaseFirestore.instance
                    .collection('employeeChecklists')
                    .doc(checkListElement.employeeId)
                    .set(checklist.toMap());

                showLoading = false;
                setState(() {});
                log('ended');
                Get.back();
              },
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            checkListElement.items
                .map(
                  (e) => e.isChecked = false,
                )
                .toList();
            setState(() {});
          },
          child: Icon(
            Icons.refresh,
            color: AppColors.text.black,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      checkListElement.description,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontFamily: AppFonts.nunito,
        height: 1.5,
      ),
    ).paddingSymmetric(
      vertical: (checkListElement.description.isEmpty) ? 0 : 20,
    );
  }
}
