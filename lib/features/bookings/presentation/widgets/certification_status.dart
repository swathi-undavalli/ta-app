import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../employees/model/employee.dart';
import '../../models/booking_model.dart';

class CertificationStatus extends StatefulWidget {
  const CertificationStatus({
    Key? key,
    required this.initialStatus,
    required this.onChanged,
    required this.itemModel,
    required this.isCertificationDetailsView,
  }) : super(key: key);
  final int initialStatus;
  final ItemModel itemModel;
  final Function(int status) onChanged;
  final bool isCertificationDetailsView;

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (status > 0 && status <= checkPoint) {
                  if (status == 1 &&
                      widget.itemModel.bookingModel?.boatDetails!.instructors?[0].id == currentEmployee?.id &&
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
                      widget.itemModel.bookingModel?.boatDetails!.instructors?[0].id == currentEmployee?.id &&
                      getBalance(
                            widget.itemModel.bookingModel!.payments!,
                            double.parse(widget.itemModel.paid).roundToDouble(),
                            double.parse(widget.itemModel.cost).roundToDouble(),
                          ) ==
                          '0' &&
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
          ((widget.itemModel.bookingModel!.certificateStatus ?? 0) < 1)
              ? 'Only the assigned instructor can update the status after full payment is processed.'
              : 'Only the shop instructor is authorized to update the status once certification has been processed.',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.text.darkgrey,
          ),
        ),
      ],
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    for (var payment in payments) {
      t += payment.amount!;
    }
    return (total - t).toInt().toString();
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
