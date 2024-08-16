import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/time_picker.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';

class RoasterDetailsView extends StatefulWidget {
  const RoasterDetailsView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const RoasterDetailsView(),
      );

  @override
  State<RoasterDetailsView> createState() => _RoasterDetailsViewState();
}

class _RoasterDetailsViewState extends State<RoasterDetailsView> {
  bool knowSwimming = false;
  bool isDived = true;
  bool interestedOwc = false;
  late TextEditingController assignedInstructor;
  late TextEditingController customerRemarks;
  List<String> instructors = ['kam', 'sahi', 'das'];
  DateTime timeIn = DateTime.now();
  DateTime timeOut = DateTime.now();

  @override
  void initState() {
    super.initState();
    assignedInstructor = TextEditingController();
    customerRemarks = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: AppBarWidget(
        heading: '',
        color: AppColors.background.lightBlue,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Spacing.h50,
            SizedBox(
              width: Screen.width,
              child: const Icon(
                Icons.account_circle,
                size: 70,
                color: Colors.grey,
              ),
            ),
            Spacing.h15,
            const Text(
              'Kamesh',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacing.h40,
            buildInstructor(),
            Spacing.h20,
            buildTimes(
              time: timeIn,
              title: 'Time In',
              onTap: () {
                selectTimeIn();
              },
            ),
            Spacing.h20,
            buildTimes(
              time: timeOut,
              title: 'Time Out',
              onTap: () {
                selectTimeOut();
              },
            ),
            Spacing.h20,
            buildSwitch(
              text: 'Dive Done / Not Done',
              switchValue: isDived,
              onChanged: (value) {
                isDived = value;
                setState(() {});
              },
            ),
            Spacing.h15,
            buildSwitch(
              text: 'Knows Swimming',
              switchValue: knowSwimming,
              onChanged: (value) {
                knowSwimming = value;
                setState(() {});
              },
            ),
            Spacing.h15,
            buildSwitch(
              text: 'Interested in OWC',
              switchValue: interestedOwc,
              onChanged: (value) {
                interestedOwc = value;
                setState(() {});
              },
            ),
            AppTextField(
              controller: customerRemarks,
              hintText: 'Customer Remarks',
              minLines: 2,
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            Spacing.h40,
            AppButton.flat(
              text: 'Submit',
              onTap: () {},
              color: Colors.black,
              textColor: Colors.white,
            ),
            Spacing.h40,
          ],
        ).paddingSymmetric(horizontal: 20).scrollable,
      ),
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
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> selectTimeIn() async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: timeIn,
    );

    if (pickedTime != null) {
      setState(() {
        timeIn = pickedTime;
      });
    }
  }

  Future<void> selectTimeOut() async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: timeOut,
    );

    if (pickedTime != null) {
      setState(() {
        timeOut = pickedTime;
      });
    }
  }

  Widget buildInstructor() {
    return Row(
      children: [
        Text(
          'Instructor',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.black,
          ),
        ),
        const Spacer(),
        Container(
          height: 30,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton(
            underline: const SizedBox(),
            isExpanded: true,
            value: assignedInstructor.text.isNotEmpty
                ? assignedInstructor.text
                : null,
            onChanged: (dynamic mode) {
              assignedInstructor.text = mode;
              setState(() {});
            },
            items: instructors.map((newIns) {
              return DropdownMenuItem(
                value: newIns,
                child: Text(newIns),
              );
            }).toList(),
          ).paddingSymmetric(horizontal: 10),
        ),
      ],
    );
  }

  Widget buildSwitch({
    required String text,
    Function? onChanged,
    required bool switchValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        Switch(
          value: switchValue,
          onChanged: onChanged as void Function(bool)?,
          activeColor: AppColors.text.skyBlue,
          inactiveThumbColor: AppColors.text.grey,
        ),
      ],
    );
  }
}
