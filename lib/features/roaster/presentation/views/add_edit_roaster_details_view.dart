import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../boat/presentation/widgets/employee_selector_bottom_sheet.dart';
import '../../../bookings/models/booking_model.dart';
import '../../models/customer_feedback.dart';
import '../../models/roaster.dart';
import '../widgets/customer_feedback_bottomsheet.dart';
import '../widgets/roaster_time_editor_bs.dart';

class AddEditRoasterDetailsView extends StatefulWidget {
  const AddEditRoasterDetailsView({
    super.key,
    required this.booking,
    required this.paxIndex,
    required this.boat,
    required this.dsdInstructors,
  });

  final Booking booking;
  final int paxIndex;
  final Boat? boat;
  final List<Instructor> dsdInstructors;

  static Route route({
    required Booking booking,
    required int paxIndex,
    required Boat? boat,
    required List<Instructor> dsdInstructors,
  }) =>
      MaterialPageRoute(
        builder: (context) => AddEditRoasterDetailsView(
          booking: booking,
          paxIndex: paxIndex,
          boat: boat,
          dsdInstructors: dsdInstructors,
        ),
      );

  @override
  State<AddEditRoasterDetailsView> createState() => _AddEditRoasterDetailsViewState();
}

//TODO: Private build widgets
class _AddEditRoasterDetailsViewState extends State<AddEditRoasterDetailsView> {
  Instructor? assignedInstructor;
  Instructor? staffInstructor;
  CustomerFeedback? customerFeedback;
  List<Instructor> dsdInstructors = [];
  DateTime? timeIn;
  DateTime? timeOut;
  bool showLoading = false;
  late Booking booking;
  Map<String, dynamic>? paxData;
  Roaster? existingRoaster;
  bool isDived = false;

  @override
  void initState() {
    super.initState();
    dsdInstructors = widget.dsdInstructors;

    booking = widget.booking;

    paxData = booking.pax?[widget.paxIndex];

    if (paxData?['roaster'] != null) {
      existingRoaster = Roaster.fromMap(paxData?['roaster']);

      assignedInstructor = existingRoaster?.instructor;
      staffInstructor = existingRoaster?.staffInstructor;
      customerFeedback = existingRoaster?.customerFeedback;
      timeIn = existingRoaster?.timeIn;
      timeOut = existingRoaster?.timeOut;
      isDived = existingRoaster?.isDived ?? false;
    }
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
        child: (showLoading)
            ? Container(
                color: Colors.transparent,
                width: Screen.width,
                height: Screen.height,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Screen.width,
                    child: const Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Colors.grey,
                    ),
                  ),
                  Spacing.h15,
                  Text(
                    '${booking.pax?[widget.paxIndex]['first-name']} ${booking.pax?[widget.paxIndex]['last-name']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacing.h40,
                  buildInstructor(),
                  Spacing.h30,
                  buildStaffInstructor(),
                  Spacing.h30,
                  Row(
                    children: [
                      buildTimeButtons(
                        title: 'In the water',
                        onTap: () {
                          timeIn ??= DateTime.now();
                          setState(() {});
                          log(timeIn.toString());
                        },
                        color: (timeIn != null) ? AppColors.text.lightSkyBlue : Colors.white,
                      ),
                      Spacing.w20,
                      buildTimeButtons(
                        title: 'Out of water',
                        onTap: () {
                          timeOut ??= DateTime.now();
                          setState(() {});
                          log(timeOut.toString());
                        },
                        color: (timeOut != null) ? AppColors.text.lightSkyBlue : Colors.white,
                      ),
                    ],
                  ),
                  Spacing.h20,
                  Row(
                    children: [
                      if (timeIn != null)
                        Expanded(
                          child: Text(
                            'In water time : ${DateFormat('hh:mm a').format(timeIn!)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      Spacing.w20,
                      if (timeOut != null)
                        Expanded(
                          child: Text(
                            'Out water time : ${DateFormat('hh:mm a').format(timeOut!)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                    ],
                  ),
                  Spacing.h10,
                  if (timeIn != null || timeOut != null)
                    buildTextEditor(
                      title: 'Change, In the water and out the water timings ',
                      onTap: () async {
                        List<DateTime?> times = await RoasterTimeEditorBs.show(context, timeIn, timeOut);

                        if (times.isNotEmpty) {
                          timeIn = times[0];
                          timeOut = times[1];
                          setState(() {});
                        }
                      },
                    ).paddingOnly(bottom: 20),
                  buildIsDived(),
                  Spacing.h30,
                  if (existingRoaster?.customerFeedback != null) buildCustomerFeedback(),
                  Spacing.h100,
                  buildSubmitButton(),
                  Spacing.h40,
                ],
              ).paddingSymmetric(horizontal: 20).scrollable,
      ),
    );
  }

  Widget buildTextEditor({required String title, required Function onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 10),
        ),
        InkWell(
          onTap: () {
            onTap();
          },
          child: const Text(
            ' here',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStaffInstructor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Staff Instructor'),
            const Spacer(),
            AppButton.miniFlat(
              text: (staffInstructor != null) ? 'Manage Instructor' : 'Add Instructor',
              onTap: () async {
                staffInstructor = await EmpSelectorBottomSheet.show(
                  context,
                  selectedInstructor: staffInstructor,
                  employeeType: EmployeeType.showAllDiveTeam,
                  tanksRequired: false,
                  selectedDate: DateTime.now(),
                );
                setState(() {});
              },
            ),
          ],
        ),
        if (staffInstructor != null) Text(staffInstructor!.name).paddingOnly(top: 10),
      ],
    );
  }

  Widget buildIsDived() {
    return Row(
      children: [
        Text(
          'Is Dived Completed',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.text.black,
          ),
        ),
        Spacing.w20,
        buildTimeButtons(
          title: 'Yes',
          onTap: () {
            setState(() {
              isDived = true;
            });
          },
          color: (isDived == true) ? AppColors.text.lightSkyBlue : Colors.white,
        ),
        Spacing.w10,
        buildTimeButtons(
          title: 'No',
          onTap: () {
            setState(() {
              isDived = false;
            });
          },
          color: (isDived == false) ? AppColors.text.lightSkyBlue : Colors.white,
        ),
      ],
    );
  }

  Widget buildCustomerFeedback() {
    return buildTextEditor(
      title: 'Customer feedback is already submitted to fill again click ',
      onTap: () async {
        await CustomerFeedbackBottomSheet.show(
          context,
          bookingModel: booking,
          paxIndex: widget.paxIndex,
          customerFeedback: customerFeedback,
        );
      },
    );
  }

  Widget buildSubmitButton() {
    return AppButton.flat(
      text: (booking.pax?[widget.paxIndex]['roaster'] == null) ? 'Submit' : 'Update',
      onTap: () async {
        showLoading = true;
        setState(() {});

        Roaster roaster = Roaster(
          instructor: assignedInstructor,
          staffInstructor: staffInstructor,
          timeIn: timeIn,
          timeOut: timeOut,
          customerFeedback: customerFeedback,
          isDived: isDived,
        );

        booking.pax?[widget.paxIndex]['roaster'] = roaster.toMap();

        await FirebaseFirestore.instance.collection('bookings').doc(booking.id).set(booking.toMap());
        showLoading = false;
        setState(() {});

        Get.back();
      },
      color: Colors.black,
      textColor: Colors.white,
    );
  }

  Widget buildTimeButtons({
    required String title,
    required Function onTap,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(title),
        ),
      ),
    );
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
            value: assignedInstructor,
            onChanged: (dynamic mode) {
              assignedInstructor = mode;
              setState(() {});
            },
            items: dsdInstructors.map((newIns) {
              return DropdownMenuItem(
                value: newIns,
                child: Text(newIns.name),
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
