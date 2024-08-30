import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/authentication/firebase_authentication.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/checklist_model.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/add_employee_widget/add_employee_widget.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../dive_checklist/presentation/views/dive_checklist_view.dart';
import '../../../employees/model/employee.dart';
import '../../../employees/presentation/views/all_employees_view.dart';
import '../../../login/presentation/views/login_view.dart';
import '../../controllers/home_controller.dart';
import '../widgets/employee_dive_calender_list_tile.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/template_bottomsheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeLogic logic = HomeLogic();

  @override
  void initState() {
    super.initState();
    logic.getBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      drawer: NavDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            buildMenuAndLogOut().paddingSymmetric(horizontal: 20),
            Spacing.h20,
            GetBuilder<HomeController>(
              builder: (controller) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        if (currentEmployee?.role != 'Intern')
                          AddEmployeeWidget(
                            text: 'Add Employees',
                            subText: 'Only admins can modify',
                            onTap: () {
                              Navigator.push(context, AllEmployeesView.route());
                            },
                          ),
                        Spacing.h20,
                        buildCheckLists(),
                        Spacing.h20,
                        buildEmployeeDiveCalender(),
                        Spacing.h50,
                      ],
                    ).paddingSymmetric(horizontal: 20),
                    if (controller.showLoading)
                      Container(
                        height: Screen.height,
                        width: Screen.width,
                        color: Colors.white,
                        child: const CircularProgressIndicator(
                          color: Colors.black,
                        ).center,
                      ),
                  ],
                );
              },
            ),
          ],
        ).scrollable,
      ),
    );
  }

  Widget buildButton({required Function onTap, required IconData icon}) {
    return SizedBox(
      height: 20,
      width: 20,
      child: IconButton(
        splashRadius: 30,
        padding: EdgeInsets.zero,
        onPressed: () {
          onTap();
        },
        icon: Icon(
          icon,
          color: Colors.black,
          size: 14,
        ),
      ),
    );
  }

  Widget buildMenuAndLogOut() {
    return Container(
      width: Screen.width,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (currentEmployee?.role != 'Intern')
            IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            ),
          const Spacer(),
          IconButton(
            onPressed: () {
              logoutDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ).paddingOnly(top: 20),
    );
  }

  Future<void> logoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Do you want to log out.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () {
                FirebaseAuthentication.logout();
                Navigator.pushReplacement(context, LoginView.route());
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildEmployeeDiveCalender() {
    return Container(
      width: Screen.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: GetBuilder<HomeController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.h15,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildButton(
                    onTap: () {
                      logic.onDateChanged(
                        controller.selectedDate
                            .subtract(const Duration(days: 1)),
                      );
                    },
                    icon: Icons.arrow_back_ios_rounded,
                  ),
                  Spacing.w20,
                  FittedBox(
                    child: Text(
                      DateFormat('dd-MMM-yyyy').format(controller.selectedDate),
                      style: TextStyle(
                        fontFamily: AppFonts.nunito,
                        color: AppColors.text.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Spacing.w20,
                  buildButton(
                    onTap: () {
                      logic.onDateChanged(
                        controller.selectedDate.add(const Duration(days: 1)),
                      );
                    },
                    icon: Icons.arrow_forward_ios_rounded,
                  ),
                ],
              ).paddingSymmetric(horizontal: 10),
              Spacing.h5,
              const Divider(thickness: 2, color: Colors.black),
              Spacing.h10,
              if (controller.bookings.isEmpty &&
                  controller.diveBuddies.isEmpty &&
                  controller.generalStaffList.isEmpty)
                const Text('No tasks assigned').center,
              ...controller.bookings.map(
                (booking) => EmployeeDiveCalenderListTile(
                  itemModel: booking,
                  selectedDate: controller.selectedDate,
                ),
              ),
              ...controller.diveBuddies.map(
                (e) => buildListTile(
                  title: 'Dive Buddy',
                  value: '${e.name} x ${e.pax} (${e.bookingID})',
                ),
              ),
              ...controller.currentList.map(
                (e) => buildListTile(
                  title: e['role'].toString(),
                  value:
                      "${e["boat_details"]?.name}@ ${e["boat_details"]?.time}",
                ),
              ),
              ...controller.generalStaffList.map(
                (e) => buildListTile(title: e, value: 'Manage / Organize'),
              ),
              Spacing.h15,
            ],
          );
        },
      ),
    );
  }

  Widget buildListTile({required String title, String? value}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            value ?? '',
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.darkgrey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 20, vertical: 5);
  }

  Widget buildCheckLists() {
    return Container(
      width: Screen.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CheckLists',
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Spacing.h10,
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('employeeChecklists')
                .doc(currentEmployee!.id)
                .snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot,
            ) {
              if (snapshot.hasError ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                );
              }
              final data = snapshot.data?.data();

              if (data == null) {
                return const SizedBox();
              }

              Checklist? checklist =
                  Checklist.fromMap(data as Map<String, dynamic>);

              if ((checklist.checklistElement ?? []).isEmpty) {
                return const SizedBox();
              }
              return Column(
                children: [
                  ...(checklist.checklistElement ?? []).map(
                    (checklistElement) => buildChecklistTiles(
                      text: checklistElement.title,
                      onTap: () {
                        Navigator.push(
                            context,
                            DiveChecklistView.route(
                                checklistElement, checklist));
                      },
                    ).paddingOnly(bottom: 5),
                  ),
                ],
              );
            },
          ),
          buildChecklistTiles(
            text: 'Select Template',
            isAddButton: true,
            onTap: () {
              TemplateBottomSheet.show(context);
            },
          ).paddingOnly(bottom: 5),
        ],
      ).paddingSymmetric(horizontal: 15, vertical: 15),
    );
  }

  Widget buildChecklistTiles({
    required String text,
    bool isAddButton = false,
    required Function onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.darkgrey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            onTap();
          },
          icon: Icon(
            (isAddButton)
                ? Icons.add_circle_outline
                : Icons.arrow_forward_rounded,
            color: (isAddButton) ? Colors.black : AppColors.text.skyBlue,
            size: 20,
          ),
        ),
      ],
    ).width(Screen.width - 80);
  }
}
