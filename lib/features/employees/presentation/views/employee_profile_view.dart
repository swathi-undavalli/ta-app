import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/phone_number/intl_phone_field.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../model/employee.dart';

class EmployeeProfileView extends StatefulWidget {
  const EmployeeProfileView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => const EmployeeProfileView(),
      );

  @override
  State<EmployeeProfileView> createState() => _EmployeeProfileViewState();
}

class _EmployeeProfileViewState extends State<EmployeeProfileView> {
  late TextEditingController phoneNumberTED, countryCodeTED, firstNameTED, lastNameTED;

  late Employee employee;
  late String isoCode;

  DateTime? startDate;
  DateTime? endDate;

  bool isEditMode = false;

  DateTimeRange? dateRange;
  List<Timestamp> leaves = [];

  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    phoneNumberTED = TextEditingController();
    countryCodeTED = TextEditingController();
    firstNameTED = TextEditingController();
    lastNameTED = TextEditingController();
    startDate = null;
    endDate == null;

    getEmployee();
  }

  getEmployee() async {
    showLoading = true;
    setState(() {});

    var data = await FirebaseFirestore.instance.collection('employees').doc(currentEmployee?.id).get();

    employee = Employee.fromMap(data.data() ?? {});
    isoCode = employee.countryIsoCode ?? 'IN';
    if (employee.leaves?.length == 2) {
      startDate = employee.leaves?.first.toDate();
      endDate = employee.leaves?.last.toDate();
    }
    showLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        onBackPressed();
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background.lightBlue,
        appBar: buildAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                if (showLoading)
                  Container(
                    height: Screen.height,
                    color: Colors.grey.shade300,
                    child: const CircularProgressIndicator().center,
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildUserProfile(),
                      Spacing.h20,
                      const Divider(),
                      Spacing.h20,
                      Text(
                        (isEditMode) ? 'Edit Details' : 'Employee Details',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.text.skyBlue,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.nunito,
                        ),
                      ).left,
                      Spacing.h20,
                      if (isEditMode) ...[
                        buildNameTED(),
                        buildPhoneNumber(),
                        Spacing.h20,
                        buildButtons(),
                        Spacing.h20,
                      ] else ...[
                        buildEmployeeInfo(subHeading: 'Name', text: employee.name),
                        buildEmployeeInfo(
                          subHeading: 'Phone Number',
                          text: '${employee.countryCode!} ${employee.phoneNumber!}',
                        ),
                        buildEmployeeInfo(subHeading: 'Role', text: employee.role),
                        Spacing.h20,
                        buildApplyLeaves(),
                      ],
                    ],
                  ).paddingAll(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        child: isEditMode ? const SizedBox() : buildEditButton(),
      ),
    );
  }

  Widget buildNameTED() {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            hintText: 'First Name',
            controller: firstNameTED,
            keyboardType: TextInputType.text,
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
        ),
        Spacing.w20,
        Expanded(
          child: AppTextField(
            hintText: 'Last Name',
            controller: lastNameTED,
            keyboardType: TextInputType.text,
            errorValidator: () {
              return null;
            },
            validator: (_) {
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildPhoneNumber() {
    return IntlPhoneField(
      autoValidate: true,
      initialCountryCode: isoCode,
      showCountryFlag: false,
      initialValue: phoneNumberTED.text,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(
          fontSize: FontSize.small,
          fontFamily: AppFonts.nunito,
        ),
      ),
      style: const TextStyle(fontFamily: AppFonts.nunito, fontWeight: FontWeight.normal, fontSize: 14),
      searchText: 'Search',
      onSubmitted: (_) {},
      onChanged: (phone) {
        phoneNumberTED.text = phone.number!;
        countryCodeTED.text = phone.countryCode;
        isoCode = phone.countryISOCode!;
      },
    );
  }

  Widget buildApplyLeaves() {
    return SizedBox(
      width: Screen.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Apply Leaves',
                  style: TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: (startDate == null && endDate == null)
                    ? AppButton.miniFlat(
                        onTap: () {
                          showDateRangePickerBottomSheet();
                        },
                        text: 'Apply',
                      ).center
                    : GestureDetector(
                        onTap: () {
                          showDateRangePickerBottomSheet();
                        },
                        child: const Text(
                          'Change',
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                        ),
                      ),
              ),
            ],
          ),
          Spacing.h10,
          if (startDate != null && endDate != null)
            Text(
              "${DateFormat("dd-MM-yyyy").format(startDate!)} - ${DateFormat("dd-MM-yyyy").format(endDate!)}",
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  onBackPressed() {
    if (isEditMode) {
      isEditMode = !isEditMode;
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  Widget buildButtons() {
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
            isEditMode = !isEditMode;
            setState(() {});
          },
        ),
        AppButton.flat(
          height: 45,
          width: 140,
          color: AppColors.background.black,
          text: 'Update',
          textColor: AppColors.text.white,
          onTap: () async {
            if (firstNameTED.text != '' && phoneNumberTED.text != '') {
              showLoading = true;
              setState(() {});

              employee = employee.copyWith(
                firstName: firstNameTED.text,
                lastName: lastNameTED.text,
                countryCode: countryCodeTED.text,
                countryIsoCode: isoCode,
                phoneNumber: phoneNumberTED.text,
              );

              await FirebaseFirestore.instance.collection('employees').doc(employee.id).set(employee.toMap());

              showLoading = false;
              isEditMode = !isEditMode;

              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Future showDateRangePickerBottomSheet() async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
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
              ),
            ],
          ),
        );
      },
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      currentDate: DateTime.now(),
    );

    if (pickedDateRange != null) {
      dateRange = pickedDateRange;
      startDate = dateRange!.start;
      endDate = dateRange!.end;
    }
    leaves = [];

    setState(() {
      showLoading = true;
    });

    if (startDate != null) {
      Timestamp startTimestamp = Timestamp.fromDate(startDate!);
      leaves.add(startTimestamp);
    }
    if (endDate != null) {
      Timestamp endTimestamp = Timestamp.fromDate(endDate!);
      leaves.add(endTimestamp);
      employee = employee.copyWith(leaves: leaves);
      await FirebaseFirestore.instance.collection('employees').doc(employee.id).set(employee.toMap());
    }
    setState(() {
      showLoading = false;
    });
  }

  Widget buildEditButton() {
    return EmployeeAccess(
      access: AccessRights.personalProfileEdit,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(Colors.black.withOpacity(0.2)),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          minimumSize: WidgetStateProperty.all<Size>(const Size(100, 31)),
        ),
        onPressed: () {
          isEditMode = !isEditMode;
          phoneNumberTED.text = employee.phoneNumber ?? '';
          countryCodeTED.text = employee.countryCode ?? '';
          isoCode = employee.countryIsoCode ?? 'IN';
          firstNameTED.text = employee.firstName ?? '';
          lastNameTED.text = employee.lastName ?? '';
          setState(() {});
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
      ),
    );
  }

  Widget buildEmployeeInfo({String? subHeading, String? text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            subHeading!,
            style: TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 150,
          child: Text(
            text!,
            style: TextStyle(color: AppColors.text.black, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ).paddingAll(5);
  }

  Widget buildUserProfile() {
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
              if (isEditMode)
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
  }
}
