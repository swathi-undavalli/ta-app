import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../boat/models/boats.dart';
import '../../../boat/presentation/widgets/employee_selector_bottom_sheet.dart';
import '../../controller/dive_log_controller.dart';
import '../../models/booking_model.dart';
import '../../models/dive_log_model.dart';
import '../widgets/app_text_fields.dart';

class DiveLogView extends StatefulWidget {
  const DiveLogView({
    super.key,
    required this.email,
    required this.booking,
    this.date,
    this.diveLog,
  });

  final Booking? booking;
  final String email;
  final DateTime? date;
  final DiveLogModel? diveLog;

  static Route addLogRoute(
    String email,
    Booking booking,
    DateTime date,
  ) {
    return MaterialPageRoute(
      builder: (_) => DiveLogView(
        booking: booking,
        email: email,
        date: date,
      ),
    );
  }

  static Route editLogRoute(
    String email,
    Booking booking,
    DiveLogModel log,
  ) {
    return MaterialPageRoute(
      builder: (_) => DiveLogView(
        email: email,
        booking: booking,
        diveLog: log,
      ),
    );
  }

  @override
  State<DiveLogView> createState() => _DiveLogViewState();
}

class _DiveLogViewState extends State<DiveLogView> {
  final DiveLogLogic logic = DiveLogLogic();

  @override
  void initState() {
    super.initState();
    logic.clear();
    logic.controller.booking = widget.booking;
    logic.controller.email = widget.email;
    logic.controller.selectedDate = widget.date ?? DateTime.now();
    logic.controller.diveLog = widget.diveLog;

    if (logic.controller.diveLog != null) {
      logic.controller.selectedDate = logic.controller.diveLog!.timeIn.toDate();
      logic.controller.selectedTime = TimeOfDay(
        hour: logic.controller.diveLog!.timeIn.toDate().hour,
        minute: logic.controller.diveLog!.timeIn.toDate().minute,
      );
      logic.controller.instructor = [logic.controller.diveLog!.instructor];
      logic.controller.diveSiteTED.text = logic.controller.diveLog!.diveSite;
      logic.controller.tankTypeTED.text = logic.controller.diveLog!.tankType ?? '';
      logic.controller.tankNoTED.text = logic.controller.diveLog!.tankNo.toString();
      logic.controller.bottomTimeTED.text = logic.controller.diveLog!.bottomTime.toString();
      logic.controller.maxDepthTED.text = logic.controller.diveLog!.maxDepth.toString();
      logic.controller.rentalEquipmentTED.text = logic.controller.diveLog!.rentalEquipment.toString();
      return;
    }

    String? boatId = logic.controller.booking?.getBoatInfo(logic.controller.selectedDate)?.id;
    logic.controller.nitrox = logic.controller.booking?.getBoatInfo(logic.controller.selectedDate)?.nitrox;
    logic.controller.air = logic.controller.booking?.getBoatInfo(logic.controller.selectedDate)?.air;

    if (boatId != null) {
      fetchBoatDetails(boatId);
    }
    if (logic.controller.booking?.getInstructor(logic.controller.selectedDate) != null) {
      logic.controller.instructor = [
        logic.controller.booking!.getInstructor(logic.controller.selectedDate)!,
      ];
    }
    isAirOrNitrox();
  }

  Future<void> fetchBoatDetails(String? boatId) async {
    var d = await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(logic.controller.selectedDate))
        .get();
    Map<String, dynamic>? data = d.data();
    BoatsModel? boatsModel = BoatsModel.fromMap(data);
    List<Boat> allBoats = boatsModel.boats ?? [];
    for (var boat in allBoats) {
      if (boat.id == boatId) {
        logic.controller.diveSiteTED.text = boat.diveSite ?? '-';
      }
    }
    setState(() {});
  }

  void isAirOrNitrox() {
    if ((logic.controller.air == null && logic.controller.nitrox == null) ||
        (logic.controller.air == 0 && logic.controller.nitrox == 0)) {
      logic.controller.tankTypeTED.text = '';
    } else if (logic.controller.air != 0) {
      logic.controller.tankTypeTED.text = 'Air';
    } else if (logic.controller.nitrox != 0) {
      logic.controller.tankTypeTED.text = 'Nitrox';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'Add Log'),
      body: SafeArea(
        child: GetBuilder<DiveLogController>(
          builder: (controller) {
            if (controller.showLoading) {
              return buildShowLoading();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDate(controller, context),
                Spacing.h20,
                buildTime(controller, context),
                Spacing.h20,
                buildEmployeeSelector(context),
                Text(
                  (controller.instructorError != null) ? 'Instructor ${controller.instructorError}' : '',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade900),
                ),
                AppTextField(
                  hintText: 'Dive Site *',
                  controller: controller.diveSiteTED,
                  errorValidator: () {
                    return controller.diveSiteError;
                  },
                  validator: (diveSite) {
                    return diveSite;
                  },
                ),
                AppTextField(
                  hintText: 'Tank Type *',
                  controller: controller.tankTypeTED,
                  errorValidator: () {
                    return null;
                  },
                  validator: (tankNo) {
                    return null;
                  },
                ),
                AppTextField(
                  hintText: 'Tank No *',
                  controller: controller.tankNoTED,
                  keyboardType: TextInputType.number,
                  errorValidator: () {
                    return controller.tankNoError;
                  },
                  validator: (tankNo) {
                    return tankNo;
                  },
                ),
                AppTextField(
                  hintText: 'Bottom Time *',
                  controller: controller.bottomTimeTED,
                  keyboardType: TextInputType.number,
                  suffixText: 'mins',
                  errorValidator: () {
                    return controller.bottomTimeError;
                  },
                  validator: (bottomTimeError) {
                    return bottomTimeError;
                  },
                ),
                AppTextField(
                  hintText: 'Max Depth *',
                  controller: controller.maxDepthTED,
                  suffixText: 'm',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  errorValidator: () {
                    return controller.maxDepthError;
                  },
                  validator: (maxDepthError) {
                    return maxDepthError;
                  },
                ),
                AppTextField(
                  hintText: 'Rental Equipment',
                  controller: controller.rentalEquipmentTED,
                  errorValidator: () {
                    return null;
                  },
                  validator: (_) {
                    return null;
                  },
                ),
                Spacing.h30,
                Spacing.h30,
                AppButton.flat(
                  onTap: () {
                    logic.onSubmitPressed(context);
                  },
                  text: 'Submit',
                  color: Colors.black,
                  textColor: Colors.white,
                ).center,
                Spacing.h30,
                Spacing.h30,
              ],
            );
          },
        ).paddingSymmetric(horizontal: 20, vertical: 30).scrollable,
      ),
    );
  }

  Widget buildShowLoading() {
    return Container(
      color: Colors.white,
      height: Screen.height,
      width: Screen.width,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  Widget buildEmployeeSelector(BuildContext context) {
    if (logic.controller.instructor.isEmpty) {
      return Row(
        children: [
          const Text(
            'Select Instructor',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          AppButton.miniFlat(
            text: 'Select',
            onTap: () async {
              logic.controller.instructor = await EmpSelectorBottomSheet.getSelectedInstructors(
                    context,
                    initialSelectedInstructors: logic.controller.instructor,
                    instructorLimit: 1,
                    employeeType: EmployeeType.showAllDiveTeam,
                    tanksRequired: false,
                    selectedDate: logic.controller.selectedDate,
                  ) ??
                  [];
              logic.controller.update();
            },
          ),
        ],
      );
    }
    return Row(
      children: [
        const Text(
          'Instructor',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const Spacer(),
        Text(
          '${logic.controller.instructor[0].name} ',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        InkWell(
          onTap: () async {
            logic.controller.instructor = (await EmpSelectorBottomSheet.getSelectedInstructors(
                  context,
                  initialSelectedInstructors: logic.controller.instructor,
                  instructorLimit: 1,
                  employeeType: EmployeeType.showAllDiveTeam,
                  tanksRequired: false,
                  selectedDate: null,
                )) ??
                [];
            logic.controller.update();
          },
          child: const Text(
            'Change',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Spacing.w5,
        const Icon(
          Icons.edit,
          size: 12,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget buildDate(DiveLogController controller, BuildContext context) {
    return Row(
      children: [
        const Text(
          'Date',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const Spacer(),
        Text(
          DateFormat('dd-MM-yyyy').format(controller.selectedDate.toLocal()),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.w10,
        InkWell(
          onTap: () {
            _selectDate(context);
          },
          child: Row(
            children: [
              const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              Spacing.w5,
              const Icon(
                Icons.edit,
                size: 12,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTime(DiveLogController controller, BuildContext context) {
    return Row(
      children: [
        const Text(
          'Time-In',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        const Spacer(),
        Text(
          controller.selectedTime.format(context),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.w10,
        InkWell(
          onTap: () {
            _selectTime(context);
          },
          child: Row(
            children: [
              const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              Spacing.w5,
              const Icon(
                Icons.edit,
                size: 12,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: logic.controller.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != logic.controller.selectedDate) {
      logic.controller.selectedDate = picked;
      logic.controller.update();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: logic.controller.selectedTime,
    );

    if (picked != null && picked != logic.controller.selectedTime) {
      logic.controller.selectedTime = picked;
      log(logic.controller.selectedTime.toString());
      logic.controller.update();
    }
  }
}
