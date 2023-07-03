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
          child:
              GetBuilder<ManageDSDEquipmentController>(builder: (controller) {
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
                  ...controller.bcdSizes.map(
                    (e) => CounterWidget(
                      onChanged: (int count) {
                        log(count.toString());
                      },
                      size: e,
                      countValue: 0,
                    ),
                  ),
                  buildSectionTitle("Regulator : "),
                  CounterWidget(onChanged: (int count) {}, countValue: 0),
                  buildSectionTitle("Mask : "),
                  CounterWidget(onChanged: (int count) {}, countValue: 0),
                  buildSectionTitle("Power Mask : "),
                  CounterWidget(onChanged: (int count) {}, countValue: 0),
                  buildSectionTitle("Fins : "),
                  CounterWidget(onChanged: (int count) {}, countValue: 0),
                  buildSectionTitle("Weights : "),
                  ...controller.weights.map((e) => CounterWidget(
                        onChanged: (int count) {},
                        countValue: 0,
                        size: e,
                      )),
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
          }),
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
                logic.controller.dayOffEmployees =
                    await EmpSelectorBottomSheet.show(
                  context,
                  initialSelectedEmployees:
                      logic.controller.dayOffEmployees ?? [],
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
        if (logic.controller.dayOffEmployees != null)
          ...?logic.controller.dayOffEmployees?.map((e) => Text(
                  "${(logic.controller.dayOffEmployees?.indexOf(e))! + 1} .  ${e.name}",
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
      // await logic.getLatestConditions();
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
