import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/alignment_extensions.dart';
import 'package:temple_adventures/core/util/spacing_widgets.dart';
import 'package:temple_adventures/core/widgets/app_button.dart';

import '../../../../core/models/checklist_model.dart';
import '../widgets/check_box_widget.dart';

class DiveChecklistView extends StatefulWidget {
  static const String id = "RecreationalStudentDiveChecklist";

  @override
  State<DiveChecklistView> createState() => _DiveChecklistViewState();
}

class _DiveChecklistViewState extends State<DiveChecklistView> {
  final Checklist checkList = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Column(
          key: UniqueKey(),
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDescription(),
            Spacing.h20,
            _buildCheckList(),
            Spacing.h20,
            AppButton.flat(
              text: "Close",
              onTap: () {
                Get.back();
              },
              textColor: Colors.white,
              color: Colors.black,
            ).center,
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 30).scrollable,
      ),
    );
  }

  Widget _buildCheckList() {
    return Column(children: [
      ...checkList.items.map(
        (e) {
          return CheckBoxWidget(
            onChanged: (_) {},
            text: e,
            initialValue: false,
          ).paddingOnly(bottom: 10);
        },
      ),
    ]);
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
        checkList.name,
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 16,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ).center,
      actions: [
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
      checkList.description,
      style: TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontFamily: AppFonts.nunito,
        height: 1.5,
      ),
    );
  }
}
