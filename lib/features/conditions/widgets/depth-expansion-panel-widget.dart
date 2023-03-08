import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class DepthExpansionPanelWidget extends StatefulWidget {
  const DepthExpansionPanelWidget({Key? key}) : super(key: key);

  @override
  State<DepthExpansionPanelWidget> createState() => _DepthExpansionPanelWidgetState();
}

class _DepthExpansionPanelWidgetState extends State<DepthExpansionPanelWidget> {
  bool isExpanded = false;

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
              Text("Hii Hello"),
              Spacer(),
              IconButton(
                splashRadius: 20,
                iconSize: 23,
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
              children: [SizedBox(height: 20), Text("10 meters")],
            )
        ],
      ),
    ).paddingOnly(bottom: 15);
  }
}