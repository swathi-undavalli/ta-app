// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:temple_adventures/access_levels.dart';
// import 'package:temple_adventures/core/constants/constants.dart';
// import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
// import 'package:temple_adventures/features/Freelancers/controller/all-freelancers-controller.dart';
// import 'package:temple_adventures/features/Freelancers/presentation/screens/add-freelance-screen.dart';
// import 'package:temple_adventures/features/counter-model.dart';
// import 'package:temple_adventures/features/home/model/employee.dart';
//
// class AllFreelancersScreen extends StatelessWidget {
//   static const String id = "AllFreelancersScreen";
//   AllFreelanceLogic logic = AllFreelanceLogic();
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (logic.controller.showSuggestions) {
//           logic.controller.showSuggestions = false;
//           return false;
//         }
//         logic.controller.searchTED.text = "";
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           toolbarHeight: 70,
//           centerTitle: true,
//           title: buildTitle(),
//           leading: BackNavigationIcon(),
//           elevation: 0,
//           backgroundColor: AppColors.background.white,
//         ),
//         floatingActionButton: buildFloatingActionButton(),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//         body: RefreshIndicator(
//           color: AppColors.IconColor.black,
//           onRefresh: () async {
//             logic.controller.update();
//           },
//           child: SafeArea(
//             child: Column(
//               children: [
//                 SizedBox(height: 10),
//                 buildSearchBar(),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       logic.controller.showSuggestions = false;
//                     },
//                     child: SingleChildScrollView(
//                       physics: BouncingScrollPhysics(),
//                       child: Padding(
//                         padding: const EdgeInsets.only(
//                             top: 0, bottom: 20, left: 25, right: 20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // buildRoles(),
//                             // SizedBox(height: 10).
//                             SizedBox(height: 10),
//                             ...List.generate(counterModel.freelance, (index) {
//                               return buildAllEmployees(index.toString());
//                             }),
//                             SizedBox(height: 10),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildFloatingActionButton() {
//     return EmployeeAccess(
//       access: AccessRights.createEmployees,
//       child: FloatingActionButton(
//         onPressed: () {
//           Get.toNamed(AddFreelanceScreen.id);
//         },
//         backgroundColor: AppColors.background.black,
//         child: Icon(Icons.add),
//         elevation: 0,
//       ),
//     );
//   }
//
//   Widget buildTitle() {
//     return Text(
//       'All Freelancers',
//       style: TextStyle(
//         color: AppColors.text.black,
//         fontSize: 20,
//         fontFamily: AppFonts.nunito,
//         fontWeight: FontWeight.normal,
//         letterSpacing: 1.2,
//       ),
//     );
//   }
//
//   Widget buildSearchBar() {
//     return Container(
//       height: 50,
//       child: TextField(
//         cursorColor: AppColors.text.darkgrey,
//         cursorHeight: 20,
//         decoration: InputDecoration(
//             prefixIcon: Icon(Icons.search_rounded,
//                 size: 18, color: Colors.black87.withOpacity(0.6)),
//             border: OutlineInputBorder(),
//             focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.black.withOpacity(0.3))),
//             hintText: 'Search...',
//             hintStyle: TextStyle(fontSize: 14, height: 1)),
//         controller: logic.controller.searchTED,
//         onChanged: (text) {
//           logic.controller.update();
//         },
//       ),
//     );
//   }
//
//   Widget buildAllEmployees(String employeeID) {
//     return GetBuilder<AllFreelanceController>(builder: (controller) {
//       return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//           stream: FirebaseFirestore.instance
//               .collection("freelance")
//               .doc(employeeID)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData && employeeID != null) {
//               Employee employee = Employee.fromMap(snapshot.data.data());
//               if (controller.searchTED.text.isNotEmpty) {
//                 if (employee.id.contains(controller.searchTED.text) ||
//                     employee.name.toLowerCase().contains(
//                         controller.searchTED.text.toLowerCase().trim()))
//                   return buildEmployeeNames(e: employee);
//                 return SizedBox();
//               }
//               return buildEmployeeNames(e: employee);
//             }
//             return Container();
//           });
//     });
//   }
//
//   Widget buildEmployeeNames({Employee e}) {
//     return Container(
//       child: Material(
//         child: InkWell(
//           onTap: () {
//             // onEmployeeTapped(Employees(
//             //   name: e.name,
//             //   phone: e.phoneNumber,
//             //   id: e.id,
//             //   gender: e.gender,
//             // ));
//             // logic.controller.update();
//           },
//           child: Container(
//             height: 47,
//             width: Get.width,
//             child: Row(
//               children: [
//                 Icon(Icons.account_circle, color: Colors.black38, size: 25),
//                 Text(
//                   "   ${e.name}",
//                   style: TextStyle(color: AppColors.text.black, fontSize: 14),
//                 ),
//                 Expanded(
//                     child: Container(
//                   color: Colors.transparent,
//                 )),
//               ],
//             ),
//           ),
//         ),
//         color: Colors.transparent,
//       ),
//     );
//   }
// }

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
  AllFreelanceLogic logic = AllFreelanceLogic();

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
              children: snapshot.data.docs.map((document) {
                Employee employee = Employee.fromMap(document.data());

                if (controller.searchTED.text.isNotEmpty) {
                  if (employee.id.contains(controller.searchTED.text) ||
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

  Widget buildFreelance({Employee f}) {
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
