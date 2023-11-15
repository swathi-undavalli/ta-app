import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/phone_number/intl_phone_field.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../controllers/employee_profile_controller.dart';
import '../../model/employee.dart';

class EmployeeProfileScreen extends StatefulWidget {
  static const String id = 'EmployeeProfileScreen';

  const EmployeeProfileScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final EmployeeProfileLogic logic = EmployeeProfileLogic();

  @override
  void initState() {
    super.initState();
    logic.init();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = currentEmployee!.shiftTiming!;
    final DateFormat formatter = DateFormat('HH-mm-ss');
    final String shiftTiming = formatter.format(date);
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return false;
      },
      child: Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: GetBuilder<EmployeeProfileController>(
              builder: (controller) {
                return Stack(
                  children: [
                    if (controller.showLoading)
                      Container(
                        height: Get.height,
                        color: Colors.grey.shade300,
                        child: const CircularProgressIndicator().center,
                      ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildUserProfile(),
                              const SizedBox(height: 20),
                              const Divider(),
                              const SizedBox(height: 20),
                              (controller.isEditMode)
                                  ? buildTitle('Edit Details')
                                  : buildTitle('Employee Details'),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildEmployeeInfo(
                                        subHeading: 'Name',
                                        text: currentEmployee!.name),
                                    buildEmployeeInfo(
                                      subHeading: 'Phone Number',
                                      text: currentEmployee!.countryCode! +
                                          currentEmployee!.phoneNumber!,
                                    ),
                                    buildEmployeeInfo(
                                        subHeading: 'ShiftTiming',
                                        text: shiftTiming),
                                    buildEmployeeInfo(
                                        subHeading: 'Role',
                                        text: currentEmployee!.role),
                                    if (!controller.isEditMode)
                                      buildApplyLeaves(context)
                                          .paddingOnly(top: 20),
                                  ],
                                ),
                              ),
                              buildTextFields(
                                hintText: 'Name',
                                textEditingController: controller.nameTED,
                                focus: controller.nameNode,
                                nextFocus: controller.phoneNumberNode,
                                keyBoardType: TextInputType.text,
                              ),
                              buildPhoneNumber(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        buildButtons(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///=====================UI=====================///
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background.white,
      elevation: 0,
      toolbarHeight: 70,
      leading: Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            onBackPressed();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          ),
        ),
      ),
      title: Container(
        alignment: Alignment.centerRight,
        child: buildEditButton(),
      ),
    );
  }

  Widget buildApplyLeaves(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: Get.width,
                  child: Text(
                    'Apply Leaves',
                    style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(
                width: 130,
                child: (logic.controller.startDate == null &&
                        logic.controller.endDate == null)
                    ? AppButton.miniFlat(
                        onTap: () {
                          showDateRangePickerBottomSheet(context);
                        },
                        text: 'Apply',
                      ).center
                    : GestureDetector(
                        onTap: () {
                          showDateRangePickerBottomSheet(context);
                        },
                        child: const Text(
                          'Change',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue),
                        ),
                      ),
              ),
            ],
          ),
          Spacing.h10,
          if (logic.controller.startDate != null &&
              logic.controller.endDate != null)
            Text(
              "${DateFormat("dd-MM-yyyy").format(logic.controller.startDate!)} - ${DateFormat("dd-MM-yyyy").format(logic.controller.endDate!)}",
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  onBackPressed() {
    if (logic.controller.isEditMode) {
      logic.controller.isEditMode = !logic.controller.isEditMode;
    } else {
      Get.back();
    }
  }

  Future showDateRangePickerBottomSheet(BuildContext context) {
    return showDateRangePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff376aed),
            ),
          ),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              )
            ],
          ),
        );
      },
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      currentDate: DateTime.now(),
    ).then((pickedDateRange) async {
      if (pickedDateRange != null) {
        logic.controller.dateRange = pickedDateRange;
        logic.controller.startDate = logic.controller.dateRange!.start;
        logic.controller.endDate = logic.controller.dateRange!.end;
      }
      logic.controller.leaves = [];

      logic.controller.showLoading = true;

      if (logic.controller.startDate != null) {
        Timestamp startTimestamp =
            Timestamp.fromDate(logic.controller.startDate!);
        logic.controller.leaves.add(startTimestamp);
      }
      if (logic.controller.endDate != null) {
        Timestamp endTimestamp = Timestamp.fromDate(logic.controller.endDate!);
        logic.controller.leaves.add(endTimestamp);
        currentEmployee?.leaves = logic.controller.leaves;
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(currentEmployee!.id)
            .set(currentEmployee!.toMap());
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(currentEmployee!.id)
            .collection('employeeFullInformation')
            .doc('employeeData')
            .set(currentEmployee!.toMap());
        logic.controller.update();
      }
      logic.controller.showLoading = false;
    });
  }

  Widget buildPhoneNumber() {
    return GetBuilder<EmployeeProfileController>(
      builder: (controller) {
        if (controller.isEditMode) {
          return IntlPhoneField(
            autoValidate: true,
            initialCountryCode: controller.isoCode,
            showCountryFlag: false,
            initialValue: controller.phoneNumberTED.text,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              labelStyle: TextStyle(
                fontSize: FontSize.small,
                fontFamily: AppFonts.nunito,
              ),
            ),
            style: const TextStyle(
                fontFamily: AppFonts.nunito,
                fontWeight: FontWeight.normal,
                fontSize: 14),
            searchText: 'Search',
            onSubmitted: (_) {},
            onChanged: (phone) {
              controller.phoneNumberTED.text = phone.number!;
              controller.countryCodeTED.text = phone.countryCode;
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildButtons() {
    return GetBuilder<EmployeeProfileController>(
      builder: (controller) {
        if (controller.isEditMode) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppButton.flat(
                height: 45,
                width: 140,
                color: AppColors.background.grey,
                text: 'Cancel',
                textColor: AppColors.text.black,
                onTap: () {
                  disposeKeyboard();
                  controller.isEditMode = !controller.isEditMode;
                },
              ),
              AppButton.flat(
                height: 45,
                width: 140,
                color: AppColors.background.black,
                text: 'Update',
                textColor: AppColors.text.white,
                onTap: () async {
                  if (controller.nameTED.text != '')
                    currentEmployee!.firstName = controller.nameTED.text;
                  if (controller.phoneNumberTED.text != '') {
                    currentEmployee!.countryIsoCode = controller.isoCode;
                    currentEmployee!.countryCode =
                        controller.countryCodeTED.text;
                    currentEmployee!.phoneNumber =
                        controller.phoneNumberTED.text;
                  }
                  controller.showLoading = true;
                  await FirebaseFirestore.instance
                      .collection('employees')
                      .doc(currentEmployee!.id)
                      .collection('employeeFullInformation')
                      .doc('employeeData')
                      .set(currentEmployee!.toMap());
                  await FirebaseFirestore.instance
                      .collection('employees')
                      .doc(currentEmployee!.id)
                      .set(currentEmployee!.toMap());
                  controller.showLoading = false;

                  controller.isEditMode = !controller.isEditMode;
                },
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildTextFields({
    String? hintText,
    TextEditingController? textEditingController,
    FocusNode? focus,
    FocusNode? nextFocus,
    TextInputType? keyBoardType,
  }) {
    return GetBuilder<EmployeeProfileController>(
      builder: (controller) {
        if (controller.isEditMode) {
          return SizedBox(
            width: 280,
            child: AppTextField(
              hintText: hintText,
              keyboardType: keyBoardType,
              focusNode: focus,
              nextFocusNode: nextFocus,
              controller: textEditingController,
              errorValidator: () {
                return null;
              },
              validator: (_) {
                return null;
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildEditButton() {
    return EmployeeAccess(
      access: AccessRights.personalProfileEdit,
      child: GetBuilder<EmployeeProfileController>(
        builder: (controller) {
          if (!controller.isEditMode) {
            return TextButton(
              style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(100, 31)),
              ),
              onPressed: () {
                controller.reset();
                controller.isEditMode = !controller.isEditMode;
                controller.phoneNumberTED.text =
                    currentEmployee?.phoneNumber ?? '';
                controller.countryCodeTED.text =
                    currentEmployee?.countryCode ?? '';
                controller.nameTED.text = currentEmployee?.firstName ?? '';
              },
              child: Text(
                'Edit',
                style: TextStyle(
                  color: AppColors.text.black,
                  fontSize: 14,
                  fontFamily: AppFonts.nunito,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.60,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget buildEmployeeInfo({String? subHeading, String? text}) {
    return GetBuilder<EmployeeProfileController>(
      builder: (controller) {
        if (!controller.isEditMode) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: 320,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: Get.width,
                      child: Text(
                        subHeading!,
                        style: TextStyle(
                            color: AppColors.text.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      ':      ${text!}',
                      style: TextStyle(
                          color: AppColors.text.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget buildTitle(String text) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: AppColors.text.skyBlue,
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.nunito,
        ),
      ),
    );
  }

  Widget buildIcons(IconData icon, Function onTap) {
    return Center(
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon),
        iconSize: 20,
        color: AppColors.background.black,
      ),
    );
  }

  Widget buildUserProfile() {
    return GetBuilder<EmployeeProfileController>(
      builder: (controller) {
        return Center(
          child: Column(
            children: [
              Stack(
                children: [
                  const SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg',
                      ),
                    ),
                  ),
                  if (controller.isEditMode)
                    Positioned(
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.white54,
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: FontSize.small,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
