import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../core/constants/constants.dart';
import '../../../core/constants/enums.dart';
import '../../../core/util/utils.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/booking_calender_widget_old/booking_calender_old.dart';
import '../../../core/widgets/booking_calender_widget_old/bookings_calender_widget_controller_old.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../dashboard/presentation/views/dashboard_view.dart';
import '../../employees/model/employee.dart';
import '../../logs/models/log_model.dart';
import '../../logs/presentation/views/log_view.dart';
import '../models/activity_model.dart';
import '../models/booking_model.dart';
import '../models/customer_model.dart';
import '../presentation/views/book_date_time_view.dart';
import '../presentation/views/new_booking_view.dart';
import '../presentation/views/payment_details_view.dart';
import '../repository/booking_repo.dart';

class NewBookingLogic {
  NewBookingLogic() {
    getDataFromFireBase();
  }

  NewBookingController controller = Get.put(NewBookingController());
  final AutoScrollController autoScrollControllerTheory =
      AutoScrollController();
  final AutoScrollController autoScrollControllerPool = AutoScrollController();
  final AutoScrollController autoScrollControllerDive = AutoScrollController();

  Future<void> getDetailsPressed() async {
    controller.showLoading = true;
    controller.customerExist = await isCustomerExists();
    controller.getDetailsPressed = true;
    controller.showLoading = false;
  }

  getDataFromFireBase() async {
    QuerySnapshot<Map<String, dynamic>> catalogue =
        await FirebaseFirestore.instance.collection('catalogue').get();
    controller.activities = [];
    for (int i = 0; i < catalogue.docs.length; i++) {
      if (catalogue.docs[i].id == 'colors') continue;
      Activity activity = Activity.fromMap(catalogue.docs[i].data());
      controller.activities.add(activity);
      controller.activities
          .sort((a1, a2) => a2.priority!.compareTo(a1.priority!));
      controller.showLoading = false;
    }
  }

  onContinuePressedBookingForm(BuildContext context) {
    controller.bookingModel.remarks = controller.remarksTED.text.toString();
    controller.bookingModel.employeeName =
        currentEmployee!.firstName! + currentEmployee!.lastName!;
    if (controller.payingNowTED.text == '' ||
        int.parse(controller.payingNowTED.text) == 0) {
      createBooking(context);
      Get.defaultDialog(
        barrierDismissible: false,
        title: '',
        titlePadding: const EdgeInsets.all(0),
        backgroundColor: Colors.white,
        titleStyle: const TextStyle(fontSize: 0),
        content: GetBuilder<NewBookingController>(
          builder: (controller) {
            if (controller.bookingId != null) {
              return Column(
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.background.skyBlue,
                    size: 30,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.bookingId!,
                    style: const TextStyle(fontSize: FontSize.title),
                  ),
                  const Text('Booking Created Successfully'),
                  const SizedBox(height: 20),
                  AppButton.miniFlat(
                    text: 'Okay',
                    onTap: () async {
                      Navigator.push(context, DashBoardView.route());
                      DashBoardScreenLogic dashboardLogic =
                          DashBoardScreenLogic();
                      dashboardLogic.controller.currentIndex = 2;
                      controller.reset();
                      BookingsCalenderWidgetLogic bookingCalenderLogic =
                          BookingsCalenderWidgetLogic();
                      bookingCalenderLogic.onDateSelected(
                        bookingCalenderLogic.controller.lastDateIndex,
                      );
                    },
                  ),
                ],
              );
            }
            return const SizedBox(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 1,
                ),
              ),
            );
          },
        ),
      );
    } else {
      Navigator.push(context, PaymentDetailsView.route());
    }
  }

  Future<void> createCustomer() async {
    CustomerModel customer = CustomerModel(
      countryCode: controller.countryCodeTED.text,
      firstName: controller.fNameTED.text,
      lastName: controller.lNameTED.text,
      email: controller.emailTED.text,
      phoneNumber: controller.phoneNumberTED.text,
      idProof: '',
      gender: controller.genderTED.text,
      dob: controller.dob.toString(),
    );
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(controller.emailTED.text)
        .set(customer.toMap());
  }

  onPaymentDetailsFilled(BuildContext context) {
    if (controller.paymentModeTED.text != '') {
      controller.bookingModel.paymentMode = controller.paymentModeTED.text;
      controller.bookingModel.paymentTransactionId =
          controller.paymentReferenceTED.text;
      controller.bookingModel.receiptNo = controller.receiptNoTED.text;
      createBooking(context);
      Get.defaultDialog(
        barrierDismissible: false,
        title: '',
        titlePadding: const EdgeInsets.all(0),
        titleStyle: const TextStyle(fontSize: 0),
        backgroundColor: Colors.white,
        content: GetBuilder<NewBookingController>(
          builder: (controller) {
            if (controller.bookingId != null) {
              return Column(
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.background.skyBlue,
                    size: 30,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    controller.bookingId!,
                    style: const TextStyle(fontSize: FontSize.title),
                  ),
                  const Text('Booking Created Successfully'),
                  const SizedBox(height: 20),
                  AppButton.miniFlat(
                    text: 'Okay',
                    onTap: () async {
                      Navigator.push(context, DashBoardView.route());
                      dashboardLogic.controller.currentIndex = 2;
                      controller.reset();
                      BookingsCalenderWidgetLogic bookingCalenderLogic =
                          BookingsCalenderWidgetLogic();
                      bookingCalenderLogic.onDateSelected(
                        bookingCalenderLogic.controller.lastDateIndex,
                      );
                    },
                  ),
                ],
              );
            }
            return const SizedBox(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 1,
                ),
              ),
            );
          },
        ),
      );
    } else {
      showToast('Invalid Input');
    }
  }

  paymentDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().subtract(const Duration(days: 36500)),
      maxTime: DateTime.now(),
      onChanged: (date) {
        controller.paymentDate = date;
      },
      onConfirm: (date) {
        controller.paymentDate = date;
        controller.update();
      },
      currentTime: controller.paymentDate,
    );
  }

  dobDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().subtract(const Duration(days: 36500)),
      maxTime: DateTime.now().subtract(const Duration(days: 2920)),
      onChanged: (date) {
        controller.dob = date;
        controller.dobTED.text = DateFormat('dd MMM, yyyy').format(date);
      },
      onConfirm: (date) {
        controller.dob = date;
        controller.dobTED.text = DateFormat('dd MMM, yyyy').format(date);
        controller.update();
      },
      currentTime: controller.dob,
    );
  }

  addPoolSessionDateTime(BuildContext context) {
    DateTime? selectedPoolDate;
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(fontSize: 0, height: 0),
      content: SizedBox(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: const Text(
                'Choose Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BookingsCalenderWidgetOld(
              autoScrollController: autoScrollControllerPool,
              highlightInvalidTime: true,
              calenderType: FilterType.Pool,
              startDate: DateTime.now(),
              onDateTimeSelected: (date) {
                selectedPoolDate = date;
              },
              isDiveSession: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton.miniFlat(
                  text: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppButton.miniFlat(
                  text: 'Okay',
                  onTap: () {
                    controller.bookingModel.poolDate ??= [];
                    controller.bookingModel.poolDate!.add(selectedPoolDate);
                    controller.bookingModel.poolDate =
                        controller.bookingModel.poolDate!.toSet().toList();
                    controller.update();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      radius: 10,
    );
  }

  addDiveSessionDateTime(BuildContext context) {
    DateTime? selectedDiveDate;
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.background.lightBlue,
      titleStyle: const TextStyle(fontSize: 0, height: 0),
      content: SizedBox(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: const Text(
                'Choose Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BookingsCalenderWidgetOld(
              autoScrollController: autoScrollControllerDive,
              highlightInvalidTime: true,
              startDate: DateTime.now(),
              calenderType: FilterType.Dive,
              onDateTimeSelected: (date) {
                selectedDiveDate = date;
              },
              isDiveSession: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton.miniFlat(
                  text: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppButton.miniFlat(
                  text: 'Okay',
                  onTap: () {
                    controller.bookingModel.diveDate ??= [];
                    controller.bookingModel.diveDate!.add(selectedDiveDate);
                    controller.bookingModel.diveDate =
                        controller.bookingModel.diveDate!.toSet().toList();
                    controller.update();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      radius: 10,
    );
  }

  addQuickDiveSessionDateTime(BuildContext context) {
    DateTime? selectedDiveDate;
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.background.lightBlue,
      titleStyle: const TextStyle(fontSize: 0, height: 0),
      content: SizedBox(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: const Text(
                'Choose Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BookingsCalenderWidgetOld(
              autoScrollController: autoScrollControllerDive,
              highlightInvalidTime: true,
              startDate: DateTime.now(),
              calenderType: FilterType.Dive,
              onDateTimeSelected: (date) {
                selectedDiveDate = date;
              },
              isDiveSession: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton.miniFlat(
                  text: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppButton.miniFlat(
                  text: 'Okay',
                  onTap: () {
                    if (selectedDiveDate != null) {
                      controller.quickDiveDates ??= [];
                      controller.quickDiveDates!.add(selectedDiveDate);
                      controller.quickDiveDates =
                          controller.quickDiveDates!.toSet().toList();
                    }
                    controller.update();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      radius: 10,
    );
  }

  addTheorySessionDateTime(BuildContext context) {
    DateTime? selectedTheoryDate;
    Get.defaultDialog(
      title: '',
      titlePadding: const EdgeInsets.all(0),
      backgroundColor: AppColors.background.lightBlue,
      titleStyle: const TextStyle(fontSize: 0, height: 0),
      content: SizedBox(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: const Text(
                'Choose Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BookingsCalenderWidgetOld(
              autoScrollController: autoScrollControllerTheory,
              highlightInvalidTime: true,
              calenderType: FilterType.Theory,
              startDate: DateTime.now(),
              onDateTimeSelected: (date) {
                log(date.toString());
                selectedTheoryDate = date;
              },
              isDiveSession: false,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton.miniFlat(
                  text: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                AppButton.miniFlat(
                  text: 'Okay',
                  onTap: () {
                    controller.bookingModel.theoryDate ??= [];
                    controller.bookingModel.theoryDate!.add(selectedTheoryDate);
                    controller.bookingModel.theoryDate =
                        controller.bookingModel.theoryDate!.toSet().toList();
                    controller.update();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      radius: 10,
    );
  }

  createBooking(BuildContext context) async {
    List<String> bookingDates = [];

    if (controller.isQuickBooking) {
      if (isValid()) {
        controller.showLoading = true;
        for (var element in controller.quickDiveDates!) {
          bookingDates.add(getStringDate(element!));
        }

        Booking bookingModel = Booking(
          id: '',
          details: BookingDetails(
            firstName: controller.fNameTED.text,
            lastName: controller.lNameTED.text,
            dob: Timestamp.fromDate(DateTime.now()),
            email: 'quickBooking@temple.com',
            gender: controller.genderTED.text,
            countryCode: '+91',
            isoCode: 'IN',
            phoneNumber: '9876543210',
          ),
          activity: [controller.quickSelectedActivity!],
          noOfPersons: int.parse(controller.paxTED.text),
          diveDate: controller.quickDiveDates,
          bookingDate: bookingDates,
          employeeName: currentEmployee?.name ?? 'quick',
          paymentMode: 'Cash',
          paymentTransactionId: 'quickBooking',
          theoryDate: [],
          poolDate: [],
          receiptNo: 'quick',
          remarks: 'quick',
          idProofs: [],
          payments: [],
          createdAt: DateTime.now(),
          isQuickBooking: true,
          price: ((controller.quickSelectedActivity?.price ?? 0) * 1.0) *
              int.parse(controller.paxTED.text),
        );

        controller.bookingId = await BookingRepo.addNewBooking(bookingModel);
        LogModel logModel = LogModel(
          type: LogType.quickBookingCreated,
          bookingId: controller.bookingId,
        );
        FirebaseFirestore.instance
            .collection('logs')
            .doc()
            .set(logModel.toMap());
        controller.showLoading = false;
        controller.reset();
        if (context.mounted) {
          Navigator.pop(context);
        }
        controller.update();

        return;
      } else {
        showToast('Invalid  input');
        return;
      }
    }

    controller.bookingModel.bookingDate = [];
    if (controller.bookingModel.theoryDate != null &&
        controller.bookingModel.theoryDate!.isNotEmpty) {
      for (var element in controller.bookingModel.theoryDate!) {
        controller.bookingModel.bookingDate!.add(getStringDate(element!));
      }
    }
    if (controller.bookingModel.poolDate != null &&
        controller.bookingModel.poolDate!.isNotEmpty) {
      for (var element in controller.bookingModel.poolDate!) {
        controller.bookingModel.bookingDate!.add(getStringDate(element!));
      }
    }
    if (controller.bookingModel.diveDate != null &&
        controller.bookingModel.diveDate!.isNotEmpty) {
      for (var element in controller.bookingModel.diveDate!) {
        controller.bookingModel.bookingDate!.add(getStringDate(element!));
      }
    }
    createCustomer();

    controller.bookingId =
        await BookingRepo.addNewBooking(controller.bookingModel);
    LogModel logModel =
        LogModel(type: LogType.bookingCreated, bookingId: controller.bookingId);
    FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());
    controller.update();
  }

  onContinueChooseDatesPressed(BuildContext context) {
    if (controller.bookingModel.activity != null) {
      if ((controller.bookingModel.theoryDate != null &&
              controller.bookingModel.theoryDate!.isNotEmpty) ||
          (controller.bookingModel.poolDate != null &&
              controller.bookingModel.poolDate!.isNotEmpty) ||
          (controller.bookingModel.diveDate != null &&
              controller.bookingModel.diveDate!.isNotEmpty)) {
        Navigator.push(context, NewBookingView.route());
      } else {
        showToast('Please select at-least one session');
      }
    } else {
      showToast('Please select Activity');
    }
  }

  void onCheckPressed(BuildContext context) {
    if (isValid()) {
      controller.bookingModel.details = BookingDetails(
        firstName: controller.fNameTED.text,
        lastName: controller.lNameTED.text,
        dob:
            controller.dob != null ? Timestamp.fromDate(controller.dob!) : null,
        email: controller.emailTED.text,
        gender: controller.genderTED.text,
        countryCode: controller.countryCodeTED.text,
        isoCode: controller.isoCode ?? 'IN',
        phoneNumber: controller.phoneNumberTED.text,
      );
      controller.bookingModel.noOfPersons = getInt(controller.paxTED.text);
      disposeKeyboard();
      Navigator.push(context, BookDateTimeView.route());
    } else {
      log('not allowed');
    }
  }

  clear() {
    controller.nameError = null;
    controller.emailError = null;
    controller.phoneError = null;
    controller.genderError = null;
    controller.dobError = null;
    controller.paxError = null;
    controller.quickDiveDateError = null;
    controller.quickActivityError = null;
    controller.update();
  }

  bool isValid() {
    bool isValid = true;
    clear();

    if (controller.isQuickBooking) {
      if (controller.fNameTED.text.isEmpty) {
        controller.nameError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.paxTED.text.isEmpty) {
        controller.paxError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.quickSelectedActivity == null) {
        controller.quickActivityError = 'Required';
        isValid = false;
        controller.update();
      }
      if ((controller.quickDiveDates ?? []).isEmpty) {
        controller.quickDiveDateError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.genderTED.text.isEmpty) {
        controller.genderError = 'Required';
        isValid = false;
        controller.update();
      }

      return isValid;
    } else {
      if (controller.fNameTED.text.isEmpty) {
        controller.nameError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.emailTED.text.isEmpty) {
        controller.emailError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.phoneNumberTED.text.isEmpty) {
        controller.phoneError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.genderTED.text.isEmpty) {
        controller.genderError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.dobTED.text.isEmpty) {
        controller.dobError = 'Required';
        isValid = false;
        controller.update();
      }
      if (controller.paxTED.text.isEmpty) {
        controller.paxError = 'Required';
        isValid = false;
        controller.update();
      }
      return isValid;
    }
  }

  Future<bool> isCustomerExists() async {
    var d = await FirebaseFirestore.instance
        .collection('customers')
        .doc(controller.emailTED.text)
        .get();
    Map<String, dynamic>? data = d.data();
    if (data == null) return false;
    controller.customerModel = CustomerModel.fromMap(data);
    controller.fNameTED.text = controller.customerModel.firstName ?? '';
    controller.lNameTED.text = controller.customerModel.lastName ?? '';
    controller.phoneNumberTED.text = controller.customerModel.phoneNumber ?? '';
    controller.countryCodeTED.text =
        ((controller.customerModel.countryCode != null &&
                controller.customerModel.countryCode!.isNotEmpty)
            ? controller.customerModel.countryCode!
            : '+91');
    if (controller.customerModel.dateOfBirth != null) {
      controller.dob = controller.customerModel.dateOfBirth;
      controller.dobTED.text = DateFormat('dd MMM, yyyy')
          .format(controller.customerModel.dateOfBirth!);
    }
    controller.genderTED.text = ((controller.customerModel.gender != null) &&
            (controller.customerModel.gender!.isNotEmpty))
        ? controller.customerModel.gender!
        : '';
    controller.update();

    return true;
  }
}

class NewBookingController extends GetxController {
  String? _bookingId;

  TextEditingController emailTED = TextEditingController();
  TextEditingController fNameTED = TextEditingController();
  TextEditingController lNameTED = TextEditingController();
  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController remarksTED = TextEditingController();
  TextEditingController priceTED = TextEditingController();
  TextEditingController genderTED = TextEditingController();

  Activity? quickSelectedActivity;
  List<DateTime?>? quickDiveDates;
  List<String> gender = ['Male', 'Female'];
  String? nameError;
  String? emailError;
  String? phoneError;
  String? genderError;
  String? dobError;
  String? paxError;
  String? quickDiveDateError;
  String? quickActivityError;

  FocusNode emailNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode remarksNode = FocusNode();
  FocusNode dobNode = FocusNode();

  AutoScrollController autoScrollController = AutoScrollController();
  CustomerModel customerModel = CustomerModel();

  String _diveLocation = 'Pondicherry';

  bool _discountSwitch = true;
  bool _isQuickBooking = false;

  DateTime _paymentDate = DateTime.now();

  bool _taxable = true;

  bool customerExist = false;

  bool _getDetailsPressed = false;

  DateTime get paymentDate => _paymentDate;

  String? get bookingId => _bookingId;

  bool get discountSwitch => _discountSwitch;

  bool get taxable => _taxable;

  bool get getDetailsPressed => _getDetailsPressed;

  bool get isQuickBooking => _isQuickBooking;

  set isQuickBooking(bool value) {
    _isQuickBooking = value;
    update();
  }

  set getDetailsPressed(bool value) {
    _getDetailsPressed = value;
    update();
  }

  set taxable(bool value) {
    _taxable = value;
    update();
  }

  set paymentDate(DateTime value) {
    _paymentDate = value;
    update();
  }

  set discountSwitch(bool value) {
    _discountSwitch = value;
    update();
  }

  set bookingId(String? value) {
    _bookingId = value;
    update();
  }

  List<String> paymentOptions = [
    'Cash',
    'Razor Pay',
    'Bank Transfer',
    'UPI',
    'Card',
    'Rose',
    'QR',
  ];

  TextEditingController locationTED = TextEditingController();
  FocusNode locationNode = FocusNode();

  Booking _bookingModel = Booking();

  FocusNode noOfPersonsNode = FocusNode();
  FocusNode payingNowNode = FocusNode();
  FocusNode discountNode = FocusNode();
  FocusNode discountOptionsNode = FocusNode();
  FocusNode paymentReferenceNode = FocusNode();
  FocusNode receiptNoNode = FocusNode();

  TextEditingController paxTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController discountTED = TextEditingController();
  TextEditingController payingNowTED = TextEditingController();
  TextEditingController paymentModeTED = TextEditingController();
  TextEditingController paymentReferenceTED = TextEditingController();
  TextEditingController receiptNoTED = TextEditingController();
  TextEditingController dobTED = TextEditingController();

  DateTime? _dob = DateTime.now();
  Activity? selectedActivity;

  double _cost = 0;
  double _balance = 0;
  double _discount = 0;
  double _totalCost = 0;
  double _taxableAmount = 0;

  List<Activity> activities = [];

  reset() {
    dobTED.text = '';
    _dob = null;
    _bookingId = null;
    _diveLocation = 'Pondicherry';
    _discountSwitch = true;
    _paymentDate = DateTime.now();
    locationTED.text = '';
    bookingModel = Booking();
    emailTED.text = '';
    fNameTED.text = '';
    lNameTED.text = '';
    paxTED.text = '';
    priceTED.text = '';
    discountTED.text = '';
    payingNowTED.text = '';
    paymentModeTED.text = '';
    paymentReferenceTED.text = '';
    phoneNumberTED.text = '';
    countryCodeTED.text = '';
    remarksTED.text = '';
    receiptNoTED.text = '';
    selectedActivity = null;
    _isoCode = 'IN';
    _cost = 0;
    _taxableAmount = 0;
    _balance = 0;
    _discount = 0;
    _totalCost = 0;
    activities = [];
    taxable = true;
    showLoading = false;
    getDetailsPressed = false;
    isQuickBooking = false;
    quickDiveDates = [];
    quickSelectedActivity = null;
    genderTED.text = '';
    nameError = null;
    paxError = null;
    dobError = null;
    phoneError = null;
    genderError = null;
    emailError = null;
    quickDiveDateError = null;
    quickActivityError = null;
  }

  bool _showLoading = true;

  String? _isoCode = 'IN';

  String? get isoCode {
    return _isoCode;
  }

  String get diveLocation => _diveLocation;

  DateTime? get dob => _dob;

  set dob(DateTime? value) {
    _dob = value;
    update();
  }

  bool get showLoading => _showLoading;

  double get cost => _cost;

  double get balance => _balance;

  double get totalCost => _totalCost;

  double get discount => _discount;

  Booking get bookingModel => _bookingModel;

  double get taxableAmount => _taxableAmount;

  set taxableAmount(double value) {
    _taxableAmount = value;
    update();
  }

  set isoCode(String? value) {
    _isoCode = value;
    update();
  }

  set diveLocation(String value) {
    _diveLocation = value;
    update();
  }

  set bookingModel(Booking value) {
    _bookingModel = value;
    update();
  }

  set discount(double value) {
    _discount = value;
    update();
  }

  set totalCost(double value) {
    _totalCost = value;
    update();
  }

  set balance(double value) {
    _balance = value;
    update();
  }

  set cost(double value) {
    _cost = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }
}
