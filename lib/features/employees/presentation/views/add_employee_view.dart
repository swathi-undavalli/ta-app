import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/counter_model.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/phone_number_input.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../../logs/models/log_model.dart';
import '../../../logs/presentation/views/log_view.dart';
import '../../model/employee.dart';

class AddEmployeeView extends StatefulWidget {
  final Employee? employeeArgument;

  const AddEmployeeView({super.key, this.employeeArgument});

  static Route route(Employee? employeeArgument) => MaterialPageRoute(
        builder: (context) =>
            AddEmployeeView(employeeArgument: employeeArgument),
      );

  @override
  State<AddEmployeeView> createState() => _AddEmployeeViewState();
}

class _AddEmployeeViewState extends State<AddEmployeeView> {
  bool get isEditMode => widget.employeeArgument != null;

  late TextEditingController firstNameTED;
  late TextEditingController nickNameTED;
  late TextEditingController lastNameTED;
  late TextEditingController phoneNumberTED;
  late TextEditingController countryCodeTED;
  late TextEditingController agencyIdTED;
  late TextEditingController roleTED;
  late TextEditingController genderTED;
  late TextEditingController employeeIdTED;
  late String? countryIsoCode;
  late bool? viewBookings;
  late bool? weatherReport;
  late bool? createBookings;
  late bool? editBookings;
  late bool? editActivityPrices;
  late bool? addActivity;
  late bool? editEmployees;
  late bool? personalProfileEdit;
  late bool? createEmployees;
  late bool? viewEmployees;
  late bool? notifications;
  late bool? boatPlan;
  late bool? marketingGallery;
  late bool? offers;
  late bool? processCertificate;
  late bool? addEquipment;
  late bool? viewEquipment;
  late bool? generalInfo;
  late bool? roster;
  late bool? logs;
  late bool? upcomingEvents;
  late bool? coastGuardSlip;
  late bool? approveEquipment;
  late bool? showPaymentDetails;

  List<String> gender = ['Male', 'Female'];

  List<String> roles = [
    'Office Staff',
    'Admin Team',
    'Dive Team',
    'Accounts Team',
    'Front Desk Team',
    'Marketing Team',
    'Captain Team',
    'Bookings Team',
    'Social Media',
    'Freelance Team',
    'Intern',
  ];

  bool showLoading = false;

  @override
  void initState() {
    super.initState();

    firstNameTED =
        TextEditingController(text: widget.employeeArgument?.firstName);
    lastNameTED =
        TextEditingController(text: widget.employeeArgument?.lastName);
    nickNameTED =
        TextEditingController(text: widget.employeeArgument?.nickName);
    phoneNumberTED =
        TextEditingController(text: widget.employeeArgument?.phoneNumber);
    countryCodeTED =
        TextEditingController(text: widget.employeeArgument?.countryCode);
    agencyIdTED =
        TextEditingController(text: widget.employeeArgument?.agencyId);
    roleTED = TextEditingController(text: widget.employeeArgument?.role);
    genderTED = TextEditingController(text: widget.employeeArgument?.gender);
    employeeIdTED = TextEditingController(text: widget.employeeArgument?.id);
    countryIsoCode = widget.employeeArgument?.countryIsoCode ?? 'IN';

    viewBookings = widget.employeeArgument?.accessLevels?.viewBookings ?? false;
    weatherReport =
        widget.employeeArgument?.accessLevels?.weatherReport ?? false;
    createBookings =
        widget.employeeArgument?.accessLevels?.createBookings ?? false;
    editBookings = widget.employeeArgument?.accessLevels?.editBookings ?? false;
    editActivityPrices =
        widget.employeeArgument?.accessLevels?.editActivityPrices ?? false;
    addActivity = widget.employeeArgument?.accessLevels?.addActivity ?? false;
    editEmployees =
        widget.employeeArgument?.accessLevels?.editEmployees ?? false;
    personalProfileEdit =
        widget.employeeArgument?.accessLevels?.personalProfileEdit ?? false;
    createEmployees =
        widget.employeeArgument?.accessLevels?.createEmployees ?? false;
    viewEmployees =
        widget.employeeArgument?.accessLevels?.viewEmployees ?? false;
    notifications =
        widget.employeeArgument?.accessLevels?.notifications ?? false;
    boatPlan = widget.employeeArgument?.accessLevels?.boatPlan ?? false;
    marketingGallery =
        widget.employeeArgument?.accessLevels?.marketingGallery ?? false;
    offers = widget.employeeArgument?.accessLevels?.offers ?? false;
    processCertificate =
        widget.employeeArgument?.accessLevels?.processCertificate ?? false;
    addEquipment = widget.employeeArgument?.accessLevels?.addEquipment ?? false;
    viewEquipment =
        widget.employeeArgument?.accessLevels?.viewEquipment ?? false;
    approveEquipment =
        widget.employeeArgument?.accessLevels?.approveEquipment ?? false;
    generalInfo = widget.employeeArgument?.accessLevels?.generalInfo ?? false;
    roster = widget.employeeArgument?.accessLevels?.roster ?? false;
    logs = widget.employeeArgument?.accessLevels?.logs ?? false;
    upcomingEvents =
        widget.employeeArgument?.accessLevels?.upcomingEvents ?? false;
    coastGuardSlip =
        widget.employeeArgument?.accessLevels?.coastGuardSlip ?? false;
    showPaymentDetails =
        widget.employeeArgument?.accessLevels?.showPaymentDetails ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        reset();
      },
      child: Scaffold(
        appBar: const AppBarWidget(heading: 'Employee Details'),
        backgroundColor: AppColors.background.lightBlue,
        body: SafeArea(
          child: SingleChildScrollView(
            child: (showLoading)
                ? SizedBox(
                    height: Screen.height,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: Colors.grey,
                      color: Colors.black,
                    ).center,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Spacing.h10,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Spacing.h10,
                          Text(
                            'Last Employee ID : ${counterModel!.employee.toString()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          buildEmployeeID(),
                          Row(
                            children: [
                              Expanded(
                                child: buildFirstName(),
                              ),
                              Spacing.w10,
                              Expanded(
                                child: buildLastName(),
                              ),
                            ],
                          ),
                          buildNickName(),
                          buildUniqueAgencyId(),
                          PhoneNumberInput(
                            controller: phoneNumberTED,
                            initialCountryCode: countryIsoCode,
                            required: true,
                            onChanged: (phone) {
                              countryCodeTED.text = phone.countryCode;
                              phoneNumberTED.text = phone.number;
                              countryIsoCode = phone.countryISOCode;
                            },
                            onCountryChanged: (country) {
                              countryCodeTED.text = country.dialCode;
                            },
                          ),
                          buildSubtitle('Role *'),
                          buildRolesList(),
                          Spacing.h10,
                          buildSubtitle('Gender *'),
                          buildGender(),
                          Spacing.h30,
                          SizedBox(
                            width: Screen.width,
                            child: const Text(
                              'Access Levels',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: AppFonts.nunito,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Spacing.h20,
                          buildAccessLevels(),
                        ],
                      ).paddingSymmetric(horizontal: 30),
                      Spacing.h30,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildCancelButton(),
                          buildSubmitButton(),
                        ],
                      ),
                      Spacing.h30,
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  ///===============UI==============///

  reset() {
    firstNameTED.text = '';
    lastNameTED.text = '';
    nickNameTED.text = '';
    phoneNumberTED.text = '';
    countryCodeTED.text = '';
    roleTED.text = '';
    genderTED.text = '';
    agencyIdTED.text = '';
    viewBookings = false;
    createBookings = false;
    editBookings = false;
    viewEmployees = false;
    createEmployees = false;
    editEmployees = false;
    personalProfileEdit = false;
    weatherReport = false;
    editActivityPrices = false;
    addActivity = false;
    notifications = false;
    marketingGallery = false;
    offers = false;
    boatPlan = false;
    processCertificate = false;
    generalInfo = false;
    roster = false;
    logs = false;
    upcomingEvents = false;
    coastGuardSlip = false;
    addEquipment = false;
    viewEquipment = false;
    approveEquipment = false;
  }

  Widget buildAccessLevels() {
    return Column(
      children: [
        buildSwitch(
          text: 'View Bookings',
          switchValue: viewBookings!,
          onChanged: (value) {
            viewBookings = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Create Bookings',
          switchValue: createBookings!,
          onChanged: (value) {
            createBookings = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Edit Bookings',
          switchValue: editBookings!,
          onChanged: (value) {
            editBookings = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'View Employees',
          switchValue: viewEmployees!,
          onChanged: (value) {
            viewEmployees = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Create Employees',
          switchValue: createEmployees!,
          onChanged: (value) {
            createEmployees = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Edit Employees',
          switchValue: editEmployees!,
          onChanged: (value) {
            editEmployees = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Personal Profile Edit',
          switchValue: personalProfileEdit!,
          onChanged: (value) {
            personalProfileEdit = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Weather Report',
          switchValue: weatherReport!,
          onChanged: (value) {
            weatherReport = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Edit Activity Prices',
          switchValue: editActivityPrices!,
          onChanged: (value) {
            editActivityPrices = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Add Activity',
          switchValue: addActivity!,
          onChanged: (value) {
            addActivity = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Boat Plan',
          switchValue: boatPlan!,
          onChanged: (value) {
            boatPlan = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Marketing Gallery',
          switchValue: marketingGallery!,
          onChanged: (value) {
            marketingGallery = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Offers',
          switchValue: offers!,
          onChanged: (value) {
            offers = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Process Certificate',
          switchValue: processCertificate!,
          onChanged: (value) {
            processCertificate = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'View equipment',
          switchValue: viewEquipment!,
          onChanged: (value) {
            viewEquipment = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Add equipment',
          switchValue: addEquipment!,
          onChanged: (value) {
            addEquipment = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Approve equipment',
          switchValue: approveEquipment!,
          onChanged: (value) {
            approveEquipment = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'General Info',
          switchValue: generalInfo!,
          onChanged: (value) {
            generalInfo = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Roster',
          switchValue: roster!,
          onChanged: (value) {
            roster = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Logs',
          switchValue: logs!,
          onChanged: (value) {
            logs = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Upcoming Events',
          switchValue: upcomingEvents!,
          onChanged: (value) {
            upcomingEvents = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Coast Guard Slip',
          switchValue: coastGuardSlip!,
          onChanged: (value) {
            coastGuardSlip = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Show Payment Details',
          switchValue: showPaymentDetails!,
          onChanged: (value) {
            showPaymentDetails = value;
            setState(() {});
          },
        ),
        buildSwitch(
          text: 'Subscribe Notifications',
          switchValue: notifications!,
          onChanged: (value) {
            notifications = value;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget buildSwitch({
    required String text,
    Function? onChanged,
    required bool switchValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: FontSize.small,
              color: AppColors.text.darkgrey,
            ),
          ),
        ),
        Switch(
          value: switchValue,
          onChanged: onChanged as void Function(bool)?,
          activeColor: AppColors.text.black,
          inactiveThumbColor: AppColors.text.grey,
        ),
      ],
    );
  }

  Widget buildFirstName() {
    return AppTextField(
      width: Screen.width,
      hintText: 'First Name',
      controller: firstNameTED,
      required: true,
      errorValidator: () {
        return null;
      },
      validator: (firstName) {
        return null;
      },
    );
  }

  Widget buildNickName() {
    return AppTextField(
      width: Screen.width,
      hintText: 'Nick Name',
      controller: nickNameTED,
      errorValidator: () {
        return null;
      },
      validator: (firstName) {
        return null;
      },
    );
  }

  Widget buildUniqueAgencyId() {
    return AppTextField(
      width: Screen.width,
      hintText: 'Padi No',
      controller: agencyIdTED,
      required: false,
      errorValidator: () {
        return null;
      },
      validator: (firstName) {
        return null;
      },
    );
  }

  Widget buildLastName() {
    return AppTextField(
      width: Screen.width,
      hintText: 'Last Name',
      controller: lastNameTED,
      required: false,
      errorValidator: () {
        return null;
      },
      validator: (firstName) {
        return null;
      },
    );
  }

  Widget buildEmployeeID() {
    return AppTextField(
      width: 320,
      hintText: 'EmployeeID',
      controller: employeeIdTED,
      keyboardType: TextInputType.number,
      required: true,
      errorValidator: () {
        return null;
      },
      validator: (firstName) {
        return null;
      },
    );
  }

  Widget buildSubtitle(String name) {
    return SizedBox(
      width: Screen.width,
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.black54,
          fontFamily: AppFonts.nunito,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget buildRolesList() {
    return DropdownButton(
      underline: Container(height: 1, color: Colors.grey),
      isExpanded: true,
      value: roleTED.text.isNotEmpty ? roleTED.text : null,
      onChanged: (dynamic newRole) {
        roleTED.text = newRole;
        setState(() {});
      },
      items: roles.map((role) {
        return DropdownMenuItem(
          value: role,
          child: Text(role),
        );
      }).toList(),
    );
  }

  Widget buildGender() {
    return DropdownButton(
      underline: Container(height: 1, color: Colors.grey),
      isExpanded: true,
      value: genderTED.text.isNotEmpty ? genderTED.text : null,
      onChanged: (dynamic newGender) {
        genderTED.text = newGender;
        setState(() {});
      },
      items: gender.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
    );
  }

  Widget buildCancelButton() {
    return Center(
      child: AppButton.flat(
        text: 'Cancel',
        isSecondary: true,
        onTap: () {
          Navigator.pop(context);
          reset();
        },
      ),
    );
  }

  Widget buildSubmitButton() {
    return Center(
      child: AppButton.flat(
        text: (isEditMode) ? 'Update' : 'Submit',
        onTap: () {
          onSubmitPressed();
        },
      ),
    );
  }

  onSubmitPressed() async {
    if (firstNameTED.text.trim().isNotEmpty &&
        employeeIdTED.text.trim().isNotEmpty &&
        phoneNumberTED.text.trim().isNotEmpty &&
        countryCodeTED.text.trim().isNotEmpty &&
        roleTED.text.trim().isNotEmpty) {
      setState(() {
        showLoading = true;
      });

      if (isEditMode == false) {
        var data = await FirebaseFirestore.instance
            .collection('counter')
            .doc('count')
            .get();
        CounterModel counterModel = CounterModel.fromMap(data.data() ?? {});
        if (int.parse(employeeIdTED.text) < 900) {
          counterModel =
              counterModel.copyWith(employee: (counterModel.employee! + 1));
          await FirebaseFirestore.instance
              .collection('counter')
              .doc('count')
              .set(counterModel.toMap());
        }
      }

      Employee employee = Employee(
        firstName: firstNameTED.text.trim().capitalizeFirst,
        lastName: lastNameTED.text.trim().capitalizeFirst,
        nickName: nickNameTED.text.trim().capitalizeFirst,
        id: employeeIdTED.text,
        phoneNumber: phoneNumberTED.text,
        countryCode: countryCodeTED.text,
        role: roleTED.text,
        gender: genderTED.text,
        countryIsoCode: countryIsoCode,
        agencyId: agencyIdTED.text,
        accessLevels: AccessLevels(
          viewBookings: viewBookings,
          createBookings: createBookings,
          editBookings: editBookings,
          viewEmployees: viewEmployees,
          createEmployees: createEmployees,
          editEmployees: editEmployees,
          personalProfileEdit: personalProfileEdit,
          weatherReport: weatherReport,
          editActivityPrices: editActivityPrices,
          addActivity: addActivity,
          notifications: notifications,
          boatPlan: boatPlan,
          marketingGallery: marketingGallery,
          offers: offers,
          processCertificate: processCertificate,
          addEquipment: addEquipment,
          viewEquipment: viewEquipment,
          generalInfo: generalInfo,
          roster: roster,
          logs: logs,
          upcomingEvents: upcomingEvents,
          coastGuardSlip: coastGuardSlip,
          approveEquipment: approveEquipment,
          showPaymentDetails: showPaymentDetails,
        ),
      );
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.id)
          .set(employee.toMap());

      LogModel logModel =
          LogModel(type: LogType.addEmployee, employeeName: employee.name);
      await FirebaseFirestore.instance
          .collection('logs')
          .doc()
          .set(logModel.toMap());

      Fluttertoast.showToast(msg: (isEditMode) ? 'Updated' : 'Saved');

      setState(() {
        showLoading = false;
      });

      disposeKeyboard();
      if (mounted) {
        Navigator.pop(context);
        if (isEditMode) Navigator.pop(context);
      }

      reset();
    } else {
      Fluttertoast.showToast(msg: 'Invalid Input');
    }
  }
}
