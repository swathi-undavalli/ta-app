import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/alignment_extensions.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import '../../controllers/dive-checklist-controller.dart';
import '../widgets/check-box-widget.dart';

class DiveChecklistView extends StatelessWidget {
  static const String id = "RecreationalStudentDiveChecklist";
  final DiveChecklistLogic logic = DiveChecklistLogic();
  final bool isRecreationalDiveChecklist = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: GetBuilder<DiveChecklistController>(builder: (controller) {
          return Column(
            key: UniqueKey(),
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDescription(),
              Spacing.h20,
              _buildCheckList(),
              Spacing.h20,
              AppButton.flat(
                text: "Save",
                onTap: () {
                  Get.back();
                },
                textColor: Colors.white,
                color: Colors.black,
              ).center,
            ],
          ).paddingSymmetric(horizontal: 20, vertical: 30).scrollable;
        }),
      ),
    );
  }

  Widget _buildCheckList() {
    return Column(children: [
      if (isRecreationalDiveChecklist)
        ...logic.controller.recreationalDiveCheckList.map(
          (e) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (logic.controller.recreationalDiveCheckList.indexOf(e) == 8)
                  Text(
                    "Green Box : ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ).paddingOnly(bottom: 15, top: 5),
                if (logic.controller.recreationalDiveCheckList.indexOf(e) == 14)
                  Text(
                    "Green Dry Box : ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ).paddingOnly(bottom: 15, top: 5),
                CheckBoxWidget(
                  onChanged: (_) {},
                  text: e,
                  initialValue: false,
                ).paddingOnly(bottom: 10),
              ],
            );
          },
        ),
      if (!isRecreationalDiveChecklist)
        ...logic.controller.recreationalStudentDiveCheckList.map(
          (e) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (logic.controller.recreationalDiveCheckList.indexOf(e) == 8)
                  Text(
                    "Green Box : ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ).paddingOnly(bottom: 15, top: 5),
                if (logic.controller.recreationalDiveCheckList.indexOf(e) == 14)
                  Text(
                    "Green Dry Box : ",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ).paddingOnly(bottom: 15, top: 5),
                CheckBoxWidget(
                  onChanged: (_) {},
                  text: e,
                  initialValue: false,
                ).paddingOnly(bottom: 10),
              ],
            );
          },
        )
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
        (isRecreationalDiveChecklist)
            ? "Recreational Dive\n "
                "Checklist"
            : "Recreational Student\n Dive Checklist",
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
            logic.controller.update();
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
      (isRecreationalDiveChecklist)
          ? "Recreational Dive Checklist is a set of essential things that needs to be taken for every dive."
          : "Recreational Student Dive Checklist is a set of essential things that needs to be taken for every dive.",
      style: TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontFamily: AppFonts.nunito,
        height: 1.5,
      ),
    );
  }
}
