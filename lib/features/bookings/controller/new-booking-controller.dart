import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/constants/enums.dart';
import 'package:temple_adventures/core/services/firebase_api.dart';
import 'package:temple_adventures/core/util/utils.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/booking_calender_widget_old/booking_calender_old.dart';
import 'package:temple_adventures/core/widgets/booking_calender_widget_old/bookings_calender_widget_controller_old.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/models/customer-model.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/payment-details-screen.dart';
import 'package:temple_adventures/features/dashboard/controller/dashboard-controller.dart';
import 'package:temple_adventures/features/dashboard/presentation/screens/dashboard-screen.dart';
import 'package:temple_adventures/features/employees/model/employee.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';

class NewBookingLogic {
  NewBookingLogic() {
    this.getDataFromFireBase();
  }

  NewBookingController controller = Get.put(NewBookingController());
  final AutoScrollController autoScrollControllerTheory = AutoScrollController();
  final AutoScrollController autoScrollControllerPool = AutoScrollController();
  final AutoScrollController autoScrollControllerDive = AutoScrollController();

  Future<void> getDetailsPressed() async {
    controller.showLoading = true;
    controller.customerExist = await isCustomerExists();
    controller.getDetailsPressed = true;
    controller.showLoading = false;
  }

  getDataFromFireBase() async {
    QuerySnapshot<Map<String, dynamic>> catalogue = await FirebaseFirestore.instance.collection('catalogue').get();
    controller.activities = [];
    for (int i = 0; i < catalogue.docs.length; i++) {
      if (catalogue.docs[i].id == 'colors') continue;
      Activity activity = Activity.fromMap(catalogue.docs[i].data());
      controller.activities.add(activity);
      controller.activities.sort((a1, a2) => a2.priority!.compareTo(a1.priority!));
      controller.showLoading = false;
    }
  }

  onContinuePressedBookingForm() {
    controller.bookingModel.remarks = controller.remarksTED.text.toString();
    controller.bookingModel.employeeName = currentEmployee!.firstName! + currentEmployee!.lastName!;
    if (controller.payingNowTED.text == "" || int.parse(controller.payingNowTED.text) == 0) {
      createCustomer();
      createBooking();
      Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        titlePadding: EdgeInsets.all(0),
        titleStyle: TextStyle(fontSize: 0),
        content: GetBuilder<NewBookingController>(builder: (controller) {
          if (controller.bookingId != null)
            return Column(
              children: [
                SizedBox(height: 50),
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.background.skyBlue,
                  size: 30,
                ),
                SizedBox(height: 20),
                Text(
                  controller.bookingId!,
                  style: TextStyle(fontSize: FontSize.title),
                ),
                Text("Booking Created Successfully"),
                SizedBox(height: 20),
                AppButton.miniFlat(
                  text: "Okay",
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                  onTap: () async {
                    Get.offAllNamed(DashBoardScreen.id);
                    DashBoardScreenLogic dashboardlogic = DashBoardScreenLogic();
                    dashboardlogic.controller.currentIndex = 2;
                    controller.reset();
                    BookingsCalenderWidgetLogic bookingCalenderLogic = BookingsCalenderWidgetLogic();
                    bookingCalenderLogic.onDateSelected(bookingCalenderLogic.controller.lastDateIndex);
                  },
                )
              ],
            );
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 1,
              ),
            ),
          );
        }),
      );
    } else
      Get.toNamed(PaymentDetailsScreen.id);
  }

  Future<void> createCustomer() async {
    CustomerModel customer = CustomerModel(
        countryCode: controller.countryCodeTED.text,
        firstName: controller.fNameTED.text,
        lastName: controller.lNameTED.text,
        email: controller.emailTED.text,
        phoneNumber: controller.phoneNumberTED.text,
        idProof: "",
        gender: "",
        dob: controller.dob.toString());
    await FirebaseFirestore.instance.collection("customers").doc(controller.emailTED.text).set(customer.toMap());
  }

  onPaymentDetailsFilled() {
    if (controller.paymentModeTED.text != "") {
      controller.bookingModel.paymentMode = controller.paymentModeTED.text;
      controller.bookingModel.paymentTransactionId = controller.paymentReferenceTED.text;
      controller.bookingModel.receiptNo = controller.receiptNoTED.text;
      createCustomer();
      createBooking();
      Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        titlePadding: EdgeInsets.all(0),
        titleStyle: TextStyle(fontSize: 0),
        content: GetBuilder<NewBookingController>(builder: (controller) {
          if (controller.bookingId != null)
            return Column(
              children: [
                SizedBox(height: 50),
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.background.skyBlue,
                  size: 30,
                ),
                SizedBox(height: 20),
                Text(
                  controller.bookingId!,
                  style: TextStyle(fontSize: FontSize.title),
                ),
                Text("Booking Created Successfully"),
                SizedBox(height: 20),
                AppButton.miniFlat(
                  text: "Okay",
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                  onTap: () async {
                    Get.offAllNamed(DashBoardScreen.id);
                    dashboardLogic.controller.currentIndex = 2;
                    controller.reset();
                    BookingsCalenderWidgetLogic bookingCalenderLogic = BookingsCalenderWidgetLogic();
                    bookingCalenderLogic.onDateSelected(bookingCalenderLogic.controller.lastDateIndex);
                  },
                )
              ],
            );
          return Container(
            height: 150,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 1,
              ),
            ),
          );
        }),
      );
    } else {
      showToast("Invalid Input");
    }
  }

  paymentDatePicker(context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().subtract(Duration(days: 36500)),
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
      minTime: DateTime.now().subtract(Duration(days: 36500)),
      maxTime: DateTime.now().subtract(Duration(days: 2920)),
      onChanged: (date) {
        controller.dob = date;
        controller.dobTED.text = DateFormat("dd MMM, yyyy").format(date);
      },
      onConfirm: (date) {
        controller.dob = date;
        controller.dobTED.text = DateFormat("dd MMM, yyyy").format(date);
        controller.update();
      },
      currentTime: controller.dob,
      // theme: DatePickerTheme(
      //   cancelStyle: TextStyle(
      //     fontFamily: AppFonts.nunito,
      //     color: Colors.black87,
      //   ),
      //   doneStyle: TextStyle(
      //     fontFamily: AppFonts.nunito,
      //     fontWeight: FontWeight.bold,
      //     color: Colors.black,
      //   ),
      //   itemStyle: TextStyle(
      //     fontFamily: AppFonts.nunito,
      //     fontWeight: FontWeight.bold,
      //     fontSize: 16,
      //   ),
      // ),
    );
  }

  addPoolSessionDateTime() {
    DateTime? selectedPoolDate;
    Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.all(0),
      titleStyle: TextStyle(fontSize: 0, height: 0),
      content: Container(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Choose Date",
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
                // //print("updated");
                selectedPoolDate = date;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppButton.miniText(
                  text: "Cancel",
                  onTap: () {
                    Get.back();
                  },
                ),
                AppButton.miniFlat(
                  text: "Okay",
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                  onTap: () {
                    if (controller.bookingModel.poolDate == null) controller.bookingModel.poolDate = [];
                    controller.bookingModel.poolDate!.add(selectedPoolDate);
                    controller.bookingModel.poolDate = controller.bookingModel.poolDate!.toSet().toList();
                    // //print(controller.bookingModel.poolDate);
                    controller.update();
                    Get.back();
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

  addDiveSessionDateTime() {
    DateTime? selectedDiveDate;
    Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.all(0),
      titleStyle: TextStyle(fontSize: 0, height: 0),
      content: Container(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Choose Date",
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
                AppButton.miniText(
                  text: "Cancel",
                  onTap: () {
                    Get.back();
                  },
                ),
                AppButton.miniFlat(
                  text: "Okay",
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                  onTap: () {
                    if (controller.bookingModel.diveDate == null) controller.bookingModel.diveDate = [];
                    controller.bookingModel.diveDate!.add(selectedDiveDate);
                    controller.bookingModel.diveDate = controller.bookingModel.diveDate!.toSet().toList();
                    controller.update();
                    Get.back();
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

  addQuickDiveSessionDateTime() {
    DateTime? selectedDiveDate;
    Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.all(0),
      titleStyle: TextStyle(fontSize: 0, height: 0),
      content: Container(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Choose Date",
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
                AppButton.miniText(
                  text: "Cancel",
                  onTap: () {
                    Get.back();
                  },
                ),
                AppButton.miniFlat(
                  text: "Okay",
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                  onTap: () {
                    if (controller.quickDiveDates == null) controller.quickDiveDates = [];
                    controller.quickDiveDates!.add(selectedDiveDate);
                    controller.quickDiveDates = controller.quickDiveDates!.toSet().toList();
                    controller.update();
                    Get.back();
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

  addTheorySessionDateTime() {
    DateTime? selectedTheoryDate;
    Get.defaultDialog(
      title: "",
      titlePadding: EdgeInsets.all(0),
      titleStyle: TextStyle(fontSize: 0, height: 0),
      content: Container(
        height: 480,
        width: 400,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Choose Date",
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
                AppButton.miniText(
                  text: "Cancel",
                  onTap: () {
                    Get.back();
                  },
                ),
                AppButton.miniFlat(
                  text: "Okay",
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                  onTap: () {
                    if (controller.bookingModel.theoryDate == null) controller.bookingModel.theoryDate = [];
                    controller.bookingModel.theoryDate!.add(selectedTheoryDate);
                    controller.bookingModel.theoryDate = controller.bookingModel.theoryDate!.toSet().toList();
                    //log(controller.bookingModel.theoryDate.toString());
                    controller.update();
                    Get.back();
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

  createBooking() async {
    if (controller.isQuickBooking) {
      List<String> bookingDates = [];

      if (controller.quickNameTED.text != "" &&
          controller.quickNoOfPersonsTED.text != "" &&
          controller.quickSelectedActivity != null) {
        controller.quickShowLoading = true;
        if (controller.quickDiveDates != null && controller.quickDiveDates!.isNotEmpty) {
          controller.quickDiveDates!.forEach((element) {
            bookingDates.add(getStringDate(element!));
          });
        }

        Booking bookingModel = Booking(
          activity: [controller.quickSelectedActivity!],
          noOfPersons: int.parse(controller.quickNoOfPersonsTED.text),
          id: controller.quickBookingIdTED.text,
          pax: [
            {
              "first-name": controller.quickNameTED.text,
              "email": "quickBooking@temple.com",
              "last-name": "",
              "countryCode": "+91",
              "phoneNumber": "9876543210",
              "isoCode": "IN",
              "dob": DateTime.now(),
            }
          ],
          diveDate: controller.quickDiveDates,
          bookingDate: bookingDates,
          employeeName: currentEmployee?.name ?? "quick",
          paymentMode: "Cash",
          paymentTransactionId: "quickBooking",
          theoryDate: [],
          poolDate: [],
          receiptNo: "quick",
          remarks: "quick",
          idProofs: [],
          payments: [],
          createdAt: DateTime.now(),
          isQuickBooking: true,
          parentBookingId: controller.quickBookingIdTED.text,
        );

        controller.bookingId = await FirebaseApi.addNewBooking(bookingModel);
        LogModel logModel = LogModel(type: LogType.quickBookingCreated, bookingId: controller.bookingId);
        FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());
        controller.quickShowLoading = false;
        controller.reset();
        Get.back();
        controller.update();

        return;
      } else {
        showToast("Invalid  input");
        return;
      }
    }

    controller.bookingModel.bookingDate = [];
    if (controller.bookingModel.theoryDate != null && controller.bookingModel.theoryDate!.isNotEmpty) {
      controller.bookingModel.theoryDate!.forEach((element) {
        controller.bookingModel.bookingDate!.add(getStringDate(element!));
      });
    }
    if (controller.bookingModel.poolDate != null && controller.bookingModel.poolDate!.isNotEmpty) {
      controller.bookingModel.poolDate!.forEach((element) {
        controller.bookingModel.bookingDate!.add(getStringDate(element!));
      });
    }
    if (controller.bookingModel.diveDate != null && controller.bookingModel.diveDate!.isNotEmpty) {
      controller.bookingModel.diveDate!.forEach((element) {
        controller.bookingModel.bookingDate!.add(getStringDate(element!));
      });
    }
    controller.bookingId = await FirebaseApi.addNewBooking(controller.bookingModel);
    LogModel logModel = LogModel(type: LogType.bookingCreated, bookingId: controller.bookingId);
    FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());
    controller.update();
  }

  onContinueChooseDatesPressed() {
    if (controller.bookingModel.activity != null) {
      if ((controller.bookingModel.theoryDate != null && controller.bookingModel.theoryDate!.isNotEmpty) ||
          (controller.bookingModel.poolDate != null && controller.bookingModel.poolDate!.isNotEmpty) ||
          (controller.bookingModel.diveDate != null && controller.bookingModel.diveDate!.isNotEmpty)) {
        Get.toNamed(NewBookingScreen.id);
      } else
        showToast("Please select at-least one session");
    } else {
      showToast("Please select Activity");
    }
  }

  void onCheckPressed() {
    if (controller.emailTED.text != "" &&
        controller.fNameTED.text != "" &&
        controller.paxTED.text != "" &&
        controller.phoneNumberTED.text != "") {
      controller.bookingModel.pax = [];
      controller.bookingModel.pax!.add({
        "email": controller.emailTED.text,
        "first-name": controller.fNameTED.text,
        "last-name": controller.lNameTED.text,
        "countryCode": controller.countryCodeTED.text,
        "phoneNumber": controller.phoneNumberTED.text,
        "isoCode": controller.isoCode,
        "dob": controller.dob,
      });
      log(controller.dob.toString());
      log("country code${controller.countryCodeTED.text}");
      controller.bookingModel.noOfPersons = getInt(controller.paxTED.text);
      disposeKeyboard();
      Get.toNamed(BookDateTime.id);
    } else {
      log("not allowed");
      showToast("Invalid Input");
    }
  }

  Future<bool> isCustomerExists() async {
    var d = await FirebaseFirestore.instance.collection("customers").doc(controller.emailTED.text).get();
    Map<String, dynamic>? data = d.data();
    if (data == null) return false;
    controller.customerModel = CustomerModel.fromMap(data);
    log(controller.customerModel.toMap().toString());
    controller.fNameTED.text = controller.customerModel.firstName ?? "";
    controller.lNameTED.text = controller.customerModel.lastName ?? "";
    controller.phoneNumberTED.text = controller.customerModel.phoneNumber ?? "";
    controller.countryCodeTED.text =
        ((controller.customerModel.countryCode != null && controller.customerModel.countryCode!.isNotEmpty)
            ? controller.customerModel.countryCode
            : "+91")!;
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
  TextEditingController quickBookingIdTED = TextEditingController();
  TextEditingController quickNameTED = TextEditingController();
  TextEditingController quickNoOfPersonsTED = TextEditingController();
  Activity? quickSelectedActivity;
  List<DateTime?>? quickDiveDates;

  bool _quickShowLoading = false;

  bool get quickShowLoading => _quickShowLoading;

  set quickShowLoading(bool value) {
    _quickShowLoading = value;
    update();
  }

  FocusNode emailNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode remarksNode = FocusNode();
  FocusNode dobNode = FocusNode();

  AutoScrollController autoScrollController = AutoScrollController();
  CustomerModel customerModel = CustomerModel();

  String _diveLocation = "Pondicherry";

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
    dobTED.text = "";
    _dob = null;
    _bookingId = null;
    _diveLocation = "Pondicherry";
    _discountSwitch = true;
    _paymentDate = DateTime.now();
    locationTED.text = "";
    bookingModel = Booking();
    emailTED.text = "";
    fNameTED.text = "";
    lNameTED.text = "";
    paxTED.text = "";
    priceTED.text = "";
    discountTED.text = "";
    payingNowTED.text = "";
    paymentModeTED.text = "";
    paymentReferenceTED.text = "";
    phoneNumberTED.text = "";
    countryCodeTED.text = "";
    remarksTED.text = "";
    receiptNoTED.text = "";
    selectedActivity = null;
    _isoCode = "IN";
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
    quickShowLoading = false;
    quickNoOfPersonsTED.text = "";
    quickDiveDates = [];
    quickSelectedActivity = null;
    quickNameTED.text = "";
    quickBookingIdTED.text = "";
  }

  bool _showLoading = true;

  String? _isoCode = "IN";

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
