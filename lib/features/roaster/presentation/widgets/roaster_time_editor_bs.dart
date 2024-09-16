import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/time_picker.dart';

class RoasterTimeEditorBs extends StatefulWidget {
  const RoasterTimeEditorBs({super.key, this.selectedTimeIn, this.selectedTmeOut});

  final DateTime? selectedTimeIn;
  final DateTime? selectedTmeOut;

  static show(BuildContext context, DateTime? selectedTmeIn, DateTime? selectedTmeOut) async {
    List<DateTime?>? data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return RoasterTimeEditorBs(
          selectedTimeIn: selectedTmeIn,
          selectedTmeOut: selectedTmeOut,
        );
      },
    );
    return data ?? [];
  }

  @override
  State<RoasterTimeEditorBs> createState() => _RoasterTimeEditorBsState();
}

class _RoasterTimeEditorBsState extends State<RoasterTimeEditorBs> {
  DateTime? timeIn;
  DateTime? timeOut;

  @override
  void initState() {
    timeIn = widget.selectedTimeIn;
    timeOut = widget.selectedTmeOut;

    log(timeIn.toString());
    log(timeOut.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      child: Column(
        children: [
          buildHeader(),
          Spacing.h30,
          if (timeIn != null)
            buildTimes(
              time: timeIn!,
              title: 'Time In',
              onTap: () {
                selectTimeIn(context);
              },
            ),
          Spacing.h20,
          if (timeOut != null)
            buildTimes(
              time: timeOut!,
              title: 'Time Out',
              onTap: () {
                selectTimeOut(context);
              },
            ),
          Spacing.h30,
          AppButton.miniFlat(
            text: 'Reset',
            onTap: () {
              timeIn = null;
              timeOut = null;
              if (context.mounted) {
                Navigator.pop(context, [timeIn, timeOut]);
              }
            },
          ).left,
          Spacing.h30,
          Row(
            children: [
              AppButton.miniText(
                text: 'Cancel',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Spacer(),
              AppButton.miniFlat(
                text: 'Okay',
                onTap: () async {
                  if (context.mounted) {
                    Navigator.pop(context, [timeIn, timeOut]);
                  }
                },
              ),
            ],
          ),
          Spacing.h50,
        ],
      ).paddingSymmetric(horizontal: 20).scrollable,
    );
  }

  Widget buildTimes({
    required DateTime time,
    required String title,
    required Function onTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.black,
            fontFamily: AppFonts.nunito,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            height: 30,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                TimePicker.getFormattedTime(time) ?? 'No time selected',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> selectTimeIn(
    BuildContext context,
  ) async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: timeIn!,
    );

    if (pickedTime != null) {
      setState(() {
        timeIn = pickedTime;
      });
    }
  }

  Future<void> selectTimeOut(
    BuildContext context,
  ) async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: timeOut!,
    );

    if (pickedTime != null) {
      setState(() {
        timeOut = pickedTime;
      });
    }
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Change Times',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ).paddingOnly(top: 8),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            Navigator.pop(context, [widget.selectedTimeIn, widget.selectedTmeOut  ]);
          },
        ),
      ],
    );
  }
}
