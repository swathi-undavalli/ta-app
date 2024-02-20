import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/booking_model.dart';
import '../../models/dive-log-model.dart';
import '../screens/dive_log_view.dart';
import 'add_customer_dialog.dart';

class DiveLogBottomSheet extends StatefulWidget {
  const DiveLogBottomSheet({
    Key? key,
    required this.bookingModel,
    required this.selectedDate,
  }) : super(key: key);

  final Booking bookingModel;
  final DateTime selectedDate;

  static void show(BuildContext context, {required Booking bookingModel, required DateTime date}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return DiveLogBottomSheet(
          bookingModel: bookingModel,
          selectedDate: date,
        );
      },
    );
  }

  @override
  State<DiveLogBottomSheet> createState() => _DiveLogBottomSheetState();
}

class _DiveLogBottomSheetState extends State<DiveLogBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 40,
        left: 25,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.h30,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Add Log',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ).paddingOnly(top: 8),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    Get.back();
                  },
                ),
              ],
            ),
            Spacing.h20,
            ...List.generate(
              widget.bookingModel.pax!.length,
              (index) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("${widget.bookingModel.pax?[index]['first-name']}"
                          " ${widget.bookingModel.pax?[index]['last-name']}"),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(
                            DiveLogView.id,
                            arguments: [
                              widget.bookingModel,
                              widget.bookingModel.pax?[index]['email'],
                              widget.selectedDate,
                            ],
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: AppColors.text.skyBlue,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('customers')
                        .doc(widget.bookingModel.pax?[index]['email'])
                        .collection('diveLogs')
                        .snapshots(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 15,
                          width: 15,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ).center,
                        );
                      }
                      final data = snapshot.data?.docs;
                      if (data == null || data.isEmpty) {
                        return Column(
                          children: [
                            const Text(
                              'No Logs Added 🥲',
                              style: TextStyle(fontSize: 10),
                            ).center,
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacing.h10,
                            buildHeadings(),
                            Spacing.h5,
                            ...data.map((d) {
                              DiveLogModel diveLogModel = DiveLogModel.fromMap(d.data() as Map<String, dynamic>?);
                              return buildLogDetails(diveLogModel).paddingOnly(bottom: 4);
                            }),
                          ],
                        );
                      }
                    },
                  ),
                  Spacing.h10,
                  AppButton.miniFlat(
                    text: 'Copy Email',
                    onTap: () async {
                      String email = widget.bookingModel.pax?[index]['email'];
                      await Clipboard.setData(ClipboardData(text: email));
                    },
                  ),
                ],
              ),
            ),
            Spacing.h20,
            if (widget.bookingModel.pax!.length != widget.bookingModel.noOfPersons)
              AppButton.miniFlat(
                text: 'Add Customer',
                onTap: () {
                  AddCustomerDialog.show(
                    context,
                    bookingModel: widget.bookingModel,
                  );
                },
              ),
            Spacing.h30,
          ],
        ),
      ),
    );
  }

  Widget buildLogDetails(DiveLogModel diveLogModel) {
    return Row(
      children: [
        buildText(
          text: DateFormat('hh-MM-yy').format(diveLogModel.timeIn.toDate()).toString(),
        ),
        buildText(text: diveLogModel.instructor.name),
        buildText(text: diveLogModel.course, width: 60),
        buildText(text: diveLogModel.diveSite, width: 60),
        buildText(text: '${tankType(diveLogModel.tankType)}${diveLogModel.tankNo.toString()}', width: 30),
        buildText(text: diveLogModel.bottomTime.toString(), width: 35),
        buildText(text: diveLogModel.maxDepth.toString(), width: 30),
      ],
    );
  }

  String tankType(String? tankType) {
    if (tankType == 'Air') {
      return 'A-';
    } else if (tankType == 'Nitrox') {
      return 'N-';
    }
    return '';
  }

  Widget buildHeadings() {
    return Row(
      children: [
        buildText(text: 'Date', fontWeight: FontWeight.bold),
        buildText(text: 'Instructor', fontWeight: FontWeight.bold),
        buildText(text: 'Course', width: 60, fontWeight: FontWeight.bold),
        buildText(text: 'Dive Site', width: 60, fontWeight: FontWeight.bold),
        buildText(text: 'Tank No', width: 30, fontWeight: FontWeight.bold),
        buildText(text: 'Bottom Time', width: 35, fontWeight: FontWeight.bold),
        buildText(text: 'Max Depth', width: 30, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget buildText({required String text, double width = 50, FontWeight fontWeight = FontWeight.normal}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(fontSize: 8, fontWeight: fontWeight),
      ).paddingSymmetric(horizontal: 2),
    );
  }
}
