import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/firebase/api.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/time_picker.dart';
import '../../../boat/models/boat_details.dart';
import '../../../boat/presentation/widgets/employee_selector_bottom_sheet.dart';
import '../../../employees/model/employee.dart';
import '../../models/event_model.dart';

class EventEntryBottomSheet extends StatefulWidget {
  final Event? event;

  const EventEntryBottomSheet({
    super.key,
    this.event,
  });

  static Future show(
    BuildContext context, {
    Event? eventElementModel,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EventEntryBottomSheet(
          event: eventElementModel,
        );
      },
    );

    return data;
  }

  @override
  State<EventEntryBottomSheet> createState() => _EventEntryBottomSheetState();
}

class _EventEntryBottomSheetState extends State<EventEntryBottomSheet> {
  late TextEditingController locationTED;
  late TextEditingController sessionNameTED;
  String? locationError;
  String? sessionError;
  List<Instructor> employees = [];
  late DateTime sessionDate;
  late DateTime sessionTime;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    locationTED = TextEditingController(text: widget.event?.location ?? '');
    sessionNameTED = TextEditingController(text: widget.event?.session ?? '');
    sessionDate = widget.event?.dateTime ?? DateTime.now();
    sessionTime = widget.event?.dateTime ?? DateTime.now();
    employees = widget.event?.employees ?? [];
    if (widget.event != null) {
      employees[0].phone = widget.event?.phone ?? '';
    }
    log('called');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.background.lightBlue,
      ),
      child: Stack(
        children: [
          if (showLoading)
            Container(
              width: Screen.width,
              height: 650,
              color: Colors.grey,
              child: const CircularProgressIndicator(
                color: Colors.black,
              ).center,
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              buildKeyValuePair(
                title: 'Session Name',
                controller: sessionNameTED,
                errorText: sessionError,
                textInputType: TextInputType.text,
                maxLines: 3,
              ),
              buildKeyValuePair(
                title: 'Location',
                controller: locationTED,
                errorText: locationError,
                textInputType: TextInputType.text,
                maxLines: 2,
              ),
              Spacing.h35,
              buildDateAndTime(
                onTap: () {
                  selectTime(context);
                },
                title: 'Time',
                value: TimePicker.getFormattedTime(sessionTime) ?? 'No time selected',
              ),
              Spacing.h35,
              buildDateAndTime(
                value: DateFormat('dd-MM-yyyy').format(sessionDate),
                onTap: () {
                  selectDate(context);
                },
                title: 'Date',
              ),
              Spacing.h35,
              buildEmployeeSelector(
                employees: employees,
                title: 'Select Employee',
                employeeType: EmployeeType.showAllEmployees,
                employeeLimit: 1,
              ),
              Spacing.h50,
              buildSubmitButton().center,
            ],
          ).paddingSymmetric(horizontal: 20, vertical: 20).scrollable,
        ],
      ),
    );
  }

  Widget buildEmployeeSelector({
    required List<Instructor> employees,
    required String title,
    required int employeeLimit,
    required EmployeeType employeeType,
  }) {
    if (employees.isEmpty) {
      return AppButton.miniFlat(
        text: title,
        onTap: () async {
          employees = (await EmpSelectorBottomSheet.getSelectedInstructors(
                context,
                initialSelectedInstructors: employees,
                instructorLimit: employeeLimit,
                employeeType: employeeType,
                selectedDate: null,
              )) ??
              [];
          log(employees[0].phone.toString());
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

  Widget buildDateAndTime({
    required String title,
    required String value,
    required Function onTap,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.black,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
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
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.nunito,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> selectTime(BuildContext context) async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: sessionTime,
    );

    if (pickedTime != null) {
      setState(() {
        sessionTime = pickedTime;
      });
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: sessionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != sessionDate) {
      setState(() {
        sessionDate = picked;
      });
    }
  }

  Widget buildSubmitButton() {
    return AppButton.flat(
      onTap: () async {
        if (!isValid) return;
        setState(() {
          showLoading = true;
        });

        Event event = Event(
          id: widget.event?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
          session: sessionNameTED.text,
          location: locationTED.text,
          employees: employees,
          phone: employees[0].phone ?? '',
          dateTime: DateTime(
            sessionDate.year,
            sessionDate.month,
            sessionDate.day,
            sessionTime.hour,
            sessionTime.minute,
          ),
          createdBy: currentEmployee?.firstName,
        );

        await firebaseApi.updateEvent(event);

        setState(() {
          showLoading = false;
        });
        clear();
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      },
      text: 'Submit',
      color: Colors.black,
      textColor: Colors.white,
    );
  }

  bool get isValid {
    bool isValid = true;
    locationError = null;
    sessionError = null;

    if (sessionNameTED.text.isEmpty) {
      sessionError = 'Required';
      isValid = false;
    }

    if (locationTED.text.isEmpty) {
      locationError = 'Required';
      isValid = false;
    }
    if (employees.isEmpty) {
      showToast('Employee is not selected');
      isValid = false;
    }

    return isValid;
  }

  clear() {
    locationTED.text = '';
    locationError = null;
    sessionError = null;
    sessionNameTED.text = '';
    employees = [];
  }

  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Add Event',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 19,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            clear();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget buildKeyValuePair({
    required String title,
    required TextEditingController controller,
    required TextInputType textInputType,
    String? errorText,
    int? maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.black,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: textInputType,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: '',
              errorText: errorText,
              suffixText: (title == 'Duration') ? 'sec' : '',
              suffixIcon: (title == 'URL' && locationTED.text.isNotEmpty)
                  ? GestureDetector(
                      onTap: () {
                        locationTED.text = '';
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ).paddingAll(5),
                    )
                  : const SizedBox(),
              errorStyle: TextStyle(color: Colors.red.shade700),
              border: const UnderlineInputBorder(),
            ),
          ),
        ),
      ],
    ).paddingOnly(top: 15);
  }
}
