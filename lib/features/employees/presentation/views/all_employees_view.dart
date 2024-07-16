import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../model/employee.dart';
import 'add_employee_view.dart';
import 'employee_details_view.dart';

class AllEmployeesView extends StatefulWidget {
  const AllEmployeesView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => const AllEmployeesView(),
      );

  @override
  State<AllEmployeesView> createState() => _AllEmployeesViewState();
}

class _AllEmployeesViewState extends State<AllEmployeesView> {
  final Query<Map<String, dynamic>> employeesCollection =
      FirebaseFirestore.instance.collection('employees').orderBy('firstName');
  late Stream<QuerySnapshot> _stream; // Declare the stream
  late TextEditingController searchTED;
  @override
  void initState() {
    super.initState();
    searchTED = TextEditingController();
    _stream = employeesCollection.snapshots(); // Initialize the stream
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (searchTED.text != '') {
          searchTED.text = '';
          _stream = employeesCollection.snapshots();
          setState(() {});
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background.lightBlue,
        floatingActionButton: buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: const AppBarWidget(heading: 'All Employees'),
        body: RefreshIndicator(
          color: AppColors.iconColor.black,
          onRefresh: () async {
            setState(() {});
          },
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Spacing.h10,
                    buildSearchBar(),
                    buildAllEmployees(),
                  ],
                ).paddingSymmetric(horizontal: 20),
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
                Employee employee = Employee.fromMap(document.data() as Map<String, dynamic>);
                return buildEmployeeNames(employee);
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
    return employeesCollection.where('firstName', isGreaterThanOrEqualTo: query.capitalizeFirst).snapshots();
  }

  Widget buildFloatingActionButton() {
    return EmployeeAccess(
      access: AccessRights.createEmployees,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, AddEmployeeView.route(null));
        },
        backgroundColor: AppColors.background.black,
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildEmployeeNames(Employee e) {
    return GestureDetector(
      onTap: () {
        searchTED.text = '';
        Navigator.push(context, EmployeeDetailsView.route(e));
      },
      child: SizedBox(
        height: 47,
        width: Screen.width,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.background.lightSkyBlue,
                shape: BoxShape.circle,
              ),
              child: Text(
                e.id,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Spacing.w30,
            Text(
              e.name,
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
      width: Screen.width,
      height: 47,
      decoration: BoxDecoration(
        color: AppColors.background.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.text.darkgrey),
          Spacing.w15,
          Expanded(
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
                _stream = _filterStream('');
                setState(() {});
              },
              highlightColor: Colors.grey,
              splashColor: Colors.red,
              radius: 30,
              child: Icon(Icons.close, color: AppColors.text.darkgrey).paddingAll(5),
            ),
        ],
      ).paddingSymmetric(horizontal: 15),
    );
  }
}
