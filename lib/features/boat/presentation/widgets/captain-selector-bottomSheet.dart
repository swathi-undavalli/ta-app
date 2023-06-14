import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class CaptainSelectorBottomSheet extends StatefulWidget {
  final Employee? initialCaptain;

  const CaptainSelectorBottomSheet({
    Key? key,
    required this.initialCaptain,
  }) : super(key: key);

  static Future<Employee?> show(BuildContext context,
      {required Employee? initialSelectedCaptain}) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CaptainSelectorBottomSheet(
          initialCaptain: initialSelectedCaptain,
        );
      },
    );

    return data as Employee?;
  }

  @override
  State<CaptainSelectorBottomSheet> createState() =>
      _CaptainSelectorBottomSheetState();
}

class _CaptainSelectorBottomSheetState
    extends State<CaptainSelectorBottomSheet> {
  final CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');
  Employee? selectedCaptain;

  @override
  void initState() {
    selectedCaptain = widget.initialCaptain;
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
                "Add Captain",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ).paddingOnly(top: 8),
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  Navigator.pop(context, selectedCaptain);
                },
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          if (selectedCaptain != null)
            InkWell(
              onTap: () {
                selectedCaptain = null;
                setState(() {});
              },
              child: Container(
                height: 30,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    Text(selectedCaptain?.name ?? ""),
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
            ),
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

                      return InkWell(
                        onTap: () {
                          selectedCaptain = employee;
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
                            // Icon(
                            //   Icons.check_circle,
                            //   color: Colors.green,
                            // ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      );
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
