import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/Freelancers/controller/all-freelancers-controller.dart';
import 'package:temple_adventures/features/Freelancers/presentation/screens/add-freelance-screen.dart';
import 'package:temple_adventures/features/Freelancers/presentation/screens/freelance-details-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AllFreelancersScreen extends StatelessWidget {
  static const String id = "AllFreelancersScreen";
  final AllFreelanceLogic logic = AllFreelanceLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        title: buildTitle(),
        leading: BackNavigationIcon(),
        elevation: 0,
        backgroundColor: AppColors.background.white,
      ),
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                buildSearchBar(),
                SizedBox(height: 10),
                checkFireBase(),
              ],
            ),
          ),
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
          borderRadius: BorderRadius.circular(5)),
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.text.darkgrey),
            SizedBox(width: 15),
            Container(
              width: 240,
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
                controller: logic.controller.searchTED,
                onChanged: (text) {
                  logic.controller.update();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkFireBase() {
    return GetBuilder<AllFreelanceController>(builder: (controller) {
      return StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('freelance').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }
            return Column(
              children: snapshot.data!.docs.map((document) {
                Employee employee = Employee.fromMap(document.data() as Map<String, dynamic>);

                if (controller.searchTED.text.isNotEmpty) {
                  if (employee.id!.contains(controller.searchTED.text) ||
                      employee.name.toLowerCase().contains(
                          controller.searchTED.text.toLowerCase().trim()))
                    return buildFreelance(f: employee);
                  return SizedBox();
                }
                return buildFreelance(
                  f: employee,
                );
              }).toList(),
            );
          });
    });
  }

  Widget buildFreelance({required Employee f}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(FreelanceDetailsScreen.id, arguments: f);
      },
      child: Container(
        height: 47,
        width: Get.width,
        child: Row(
          children: [
            Icon(
              Icons.account_circle,
              color: Colors.black38,
              size: 25,
            ),
            SizedBox(width: 20),
            Text(
              "   ${f.name}",
              style: TextStyle(color: AppColors.text.black, fontSize: 14),
            ),
            Expanded(
                child: Container(
              color: Colors.transparent,
            )),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      'Freelance',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return EmployeeAccess(
      access: AccessRights.createEmployees,
      child: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AddFreelanceScreen.id);
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }
}
