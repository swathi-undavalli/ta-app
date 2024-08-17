import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/time_picker.dart';
import '../../../boat/models/boat_details.dart';
import '../../../boat/models/boats.dart';
import '../../../boat/presentation/widgets/counter_widget.dart';
import '../../../boat/presentation/widgets/employee_selector_bottom_sheet.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';

class GeneralInfoView extends StatefulWidget {
  const GeneralInfoView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const GeneralInfoView(),
      );

  @override
  State<GeneralInfoView> createState() => _GeneralInfoViewState();
}

class _GeneralInfoViewState extends State<GeneralInfoView> {
  late TextEditingController generalNotesTED;
  late TextEditingController wavesTED;
  late TextEditingController windsTED;
  late TextEditingController powerNotesTED;

  BoatsModel? boatsModel;
  bool showLoading = false;
  DateTime selectedDate = DateTime.now();
  DateTime highTideTime = DateTime.now();
  DateTime lowTideTime = DateTime.now();
  late Dsd currentDsd;

  @override
  void initState() {
    selectedDate = DateTime.now();
    init();
    super.initState();
    generalNotesTED = TextEditingController();
    wavesTED = TextEditingController();
    windsTED = TextEditingController();
    powerNotesTED = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'General Info'),
      body: WillPopScope(
        onWillPop: () async {
          reset();
          return true;
        },
        child: SafeArea(
          child: (showLoading)
              ? SizedBox(
                  height: Screen.height,
                  width: Screen.width,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildButton(
                            onTap: () {
                              onDateChanged(
                                selectedDate.subtract(const Duration(days: 1)),
                              );
                            },
                            icon: Icons.arrow_back_ios_rounded,
                          ),
                          Spacing.w20,
                          Text(
                            DateFormat('dd-MMM-yyyy').format(selectedDate),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacing.w20,
                          buildButton(
                            onTap: () {
                              onDateChanged(
                                selectedDate.add(const Duration(days: 1)),
                              );
                            },
                            icon: Icons.arrow_forward_ios_rounded,
                          ),
                          const Spacer(),
                          IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              selectDate(context);
                            },
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              size: 17,
                            ),
                          ),
                        ],
                      ),
                      buildSectionTitle('BCD : '),
                      CounterWidget(
                        label: 'Kids',
                        onChanged: (int count) {
                          currentDsd.bcd?.kids = count;
                        },
                        initialValue: currentDsd.bcd?.kids ?? 0,
                      ),
                      CounterWidget(
                        label: 'XXS',
                        onChanged: (int count) {
                          currentDsd.bcd?.xxs = count;
                        },
                        initialValue: currentDsd.bcd?.xxs ?? 0,
                      ),
                      CounterWidget(
                        label: 'XS',
                        onChanged: (int count) {
                          currentDsd.bcd?.xs = count;
                        },
                        initialValue: currentDsd.bcd?.xs ?? 0,
                      ),
                      CounterWidget(
                        label: 'S',
                        onChanged: (int count) {
                          currentDsd.bcd?.s = count;
                        },
                        initialValue: currentDsd.bcd?.s ?? 0,
                      ),
                      CounterWidget(
                        label: 'M',
                        onChanged: (int count) {
                          currentDsd.bcd?.m = count;
                        },
                        initialValue: currentDsd.bcd?.m ?? 0,
                      ),
                      CounterWidget(
                        label: 'L',
                        onChanged: (int count) {
                          currentDsd.bcd?.l = count;
                        },
                        initialValue: currentDsd.bcd?.l ?? 0,
                      ),
                      CounterWidget(
                        label: 'XL',
                        onChanged: (int count) {
                          currentDsd.bcd?.xl = count;
                        },
                        initialValue: currentDsd.bcd?.xl ?? 0,
                      ),
                      CounterWidget(
                        label: 'XXL',
                        onChanged: (int count) {
                          currentDsd.bcd?.xxl = count;
                        },
                        initialValue: currentDsd.bcd?.xxl ?? 0,
                      ),
                      buildSectionTitle('Regulator : '),
                      CounterWidget(
                        onChanged: (int count) {
                          currentDsd.regulator = count;
                        },
                        initialValue: currentDsd.regulator ?? 0,
                      ).paddingOnly(left: 40),
                      buildSectionTitle('Mask : '),
                      CounterWidget(
                        onChanged: (int count) {
                          currentDsd.mask = count;
                        },
                        initialValue: currentDsd.mask ?? 0,
                      ).paddingOnly(left: 40),
                      const SizedBox(height: 20),
                      Text(
                        'Power Mask :',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text.black,
                          fontFamily: AppFonts.nunito,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          CounterWidget(
                            onChanged: (int count) {
                              currentDsd.powerMask = count;
                            },
                            initialValue: currentDsd.powerMask ?? 0,
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: AppTextField(
                              controller: powerNotesTED,
                              hintText: 'Power Notes',
                              keyboardType: const TextInputType.numberWithOptions(signed: true),
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
                        'Fins :',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.text.black,
                          fontFamily: AppFonts.nunito,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CounterWidget(
                        onChanged: (int count) {
                          currentDsd.fins = count;
                        },
                        initialValue: currentDsd.fins ?? 0,
                      ).paddingOnly(left: 40),
                      buildSectionTitle('Weights : '),
                      CounterWidget(
                        label: '3 kg',
                        onChanged: (int count) {
                          currentDsd.weights?.w3 = count;
                        },
                        initialValue: currentDsd.weights?.w3 ?? 0,
                      ),
                      CounterWidget(
                        label: '4 kg',
                        onChanged: (int count) {
                          currentDsd.weights?.w4 = count;
                        },
                        initialValue: currentDsd.weights?.w4 ?? 0,
                      ),
                      CounterWidget(
                        label: '5 kg',
                        onChanged: (int count) {
                          currentDsd.weights?.w5 = count;
                        },
                        initialValue: currentDsd.weights?.w5 ?? 0,
                      ),
                      CounterWidget(
                        label: '6 kg',
                        onChanged: (int count) {
                          currentDsd.weights?.w6 = count;
                        },
                        initialValue: currentDsd.weights?.w6 ?? 0,
                      ),
                      CounterWidget(
                        label: '7 kg',
                        onChanged: (int count) {
                          currentDsd.weights?.w7 = count;
                        },
                        initialValue: currentDsd.weights?.w7 ?? 0,
                      ),
                      const SizedBox(height: 20),
                      buildSectionTitle('Employees : '),
                      buildEmployeeSelector(
                        employees: currentDsd.dsdPool ?? [],
                        title: 'DSD Pool',
                        employeeType: EmployeeType.showFreelancersDivers,
                        employeeLimit: -1,
                      ),
                      Spacing.h10,
                      buildEmployeeSelector(
                        employees: currentDsd.dsdOceanHead ?? [],
                        title: 'DSD Ocean Leader',
                        employeeType: EmployeeType.showFreelancersDivers,
                        employeeLimit: -1,
                      ),
                      Spacing.h10,
                      buildEmployeeSelector(
                        employees: currentDsd.centerStaff ?? [],
                        title: 'DSD Center Staff',
                        employeeType: EmployeeType.showFreelancersDivers,
                        employeeLimit: -1,
                      ),
                      Spacing.h10,
                      buildEmployeeSelector(
                        employees: currentDsd.courseCenter ?? [],
                        title: 'Courses Center',
                        employeeType: EmployeeType.showFreelancersDivers,
                        employeeLimit: -1,
                      ),
                      Spacing.h10,
                      buildEmployeeSelector(
                        employees: currentDsd.harboursStaff ?? [],
                        title: 'Harbour Staff',
                        employeeType: EmployeeType.showAllEmployees,
                        employeeLimit: -1,
                      ),
                      Spacing.h10,
                      buildEmployeeSelector(
                        employees: currentDsd.dayOffs ?? [],
                        title: 'Day Offs',
                        employeeType: EmployeeType.showAllEmployees,
                        employeeLimit: -1,
                      ),
                      Spacing.h10,
                      buildEmployeeSelector(
                        employees: currentDsd.leaves ?? [],
                        employeeType: EmployeeType.showAllEmployees,
                        title: 'Leaves',
                        employeeLimit: -1,
                      ),
                      AppTextField(
                        controller: generalNotesTED,
                        hintText: 'General Notes',
                        minLines: 2,
                        errorValidator: () {
                          return null;
                        },
                        validator: (_) {
                          return null;
                        },
                      ),
                      Spacing.h10,
                      buildSectionTitle('Weather : '),
                      buildTides(
                        time: highTideTime,
                        title: 'High Tide : ',
                        onTap: () {
                          selectHighTideTime();
                        },
                      ),
                      const SizedBox(height: 10),
                      buildTides(
                        time: lowTideTime,
                        title: 'Low Tide : ',
                        onTap: () {
                          selectLowTideTime();
                        },
                      ),
                      AppTextField(
                        controller: wavesTED,
                        hintText: 'Waves',
                        suffixText: 'm',
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        errorValidator: () {
                          return null;
                        },
                        validator: (_) {
                          return null;
                        },
                      ),
                      AppTextField(
                        controller: windsTED,
                        hintText: 'Winds',
                        keyboardType: const TextInputType.numberWithOptions(signed: true),
                        suffixText: 'km/hr',
                        errorValidator: () {
                          return null;
                        },
                        validator: (_) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 50),
                      Center(
                        child: AppButton.flat(
                          text: 'Submit',
                          onTap: () {
                            onSubmitPressed();
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ).paddingSymmetric(horizontal: 20),
                ),
        ),
      ),
    );
  }

  Future<void> init() async {
    showLoading = true;
    var d = await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(selectedDate))
        .get();

    Map<String, dynamic>? data = d.data();
    BoatsModel? boatsModel = BoatsModel.fromMap(data);
    if (boatsModel.dsd == null) {
      currentDsd = Dsd(
        bcd: Bcd(xs: 0, s: 0, m: 0, l: 0, xl: 0, xxl: 0, kids: 0, xxs: 0),
        fins: 0,
        mask: 0,
        regulator: 0,
        powerMask: 0,
        weights: Weights(w3: 0, w4: 0, w5: 0, w6: 0, w7: 0),
        dayOffs: [],
        generalNotes: null,
        highTides: null,
        lowTides: null,
        waves: null,
        winds: null,
        leaves: [],
        powerNotes: null,
        dsdPool: [],
        dsdOceanHead: [],
        courseCenter: [],
        harboursStaff: [],
        centerStaff: [],
      );
    } else {
      currentDsd = boatsModel.dsd!;

      highTideTime = TimePicker.getDateTime(currentDsd.highTides) ?? DateTime.now();
      lowTideTime = TimePicker.getDateTime(currentDsd.lowTides) ?? DateTime.now();
      generalNotesTED.text = currentDsd.generalNotes ?? '';
      windsTED.text = currentDsd.winds ?? '';
      wavesTED.text = currentDsd.waves ?? '';
      powerNotesTED.text = currentDsd.powerNotes ?? '';
    }
    showLoading = false;
    setState(() {});
  }

  Future<void> onDateChanged(DateTime date) async {
    selectedDate = date;
    setState(() {});
    showLoading = true;
    await init();
    showLoading = false;
    setState(() {});
  }

  Future<void> onSubmitPressed() async {
    showLoading = true;
    setState(() {});

    currentDsd.highTides = TimePicker.getFormattedTime(highTideTime);
    currentDsd.lowTides = TimePicker.getFormattedTime(lowTideTime);

    currentDsd.generalNotes = generalNotesTED.text;
    currentDsd.winds = windsTED.text;
    currentDsd.waves = wavesTED.text;
    currentDsd.powerNotes = powerNotesTED.text;

    await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(selectedDate))
        .set({'dsd': currentDsd.toJson()}, SetOptions(merge: true));
    showLoading = false;
    setState(() {});
    if (mounted) {
      Navigator.pop(context);
    }
  }

  reset() {
    generalNotesTED.text = '';
    wavesTED.text = '';
    windsTED.text = '';
    powerNotesTED.text = '';
    highTideTime = DateTime.now();
    lowTideTime = DateTime.now();
    selectedDate = DateTime.now();
  }

  Future<void> selectHighTideTime() async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: highTideTime,
    );

    if (pickedTime != null) {
      setState(() {
        highTideTime = pickedTime;
      });
    }
  }

  Future<void> selectLowTideTime() async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: lowTideTime,
    );

    if (pickedTime != null) {
      setState(() {
        lowTideTime = pickedTime;
      });
    }
  }

  Widget buildEmployeeSelector({
    required List<Instructor> employees,
    required String title,
    required int employeeLimit,
    required EmployeeType employeeType,
  }) {
    if (employees.isEmpty) {
      return AppButton.miniFlat(
        text: 'Add $title',
        onTap: () async {
          FocusScope.of(context).unfocus();
          employees = (await EmpSelectorBottomSheet.getSelectedInstructors(
                context,
                initialSelectedInstructors: employees,
                instructorLimit: employeeLimit,
                employeeType: employeeType,
                selectedDate: null,
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
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...employees.map(
                  (e) => Text(
                    e.name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ).paddingOnly(bottom: 4),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                employees = (await EmpSelectorBottomSheet.getSelectedInstructors(
                      context,
                      initialSelectedInstructors: employees,
                      instructorLimit: employeeLimit,
                      employeeType: employeeType,
                      selectedDate: null,
                    )) ??
                    [];
                setState(() {});
              },
              child: const Text(
                'Change',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ).paddingOnly(left: 10, right: 7),
            ),
            const Icon(
              Icons.edit,
              size: 12,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTides({
    required DateTime time,
    required String title,
    required Function onTap,
  }) {
    return Row(
      children: [
        buildSectionTitle(title),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            height: 30,
            width: 100,
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

  selectDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
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
                textStyle: const TextStyle(fontWeight: FontWeight.w500), // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      onDateChanged(date);
    }
  }

  Widget buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.text.black,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.w600,
      ),
    ).paddingSymmetric(vertical: 20);
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
        ),
      ),
    );
  }
}
