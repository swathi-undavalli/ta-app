import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void initState() {
    checkListElement = args[0];
    checklist = args[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
                  _buildDescription().paddingSymmetric(vertical: 20),
                  _buildCheckList(),
                  Spacing.h60,
                ],
              ).paddingSymmetric(horizontal: 20).scrollable,
              Positioned(
                bottom: 20,
                width: Get.width,
                child: AppButton.flat(
                  text: 'Close',
                  onTap: () {
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

  Widget _buildCheckList() {
    return Column(
      children: [
        ...checkListElement.items.map(
          (e) {
            return CheckBoxWidget(
              onChanged: (_) {},
              text: e,
              initialValue: false,
            ).paddingOnly(bottom: 10);
          },
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    final button = PopupMenuButton(
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.black,
      ),
      key: _menuKey,
      itemBuilder: (_) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          child: const Text(
            'Edit',
            style: TextStyle(fontSize: 12),
          ),
          onTap: () async {
            Get.toNamed(
              NewChecklistView.id,
              arguments: checkListElement,
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
    );

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
        checkListElement.name,
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 16,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ).center,
      actions: [
        button,
        TextButton(
          onPressed: () {
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
        fontSize: 13,
        fontFamily: AppFonts.nunito,
        height: 1.5,
      ),
    );
  }
}
