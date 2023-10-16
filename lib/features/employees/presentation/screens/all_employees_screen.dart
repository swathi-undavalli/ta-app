import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/back_navigation_icon.dart';
import '../../controllers/all_employees_controller.dart';
import '../../model/employee.dart';
import 'add_an_employee_screen.dart';
import 'employee_details_screen.dart';

class AllEmployeesScreen extends StatefulWidget {
  static const String id = 'AllEmployeesScreen';

  const AllEmployeesScreen({Key? key}) : super(key: key);

  @override
  State<AllEmployeesScreen> createState() => _AllEmployeesScreenState();
}

class _AllEmployeesScreenState extends State<AllEmployeesScreen> {
  final AllEmployeesLogic logic = AllEmployeesLogic();
  final Query<Map<String, dynamic>> employeesCollection =
      FirebaseFirestore.instance.collection('employees').orderBy('firstName');
  late Stream<QuerySnapshot> _stream; // Declare the stream

  @override
  void initState() {
    super.initState();
    logic.controller.searchTED.text = '';
    _stream = employeesCollection.snapshots(); // Initialize the stream
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (logic.controller.searchTED.text != '') {
          logic.controller.searchTED.text = '';
          _stream = employeesCollection.snapshots();
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: buildTitle(),
          leading: const BackNavigationIcon(),
          elevation: 0,
          backgroundColor: AppColors.background.white,
        ),
        body: RefreshIndicator(
          color: AppColors.IconColor.black,
          onRefresh: () async {
            logic.controller.update();
          },
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    buildSearchBar(),
                    buildAllEmployees(),
                  ],
                ),
                // buildSuggestions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAllEmployees() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Text('No employees found.').paddingOnly(top: 100);
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              try {
                Employee employee =
                    Employee.fromMap(document.data() as Map<String, dynamic>);

                return Column(
                  children: [
                    buildEmployeeNames(employee),
                  ],
                ).paddingSymmetric(horizontal: 20);
              } catch (e) {
                return const SizedBox();
              }
            }).toList(),
          ).paddingOnly(top: 20);
        },
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

  Widget buildFloatingActionButton() {
    return EmployeeAccess(
      access: AccessRights.createEmployees,
      child: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AddAnEmployeeScreen.id);
        },
        backgroundColor: AppColors.background.black,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildEmployeeNames(Employee e) {
    return GestureDetector(
      onTap: () {
        logic.controller.searchTED.text = '';
        Get.toNamed(EmployeeDetailsScreen.id, arguments: e);
      },
      child: SizedBox(
        height: 47,
        width: Get.width,
        child: Row(
          children: [
            const Icon(
              Icons.account_circle,
              color: Colors.black38,
              size: 25,
            ),
            const SizedBox(width: 20),
            Text(
              '   ${e.name}',
              style: TextStyle(color: AppColors.text.black, fontSize: 14),
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // buildOptions()
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      width: 328,
      height: 47,
      decoration: BoxDecoration(
        color: AppColors.background.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.text.darkgrey),
            Spacing.w15,
            SizedBox(
              width: 225,
              child: TextField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Search...',
                  hintStyle: TextStyle(fontSize: FontSize.textSize, height: 1),
                ),
                controller: logic.controller.searchTED,
                onChanged: (query) {
                  _stream = _filterStream(query);
                  setState(() {});
                },
              ),
            ),
            if (logic.controller.searchTED.text != '')
              InkWell(
                onTap: () {
                  logic.controller.searchTED.text = '';
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

  Widget buildTitle() {
    return Text(
      'All Employees',
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
