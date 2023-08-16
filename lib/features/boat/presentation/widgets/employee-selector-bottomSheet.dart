import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/util/spacing-widget.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

import '../../../../core/constants/constants.dart';

class EmpSelectorBottomSheet extends StatefulWidget {
  final List<Instructor> initialSelectedInstructors;
  final int instructorLimit;
  final bool showAllEmployees;

  const EmpSelectorBottomSheet({
    Key? key,
    required this.initialSelectedInstructors,
    required this.instructorLimit,
    required this.showAllEmployees,
  }) : super(key: key);

  static Future<List<Instructor>?> show(
    BuildContext context, {
    required List<Instructor> initialSelectedEmployees,
    required int instructorLimit,
    bool showAll = false,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return EmpSelectorBottomSheet(
          initialSelectedInstructors: initialSelectedEmployees,
          instructorLimit: instructorLimit,
          showAllEmployees: showAll,
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

  @override
  void initState() {
    log(widget.showAllEmployees.toString());
    selectedInstructors = widget.initialSelectedInstructors;
    _stream = employeesCollection.snapshots(); // Initialize the stream
    searchTED = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.showAllEmployees.toString());

    return Container(
      height: 700,
      decoration: BoxDecoration(
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
              SizedBox(
                width: 30,
              ),
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
                  Navigator.pop(context, selectedInstructors);
                },
              ),
              Spacing.w30,
            ],
          ),
          Spacing.h10,
          buildSearchBar(),
          if (selectedInstructors.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: selectedInstructors
                  .map((e) => InkWell(
                        onTap: () {
                          selectedInstructors.remove(e);
                          setState(() {});
                        },
                        child: Container(
                          height: 30,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(e.name),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
              spacing: 10,
              runSpacing: 10,
            ).paddingOnly(left: 15, top: 20),
          buildEmployees(),
        ],
      ),
    );
  }

  Widget buildEmployees() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Text('No employees found.').paddingOnly(top: 40);
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              try {
                Employee employee =
                    Employee.fromMap(document.data() as Map<String, dynamic>);

                Instructor instructor = Instructor.fromEmployee(employee);

                Widget employeeTile = InkWell(
                  onTap: () {
                    if (selectedInstructors.contains(instructor)) {
                      selectedInstructors.remove(instructor);
                    } else {
                      if (widget.instructorLimit == -1) {
                        selectedInstructors.add(instructor);
                      } else if (selectedInstructors.length <
                          widget.instructorLimit) {
                        selectedInstructors.add(instructor);
                      } else {
                        showToast("Limit exceeded");
                      }
                    }
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                          employee.name,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ).paddingOnly(
                          left: 30,
                          top: 10,
                          bottom: 10,
                        ),
                      ),
                      Spacer(),
                      if (selectedInstructors.contains(employee))
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                );

                if (widget.showAllEmployees) {
                  return employeeTile;
                } else if (employee.role == 'Dive Team' ||
                    employee.role == 'Captain Team' ||
                    employee.role == 'Freelance Team') {
                  return employeeTile;
                }
                return SizedBox();
              } catch (e) {
                return SizedBox();
              }
            }).toList(),
          ).paddingOnly(top: 20);
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      width: 328,
      height: 47,
      decoration: BoxDecoration(
          color: AppColors.background.white,
          borderRadius: BorderRadius.circular(5)),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.text.darkgrey),
            Spacing.w15,
            Container(
              width: 225,
              child: TextField(
                decoration: InputDecoration(
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    disabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Search...',
                    hintStyle:
                        TextStyle(fontSize: FontSize.textSize, height: 1)),
                controller: searchTED,
                onChanged: (query) {
                  _stream = _filterStream(query);
                  setState(() {});
                },
              ),
            ),
            if (searchTED.text != "")
              InkWell(
                onTap: () {
                  searchTED.text = "";
                  setState(() {});
                },
                highlightColor: Colors.grey,
                splashColor: Colors.red,
                radius: 30,
                child: Icon(Icons.close, color: AppColors.text.darkgrey)
                    .paddingAll(5),
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

    return employeesCollection
        .where('firstName', isGreaterThanOrEqualTo: query.capitalizeFirst)
        .snapshots();
  }
}
