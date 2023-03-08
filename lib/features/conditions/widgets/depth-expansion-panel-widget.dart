import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class DepthExpansionPanelWidget extends StatefulWidget {
  DepthExpansionPanelWidget({
    required this.depth,
    required this.onDeletePressed,
    required this.onChanged,
  });

  String depth;
  Function onDeletePressed;
  Function(int fish, int visibility, int currents) onChanged;

  @override
  State<DepthExpansionPanelWidget> createState() =>
      _DepthExpansionPanelWidgetState();
}

class _DepthExpansionPanelWidgetState extends State<DepthExpansionPanelWidget> {
  bool isExpanded = false;

  int fishLife = 0;
  int visibilityRange = 0;
  int currents = 0;

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
                "${widget.depth} meters",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              IconButton(
                padding: EdgeInsets.all(0),
                visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                splashRadius: 20,
                iconSize: 13,
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.onDeletePressed();
                },
              ),
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
                SizedBox(height: 25),
                buildConditionSlider(
                    category: 'Fish Life',
                    visibility: fishLife,
                    condition: 'No fish',
                    onChanged: (value) {
                      setState(() {
                        fishLife = value.toInt();
                      });
                    }),
                buildConditionSlider(
                    category: 'Visibility',
                    visibility: visibilityRange,
                    condition: 'Hardly visible',
                    onChanged: (value) {
                      setState(() {
                        visibilityRange = value.toInt();
                      });
                    }),
                buildConditionSlider(
                    category: 'Currents',
                    visibility: currents,
                    condition: 'Low Currents',
                    onChanged: (value) {
                      setState(() {
                        currents = value.toInt();
                      });
                    }),
                SizedBox(height: 25),
              ],
            ).paddingSymmetric(horizontal: 27)
        ],
      ),
    );
  }

  ///==================UI==================///

  Widget buildConditionSlider(
      {required String category,
      required String condition,
      required Function onChanged,
      required int visibility}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ).paddingOnly(left: 5),
        SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 175,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                ),
                child: Slider(
                  label: visibility.toString(),
                  value: visibility.toDouble(),
                  onChanged: (value) {
                    onChanged(value);
                    widget.onChanged(fishLife, visibilityRange, currents);
                  },
                  activeColor: AppColors.text.grey.withOpacity(0.5),
                  inactiveColor: AppColors.text.grey.withOpacity(0.5),
                  thumbColor: AppColors.text.black,
                  divisions: 5,
                  min: 0,
                  max: 5,
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 67,
              child: Text(
                condition,
                style: TextStyle(
                    fontSize: 10,
                    color: Color(0xffBE0000),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ],
    ).paddingOnly(bottom: 22);
  }
}
