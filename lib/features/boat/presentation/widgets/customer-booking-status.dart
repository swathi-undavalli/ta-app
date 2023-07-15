import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/core/constants/constants.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus(
      {Key? key, required this.initialStatus, required this.onChanged})
      : super(key: key);
  final int initialStatus;
  final Function(int status) onChanged;

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
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
            if (status > 0 && status <= 9) {
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
            bookingStatus[status],
            style: TextStyle(
                fontSize: FontSize.small, fontWeight: FontWeight.w600),
          ).paddingOnly(left: 15, right: 15, top: 8),
        ),
        SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            if (status < 9) {
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
      return Colors.blueAccent.withOpacity(0.6);
    } else if (index == 1) {
      return Colors.blue;
    } else if (index == 2) {
      return Colors.greenAccent;
    } else if (index == 3) {
      return Colors.green;
    } else if (index == 4) {
      return Colors.grey;
    } else if (index == 5) {
      return Colors.black.withOpacity(0.5);
    } else if (index == 6) {
      return Colors.yellow;
    } else if (index == 7) {
      return Colors.pink;
    } else if (index == 8) {
      return Colors.orange;
    } else if (index == 9) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  List<String> bookingStatus = [
    "Booked In",
    "Paperwork done",
    "Pool ongoing",
    "Pool completed",
    "Dive center",
    "Harbour",
    "Left for diving",
    "Boat",
    "Returning back",
    "Completed",
  ];
}
