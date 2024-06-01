import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../../core/constants/constants.dart';

class CertificationStatus extends StatefulWidget {
  const CertificationStatus({
    Key? key,
    required this.initialStatus,
    required this.onChanged,
  }) : super(key: key);
  final int initialStatus;
  final Function(int status) onChanged;

  @override
  State<CertificationStatus> createState() => _CertificationStatusState();
}

class _CertificationStatusState extends State<CertificationStatus> {
  int status = 0;

  @override
  void initState() {
    status = widget.initialStatus;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int checkPoint = certificationStatus.length - 1;

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
              color: getCertificationStatusColor(status),
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
          decoration: BoxDecoration(
            color: getCertificationStatusColor(status),
          ),
          child: Text(
            certificationStatus[status],
            style: const TextStyle(
              fontSize: FontSize.small,
              fontWeight: FontWeight.w600,
            ),
          ).paddingOnly(left: 15, right: 15, top: 8),
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
              color: getCertificationStatusColor(status),
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

  Color getCertificationStatusColor(int index) {
    if (index == 0) {
      return Colors.red.withOpacity(0.6);
    } else if (index == 1) {
      return Colors.yellow;
    } else if (index == 2) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  List<String> certificationStatus = [
    'Start certification',
    'Certification ongoing',
    'Certification completed',
  ];
}
