import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class BoatStatus extends StatefulWidget {
  const BoatStatus(
      {Key? key, required this.initialStatus, required this.onChanged})
      : super(key: key);
  final int initialStatus;
  final Function(int status) onChanged;

  @override
  State<BoatStatus> createState() => _BoatStatusState();
}

class _BoatStatusState extends State<BoatStatus> {
  int status = 0;

  @override
  void initState() {
    status = widget.initialStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (status > 0 && status <= 6) {
              status -= 1;

              widget.onChanged(status);
              setState(() {});
            }
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: getProgressColor(status),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
            ),
            child: Icon(
              Icons.arrow_left,
              size: 16,
            ),
          ),
        ),
        SizedBox(width: 2),
        Container(
          height: 33,
          decoration: BoxDecoration(
            color: getProgressColor(status),
          ),
          child: Text(
            boatStatus[status],
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w600),
          ).paddingOnly(left: 15, right: 15, top: 8),
        ),
        SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            if (status < 6) {
              status += 1;

              widget.onChanged(status);
              setState(() {});
            }
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: getProgressColor(status),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4)),
            ),
            child: Icon(
              Icons.arrow_right,
              size: 16,
            ),
          ),
        )
      ],
    );
  }

  Color getProgressColor(int index) {
    if (index == 0) {
      return Colors.grey.shade400;
    } else if (index == 1) {
      return Colors.orange.shade300;
    } else if (index == 2) {
      return Colors.red.shade400;
    } else if (index == 3) {
      return Colors.green.shade300;
    } else if (index == 4) {
      return AppColors.text.skyBlue.withOpacity(0.5);
    } else if (index == 5) {
      return Colors.purpleAccent.shade100;
    } else if (index == 6) {
      return Colors.yellow.shade300;
    } else {
      return Colors.white70;
    }
  }

  List<String> boatStatus = [
    "Boat Ready",
    "Waiting for Captains",
    "Left Harbour",
    "Reached Dive site",
    "Diving",
    "Dives done",
    "Docked at Harbour",
  ];
}
