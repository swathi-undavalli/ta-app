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
  @override
  State<SurfaceConditionsExpansionWidget> createState() =>
      _SurfaceConditionsExpansionWidgetState();
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
    return Container(
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
          ).paddingOnly(left: 25),
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
                ).paddingSymmetric(horizontal: 27),
                SizedBox(height: 10),
                buildWaterConditions(
                  title: "Updated Time",
                  text: DateFormat("dd MMM yyyy @ hh:mm a")
                      .format(currentConditions.updatedAt),
                ).paddingSymmetric(horizontal: 27),
                SizedBox(height: 25),
              ],
            )
        ],
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
    );
  }

  Widget buildConditionSlider(SurfaceSlider type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getSliderTitle(type),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ).paddingOnly(left: 32),
        Row(
          children: [
            Container(
              width: 175,
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
            SizedBox(width: 10),
            Container(
              width: 67,
              child: Text(
                getConditions(type),
                style: TextStyle(
                    fontSize: 10,
                    color: getColor(getValue(type)),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ).paddingOnly(bottom: 5, left: 20, right: 20),
      ],
    );
  }

  Color getColor(double value) {
    if (value == 0) return Color(0xff009429);
    if (value == 1) return Color(0xff009429);
    if (value == 2) return Color(0xffFF7A00);
    if (value == 3) return Color(0xffFF7A00);
    if (value == 4 ||
        (value >= 20 && value <= 25) ||
        (value >= 30 && value <= 35)) return Color(0xffBE0000);
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
        if (surfaceCurrents == 0) return "No Current";
        if (surfaceCurrents == 1) return 'Mild Current';
        if (surfaceCurrents == 2) return 'Moderate Current';
        if (surfaceCurrents == 3) return 'Strong Current';
        return 'Where is my passport ?';
      case SurfaceSlider.windSpeed:
        if (windSpeed == 0) return "Pool like";
        if (windSpeed == 1) return 'Mild';
        if (windSpeed == 2) return 'Big';
        if (windSpeed == 3) return 'Very big';
        return 'Stay at home';
      case SurfaceSlider.swell:
        if (swell == 0) return "Gentle breeze";
        if (swell == 1) return 'Light winds';
        if (swell == 2) return 'Strong winds ';
        if (swell == 3) return 'Storm';
        return 'Boat is flying';
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
}

enum SurfaceSlider {
  surfaceTemp,
  surfaceCurrent,
  windSpeed,
  swell,
}
