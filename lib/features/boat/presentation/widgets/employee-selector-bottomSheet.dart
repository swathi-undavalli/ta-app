import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/features/boat/models/boat-details.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class EmpSelectorBottomSheet extends StatefulWidget {
  final List<Instructor> initialSelectedInstructors;
  final bool isCaptainSelector;

  const EmpSelectorBottomSheet({
    Key? key,
    required this.initialSelectedInstructors,
    required this.isCaptainSelector,
  }) : super(key: key);

  static Future<List<Instructor>?> show(
    BuildContext context, {
    required List<Instructor> initialSelectedEmployees,
    required bool captainSelector,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return EmpSelectorBottomSheet(
          initialSelectedInstructors: initialSelectedEmployees,
          isCaptainSelector: captainSelector,
        );
      },
    );

    return data as List<Instructor>?;
  }

  @override
  State<EmpSelectorBottomSheet> createState() => _EmpSelectorBottomSheetState();
}

class _EmpSelectorBottomSheetState extends State<EmpSelectorBottomSheet> {
  final CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');
  List<Instructor> selectedInstructors = [];

  @override
  void initState() {
    selectedInstructors = widget.initialSelectedInstructors;
    super.initState();
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
        children: [
          SizedBox(
            height: 10,
          ),
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
              SizedBox(
                width: 30,
              ),
            ],
          ),
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: employeesCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Text('No employees found.');
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    try {
                      Employee employee = Employee.fromMap(
                          document.data() as Map<String, dynamic>);

                      if (employee.role == 'Dive Team' ||
                          employee.role == 'Captain Team') {
                        Instructor instructor =
                            Instructor.fromEmployee(employee);

                        return InkWell(
                          onTap: () {
                            if (selectedInstructors.contains(instructor)) {
                              selectedInstructors.remove(instructor);
                            } else {
                              if ((!widget.isCaptainSelector ||
                                  selectedInstructors.length < 2)) {
                                selectedInstructors.add(instructor);
                              } else {
                                showToast("Only two captains can be selected");
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
                      } else {
                        return SizedBox();
                      }
                    } catch (e) {
                      return SizedBox();
                    }
                  }).toList(),
                ).paddingOnly(top: 20);
              },
            ),
          ),
        ],
      ),
    );
  }
}
