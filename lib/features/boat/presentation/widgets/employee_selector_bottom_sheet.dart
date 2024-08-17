import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import '../../../employees/model/employee.dart';
import '../../models/boat_details.dart';
import '../../models/boats.dart';
import 'counter_widget.dart';

class EmpSelectorBottomSheet extends StatefulWidget {
  final List<Instructor> initialSelectedInstructors;
  final int instructorLimit;
  final EmployeeType employeeType;
  final bool isTanksRequired;
  final DateTime? selectedDate;
  final bool showAssignmentStatus;

  const EmpSelectorBottomSheet({
    super.key,
    required this.initialSelectedInstructors,
    required this.instructorLimit,
    required this.employeeType,
    required this.isTanksRequired,
    required this.selectedDate,
    this.showAssignmentStatus = false,
  });

  static Future<List<Instructor>?> getSelectedInstructors(
    BuildContext context, {
    required List<Instructor> initialSelectedInstructors,
    required int instructorLimit,
    required EmployeeType employeeType,
    required DateTime? selectedDate,
    bool showAssignmentStatus = false,
    bool tanksRequired = false,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return EmpSelectorBottomSheet(
          initialSelectedInstructors: initialSelectedInstructors,
          instructorLimit: instructorLimit,
          employeeType: employeeType,
          isTanksRequired: tanksRequired,
          selectedDate: selectedDate,
          showAssignmentStatus: showAssignmentStatus,
        );
      },
    );

    return data as List<Instructor>?;
  }

  @override
  State<EmpSelectorBottomSheet> createState() => _EmpSelectorBottomSheetState();
}

class _EmpSelectorBottomSheetState extends State<EmpSelectorBottomSheet> {
  final Query<Map<String, dynamic>> employeesCollection =
      FirebaseFirestore.instance.collection('employees').orderBy('firstName');
  List<Instructor> selectedInstructors = [];
  late Stream<QuerySnapshot> _stream; // Declare the stream
  late TextEditingController searchTED;

  List<Instructor> dayOffs = [];
  List<Instructor> leaves = [];
  bool showLoading = false;

  @override
  void initState() {
    selectedInstructors = widget.initialSelectedInstructors;
    _stream = employeesCollection.snapshots(); // Initialize the stream
    searchTED = TextEditingController();
    getDSD(widget.selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      return SizedBox(
        height: Screen.height * 0.65,
        child: const CircularProgressIndicator().center,
      );
    }
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: AppColors.background.lightBlue,
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Column(
        children: [
          Spacing.h10,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30,
              ),
              const Text(
                'Manage Divers',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ).paddingOnly(top: 8),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  Navigator.pop(context, selectedInstructors);
                },
              ),
              Spacing.w30,
            ],
          ),
          Spacing.h10,
          buildSearchBar(),
          Expanded(
            child: Column(
              children: [
                if (selectedInstructors.isNotEmpty)
                  Wrap(
                    spacing: 5,
                    children: selectedInstructors
                        .map(
                          (instructor) => InkWell(
                        onTap: () {
                          if (!widget.isTanksRequired) selectedInstructors.remove(instructor);
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          child: (widget.isTanksRequired)
                              ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    instructor.name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  AppButton.miniFlat(
                                    onTap: () {
                                      selectedInstructors.remove(instructor);
                                      setState(() {});
                                    },
                                    text: 'Remove',
                                  ),
                                ],
                              ),
                              Spacing.h10,
                              if (selectedInstructors.contains(instructor)) buildTanks(instructor),
                            ],
                          ).paddingSymmetric(horizontal: 10, vertical: 10)
                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                instructor.name,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              Spacing.w5,
                              const Icon(
                                Icons.close,
                                size: 16,
                              ),
                            ],
                          ),
                        ).paddingOnly(bottom: 10),
                      ),
                    )
                        .toList(),
                  ).paddingSymmetric(horizontal: 20, vertical: 20).scrollable,
                Spacing.h5,
                buildEmployees(),
              ],
            ).scrollable,
          ),
        ],
      ),
    );
  }

  Widget buildTanks(Instructor instructor) {
    if (widget.isTanksRequired) {
      return Row(
        children: [
          Column(
            children: [
              const Text(
                'Nitrox',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 15),
              CounterWidget(
                key: UniqueKey(),
                onChanged: (int val) {
                  instructor.nitrox = val;
                },
                initialValue: instructor.nitrox ?? 0,
              ),
            ],
          ),
          Column(
            children: [
              const Text(
                'Air',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ).paddingOnly(bottom: 15),
              CounterWidget(
                key: UniqueKey(),
                onChanged: (int val) {
                  instructor.air = val;
                },
                initialValue: instructor.air ?? 0,
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget buildEmployees() {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Text('No employees found.').paddingOnly(top: 40);
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            try {
              Employee employee = Employee.fromMap(document.data() as Map<String, dynamic>);

              Instructor instructor = Instructor.fromEmployee(employee);

              var assignedEmployeeList = [];

              if (widget.showAssignmentStatus) {
                var controller = Get.find<BookingsCalenderWidgetControllerNew>();
                for (var booking in controller.bookings) {
                  for (Instructor ins in (booking.boatDetails?.instructors ?? [])) {
                    if (ins.id.isNotEmpty) assignedEmployeeList.add(ins.id);
                  }
                  for (Instructor ins in (booking.boatDetails?.diveBuddies ?? [])) {
                    if (ins.id.isNotEmpty) assignedEmployeeList.add(ins.id);
                  }
                }
                assignedEmployeeList = assignedEmployeeList.toSet().toList();
              }

              Widget employeeTile = InkWell(
                onTap: () {
                  if (widget.selectedDate != null) {
                    instructor.date = DateFormat('dd-MM-yyyy').format(widget.selectedDate!);
                  }
                  if (selectedInstructors.contains(instructor)) {
                    selectedInstructors.remove(instructor);
                  } else {
                    if (widget.instructorLimit == -1) {
                      selectedInstructors.add(instructor);
                    } else if (selectedInstructors.length < widget.instructorLimit) {
                      selectedInstructors.add(instructor);
                    } else {
                      showToast('Limit exceeded');
                    }
                  }
                  setState(() {});
                },
                child: Container(
                  decoration: (selectedInstructors.contains(employee))
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        )
                      : null,
                  child: Row(
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(fontSize: 16),
                      ).paddingOnly(left: 25, top: 10, bottom: 10),
                      const Spacer(),

                      if (widget.showAssignmentStatus) ...[
                        //Assigned
                        if (!assignedEmployeeList.contains(employee.id))
                          buildStatusTab(
                            'Assigned',
                            Colors.lightGreenAccent,
                          ).paddingOnly(right: 10),

                        //Leave
                        if (leaves.contains(employee))
                          buildStatusTab(
                            'On Leave',
                            Colors.red,
                            Colors.white,
                          ).paddingOnly(right: 10),

                        //Day off
                        if (dayOffs.contains(employee))
                          buildStatusTab(
                            'Day Off',
                            Colors.red,
                            Colors.white,
                          ).paddingOnly(right: 10),
                      ],

                      //Selected
                      if (selectedInstructors.contains(employee))
                        buildStatusTab(
                          'Selected',
                          Colors.black,
                          Colors.white,
                        ).paddingOnly(right: 10),
                    ],
                  ),
                ).paddingOnly(bottom: 10, left: 10, right: 10),
              );

              if (widget.employeeType == EmployeeType.showAllEmployees) {
                return employeeTile;
              } else if ((widget.employeeType == EmployeeType.showCaptains) && (employee.role == 'Captain Team')) {
                return employeeTile;
              } else if ((widget.employeeType == EmployeeType.showFreelancersDivers) &&
                  (employee.role == 'Dive Team' || employee.role == 'Freelance Team')) {
                return employeeTile;
              } else if ((widget.employeeType == EmployeeType.showAllDiveTeam) &&
                  (employee.role == 'Dive Team' || employee.role == 'Freelance Team' || employee.role == 'Intern')) {
                return employeeTile;
              } else if ((widget.employeeType == EmployeeType.showInterns) && (employee.role == 'Intern')) {
                return employeeTile;
              }
              return const SizedBox();
            } catch (e) {
              return const SizedBox();
            }
          }).toList(),
        );
      },
    );
  }

  Container buildStatusTab(String text, Color color, [Color? textColor]) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
      height: 20,
      width: 60,
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: textColor),
        textAlign: TextAlign.center,
      ).center,
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 47,
      width: Screen.width - 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.text.darkgrey),
            Spacing.w15,
            SizedBox(
              width: Screen.width - 150,
              child: TextField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: FontSize.textSize, height: 1),
                ),
                controller: searchTED,
                onChanged: (query) {
                  _stream = _filterStream(query);
                  setState(() {});
                },
              ),
            ),
            if (searchTED.text != '')
              InkWell(
                onTap: () {
                  searchTED.text = '';
                  setState(() {});
                },
                highlightColor: Colors.grey,
                splashColor: Colors.red,
                radius: 30,
                child: Icon(Icons.close, color: AppColors.text.darkgrey).paddingAll(5),
              ),
          ],
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _filterStream(String query) {
    if (query.isEmpty) {
      return employeesCollection.snapshots();
    }

    return employeesCollection.where('firstName', isGreaterThanOrEqualTo: query.capitalizeFirst).snapshots();
  }

  getDSD(DateTime? selectedDate) async {
    if (selectedDate == null) return;
    showLoading = true;
    var d = await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(selectedDate))
        .get();

    Map<String, dynamic>? data = d.data();
    BoatsModel? boatsModel = BoatsModel.fromMap(data);
    dayOffs = boatsModel.dsd?.dayOffs ?? [];
    dayOffs = boatsModel.dsd?.leaves ?? [];
    showLoading = false;
    setState(() {});
  }
}

enum EmployeeType {
  showAllEmployees,
  showInterns,
  showCaptains,
  showFreelancersDivers,
  showAllDiveTeam,
}
