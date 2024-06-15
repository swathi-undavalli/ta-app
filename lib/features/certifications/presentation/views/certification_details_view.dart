import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/constants.dart';
import '../../../../core/models/item_model.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/booking_model.dart';
import '../../../bookings/presentation/widgets/certification_status.dart';

class CertificationDetailsView extends StatefulWidget {
  const CertificationDetailsView({super.key, required this.itemModel});

  final ItemModel itemModel;

  static Route route(ItemModel itemModel) => MaterialPageRoute(
        builder: (context) => CertificationDetailsView(itemModel: itemModel),
      );

  @override
  State<CertificationDetailsView> createState() => _CertificationDetailsViewState();
}

class _CertificationDetailsViewState extends State<CertificationDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Certification Details'),
      body: SafeArea(
        child: Column(
          children: [
            buildKeyValuePairs(
              key: 'Name',
              value: '${widget.itemModel.name} ${widget.itemModel.lastName}',
            ),
            buildKeyValuePairs(key: 'Email', value: widget.itemModel.email ?? '-'),
            buildKeyValuePairs(
                key: 'Date of Birth',
                value: intl.DateFormat('dd-MM-yyy')
                    .format((widget.itemModel.bookingModel!.pax![0]['dob'] as Timestamp).toDate())),
            buildKeyValuePairs(key: 'Certification', value: widget.itemModel.activity),
            buildKeyValuePairs(
              key: 'Course Completion Date',
              value: widget.itemModel.bookingModel!.bookingDate?.last ?? '-',
            ),
            buildKeyValuePairs(
              key: 'Balance',
              value: getBalance(
                widget.itemModel.bookingModel!.payments!,
                double.parse(widget.itemModel.paid).roundToDouble(),
                double.parse(widget.itemModel.cost).roundToDouble(),
              ),
            ),
            buildKeyValuePairs(
              key: 'Completed instructor',
              value: widget.itemModel.bookingModel?.boatDetails!.instructors?[0].name ?? '-',
            ),
            buildKeyValuePairs(key: 'Instructor No', value: '-'),
            buildKeyValuePairs(key: 'Invoice No', value: widget.itemModel.bookingModel?.receiptNo ?? '-'),
            buildKeyValuePairs(key: 'Course / Equipment Upsell', value: '-'),
            Spacing.h30,
            CertificationStatus(
              initialStatus: widget.itemModel.bookingModel!.certificateStatus!,
              onChanged: (int status) async {
                widget.itemModel.bookingModel?.certificateStatus = status;
                await FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(widget.itemModel.bookingModel!.id)
                    .set(widget.itemModel.bookingModel!.toMap());
              },
              itemModel: widget.itemModel,
              isCertificationDetailsView: true,
            ),
          ],
        ).paddingSymmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  String getBalance(List<PaymentModel> payments, double deposit, double total) {
    double t = deposit;
    for (var payment in payments) {
      t += payment.amount!;
    }
    return (total - t).toInt().toString();
  }

  Widget buildKeyValuePairs({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            key,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(
          width: 180,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              height: 1.3,
            ),
          ),
        ),
      ],
    ).paddingOnly(bottom: 5);
  }
}
