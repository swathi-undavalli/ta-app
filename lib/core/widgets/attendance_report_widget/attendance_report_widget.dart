import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/dummy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'mini_employee_model.dart';
import 'package:intl/intl.dart';

class AttendanceReportWidget extends StatefulWidget {
  @override
  State<AttendanceReportWidget> createState() => _AttendanceReportWidgetState();
}

class _AttendanceReportWidgetState extends State<AttendanceReportWidget> {
  AttendanceReportWidgetLogic logic = AttendanceReportWidgetLogic();

  @override
  void initState() {
    // EmployeeAccess.run(
    //   function: logic.getAbsents,
    //   access: currentEmployee.accessLevels.attendanceReport,
    // );
    logic.getAbsents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EmployeeAccess(
      access: AccessRights.attendanceReport,
      child: Container(
        width: 321,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              buildTitle(),
              buildLoading(),
              buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return GetBuilder<AttendanceReportWidgetController>(builder: (controller) {
      if (controller.showLoading) return SizedBox();
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Divider(),
          Row(
            children: [
              buildTabButton("Late", () {
                controller.selectedList = controller.lateEmployeesList;
              },
                  count: controller.lateEmployeesList.length,
                  enable:
                      controller.selectedList == controller.lateEmployeesList,
                  color: Colors.orangeAccent),
              buildTabButton("On-Time", () {
                controller.selectedList = controller.onTimeEmployeesList;
              },
                  count: controller.onTimeEmployeesList.length,
                  enable:
                      controller.selectedList == controller.onTimeEmployeesList,
                  color: Colors.green),
              buildTabButton("Absent", () {
                controller.selectedList =
                    controller.notYetSignedInEmployeesList;
              },
                  count: controller.absentEmployeesList.length,
                  enable: controller.selectedList ==
                      controller.notYetSignedInEmployeesList,
                  color: Colors.red),
            ],
          ),
          Divider(),
          SizedBox(
            width: Get.width - 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.selectedList
                    .map(
                      (e) => Container(
                        height: 45,
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(e.name),
                            if (e.punctual == "Late")
                              Text(
                                e.loginTime != null
                                    ? DateFormat("hh : mm")
                                        .format(e.loginTime.toDate())
                                    : "",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: FontSize.small),
                              )
                            else if (e.punctual == "On-Time")
                              Text(
                                e.loginTime != null
                                    ? DateFormat("hh : mm")
                                        .format(e.loginTime.toDate())
                                    : "",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: FontSize.small),
                              )
                            else
                              Row(
                                children: [
                                  if (e.punctual != "Absent")
                                    Text(
                                      "${e.shiftTime.split(":")[0]} : ${e.shiftTime.split(":")[1]}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: FontSize.small),
                                    ),
                                  IconButton(
                                    onPressed: () async {
                                      var _url = "tel:${e.phone}";
                                      await canLaunch(_url)
                                          ? await launch(_url)
                                          : throw 'Could not launch $_url';
                                    },
                                    iconSize: 17,
                                    splashColor: AppColors.background.skyBlue,
                                    icon: Icon(
                                      Icons.call,
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    )
                    .toList()
                    .sublist(
                        0,
                        controller.showAll
                            ? controller.selectedList.length
                            : (controller.selectedList.length < 4)
                                ? controller.selectedList.length
                                : 4),
                SizedBox(
                  width: 321,
                  child: TextButton(
                    onPressed: () {
                      if (controller.selectedList.length > 4)
                        logic.toggleShowButton();
                    },
                    child: Text(
                      controller.showAll ? 'Show less' : "Show all",
                      style: TextStyle(
                        color: (controller.selectedList.length > 4)
                            ? AppColors.text.skyBlue
                            : AppColors.text.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget buildTabButton(
    String title,
    Function onTap, {
    bool enable = false,
    Color color,
    int count,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: enable ? AppColors.background.skyBlue : Colors.white,
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.small,
                    color: enable ? Colors.white : Colors.black,
                  ),
                ),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "$count",
                      style: TextStyle(
                        color: color,
                        fontSize: FontSize.small - 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNumbers() {
    return GetBuilder<AttendanceReportWidgetController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildCategoryStatus(
              "Staff are on time",
              "${controller.onTimeEmployeesList.length}  ",
              AppColors.text.green),
          buildCategoryStatus(
              "People are late",
              "${controller.lateEmployeesList.length}  ",
              AppColors.text.orange),
          buildCategoryStatus("People haven't signed in yet",
              "${controller.absentEmployeesList.length}  ", AppColors.text.red),
        ],
      );
    });
  }

  Container buildCategoryStatus(String key, String value, Color color) {
    return Container(
      height: 30,
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: value,
          style: TextStyle(
            fontFamily: AppFonts.nunito,
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: FontSize.small,
          ),
          children: <TextSpan>[
            TextSpan(
              text: key,
              style: TextStyle(
                color: AppColors.text.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return GetBuilder<AttendanceReportWidgetController>(builder: (controller) {
      if (controller.showLoading)
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Center(
            child: SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                color: AppColors.background.black,
                strokeWidth: 1,
              ),
            ),
          ),
        );
      return SizedBox();
    });
  }

  Container buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        "Attendance Report",
        style: TextStyle(
          fontFamily: AppFonts.nunito,
          color: AppColors.text.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

class AttendanceReportWidgetLogic {
  AttendanceReportWidgetController controller =
      Get.put(AttendanceReportWidgetController());

  Future<void> reloadData() async {
    await getAbsents();
    controller.update();
  }

  getAbsents() async {
    print("getAbsents");

    var data = await FirebaseFirestore.instance
        .collection("dailyAttendanceLogs")
        .doc(DateFormat("dd-MM-yyyy").format(DateTime.now()))
        .get();

    print(data);

    Map<String, dynamic> fData = data.data();
    // fData.forEach((key, value) {
    //   log(value.toString());
    //   // if (value["loginTime"] != null) log(fData[key].toString());
    // });

    print("------------------------------");
    controller.employeesList = [];
    controller.lateEmployeesList = [];
    controller.onTimeEmployeesList = [];
    controller.selectedList = [];
    controller.absentEmployeesList = [];
    controller.notYetSignedInEmployeesList = [];
    var now = DateTime.now();
    log(fData.toString());

    fData.forEach((key, value) {
      if (value.runtimeType != String) {
        var employee = EmployeeMiniModel.fromMap(value);
        DateTime empShiftTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(employee.shiftTime.split(":")[0]),
          int.parse(employee.shiftTime.split(":")[1]),
          int.parse(employee.shiftTime.split(":")[2]),
        );
        if (employee.loginTime == null) {
          log(DateTime.now().difference(empShiftTime).inHours.toString());
          if (DateTime.now().difference(empShiftTime).inHours >= 6) {
            employee.punctual = "Absent";
          }
          log(employee.punctual);
        }
        controller.employeesList.add(employee);
      }
    });
    print(controller.employeesList);

    controller.employeesList
        .sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));

    controller.employeesList.forEach((element) {
      // print(element.punctual);

      if (element.punctual == "Late")
        controller.lateEmployeesList.add(element);
      else if (element.punctual == "On-Time")
        controller.onTimeEmployeesList.add(element);
      else if (element.punctual == "Absent")
        controller.absentEmployeesList.add(element);
      else if (DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(element.shiftTime.split(":")[0]),
            int.parse(element.shiftTime.split(":")[1]),
            int.parse(element.shiftTime.split(":")[2]),
          ).difference(DateTime.now()).inMinutes <
          0) {
        // log(DateTime(
        //   now.year,
        //   now.month,
        //   now.day,
        //   int.parse(element.shiftTime.split(":")[0]),
        //   int.parse(element.shiftTime.split(":")[1]),
        //   int.parse(element.shiftTime.split(":")[2]),
        // ).difference(DateTime.now()).inMinutes.toString());
        // log(element.name);
        // log(element.shiftTime);
        controller.notYetSignedInEmployeesList.add(element);
      }
    });
    log("====================");
    log(controller.lateEmployeesList.toString());
    log(controller.onTimeEmployeesList.toString());
    log(controller.absentEmployeesList.toString());
    log(controller.notYetSignedInEmployeesList.toString());
    log("====================");
    controller.notYetSignedInEmployeesList =
        controller.absentEmployeesList + controller.notYetSignedInEmployeesList;
    controller.selectedList = controller.lateEmployeesList;
    controller.showLoading = false;
  }

  void toggleShowButton() {
    controller.showAll = !controller.showAll;
  }
}

class AttendanceReportWidgetController extends GetxController {
  bool _showLoading = true;
  bool _showAll = false;

  List<EmployeeMiniModel> _employeesList = [];
  List<EmployeeMiniModel> _onTimeEmployeesList = [];
  List<EmployeeMiniModel> _lateEmployeesList = [];
  List<EmployeeMiniModel> _absentEmployeesList = [];
  List<EmployeeMiniModel> _notYetSignedInEmployeesList = [];
  List<EmployeeMiniModel> _selectedList = [];

  List<EmployeeMiniModel> get employeesList => _employeesList;

  List<EmployeeMiniModel> get lateEmployeesList => _lateEmployeesList;

  bool get showLoading => _showLoading;

  bool get showAll => _showAll;

  List<EmployeeMiniModel> get onTimeEmployeesList => _onTimeEmployeesList;

  List<EmployeeMiniModel> get selectedList => _selectedList;

  List<EmployeeMiniModel> get absentEmployeesList => _absentEmployeesList;

  List<EmployeeMiniModel> get notYetSignedInEmployeesList =>
      _notYetSignedInEmployeesList;

  set notYetSignedInEmployeesList(List<EmployeeMiniModel> value) {
    _notYetSignedInEmployeesList = value;
    update();
  }

  set absentEmployeesList(List<EmployeeMiniModel> value) {
    _absentEmployeesList = value;
    update();
  }

  set selectedList(List<EmployeeMiniModel> value) {
    _selectedList = value;
    update();
  }

  set onTimeEmployeesList(List<EmployeeMiniModel> value) {
    _onTimeEmployeesList = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  set employeesList(List<EmployeeMiniModel> value) {
    _employeesList = value;
    update();
  }

  set showAll(bool value) {
    _showAll = value;
    update();
  }

  set lateEmployeesList(List<EmployeeMiniModel> value) {
    _lateEmployeesList = value;
    update();
  }
}
