import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:temple_adventures/core/constants/constants.dart';

import '../models/conditions-model.dart';

class SurfaceConditionsExpansionWidget extends StatefulWidget {
  SurfaceConditionsExpansionWidget(
      {required this.surfaceConditions,
      required this.selectedReef,
      required this.onChanged,
      required this.disableTouches,
      Key? key})
      : super(key: key);

  List<SurfaceCondition> surfaceConditions;
  String selectedReef;
  Function(List<SurfaceCondition> surfaceConditions) onChanged;
  bool disableTouches;

  late _SurfaceConditionsExpansionWidgetState depthExpansionPanelWidgetState;

  @override
  State<SurfaceConditionsExpansionWidget> createState() {
    depthExpansionPanelWidgetState = _SurfaceConditionsExpansionWidgetState();
    return depthExpansionPanelWidgetState;
  }

  void closeExpansion() {
    depthExpansionPanelWidgetState.closeExpansion();
  }
}

class _SurfaceConditionsExpansionWidgetState
    extends State<SurfaceConditionsExpansionWidget> {
  bool isExpanded = false;

  late double surfaceTemp = (currentConditions.temp) * 1.0;
  late double surfaceCurrents = (currentConditions.currents) * 1.0;
  late double windSpeed = (currentConditions.speed) * 1.0;
  late double swell = (currentConditions.swell) * 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Surface Conditions",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                IconButton(
                  visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                  padding: EdgeInsets.all(0),
                  splashRadius: 20,
                  iconSize: 20,
                  icon: Icon(isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ).paddingOnly(left: 20),
            if (isExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  buildConditionSlider(SurfaceSlider.surfaceTemp),
                  buildConditionSlider(SurfaceSlider.surfaceCurrent),
                  buildConditionSlider(SurfaceSlider.windSpeed),
                  buildConditionSlider(SurfaceSlider.swell),
                  SizedBox(height: 15),
                  buildWaterConditions(
                    title: "Updated By",
                    text: currentConditions.updatedBy,
                  ),
                  SizedBox(height: 10),
                  buildWaterConditions(
                    title: "Updated Time",
                    text: DateFormat("dd MMM yyyy @ hh:mm a")
                        .format(currentConditions.updatedAt),
                  ),
                  SizedBox(height: 25),
                ],
              )
          ],
        ),
      ),
    );
  }

  ///==================UI==================///

  Widget buildWaterConditions({required String title, required String text}) {
    return Row(
      children: [
        SizedBox(
          width: 85,
          child: Text(
            "$title",
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          " :   ${text}",
          style: TextStyle(fontSize: FontSize.small),
        ),
      ],
    ).paddingSymmetric(horizontal: 20);
  }

  Widget buildConditionSlider(SurfaceSlider type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getSliderTitle(type),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ).paddingOnly(left: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 5,
                    pressedElevation: 1,
                  ),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                ),
                child: AbsorbPointer(
                  absorbing: widget.disableTouches,
                  child: Slider(
                    value: getValue(type),
                    onChanged: (double value) {
                      switch (type) {
                        case SurfaceSlider.surfaceTemp:
                          surfaceTemp = value;
                          break;
                        case SurfaceSlider.surfaceCurrent:
                          surfaceCurrents = value;
                          break;
                        case SurfaceSlider.windSpeed:
                          windSpeed = value;
                          break;
                        case SurfaceSlider.swell:
                          swell = value;
                          break;
                      }
                      setState(() {});
                      updateConditions();
                      widget.onChanged(widget.surfaceConditions);
                    },
                    activeColor: AppColors.text.grey.withOpacity(0.5),
                    inactiveColor: AppColors.text.grey.withOpacity(0.5),
                    thumbColor: AppColors.text.black,
                    divisions: (SurfaceSlider.surfaceTemp == type) ? 15 : 5,
                    min: (SurfaceSlider.surfaceTemp == type) ? 20 : 0,
                    max: (SurfaceSlider.surfaceTemp == type) ? 35 : 5,
                  ),
                ),
              ),
            ),
            Container(
              width: 67,
              child: Text(
                getConditions(type),
                style: TextStyle(
                  fontSize: 13,
                  color: getColor(
                      getValue(type), type == SurfaceSlider.surfaceTemp),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).paddingOnly(top: 10),
          ],
        ).paddingOnly(right: 10, left: 5),
      ],
    ).paddingOnly(bottom: 5);
  }

  Color getColor(double value, bool isTemp) {
    if (isTemp) {
      // RED
      if ([20, 21, 22, 35, 34, 33].contains(value)) return Color(0xffBE0000);
      // ORANGE
      if ([23, 24, 25, 32, 31, 30].contains(value)) return Color(0xffFF7A00);
      // GREEN
      if ([26, 27, 28, 29].contains(value)) return Color(0xff009429);
    }
    if (value == 0) return Color(0xff009429);
    if (value == 1) return Color(0xff009429);
    if (value == 2) return Color(0xffFF7A00);
    if (value == 3) return Color(0xffFF7A00);
    if (value == 4) return Color(0xffBE0000);
    return Color(0xffBE0000);
  }

  String getSliderTitle(SurfaceSlider type) {
    switch (type) {
      case SurfaceSlider.surfaceTemp:
        return 'Surface Temperature';
      case SurfaceSlider.surfaceCurrent:
        return 'Surface Currents';
      case SurfaceSlider.windSpeed:
        return 'Wind Speed';
      case SurfaceSlider.swell:
        return 'Swell';
    }
  }

  String getConditions(SurfaceSlider type) {
    switch (type) {
      case SurfaceSlider.surfaceTemp:
        return surfaceTemp.toString();
      case SurfaceSlider.surfaceCurrent:
        if (surfaceCurrents == 0) return "No current";
        if (surfaceCurrents == 1) return 'Mild current';
        if (surfaceCurrents == 2) return 'Moderate current';
        if (surfaceCurrents == 3) return 'Strong current';
        return 'Where is my passport ?';
      case SurfaceSlider.windSpeed:
        if (windSpeed == 0) return "Gentle breeze";
        if (windSpeed == 1) return 'Light winds';
        if (windSpeed == 2) return 'Strong winds ';
        if (windSpeed == 3) return 'Storm';
        return 'Boat is flying';
      case SurfaceSlider.swell:
        if (swell == 0) return "Pool like";
        if (swell == 1) return 'Mild';
        if (swell == 2) return 'Big';
        if (swell == 3) return 'Very big';
        return 'Stay at home';
    }
  }

  double getValue(SurfaceSlider type) {
    switch (type) {
      case SurfaceSlider.surfaceCurrent:
        return surfaceCurrents;
      case SurfaceSlider.surfaceTemp:
        return surfaceTemp;
      case SurfaceSlider.windSpeed:
        return windSpeed;
      case SurfaceSlider.swell:
        return swell;
    }
  }

  SurfaceCondition get currentConditions {
    for (SurfaceCondition cond in widget.surfaceConditions) {
      if (cond.reefName == widget.selectedReef) {
        return cond;
      }
    }
    return currentConditions;
  }

  updateConditions() {
    for (int i = 0; i < widget.surfaceConditions.length; i++) {
      if (widget.surfaceConditions[i].reefName == widget.selectedReef) {
        widget.surfaceConditions[i] = widget.surfaceConditions[i].copyWith(
          temp: surfaceTemp,
          currents: surfaceCurrents,
          speed: windSpeed,
          swell: swell,
        );
      }
    }
  }

  void closeExpansion() {
    setState(() {
      isExpanded = false;
      log("==========depth expansion closed");
      log(isExpanded.toString());
    });
  }
}

enum SurfaceSlider {
  surfaceTemp,
  surfaceCurrent,
  windSpeed,
  swell,
}
