import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';

import '../controller/conditions-controller.dart';
import '../models/conditions-model.dart';
import '../widgets/depth-expansion-panel-widget.dart';
import '../widgets/surface-conditions-expansion-panel.dart';

class ConditionsScreen extends StatelessWidget {
  final ConditionsLogic logic = ConditionsLogic();

  ConditionsScreen() {
    logic.init();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {
              logic.onFloatingActionButtonPressed();
            },
            backgroundColor: AppColors.background.black,
            child: Icon(Icons.add),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: GetBuilder<ConditionsController>(builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 103,
                          child: Text(
                            DateFormat('dd-MMM-yyyy').format(controller.selectedDate),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            selectDate(context);
                          },
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            size: 17,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(horizontal: 32),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        ...controller.reefs.map(
                          (e) => buildChip(
                            onTap: () {
                              logic.onChipChanged(e);
                            },
                            reefName: e,
                          ),
                        )
                      ]).paddingSymmetric(horizontal: 27),
                    ),
                    SizedBox(height: 25),
                    if (controller.conditions != null)
                      SurfaceConditionsExpansionWidget(
                        key: UniqueKey(),
                        disableTouches: true,
                        surfaceConditions: controller.conditions!.surfaceConditions,
                        selectedReef: controller.selectedReef,
                        onChanged: (List<SurfaceCondition> surfaceConditions) {},
                      ).paddingSymmetric(horizontal: 27),
                    SizedBox(height: 25),
                    Container(
                      width: Get.width,
                      height: Get.height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: buildGraph().paddingSymmetric(vertical: 10),
                    ).paddingSymmetric(horizontal: 20),
                    SizedBox(height: 22),
                    // buildSurfaceConditions(
                    //     title: "Surface Temperature",
                    //     text:
                    //         "${(logic.controller.conditions != null) ? "${controller.conditions!.surfaceTemperature.toString()} °C" : "-"}"),
                    // buildSurfaceConditions(
                    //     title: "Surface Currents",
                    //     text:
                    //         "${(logic.controller.conditions != null) ? controller.conditions!.surfaceCurrents.toString() : "-"}"),
                    // buildSurfaceConditions(
                    //     title: "Wind Speed",
                    //     text:
                    //         "${(logic.controller.conditions != null) ? controller.conditions!.windSpeed.toString() : "-"}"),
                    // SizedBox(height: 30),
                  ],
                );
              }),
            ),
          ),
        ),
        GetBuilder<ConditionsController>(builder: (controller) {
          if (controller.showLoading)
            return Container(
              height: Get.height,
              width: Get.width,
              color: Colors.white70,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            );
          return SizedBox();
        }),
      ],
    );
  }

  ///=========================UI=======================///

  Widget buildSurfaceConditions({required String title, required String text}) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "${title}",
            style: TextStyle(fontSize: FontSize.small, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          " :   ${text}",
          style: TextStyle(fontSize: FontSize.small),
        ),
      ],
    ).paddingSymmetric(horizontal: 27, vertical: 5);
  }

  List<String> getReefs(ConditionsController controller) {
    return controller.reefs;
  }

  selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: logic.controller.selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.black,
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.text.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.text.black,
                textStyle: TextStyle(fontWeight: FontWeight.w500), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      logic.controller.selectedDate = date;
      logic.controller.showLoading = true;
      await logic.getLatestConditions();
      logic.controller.showLoading = false;
    }
  }

  Widget buildGraph() {
    if (logic.getLevels.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Text("No entries found in selected reef"),
        ],
      );
    }

    return Column(
      children: logic.getLevels.map((e) => buildLevel(e)).toList(),
    );
  }

  Widget buildLevel(Level level) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              "${level.depth} m",
            ).paddingOnly(right: 5),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
          width: 1,
          height: 82,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: List.generate(
                    5,
                    (index) => Container(
                      color: Colors.black.withOpacity(0.05),
                      width: 3,
                      height: 1,
                    ).paddingOnly(top: 10),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSlider(level.fish, SliderType.fishLife),
                    buildSlider(level.visibility, SliderType.visibility),
                    buildSlider(level.currents, SliderType.currents),
                  ],
                ),
              ],
            ),
            Container(
              color: Colors.black.withOpacity(0.05),
              width: 230,
              height: 1,
            ).paddingOnly(top: 10),
            RichText(
              text: TextSpan(
                text: level.updatedBy,
                style: TextStyle(
                  fontSize: 8,
                  color: AppColors.text.darkgrey,
                  fontFamily: AppFonts.nunito,
                ),
                children: <TextSpan>[
                  TextSpan(
                      style: TextStyle(color: AppColors.text.darkgrey, fontWeight: FontWeight.w600),
                      text: " (${DateFormat("hh : mm a").format(level.updatedAt)})"),
                ],
              ),
            ).paddingOnly(left: 5, top: 5),
          ],
        ),
      ],
    );
  }

  Widget buildSlider(int pos, SliderType type) {
    return Row(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 3,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 5,
              pressedElevation: 1,
            ),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
          ),
          child: Slider(
            value: pos * 1.0,
            onChanged: (double value) {},
            activeColor: AppColors.text.grey.withOpacity(0.5),
            inactiveColor: AppColors.text.grey.withOpacity(0.5),
            thumbColor: AppColors.text.black,
            divisions: 5,
            min: 0,
            max: 5,
          ),
        ),
        Text(getEmoji(type)).paddingOnly(right: 5),
        SizedBox(
          width: 85,
          child: Text(
            getStatus(pos, type),
            style: TextStyle(
              fontSize: 10,
              color: getColor(pos * 1.0, type == SliderType.currents),
            ),
          ),
        ),
      ],
    );
  }

  String getStatus(int pos, SliderType type) {
    switch (type) {
      case SliderType.fishLife:
        if (pos == 0) return 'No Fish';
        if (pos == 1) return 'Mild Fish';
        if (pos == 2) return 'More Fish';
        if (pos == 3) return 'Very More Fish';
        return 'Schools of fishes';
      case SliderType.visibility:
        if (pos == 0) return "Can't see anything";
        if (pos == 1) return 'Very Green';
        if (pos == 2) return 'Medium Visibility';
        if (pos == 3) return 'Clear';
        return 'Crystal Clear';
      case SliderType.currents:
        if (pos == 0) return "No Current";
        if (pos == 1) return 'Mild Current';
        if (pos == 2) return 'Moderate Current';
        if (pos == 3) return 'Strong Current';
        return 'Where is my passport ?';
    }
  }

  String getEmoji(SliderType type) {
    switch (type) {
      case SliderType.fishLife:
        return '🐠';
      case SliderType.visibility:
        return '👀';
      case SliderType.currents:
        return '🌊';
    }
  }

  Widget buildChip({required Function onTap, required String reefName}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: logic.controller.selectedReef == reefName ? AppColors.text.skyBlue : AppColors.text.white,
        ),
        child: Text(
          reefName,
          style: TextStyle(
              color: logic.controller.selectedReef == reefName ? AppColors.text.white : AppColors.text.black,
              fontSize: FontSize.small),
        ).paddingSymmetric(horizontal: 9, vertical: 5),
      ).paddingOnly(right: 13),
    );
  }
}
