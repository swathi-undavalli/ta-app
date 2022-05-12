import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/access_levels.dart';
import 'package:temple_adventures/features/counter-model.dart';
import 'package:temple_adventures/features/employees/controllers/all-employees-controller.dart';
import 'package:temple_adventures/features/employees/presentation/screens/employee-details-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'add-an-employee-screen.dart';

class AllEmployeesScreen extends StatelessWidget {
  static const String id = "AllEmployeesScreen";
  final ScrollController scrollController = ScrollController();

  final AllEmployeesLogic logic = AllEmployeesLogic();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (logic.controller.showSuggestions) {
          logic.controller.showSuggestions = false;
          return false;
        }
        logic.controller.searchTED.text = "";
        return true;
      },
      child: Scaffold(
        floatingActionButton: buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          title: buildTitle(),
          leading: BackNavigationIcon(),
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
                    SizedBox(height: 10),
                    buildSearchBar(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          logic.controller.showSuggestions = false;
                        },
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, bottom: 20, left: 25, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // buildRoles(),
                                // SizedBox(height: 10).
                                SizedBox(height: 10),
                                buildAllEmployees(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                buildSuggestions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///===============UI=============///

  Widget buildSuggestions() {
    return GetBuilder<AllEmployeesController>(builder: (controller) {
      if (controller.showSuggestions)
        return Positioned(
          child: Container(
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: 300,
              minWidth: 328,
              maxWidth: 328,
            ),
            margin: EdgeInsets.only(
              top: 65,
              left: (Get.width - 328) / 2,
              // right: 100,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ]),
            padding: const EdgeInsets.only(top: 10),
            child: controller.suggestionsList.isEmpty
                ? Container(
                    height: 100,
                    child: Center(
                      child: Text("No results found"),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: controller.suggestionsList
                          .map(
                            (e) => Container(
                              margin: EdgeInsets.only(left: 20),
                              child: buildEmployeeNames(e),
                            ),
                          )
                          .toList(),
                    ),
                  ),
          ),
        );
      return SizedBox();
    });
  }

  Widget buildFloatingActionButton() {
    return EmployeeAccess(
      access: AccessRights.createEmployees,
      child: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AddAnUser.id);
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }

  Widget buildAllEmployees() {
    logic.controller.allEmployeesList = [];
    getCount() {
      if (counterModel != null && counterModel.employee != null)
        return counterModel.employee;
      return 54;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          getCount(),
          (index) => buildListTile(
            (index + 1).toString(),
          ),
        ),
      ],
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> buildListTile(
      String id) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("employees")
            .doc(id)
            .collection("employeeFullInformation")
            .doc("employeeData")
            .get(),
        builder: (BuildContext context, snapshot) {
          try {
            if (!snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 30,
                  width: Get.width,
                  child: Shimmer.fromColors(
                    child: Container(
                      height: 20,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey),
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                  ),
                ),
              );
            }
            Map<String, dynamic> employeeData = snapshot.data.data();
            var e = Employee.fromMap(employeeData);
            logic.controller.allEmployeesList.add(e);
            //print(e.id);
            // //print("=============${logic.controller.allEmployeesList.length}");
            // //print(e);
            return buildEmployeeNames(e);
          } catch (e) {
            return SizedBox();
          }
        });
  }

  Widget buildEmployeeNames(Employee e) {
    return GestureDetector(
      onTap: () {
        // //print("clicked");
        Get.toNamed(EmployeeDetailsScreen.id, arguments: e);
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
              "   ${e.name}",
              style: TextStyle(color: AppColors.text.black, fontSize: 14),
            ),
            Expanded(
                child: Container(
              color: Colors.transparent,
            )),
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
                  if (text.isNotEmpty) {
                    logic.controller.showSuggestions = true;
                    logic.updateSearchList(text);
                  } else {
                    logic.controller.showSuggestions = false;
                  }
                },
              ),
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

// class AllEmployeesScreen extends StatelessWidget {
//   static const String id = "AllEmployeesScreen";
//   final ScrollController scrollController = ScrollController();
//
//   final AllEmployeesLogic logic = AllEmployeesLogic();
//
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
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Get.toNamed(AddAnUser.id);
//           },
//           backgroundColor: AppColors.background.black,
//           child: Icon(Icons.add),
//           elevation: 0,
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//         appBar: AppBar(
//           toolbarHeight: 70,
//           centerTitle: true,
//           title: buildTitle(),
//           leading: BackNavigationIcon(),
//           elevation: 0,
//           backgroundColor: AppColors.background.white,
//         ),
//         body: SafeArea(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   SizedBox(height: 10),
//                   buildSearchBar(),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         logic.controller.showSuggestions = false;
//                       },
//                       child: SingleChildScrollView(
//                         physics: BouncingScrollPhysics(),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               top: 0, bottom: 20, left: 25, right: 20),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // buildRoles(),
//                               // SizedBox(height: 10).
//                               SizedBox(height: 10),
//                               buildAllEmployees(),
//                               SizedBox(height: 10),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               buildSuggestions(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   ///===============UI=============///
//   Widget buildSuggestions() {
//     return GetBuilder<AllEmployeesController>(builder: (controller) {
//       if (controller.showSuggestions)
//         return Positioned(
//           child: Container(
//             constraints: BoxConstraints(
//               minHeight: 100,
//               maxHeight: 300,
//               minWidth: 328,
//               maxWidth: 328,
//             ),
//             margin: EdgeInsets.only(
//               top: 65,
//               left: (Get.width - 328) / 2,
//               // right: 100,
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 10,
//                     offset: Offset(0, 5), // changes position of shadow
//                   ),
//                 ]),
//             padding: const EdgeInsets.only(top: 10),
//             child: controller.suggestionsList.isEmpty
//                 ? Container(
//                     height: 100,
//                     child: Center(
//                       child: Text("No results found"),
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     child: Column(
//                       children: controller.suggestionsList
//                           .map(
//                             (e) => Container(
//                               margin: EdgeInsets.only(left: 20),
//                               child: buildEmployeeNames(e),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ),
//           ),
//         );
//       return SizedBox();
//     });
//   }
//
//   Widget buildAllEmployees() {
//     return GetBuilder<AllEmployeesController>(builder: (controller) {
//       controller.allEmployeesList = [];
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ...List.generate(
//               43, (index) => buildListTile((index + 1).toString())),
//         ],
//       );
//     });
//   }
//
//   FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> buildListTile(
//       String id) {
//     return FutureBuilder(
//         future: FirebaseFirestore.instance
//             .collection("employees")
//             .doc(id)
//             .collection("employeeFullInformation")
//             .doc("employeeData")
//             .get(),
//         builder: (BuildContext context, snapshot) {
//           if (!snapshot.hasData) {
//             return Padding(
//               padding: const EdgeInsets.all(10),
//               child: Container(
//                 height: 30,
//                 width: Get.width,
//                 child: Shimmer.fromColors(
//                   child: Container(
//                     height: 20,
//                     width: Get.width,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: Colors.grey),
//                   ),
//                   baseColor: Colors.grey[300],
//                   highlightColor: Colors.grey[100],
//                 ),
//               ),
//             );
//           }
//           Map<String, dynamic> employeeData = snapshot.data.data();
//           var e = Employee.fromMap(employeeData);
//           logic.controller.allEmployeesList.add(e);
//           //print(logic.controller.allEmployeesList);
//           return buildEmployeeNames(e);
//         });
//   }
//
//   Widget buildEmployeeNames(Employee e) {
//     return GestureDetector(
//       onTap: () {
//         // //print("clicked");
//         Get.toNamed(EmployeeDetailsScreen.id, arguments: [e]);
//       },
//       child: Container(
//         height: 47,
//         width: Get.width,
//         child: Row(
//           children: [
//             Icon(
//               Icons.account_circle,
//               color: Colors.black38,
//               size: 25,
//             ),
//             SizedBox(width: 20),
//             Text(
//               "   ${e.name}",
//               style: TextStyle(color: AppColors.text.black, fontSize: 14),
//             ),
//             Expanded(
//                 child: Container(
//               color: Colors.transparent,
//             )),
//             // buildOptions()
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget buildOptions() {
//   //   return GetBuilder<AllEmployeesController>(builder: (controller) {
//   //     return PopupMenuButton<String>(
//   //         icon: Icon(
//   //           Icons.more_vert_rounded,
//   //           size: 25,
//   //           color: AppColors.IconColor.black,
//   //         ),
//   //         onSelected: handleClick,
//   //         itemBuilder: (BuildContext context) {
//   //           return {'Call', 'Delete', "Info"}.map((String choice) {
//   //             return PopupMenuItem<String>(
//   //               value: choice,
//   //               child: Text(choice),
//   //             );
//   //           }).toList();
//   //         });
//   //   });
//   // }
//
//   void handleClick(String value) {
//     switch (value) {
//       case 'Call':
//         Get.toNamed(AddAnUser.id);
//         break;
//       case 'Delete':
//         break;
//       case 'Info':
//         break;
//     }
//   }
//
//   // Widget buildRoles() {
//   //   return GetBuilder<AllEmployeesController>(builder: (controller) {
//   //     return SingleChildScrollView(
//   //       scrollDirection: Axis.horizontal,
//   //       physics: BouncingScrollPhysics(),
//   //       child: Row(
//   //         children: [
//   //           ...controller.roles.map((e) => Padding(
//   //                 padding: const EdgeInsets.all(10.0),
//   //                 child: Container(
//   //                   height: 35,
//   //                   width: 120,
//   //                   decoration: BoxDecoration(
//   //                     borderRadius: BorderRadius.circular(10),
//   //                     color: Colors.black12,
//   //                   ),
//   //                   child: Center(
//   //                       child: Text(
//   //                     e,
//   //                     style: TextStyle(
//   //                         color: AppColors.text.black,
//   //                         fontSize: 13,
//   //                         fontWeight: FontWeight.w600),
//   //                   )),
//   //                 ),
//   //               ))
//   //         ],
//   //       ),
//   //     );
//   //   });
//   // }
//
//   Widget buildSearchBar() {
//     return Container(
//       width: 328,
//       height: 47,
//       decoration: BoxDecoration(
//           color: AppColors.background.white,
//           borderRadius: BorderRadius.circular(5)),
//       child: Container(
//         margin: EdgeInsets.only(left: 15, right: 15),
//         alignment: Alignment.centerLeft,
//         child: Row(
//           children: [
//             Icon(Icons.search, color: AppColors.text.darkgrey),
//             SizedBox(width: 15),
//             Container(
//               width: 240,
//               child: TextField(
//                 decoration: InputDecoration(
//                     enabledBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none),
//                     focusedBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none),
//                     disabledBorder:
//                         OutlineInputBorder(borderSide: BorderSide.none),
//                     hintText: 'Search...',
//                     hintStyle:
//                         TextStyle(fontSize: FontSize.textSize, height: 1)),
//                 controller: logic.controller.searchTED,
//                 onChanged: (text) {
//                   if (text.isNotEmpty) {
//                     logic.controller.showSuggestions = true;
//                     logic.updateSearchList(text);
//                   } else {
//                     logic.controller.showSuggestions = false;
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildTitle() {
//     return Text(
//       'All Employees',
//       style: TextStyle(
//         color: AppColors.text.black,
//         fontSize: 20,
//         fontFamily: AppFonts.nunito,
//         fontWeight: FontWeight.normal,
//         letterSpacing: 1.2,
//       ),
//     );
//   }
// }

///TODO :: Check Please
