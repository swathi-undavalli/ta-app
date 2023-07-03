import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/time-picker.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/models/boats.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/employee-selector-bottomSheet.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:intl/intl.dart';

import 'customer-expandable-listTile.dart';
import 'tank-counter.dart';

class BoatDetailsBottomSheet extends StatefulWidget {
  const BoatDetailsBottomSheet({
    Key? key,
    required this.selectedDate,
    required this.isBoatEdit,
    this.boat,
  }) : super(key: key);

  final DateTime selectedDate;
  final Boat? boat;
  final bool isBoatEdit;

  static Future<BoatsModel?> show(BuildContext context,
      {required DateTime date,
      required bool isBoatEdit,
      Boat? initialBoat}) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return BoatDetailsBottomSheet(
          selectedDate: date,
          isBoatEdit: isBoatEdit,
          boat: initialBoat,
        );
      },
    );

    return data as BoatsModel?;
  }

  @override
  State<BoatDetailsBottomSheet> createState() => _BoatDetailsBottomSheetState();
}

class _BoatDetailsBottomSheetState extends State<BoatDetailsBottomSheet> {
  final CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');
  List<Instructor> selectedCaptains = [];
  List<Instructor> selectedDsdInstructors = [];
  late TextEditingController boatTED;
  late TextEditingController diveSiteTED;
  late TextEditingController surfaceSupportTED;
  late TextEditingController notesTED;
  int nitrox = 0;
  int air = 0;
  late DateTime selectedTime;

  @override
  void initState() {
    boatTED = TextEditingController(text: widget.boat?.name ?? "");
    surfaceSupportTED =
        TextEditingController(text: widget.boat?.surfaceSupport ?? "");
    notesTED = TextEditingController(text: widget.boat?.notes ?? "");
    diveSiteTED = TextEditingController(text: widget.boat?.diveSite);
    nitrox = widget.boat?.nitrox ?? 0;
    air = widget.boat?.air ?? 0;

    if (widget.boat?.time != null)
      selectedTime = TimePicker.getDateTime(widget.boat?.time ?? '');
    else
      selectedTime = DateTime.now();
    if (widget.isBoatEdit) fetchEmployeeData();
    super.initState();
  }

  Future<void> fetchEmployeeData() async {
    if (widget.boat?.captains != null) {
      log(widget.boat!.captains.toString());

      selectedCaptains.addAll(widget.boat!.captains as Iterable<Instructor>);
      log(selectedCaptains.toString());
    }
    if (widget.boat?.dsdInstructors != null) {
      log(widget.boat!.dsdInstructors.toString());

      selectedDsdInstructors
          .addAll(widget.boat!.dsdInstructors as Iterable<Instructor>);
      log(selectedDsdInstructors.toString());
    }
    if (mounted) setState(() {});
  }

  Future<void> selectTime(BuildContext context) async {
    final DateTime? pickedTime = await TimePicker.show(
      context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 40,
          left: 25,
          right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  (widget.isBoatEdit) ? "Edit Boat" : "Add Boat",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ).paddingOnly(top: 8),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            (selectedCaptains.isEmpty)
                ? AppButton.miniFlat(
                    text: "Add Captains",
                    onTap: () async {
                      selectedCaptains = (await EmpSelectorBottomSheet.show(
                              context,
                              initialSelectedEmployees: selectedCaptains,
                              instructorLimit: 2)) ??
                          [];
                      setState(() {});
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Captains :",
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
                              ...selectedCaptains.map(
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
                              selectedCaptains =
                                  (await EmpSelectorBottomSheet.show(
                                          context,
                                          initialSelectedEmployees:
                                              selectedCaptains,
                                          instructorLimit: 2)) ??
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
                  ),
            (selectedDsdInstructors.isEmpty)
                ? AppButton.miniFlat(
                    text: "Add Instructors",
                    onTap: () async {
                      selectedDsdInstructors =
                          (await EmpSelectorBottomSheet.show(
                                context,
                                initialSelectedEmployees:
                                    selectedDsdInstructors,
                                instructorLimit: -1,
                              )) ??
                              [];
                      setState(() {});
                    },
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Instructors :",
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
                              ...selectedDsdInstructors.map(
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
                              selectedDsdInstructors =
                                  (await EmpSelectorBottomSheet.show(context,
                                          initialSelectedEmployees:
                                              selectedDsdInstructors,
                                          instructorLimit: -1)) ??
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
                  ),
            AppTextField(
              hintText: "Boat name",
              controller: boatTED,
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: "Dive Site",
              controller: diveSiteTED,
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Boat time",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    log(selectedTime.toString());
                    selectTime(context);
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        TimePicker.getFormattedTime(selectedTime) ??
                            'No time selected',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
            AppTextField(
              hintText: "Surface Support",
              controller: surfaceSupportTED,
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            AppTextField(
              hintText: "Notes",
              controller: notesTED,
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
            SizedBox(height: 20),
            TankCounter(
              onChanged: (int n, int a) {
                nitrox = n;
                air = a;
                setState(() {});
              },
              nitrox: nitrox,
              air: air,
            ),
            SizedBox(height: 50),
            Center(
              child: AppButton.flat(
                height: 50,
                width: 145,
                text: (widget.isBoatEdit) ? "Update" : "Submit",
                onTap: () async {
                  if (boatTED.text != "" && selectedCaptains != []) {
                    await addEditBoat(context);
                  } else {
                    if (boatTED.text == "") {
                      showToast("please enter the boat details");
                    } else {
                      showToast("please select the captain");
                    }
                  }
                },
                textColor: Colors.white,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> addEditBoat(BuildContext context) async {
    String boatId;
    var d = await FirebaseFirestore.instance
        .collection("dailyBoats")
        .doc(DateFormat("dd-MM-yyyy").format(widget.selectedDate))
        .get();
    Map<String, dynamic>? data = d.data();
    log(data.toString());
    BoatsModel? boatsModel = BoatsModel.fromJson(data);

    if (!widget.isBoatEdit) {
      if (data != null) {
        boatId = boatsModel.boats!.length.toString();
      } else {
        boatId = "0";
      }
      Boat boat = Boat(
        captains: selectedCaptains,
        id: boatId,
        name: boatTED.text,
        surfaceSupport: surfaceSupportTED.text,
        notes: notesTED.text,
        nitrox: nitrox,
        air: air,
        time: TimePicker.getFormattedTime(selectedTime)!,
        diveSite: diveSiteTED.text,
        dsdInstructors: selectedDsdInstructors,
      );
      boatsModel.boats?.add(boat);
    } else {
      boatId = widget.boat!.id;
      Boat boat = Boat(
        captains: selectedCaptains,
        id: boatId,
        name: boatTED.text,
        surfaceSupport: surfaceSupportTED.text,
        notes: notesTED.text,
        nitrox: nitrox,
        air: air,
        time: TimePicker.getFormattedTime(selectedTime)!,
        diveSite: diveSiteTED.text,
        dsdInstructors: selectedDsdInstructors,
      );

      boatsModel.boats?.removeWhere((b) => b.id == boatId);
      boatsModel.boats?.add(boat);
    }
    Navigator.pop(context, boatsModel);
  }
}
