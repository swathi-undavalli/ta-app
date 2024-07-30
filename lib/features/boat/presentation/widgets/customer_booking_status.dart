import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({
    super.key,
    required this.initialStatus,
    required this.onChanged,
    required this.isDSD,
  });
  final int initialStatus;
  final bool isDSD;
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
    int checkPoint = (widget.isDSD ? dsdStatus.length : coursesStatus.length) - 1;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (status > 0 && status <= checkPoint) {
              status -= 1;

              widget.onChanged(status);
              setState(() {});
            }
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: widget.isDSD ? getDSDProgressColor(status) : getCourseProgressColor(status),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: const Icon(
              Icons.arrow_left,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 2),
        Container(
          height: 33,
          width: 100,
          decoration: BoxDecoration(
            color: widget.isDSD ? getDSDProgressColor(status) : getCourseProgressColor(status),
          ),
          child: Text(
            widget.isDSD ? dsdStatus[status] : coursesStatus[status],
            style: const TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.w600,
            ),
          ).paddingSymmetric(horizontal: 15).center,
        ),
        const SizedBox(width: 2),
        GestureDetector(
          onTap: () {
            if (status < checkPoint) {
              status += 1;
              widget.onChanged(status);
              setState(() {});
            }
          },
          child: Container(
            height: 33,
            width: 27,
            decoration: BoxDecoration(
              color: widget.isDSD ? getDSDProgressColor(status) : getCourseProgressColor(status),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: const Icon(
              Icons.arrow_right,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  Color getDSDProgressColor(int index) {
    if (index == 0) {
      return Colors.blueAccent.withOpacity(0.6);
    } else if (index == 1) {
      return Colors.yellow;
    } else if (index == 2) {
      return Colors.blue;
    } else if (index == 3) {
      return Colors.greenAccent;
    } else if (index == 4) {
      return Colors.green;
    } else if (index == 5) {
      return Colors.grey;
    } else if (index == 6) {
      return Colors.black.withOpacity(0.5);
    } else {
      return Colors.grey;
    }
  }

  Color getCourseProgressColor(int index) {
    if (index == 0) {
      return Colors.blueAccent.withOpacity(0.6);
    } else if (index == 1) {
      return Colors.yellow;
    } else if (index == 2) {
      return Colors.blue;
    } else if (index == 3) {
      return Colors.grey;
    } else if (index == 4) {
      return Colors.black.withOpacity(0.5);
    } else {
      return Colors.grey;
    }
  }

  List<String> coursesStatus = [
    'Booked In',
    'Pw ongoing',
    'Pw done',
    'Dive center',
    'Harbour',
  ];

  List<String> dsdStatus = [
    'Booked In',
    'Pw ongoing',
    'Pw done',
    'Pool ongoing',
    'Pool completed',
    'Dive center',
    'Harbour',
  ];
}
