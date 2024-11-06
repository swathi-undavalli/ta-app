import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../logs/models/log_model.dart';
import '../../../logs/presentation/views/log_view.dart';
import '../../model/employee.dart';
import 'add_employee_view.dart';

class EmployeeDetailsView extends StatefulWidget {
  final Employee employeeArgument;

  const EmployeeDetailsView({super.key, required this.employeeArgument});

  static Route route(Employee employeeArgument) => MaterialPageRoute(
        builder: (context) => EmployeeDetailsView(employeeArgument: employeeArgument),
      );

  @override
  State<EmployeeDetailsView> createState() => _EmployeeDetailsViewState();
}

class _EmployeeDetailsViewState extends State<EmployeeDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(heading: '', color: Colors.transparent),
      backgroundColor: AppColors.background.lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildUserProfile().center,
              Spacing.h20,
              Text(
                widget.employeeArgument.name,
                style: TextStyle(
                  color: AppColors.text.black,
                  fontWeight: FontWeight.w700,
                  fontSize: FontSize.textSize,
                ),
              ),
              Spacing.h20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildIcons(
                    Icons.call_rounded,
                    () {
                      makingPhoneCall(
                        widget.employeeArgument.phoneNumber!,
                        widget.employeeArgument.countryCode!,
                      );
                    },
                  ),
                  EmployeeAccess(
                    access: AccessRights.editEmployees,
                    child: buildIcons(Icons.edit, () async {
                      Navigator.push(context, AddEmployeeView.route(widget.employeeArgument));
                    }),
                  ),
                  EmployeeAccess(
                    access: AccessRights.editEmployees,
                    child: buildIcons(
                      Icons.delete,
                      () {
                        Get.defaultDialog(
                          contentPadding: const EdgeInsets.only(
                            left: 30,
                            right: 30,
                            top: 20,
                            bottom: 30,
                          ),
                          title: '\nAre You Sure ? ',
                          middleText: 'Account will Be Deleted Permanently.',
                          backgroundColor: Colors.white,
                          titleStyle: TextStyle(
                            color: AppColors.text.black,
                            fontFamily: AppFonts.nunito,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          middleTextStyle: TextStyle(
                            color: AppColors.text.black,
                            fontFamily: AppFonts.nunito,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          confirm: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppButton.miniText(
                                text: 'Cancel',
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              AppButton.miniFlat(
                                text: 'OK',
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('employees')
                                      .doc(widget.employeeArgument.id)
                                      .delete();
                                  LogModel logModel = LogModel(
                                    type: LogType.deleteEmployee,
                                    employeeName: widget.employeeArgument.name,
                                  );
                                  FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                          barrierDismissible: false,
                          radius: 10,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Spacing.h20,
              const Divider(),
              Spacing.h20,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildTitle('Employee Details').left,
                  Spacing.h15,
                  buildEmployeeInfo(
                    subHeading: 'Name',
                    text: widget.employeeArgument.name,
                  ),
                  buildEmployeeInfo(
                    subHeading: 'Employee ID',
                    text: widget.employeeArgument.id,
                  ),
                  buildEmployeeInfo(
                    subHeading: 'Padi No',
                    text: widget.employeeArgument.agencyId,
                  ),
                  buildEmployeeInfo(
                    subHeading: 'Phone Number',
                    text: '${widget.employeeArgument.countryCode!} ${widget.employeeArgument.phoneNumber!}',
                  ),
                  buildEmployeeInfo(
                    subHeading: 'Role',
                    text: widget.employeeArgument.role!,
                  ),
                ],
              ).paddingSymmetric(horizontal: 15),
              Spacing.h20,
            ],
          ).paddingAll(20),
        ),
      ),
    );
  }

  ///================UI================///

  Widget buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.text.skyBlue,
        fontWeight: FontWeight.w700,
        fontFamily: AppFonts.nunito,
      ),
    );
  }

  Widget buildEmployeeInfo({
    required String subHeading,
    required String? text,
  }) {
    return SizedBox(
      width: Screen.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: Screen.width,
              child: Text(
                subHeading,
                style: TextStyle(
                  color: AppColors.text.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Text(
              (text != null && text.isNotEmpty) ? text : '-',
              style: TextStyle(
                color: AppColors.text.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).paddingAll(5);
  }

  makingPhoneCall(String phoneNumber, String code) async {
    String url = 'tel:${code + phoneNumber}';
    Uri? uri = Uri.tryParse(url);

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildIcons(IconData icon, Function onTap) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.background.lightSkyBlue,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: AppColors.background.black,
          ),
        ),
      ),
    );
  }

  Widget buildUserProfile() {
    return const SizedBox(
      height: 100,
      width: 100,
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg',
        ),
      ),
    );
  }
}
