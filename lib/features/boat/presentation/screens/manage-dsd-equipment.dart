import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/time-picker.dart';
import 'package:temple_adventures/features/boat/controller/manage-dsd-equipment-controller.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/counter-widget.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/customer-expandable-listTile.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/employee-selector-bottomSheet.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:intl/intl.dart';

class ManageDSDEquipment extends StatefulWidget {
  static const String id = "ManageDSDEquipment";

  @override
  State<ManageDSDEquipment> createState() => _ManageDSDEquipmentState();
}

class _ManageDSDEquipmentState extends State<ManageDSDEquipment> {
  final ManageDSDEquipmentLogic logic = ManageDSDEquipmentLogic();

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
          child: GetBuilder<ManageDSDEquipmentController>(
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
                        Text(
                          DateFormat('dd-MMM-yyyy')
                              .format(controller.selectedDate),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
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
                    buildSectionTitle("Power Mask : "),
                    CounterWidget(
                      onChanged: (int count) {
                        controller.currentDsd.powerMask = count;
                      },
                      initialValue: controller.currentDsd.powerMask ?? 0,
                    ).paddingOnly(left: 40),
                    buildSectionTitle("Fins : "),
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
                    SizedBox(height: 10),
                    buildDayOffs(),
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
                    SizedBox(height: 10),
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
                      suffixText: "mt/s",
                      keyboardType: TextInputType.number,
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
                      keyboardType: TextInputType.number,
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

  Widget buildDayOffs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Day Offs : ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(width: 20),
            InkWell(
              onTap: () async {
                logic.controller.currentDsd.dayOffs =
                    await EmpSelectorBottomSheet.show(
                  context,
                  initialSelectedEmployees:
                      logic.controller.currentDsd.dayOffs ?? [],
                  instructorLimit: -1,
                );
                logic.controller.update();
              },
              child: Container(
                height: 31,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Manage",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        if (logic.controller.currentDsd.dayOffs != null)
          ...?logic.controller.currentDsd.dayOffs?.map((e) => Text(
                  "${(logic.controller.currentDsd.dayOffs?.indexOf(e))! + 1} .  ${e.name}",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              .paddingOnly(top: 5))
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
                primary: AppColors.text.black,
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
      logic.controller.selectedDate = date;
      logic.controller.showLoading = true;
      await logic.init();
      logic.controller.showLoading = false;
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
      title: buildAppBarTitle(),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildAppBarTitle() {
    return Text(
      'DSD Equipment',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }
}
