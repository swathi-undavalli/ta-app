import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../employees/model/employee.dart';

class CertificationStatus extends StatefulWidget {
  const CertificationStatus({
    super.key,
    required this.onChanged,
    required this.itemModel,
    required this.isCertificationDetailsView,
    required this.paxIndex,
    required this.selectedDate,
  });

  final ItemModel itemModel;
  final Function(int status) onChanged;
  final bool isCertificationDetailsView;
  final int paxIndex;
  final DateTime? selectedDate;

  @override
  State<CertificationStatus> createState() => _CertificationStatusState();
}

class _CertificationStatusState extends State<CertificationStatus> {
  int status = 0;

  @override
  void initState() {
    status = widget.itemModel.bookingModel?.pax?[widget.paxIndex]['certificateStatus'] ?? 0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int checkPoint = certificationStatus.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (status > 0 && status <= checkPoint) {
                  if (status == 1 &&
                      widget.selectedDate != null &&
                      widget.itemModel.bookingModel?.getInstructor(widget.selectedDate!)?.id == currentEmployee?.id &&
                      !widget.isCertificationDetailsView) {
                    status -= 1;
                  } else if (status == 2 && AccessRights.processCertificate && widget.isCertificationDetailsView) {
                    status -= 1;
                  }
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
                  if (status == 0 &&
                      widget.selectedDate != null &&
                      (widget.itemModel.bookingModel?.getInstructor(widget.selectedDate!)?.id) == currentEmployee?.id &&
                      !widget.isCertificationDetailsView) {
                    status += 1;
                  } else if (status == 1 && AccessRights.processCertificate && widget.isCertificationDetailsView) {
                    status += 1;
                  }
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
        ),
        Spacing.h5,
        Text(
          ((widget.itemModel.bookingModel!.pax?[widget.paxIndex]['certificateStatus'] ?? 0) < 1)
              ? 'Only the assigned instructor ${widget.itemModel.bookingModel?.getInstructor(widget.selectedDate!)?.name} can update the status.'
              : 'Only the shop instructor is authorized to update the status once certification has been processed.',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.text.black,
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
