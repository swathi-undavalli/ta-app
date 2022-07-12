// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/counter-model.dart';
import '../../../home/model/employee.dart' as emp;

import '../../models/boat-passengers-model.dart';

class EmployeeSelectorBottomSheet extends StatelessWidget {
  final BottomSheetLogic logic = BottomSheetLogic();
  final TextEditingController searchTED = TextEditingController();

  EmployeeSelectorBottomSheet({
  @required this.onEmployeeTapped,
  @required this.onEmployeeDeleted,
    @required this.selectedEmployees,
    @required this.commonEmployees,
  });

  final List<Employees> selectedEmployees;
  final List<Employees> commonEmployees;

  final Function(Employees) onEmployeeTapped;
  final Function(Employees) onEmployeeDeleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 450,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Employees", style: TextStyle(fontSize: 17)),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.clear_rounded,
                        size: 21,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 25),
            buildSearchBar(),
            SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                child: ListView(
                  children: [
                    ...List.generate(counterModel.employee, (index) {
                      return buildAllEmployees((index + 1).toString());
                    }),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 50,
      child: TextField(
        cursorColor: AppColors.text.darkgrey,
        cursorHeight: 20,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search_rounded,
                size: 18, color: Colors.black87.withOpacity(0.6)),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withOpacity(0.3))),
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14, height: 1)),
        controller: searchTED,
        onChanged: (text) {
          logic.controller.update();
        },
      ),
    );
  }

  Widget buildAllEmployees(String employeeID) {
    return GetBuilder<BottomSheetController>(builder: (controller) {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("employees")
              .doc(employeeID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              emp.Employee employee =
                  emp.Employee.fromMap(snapshot.data.data());
              if (searchTED.text.isNotEmpty) {
                if (employee.id.contains(searchTED.text) ||
                    employee.name
                        .toLowerCase()
                        .contains(searchTED.text.toLowerCase().trim()))
                  return buildEmployeeNames(e: employee);
                return SizedBox();
              }
              return buildEmployeeNames(e: employee);
            }
            return Container();
          });
    });
  }

  Widget buildEmployeeNames({emp.Employee e}) {
    return Container(
      child: Material(
        child: InkWell(
          onTap: () {
            onEmployeeTapped(Employees(
              name: e.name,
              phone: e.phoneNumber,
              id: e.id,
              gender: e.gender,
            ));
            logic.controller.update();
          },
          child: Container(
            height: 47,
            width: Get.width,
            child: GetBuilder<BottomSheetController>(builder: (controller) {
              return Row(
                children: [
                  Icon(Icons.account_circle, color: Colors.black38, size: 25),
                  Text(
                    "   ${e.name}",
                    style: TextStyle(color: AppColors.text.black, fontSize: 14),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.transparent,
                  )),
                  if (selectedEmployees
                      .map((e) => e.name)
                      .toList()
                      .contains(e.name))
                    Icon(Icons.check, color: Colors.green, size: 25),
                  // if (!selectedEmployees
                  //         .map((e) => e.name)
                  //         .toList()
                  //         .contains(e.name) &&
                  if (commonEmployees
                      .map((e) => e.name)
                      .toList()
                      .contains(e.name))
                    Icon(Icons.check, color: Colors.orange, size: 25),
                ],
              );
            }),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}

class BottomSheetLogic {
  BottomSheetController controller = Get.put(BottomSheetController());
}

class BottomSheetController extends GetxController {
  TextEditingController searchTED = TextEditingController();
}
