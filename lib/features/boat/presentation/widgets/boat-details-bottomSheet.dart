import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/time-picker.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/boat/models/boats.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/boat-selector.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/counter-widget.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/employee-selector-bottomSheet.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/interns-bottomSheet.dart';
import 'package:temple_adventures/features/bookings/presentation/widgets/app-text-fields.dart';
import 'package:intl/intl.dart';

import 'boat-status.dart';
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
  List<Instructor> selectedPhotographer = [];
  List<Instructor> surfaceSupport = [];
  List<Intern> selectedInternsPhotographers = [];
  List<Intern> selectedInternsSurfaceSupport = [];
  List<int> dsdInstructorAir = [];
  List<int> dsdInstructorNitrox = [];
  late TextEditingController boatTED;
  late TextEditingController diveSiteTED;
  late TextEditingController notesTED;
  int nitrox = 0;
  int air = 0;
  int photoAir = 0;
  int photoNitrox = 0;
  late DateTime selectedTime;
  int boatStatus = 0;

  @override
  void initState() {
    boatTED = TextEditingController(text: widget.boat?.name ?? "");
    notesTED = TextEditingController(text: widget.boat?.notes ?? "");
    diveSiteTED = TextEditingController(text: widget.boat?.diveSite);
    nitrox = widget.boat?.nitrox ?? 0;
    air = widget.boat?.air ?? 0;
    photoAir = widget.boat?.photoAir ?? 0;
    photoNitrox = widget.boat?.photoNitrox ?? 0;
    boatStatus = widget.boat?.boatStatus ?? 0;
    if (widget.boat?.time != null)
      selectedTime =
          TimePicker.getDateTime(widget.boat?.time ?? '') ?? DateTime.now();
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

    if (widget.boat?.photographer != null) {
      log(widget.boat!.photographer.toString());

      selectedPhotographer
          .addAll(widget.boat!.photographer as Iterable<Instructor>);
      log(selectedPhotographer.toString());
    }
    if (widget.boat?.internPhotographer != null) {
      log(widget.boat!.internPhotographer.toString());

      selectedInternsPhotographers
          .addAll(widget.boat!.internPhotographer as Iterable<Intern>);
      log(selectedPhotographer.toString());
    }

    if (widget.boat?.internSurfaceSupport != null) {
      log(widget.boat!.internSurfaceSupport.toString());

      selectedInternsSurfaceSupport
          .addAll(widget.boat!.internSurfaceSupport as Iterable<Intern>);
      log(selectedInternsSurfaceSupport.toString());
    }

    if (widget.boat?.surfaceSupport != null) {
      log(widget.boat!.surfaceSupport.toString());

      surfaceSupport
          .addAll(widget.boat!.surfaceSupport as Iterable<Instructor>);
      log(surfaceSupport.toString());
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
                    if (boatTED.text != "" && selectedCaptains.isNotEmpty) {
                      await addEditBoat(context);
                    } else {
                      if (boatTED.text == "") {
                        showToast("please enter the boat details");
                      } else {
                        showToast("please select the captain");
                      }
                    }
                    // Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            BoatStatus(
              initialStatus: boatStatus,
              onChanged: (int status) {
                boatStatus = status;
              },
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            buildEmployeeSelector(
                employees: selectedCaptains,
                title: "Captains",
                employeeLimit: 2,
                isTanksRequired: false),
            SizedBox(height: 20),
            buildEmployeeSelector(
                employees: selectedDsdInstructors,
                title: "DSD Instructors",
                employeeLimit: -1,
                isTanksRequired: true),
            SizedBox(height: 20),
            buildEmployeeSelector(
                employees: selectedPhotographer,
                title: "Photographer / Videographer",
                employeeLimit: 2,
                isTanksRequired: false),
            SizedBox(height: 20),
            buildVideoPhotoTankCount(),
            buildInternPhotographers(
                interns: selectedInternsPhotographers,
                title: 'Intern Photographer / Videographer (A - N)',
                isSurfaceSupport: false),
            SizedBox(height: 20),
            buildInternPhotographers(
                interns: selectedInternsSurfaceSupport,
                title: 'Surface Support',
                isSurfaceSupport: true),
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
            Text(
              "Extra / Spare Tanks : ",
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.text.black,
                  fontFamily: AppFonts.nunito,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            buildSpareTankCount(),
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

  Widget buildInternPhotographers(
      {required List<Intern> interns,
      required String title,
      required bool isSurfaceSupport}) {
    if (interns.isEmpty) {
      return AppButton.miniFlat(
        text: "Add $title",
        onTap: () async {
          interns = await InternsBottomSheet.show(context,
              initialInterns: interns,
              surfaceSupport: isSurfaceSupport) as List<Intern>;
          setState(() {});
        },
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
                ...interns.map(
                  (e) => Row(
                    children: [
                      Text(
                        "${e.name} ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        (!isSurfaceSupport) ? "( ${e.air} - ${e.nitrox} )" : "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ).paddingOnly(bottom: 4),
                ),
              ],
            ),
            GestureDetector(
              onTap: () async {
                interns = await InternsBottomSheet.show(context,
                    initialInterns: interns,
                    surfaceSupport: isSurfaceSupport) as List<Intern>;
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

  Widget buildSpareTankCount() {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                "Nitrox",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 15),
              Container(
                child: CounterWidget(
                  onChanged: (int val) {
                    nitrox = val;
                    setState(() {});
                  },
                  initialValue: nitrox,
                ),
              )
            ],
          ),
          SizedBox(width: 20),
          Column(
            children: [
              Text(
                "Air",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 15),
              CounterWidget(
                onChanged: (int val) {
                  air = val;
                  setState(() {});
                },
                initialValue: air,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildVideoPhotoTankCount() {
    if (selectedPhotographer.isNotEmpty)
      return Container(
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  "Nitrox",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ).paddingOnly(bottom: 15),
                Container(
                  child: CounterWidget(
                    onChanged: (int val) {
                      photoNitrox = val;
                      setState(() {});
                    },
                    initialValue: photoNitrox,
                  ),
                )
              ],
            ),
            SizedBox(width: 20),
            Column(
              children: [
                Text(
                  "Air",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ).paddingOnly(bottom: 15),
                CounterWidget(
                  onChanged: (int val) {
                    photoAir = val;
                    setState(() {});
                  },
                  initialValue: photoAir,
                )
              ],
            ),
          ],
        ),
      ).paddingOnly(bottom: 20);
    return SizedBox();
  }

  Widget buildEmployeeSelector(
      {required List<Instructor> employees,
      required String title,
      required int employeeLimit,
      required bool isTanksRequired}) {
    if (employees.isEmpty) {
      return AppButton.miniFlat(
        text: "Add $title",
        onTap: () async {
          employees = (await EmpSelectorBottomSheet.show(context,
                  initialSelectedEmployees: employees,
                  instructorLimit: employeeLimit)) ??
              [];

          setState(() {});
        },
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title (A - N)",
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
                  (e) => Row(
                    children: [
                      Text(
                        "${e.name}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      if (isTanksRequired)
                        Text(
                          " (${dsdInstructorAir[employees.indexOf(e)]} - ${dsdInstructorNitrox[employees.indexOf(e)]})",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ).paddingOnly(bottom: 4),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        employees = (await EmpSelectorBottomSheet.show(context,
                                initialSelectedEmployees: employees,
                                instructorLimit: employeeLimit)) ??
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
                SizedBox(height: 5),
                if (isTanksRequired)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          dsdInstructorAir =
                              List.generate(employees.length, (index) => 0);
                          dsdInstructorNitrox =
                              List.generate(employees.length, (index) => 0);
                          Map<Instructor, List<int>>? dsdInstructorTanks =
                              await InstructorTanksBottomSheet.show(
                            context,
                            initialSelectedEmployees: employees,
                            air: dsdInstructorAir,
                            nitrox: dsdInstructorNitrox,
                          );

                          // log(dsdInstructorTanks.toString());
                          // log(dsdInstructorTanks![employees[0]].toString() ??
                          //     "");

                          if (dsdInstructorTanks != null)
                            dsdInstructorNitrox = [];
                          dsdInstructorAir = [];
                          for (Instructor instructor in employees) {
                            dsdInstructorNitrox
                                .add(dsdInstructorTanks![instructor]![0]);
                            dsdInstructorAir
                                .add(dsdInstructorTanks[instructor]![1]);
                          }

                          log(dsdInstructorNitrox.toString());
                          log(dsdInstructorAir.toString());

                          setState(() {});
                        },
                        child: Text(
                          "Add Tanks",
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
          ],
        ),
      ],
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
        surfaceSupport: surfaceSupport,
        notes: notesTED.text,
        nitrox: nitrox,
        air: air,
        time: TimePicker.getFormattedTime(selectedTime)!,
        diveSite: diveSiteTED.text,
        dsdInstructors: selectedDsdInstructors,
        photographer: selectedPhotographer,
        photoAir: photoAir,
        photoNitrox: photoNitrox,
        boatStatus: boatStatus,
        internPhotographer: selectedInternsPhotographers,
        internSurfaceSupport: selectedInternsSurfaceSupport,
      );
      boatsModel.boats?.add(boat);
    } else {
      boatId = widget.boat!.id;
      Boat boat = Boat(
        captains: selectedCaptains,
        id: boatId,
        name: boatTED.text,
        surfaceSupport: surfaceSupport,
        notes: notesTED.text,
        nitrox: nitrox,
        air: air,
        time: TimePicker.getFormattedTime(selectedTime)!,
        diveSite: diveSiteTED.text,
        dsdInstructors: selectedDsdInstructors,
        photographer: selectedPhotographer,
        photoAir: photoAir,
        photoNitrox: photoNitrox,
        boatStatus: boatStatus,
        internPhotographer: selectedInternsPhotographers,
        internSurfaceSupport: selectedInternsSurfaceSupport,
      );

      boatsModel.boats?.removeWhere((b) => b.id == boatId);
      boatsModel.boats?.add(boat);
    }
    Navigator.pop(context, boatsModel);
  }
}

class InstructorTanksBottomSheet extends StatefulWidget {
  final List<Instructor> instructors;
  final List<int> air;
  final List<int> nitrox;

  const InstructorTanksBottomSheet({
    Key? key,
    required this.instructors,
    required this.air,
    required this.nitrox,
  }) : super(key: key);

  static Future<Map<Instructor, List<int>>?> show(
    BuildContext context, {
    required List<Instructor> initialSelectedEmployees,
    required List<int> air,
    required List<int> nitrox,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return InstructorTanksBottomSheet(
          instructors: initialSelectedEmployees,
          air: air,
          nitrox: nitrox,
        );
      },
    );

    return data as Map<Instructor, List<int>>?;
  }

  @override
  State<InstructorTanksBottomSheet> createState() =>
      _InstructorTanksBottomSheetState();
}

class _InstructorTanksBottomSheetState
    extends State<InstructorTanksBottomSheet> {
  late Map<Instructor, List<int>> instructorTanks;

  @override
  void initState() {
    super.initState();
    instructorTanks = {};
    for (int i = 0; i < widget.nitrox.length; i++) {
      instructorTanks[widget.instructors[i]] = [
        widget.nitrox[i],
        widget.air[i]
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Manage Divers",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ).paddingOnly(top: 8),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  Navigator.pop(context, instructorTanks);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          ...widget.instructors.map(
            (instructor) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${instructor.name} : ",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 15),
                TankCounter(
                    onChanged: (n, a) {
                      instructorTanks[instructor]![0] = n;
                      instructorTanks[instructor]![1] = a;
                    },
                    nitrox: instructorTanks[instructor]![0],
                    air: instructorTanks[instructor]![1])
              ],
            ).paddingOnly(bottom: 30),
          )
        ],
      ).paddingSymmetric(horizontal: 25),
    );
  }
}
