import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:temple_adventures/features/equipment/presentation/views/submission_bottom_sheet.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../employees/model/employee.dart';
import '../../models/equipment_log_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/banner_container.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';
import '../widgets/equipment_pieces_summary_table.dart';

class EquipmentLogDetailsView extends StatefulWidget {
  final EquipmentLog log;

  const EquipmentLogDetailsView({super.key, required this.log});

  static Route route(EquipmentLog log) => MaterialPageRoute(
        builder: (context) => EquipmentLogDetailsView(log: log),
      );

  @override
  State<EquipmentLogDetailsView> createState() => _EquipmentLogDetailsViewState();
}

class _EquipmentLogDetailsViewState extends State<EquipmentLogDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<EquipmentProvider>().fetchEmployees();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: EquipmentAppBar(
        title: 'Log #${widget.log.id}',
        description: 'Equipment log for ${widget.log.pieces.length} item${widget.log.pieces.length == 1 ? '' : 's'}',
      ),
      body: EquipmentBody(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: Screen.width),
                Spacing.h32,
                _LogDetails(widget.log),
                Spacing.h32,
                EquipmentPiecesSummaryTable(
                  widget.log.pieces,
                  title: 'Equipment details :',
                ),
                _Message(widget.log),
                Spacing.h60,
              ],
            ).paddingHorizontal(16),
            _SubmissionButton(widget.log),
          ],
        ),
      ),
    );
  }
}

class _LogDetails extends StatelessWidget {
  final EquipmentLog log;

  const _LogDetails(this.log);

  @override
  Widget build(BuildContext context) {
    Employee? renter = context.read<EquipmentProvider>().employees.firstWhereOrNull((emp) => emp.id == log.renterID);
    Employee? collector =
        context.read<EquipmentProvider>().employees.firstWhereOrNull((emp) => emp.id == log.collectorID);
    Employee? approver =
        context.read<EquipmentProvider>().employees.firstWhereOrNull((emp) => emp.id == log.approverID);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailItem('Renter', _getName(renter) ?? 'Employee ${log.renterID}').paddingOnly(bottom: 8),
        _DetailItem('Approved by', _getName(approver) ?? 'Employee ${log.approverID}').paddingOnly(bottom: 8),
        if (log.collectorID != null)
          _DetailItem('Collected by', _getName(collector) ?? 'Employee ${log.collectorID}').paddingOnly(bottom: 8),
        _DetailItem('Rented time', DateFormat('MMM dd, yyyy hh:mm a').format(log.time.toDate())).paddingOnly(bottom: 8),
        if (log.collectorID != null)
          _DetailItem('Collection time', DateFormat('MMM dd, yyyy hh:mm a').format(log.collectedTime.toDate()))
              .paddingOnly(bottom: 8),
      ],
    ).paddingOnly(left: 15);
  }

  String? _getName(Employee? employee) {
    if (employee?.nickName?.trim().isNotEmpty ?? false) {
      return employee?.nickName;
    }

    if (employee == null) return null;
    if (employee.name.length < 10) {
      return employee.name;
    }

    return employee.firstName;
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const _DetailItem(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          fontFamily: 'Nunito',
          color: Colors.black,
          fontSize: 14,
        ),
        children: <TextSpan>[
          TextSpan(
            text: ' $value',
            style: const TextStyle(color: Color(0xff727272)),
          ),
        ],
      ),
    );
  }
}

class _SubmissionButton extends StatelessWidget {
  final EquipmentLog log;

  const _SubmissionButton(this.log);

  @override
  Widget build(BuildContext context) {
    if (log.collectorID != null) return const SizedBox();
    if (log.renterID == currentEmployee?.id) return const SizedBox();

    return Positioned(
      bottom: 30,
      child: BannerContainer(
        height: 45,
        child: InkWell(
          onTap: () {
            SubmissionBottomSheet.show(context, log.pieces, () {
              context.read<EquipmentProvider>().completeSubmission(log).whenComplete(() {
                if (!context.mounted) return;
                Navigator.pop(context);
                Navigator.pop(context);
              });
            });
          },
          child: Text(
            'Start submission',
            style: TextStyle(
              color: Colors.white.withOpacity(1),
              fontWeight: FontWeight.bold,
            ),
          ).center,
        ),
      ).center.width(Screen.width),
    );
  }
}

class _Message extends StatelessWidget {
  final EquipmentLog log;

  const _Message(this.log);

  @override
  Widget build(BuildContext context) {
    if (log.collectorID != null) return const SizedBox();

    if (log.renterID == currentEmployee?.id) {
      //ask your co-diver message.
      return Expanded(
        child: RichText(
          text: TextSpan(
            text: 'In order to complete ',
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: Colors.black,
              fontSize: 14,
            ),
            children: <TextSpan>[
              const TextSpan(
                text: ' Submission',
                style: TextStyle(fontWeight: FontWeight.bold, color: appBlue),
              ),
              const TextSpan(
                text: ', ask you diver buddy to verify each item in there app. Share the ID # ',
              ),
              TextSpan(
                text: log.id,
                style: const TextStyle(fontWeight: FontWeight.bold, color: appBlue),
              ),
              const TextSpan(
                text: ' to find the log easily.',
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ).center,
      );
    }

    //guide user to submission.
    return Expanded(
      child: RichText(
        text: const TextSpan(
          text: 'Please review each item to ensure it is in working condition. Once verified, click the "',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: Colors.black,
            fontSize: 14,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Start Submission',
              style: TextStyle(fontWeight: FontWeight.bold, color: appBlue),
            ),
            TextSpan(
              text: '" button. Then, go through each item and click "',
            ),
            TextSpan(
              text: 'Accept Submission',
              style: TextStyle(fontWeight: FontWeight.bold, color: appBlue),
            ),
            TextSpan(
              text: '" to confirm.',
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ).center,
    );
  }
}
