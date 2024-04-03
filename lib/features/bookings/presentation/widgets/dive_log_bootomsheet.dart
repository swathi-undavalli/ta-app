import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/firebase/api.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/booking_model.dart';
import '../../models/dive_log_model.dart';
import '../screens/dive_log_view.dart';
import 'add_customer_dialog.dart';
import 'copy_dives_bottomsheet.dart';

class DiveLogBottomSheet extends StatefulWidget {
  const DiveLogBottomSheet({
    Key? key,
    required this.bookingModel,
    required this.selectedDate,
  }) : super(key: key);

  final Booking bookingModel;
  final DateTime selectedDate;

  static void show(BuildContext context,
      {required Booking bookingModel, required DateTime date}) async {
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
        top: 30,
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
            buildHeader(),
            Spacing.h20,
            ...buildCustomers(),
            Spacing.h20,
            buildCopyLogsButton(),
            Spacing.h20,
            buildAddCustomerButton(),
            Spacing.h30,
          ],
        ),
      ),
    );
  }

  List<Widget> buildCustomers() {
    return List.generate(
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
                  onPressed: () async {
                    String email = widget.bookingModel.pax?[index]['email'];
                    await Clipboard.setData(ClipboardData(text: email));
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.black,
                    size: 20,
                  )),
              Spacing.w10,
              AppButton.miniFlat(
                onTap: () {
                  Navigator.push(
                    context,
                    DiveLogView.addLogRoute(
                      widget.bookingModel.pax?[index]['email'],
                      widget.bookingModel,
                      widget.selectedDate,
                    ),
                  );
                },
                text: 'Add Log',
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
          Spacing.h15,
          buildDiveLogs(index).paddingSymmetric(horizontal: 10),
        ],
      ),
    );
  }

  Widget buildAddCustomerButton() {
    if (widget.bookingModel.pax!.length != widget.bookingModel.noOfPersons) {
      return AppButton.miniFlat(
        text: 'Add Customer',
        onTap: () {
          AddCustomerDialog.show(
            context,
            bookingModel: widget.bookingModel,
          );
        },
      ).paddingSymmetric(horizontal: 20);
    }
    return const SizedBox();
  }

  Widget buildAddLogHeader() {
    return Row(
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
    ).paddingSymmetric(horizontal: 20);
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> buildDiveLogs(int index) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.bookingModel.pax?[index]['email'])
          .collection('diveLogs')
          .snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasError ||
            snapshot.connectionState == ConnectionState.waiting) {
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
            children: [
              Spacing.h10,
              buildHeadings(),
              Spacing.h5,
              ...data.map((d) {
                DiveLogModel diveLogModel =
                    DiveLogModel.fromMap(d.data() as Map<String, dynamic>?);
                return buildLog(diveLogModel, index)
                    .paddingSymmetric(vertical: 10);
              }),
            ],
          );
        }
      },
    );
  }

  Widget buildLog(DiveLogModel diveLogModel, int index) {
    String getCourse(String text) {
      String t = '';
      text.split(' ').forEach((e) {
        if (e.isNotEmpty) {
          t = t + (e[0].capitalize).toString();
        }
      });

      return t;
    }

    return Row(
      children: [
        buildText(
          text: DateFormat('dd-MM-yy')
              .format(diveLogModel.timeIn.toDate())
              .toString(),
        ),
        buildText(text: diveLogModel.instructor.name),
        buildText(text: '  ${getCourse(diveLogModel.course)}', width: 35),
        buildText(text: diveLogModel.diveSite, width: 40),
        buildText(
            text:
                '${tankType(diveLogModel.tankType)}${diveLogModel.tankNo.toString()}',
            width: 30),
        buildText(text: diveLogModel.bottomTime.toString(), width: 35),
        buildText(text: diveLogModel.maxDepth.toString(), width: 30),
        Spacing.w10,
        buildEditDeleteButtons(
          onTap: () {
            Navigator.push(
              context,
              DiveLogView.editLogRoute(
                widget.bookingModel.pax?[index]['email'],
                widget.bookingModel,
                diveLogModel,
              ),
            );
          },
          icon: Icons.edit,
        ),
        Spacing.w20,
        buildEditDeleteButtons(
          onTap: () {
            deleteDialog(context, id: diveLogModel.id, index: index);
          },
          icon: Icons.delete,
        ),
      ],
    );
  }

  Future<void> deleteDialog(
    BuildContext context, {
    required String id,
    required int index,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Log will be completely deleted',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Get.back();
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () {
                firebaseApi.deleteDiveLog(
                  id,
                  widget.bookingModel.pax?[index]['email'],
                );

                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildEditDeleteButtons(
      {required Function onTap, required IconData icon}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      radius: 50,
      child: Icon(icon, size: 12),
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
        buildText(text: 'Course', width: 35, fontWeight: FontWeight.bold),
        buildText(text: 'Dive Site', width: 40, fontWeight: FontWeight.bold),
        buildText(text: 'Tank No', width: 30, fontWeight: FontWeight.bold),
        buildText(text: 'Bottom Time', width: 35, fontWeight: FontWeight.bold),
        buildText(text: 'Max Depth', width: 30, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget buildText(
      {required String text,
      double width = 50,
      FontWeight fontWeight = FontWeight.normal}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(fontSize: 7, fontWeight: fontWeight),
      ).paddingSymmetric(horizontal: 2),
    );
  }
}
