import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../boat/presentation/widgets/employee_selector_bottom_sheet.dart';
import '../../controller/dive_log_controller.dart';
import '../widgets/app_text_fields.dart';

class DiveLogView extends StatefulWidget {
  const DiveLogView({Key? key}) : super(key: key);

  static const String id = 'AddLogView';

  @override
  State<DiveLogView> createState() => _DiveLogViewState();
}

class _DiveLogViewState extends State<DiveLogView> {
  final DiveLogLogic logic = DiveLogLogic();

  var args = Get.arguments;

  @override
  void initState() {
    super.initState();
    logic.clear();
    logic.controller.booking = args[0];
    logic.controller.email = args[1];
    log(logic.controller.email.toString());
    log(logic.controller.booking!.activity!.map((e) => e?.toMap()).toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: buildAppBar(),
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
                  hintText: 'Dive Site',
                  controller: controller.diveSiteTED,
                  errorValidator: () {
                    return controller.diveSiteError;
                  },
                  validator: (diveSite) {
                    return diveSite;
                  },
                ),
                AppTextField(
                  hintText: 'Tank No',
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
                  hintText: 'Bottom Time',
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
                  hintText: 'Max Depth',
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
                Spacing.h30,
                Spacing.h30,
                AppButton.flat(
                  onTap: () {
                    logic.onSubmitPressed();
                  },
                  text: 'Submit',
                  color: Colors.black,
                  textColor: Colors.white,
                ).center,
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
      height: Get.height,
      width: Get.width,
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

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'Add Log',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.text.black,
          size: 17,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}
