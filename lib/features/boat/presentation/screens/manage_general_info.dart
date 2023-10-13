import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/spacing_widgets.dart';
import 'package:temple_adventures/core/widgets/app_button.dart';
import 'package:temple_adventures/core/widgets/back_navigation_icon.dart';
import 'package:temple_adventures/core/widgets/time_picker.dart';
import 'package:temple_adventures/features/boat/controller/manage_general_info_controller.dart';
import 'package:temple_adventures/features/boat/models/boat_details.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/counter_widget.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/employee_selector_bottom_sheet.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app_text_fields.dart';

class ManageGeneralInfo extends StatefulWidget {
  static const String id = "ManageDSDEquipment";

  @override
  State<ManageGeneralInfo> createState() => _ManageGeneralInfoState();
}

class _ManageGeneralInfoState extends State<ManageGeneralInfo> {
  final ManageGeneralInfoLogic logic = ManageGeneralInfoLogic();

  @override
  void initState() {
    logic.controller.selectedDate = DateTime.now();
    logic.init().whenComplete(() => logic.controller.update());
    super.initState();
  }

  Future<void> selectHighTideTime(BuildContext context) async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: logic.controller.highTideTime,
    );

    if (pickedTime != null) {
      setState(() {
        logic.controller.highTideTime = pickedTime;
      });
    }
  }

  Future<void> selectLowTideTime(BuildContext context) async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: logic.controller.lowTideTime,
    );

    if (pickedTime != null) {
      setState(() {
        logic.controller.lowTideTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar() as PreferredSizeWidget?,
      body: WillPopScope(
        onWillPop: () async {
          logic.controller.reset();
          return true;
        },
        child: SafeArea(
          child: GetBuilder<ManageGeneralInfoController>(
            builder: (controller) {
              if (controller.showLoading)
                return Container(
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                );
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        buildButton(
                            onTap: () {
                              logic.onDateChanged(controller.selectedDate
                                  .subtract(const Duration(days: 1)));
                            },
                            icon: Icons.arrow_back_ios_rounded),
                        Spacing.w20,
                        Text(
                          DateFormat('dd-MMM-yyyy')
                              .format(controller.selectedDate),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Spacing.w20,
                        buildButton(
                            onTap: () {
                              logic.onDateChanged(controller.selectedDate
                                  .add(const Duration(days: 1)));
                            },
                            icon: Icons.arrow_forward_ios_rounded),
                        Spacer(),
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            selectDate(context);
                          },
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                    buildSectionTitle("BCD : "),
                    CounterWidget(
                        label: "Kids",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.kids = count;
                        },
                        initialValue: controller.currentDsd.bcd?.kids ?? 0),
                    CounterWidget(
                        label: "XXS",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.xxs = count;
                        },
                        initialValue: controller.currentDsd.bcd?.xxs ?? 0),
                    CounterWidget(
                        label: "XS",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.xs = count;
                        },
                        initialValue: controller.currentDsd.bcd?.xs ?? 0),
                    CounterWidget(
                        label: "S",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.s = count;
                        },
                        initialValue: controller.currentDsd.bcd?.s ?? 0),
                    CounterWidget(
                        label: "M",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.m = count;
                        },
                        initialValue: controller.currentDsd.bcd?.m ?? 0),
                    CounterWidget(
                        label: "L",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.l = count;
                        },
                        initialValue: controller.currentDsd.bcd?.l ?? 0),
                    CounterWidget(
                        label: "XL",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.xl = count;
                        },
                        initialValue: controller.currentDsd.bcd?.xl ?? 0),
                    CounterWidget(
                        label: "XXL",
                        onChanged: (int count) {
                          controller.currentDsd.bcd?.xxl = count;
                        },
                        initialValue: controller.currentDsd.bcd?.xxl ?? 0),
                    buildSectionTitle("Regulator : "),
                    CounterWidget(
                      onChanged: (int count) {
                        controller.currentDsd.regulator = count;
                      },
                      initialValue: controller.currentDsd.regulator ?? 0,
                    ).paddingOnly(left: 40),
                    buildSectionTitle("Mask : "),
                    CounterWidget(
                      onChanged: (int count) {
                        controller.currentDsd.mask = count;
                      },
                      initialValue: controller.currentDsd.mask ?? 0,
                    ).paddingOnly(left: 40),
                    SizedBox(height: 20),
                    Text(
                      "Power Mask :",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text.black,
                          fontFamily: AppFonts.nunito,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        CounterWidget(
                          onChanged: (int count) {
                            controller.currentDsd.powerMask = count;
                          },
                          initialValue: controller.currentDsd.powerMask ?? 0,
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: AppTextField(
                            controller: controller.powerNotesTED,
                            hintText: "Power Notes",
                            keyboardType:
                                TextInputType.numberWithOptions(signed: true),
                            errorValidator: () {
                              return null;
                            },
                            validator: (_) {
                              return null;
                            },
                          ).paddingOnly(bottom: 30),
                        ),
                      ],
                    ),
                    Text(
                      "Fins :",
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text.black,
                          fontFamily: AppFonts.nunito,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20),
                    CounterWidget(
                      onChanged: (int count) {
                        controller.currentDsd.fins = count;
                      },
                      initialValue: controller.currentDsd.fins ?? 0,
                    ).paddingOnly(left: 40),
                    buildSectionTitle("Weights : "),
                    CounterWidget(
                        label: "3 kg",
                        onChanged: (int count) {
                          controller.currentDsd.weights?.w3 = count;
                        },
                        initialValue: controller.currentDsd.weights?.w3 ?? 0),
                    CounterWidget(
                        label: "4 kg",
                        onChanged: (int count) {
                          controller.currentDsd.weights?.w4 = count;
                        },
                        initialValue: controller.currentDsd.weights?.w4 ?? 0),
                    CounterWidget(
                        label: "5 kg",
                        onChanged: (int count) {
                          controller.currentDsd.weights?.w5 = count;
                        },
                        initialValue: controller.currentDsd.weights?.w5 ?? 0),
                    CounterWidget(
                        label: "6 kg",
                        onChanged: (int count) {
                          controller.currentDsd.weights?.w6 = count;
                        },
                        initialValue: controller.currentDsd.weights?.w6 ?? 0),
                    CounterWidget(
                        label: "7 kg",
                        onChanged: (int count) {
                          controller.currentDsd.weights?.w7 = count;
                        },
                        initialValue: controller.currentDsd.weights?.w7 ?? 0),
                    SizedBox(height: 20),
                    buildSectionTitle("Employees : "),
                    buildEmployeeSelector(
                      employees: logic.controller.currentDsd.dsdPool ?? [],
                      title: "DSD Pool",
                      employeeType: EmployeeType.ShowFreelancersDivers,
                      employeeLimit: -1,
                    ),
                    Spacing.h10,
                    buildEmployeeSelector(
                      employees: logic.controller.currentDsd.dsdOceanHead ?? [],
                      title: "DSD Ocean Leader",
                      employeeType: EmployeeType.ShowFreelancersDivers,
                      employeeLimit: -1,
                    ),
                    Spacing.h10,
                    buildEmployeeSelector(
                      employees: logic.controller.currentDsd.centerStaff ?? [],
                      title: "DSD Center Staff",
                      employeeType: EmployeeType.ShowFreelancersDivers,
                      employeeLimit: -1,
                    ),
                    Spacing.h10,
                    buildEmployeeSelector(
                      employees: logic.controller.currentDsd.courseCenter ?? [],
                      title: "Courses Center",
                      employeeType: EmployeeType.ShowFreelancersDivers,
                      employeeLimit: -1,
                    ),
                    Spacing.h10,
                    buildEmployeeSelector(
                      employees:
                          logic.controller.currentDsd.harboursStaff ?? [],
                      title: "Harbour Staff",
                      employeeType: EmployeeType.ShowAllEmployees,
                      employeeLimit: -1,
                    ),
                    Spacing.h10,
                    buildEmployeeSelector(
                      employees: logic.controller.currentDsd.dayOffs ?? [],
                      title: "Day Offs",
                      employeeType: EmployeeType.ShowAllEmployees,
                      employeeLimit: -1,
                    ),
                    Spacing.h10,
                    buildEmployeeSelector(
                      employees: logic.controller.currentDsd.leaves ?? [],
                      employeeType: EmployeeType.ShowAllEmployees,
                      title: "Leaves",
                      employeeLimit: -1,
                    ),
                    AppTextField(
                      controller: controller.generalNotesTED,
                      hintText: "General Notes",
                      minLines: 2,
                      errorValidator: () {
                        return null;
                      },
                      validator: (_) {
                        return null;
                      },
                    ),
                    Spacing.h10,
                    buildSectionTitle("Weather : "),
                    buildTides(context,
                        time: controller.highTideTime,
                        title: "High Tide : ", onTap: () {
                      selectHighTideTime(context);
                    }),
                    SizedBox(height: 10),
                    buildTides(context,
                        time: controller.lowTideTime,
                        title: "Low Tide : ", onTap: () {
                      selectLowTideTime(context);
                    }),
                    AppTextField(
                      controller: controller.wavesTED,
                      hintText: "Waves",
                      suffixText: "m",
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      errorValidator: () {
                        return null;
                      },
                      validator: (_) {
                        return null;
                      },
                    ),
                    AppTextField(
                      controller: controller.windsTED,
                      hintText: "Winds",
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                      suffixText: "km/hr",
                      errorValidator: () {
                        return null;
                      },
                      validator: (_) {
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: AppButton.flat(
                        text: "Submit",
                        onTap: () {
                          logic.onSubmitPressed();
                        },
                        color: Colors.black,
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ).paddingSymmetric(horizontal: 20),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildEmployeeSelector(
      {required List<Instructor> employees,
      required String title,
      required int employeeLimit,
      required EmployeeType employeeType}) {
    if (employees.isEmpty) {
      return AppButton.miniFlat(
        text: "Add $title",
        onTap: () async {
          employees = (await EmpSelectorBottomSheet.show(
                context,
                initialSelectedEmployees: employees,
                instructorLimit: employeeLimit,
                employeeType: employeeType,
              )) ??
              [];
          setState(() {});
        },
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...employees.map(
                  (e) => Text(
                    "${e.name}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ).paddingOnly(bottom: 4),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                employees = (await EmpSelectorBottomSheet.show(context,
                        initialSelectedEmployees: employees,
                        instructorLimit: employeeLimit,
                        employeeType: employeeType)) ??
                    [];
                setState(() {});
              },
              child: Text(
                "Change",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ).paddingOnly(left: 10, right: 7),
            ),
            Icon(
              Icons.edit,
              size: 12,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTides(BuildContext context,
      {required DateTime time,
      required String title,
      required Function onTap}) {
    return Row(
      children: [
        buildSectionTitle(title),
        SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            height: 30,
            width: 100,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                TimePicker.getFormattedTime(time) ?? 'No time selected',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: logic.controller.selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2090),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.text.black,
              onPrimary: Colors.white, // header text color
              onSurface: AppColors.text.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.text.black,
                textStyle:
                    TextStyle(fontWeight: FontWeight.w500), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      logic.onDateChanged(date);
    }
  }

  Widget buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 14,
          color: AppColors.text.black,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.w600),
    ).paddingSymmetric(vertical: 20);
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'General Info',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildButton({required Function onTap, required IconData icon}) {
    return SizedBox(
        height: 20,
        width: 20,
        child: IconButton(
            splashRadius: 30,
            padding: EdgeInsets.zero,
            onPressed: () {
              onTap();
            },
            icon: Icon(
              icon,
              color: Colors.black,
              size: 14,
            )));
  }
}
