import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/services/firebase_api.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/models/customer-model.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/book-date-time-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/new-booking-screen.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/payment-details-screen.dart';
import 'package:temple_adventures/features/dashboard/controller/dashboard-controller.dart';
import 'package:temple_adventures/features/dashboard/presentation/screens/dashboard-screen.dart';
import 'package:temple_adventures/features/home/model/employee.dart';
import 'package:temple_adventures/features/logs/models/log-model.dart';
import 'package:temple_adventures/features/logs/presentation/screens/log-screen.dart';

class NewBookingLogic {
  NewBookingLogic() {
    this.getDataFromFireBase();
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
      ActivityModel activity = ActivityModel.fromMap(catalogue.docs[i].data());
      controller.activities.add(activity);
      controller.activities
          .sort((a1, a2) => a2.priority.compareTo(a1.priority));
      controller.showLoading = false;
    }
  }

  onContinuePressedBookingForm() {
    controller.bookingModel.remarks = controller.remarksTED.text.toString();
    controller.bookingModel.employeeName =
        currentEmployee.firstName + currentEmployee.lastName;
    if (controller.payingNowTED.text == "" ||
        controller.payingNowTED.text == 0.toString()) {
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
                  controller.bookingId,
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
                    DashBoardScreenLogic dashboardlogic =
                        DashBoardScreenLogic();
                    dashboardlogic.controller.currentIndex = 2;
                    controller.reset();
                    BookingsCalenderWidgetLogic bookingCalenderLogic =
                        BookingsCalenderWidgetLogic();
                    bookingCalenderLogic.onDateSelected(
                        bookingCalenderLogic.controller.lastDateIndex);
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
    );
    await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .set(customer.toMap());
  }

  onPaymentDetailsFilled() {
    if (controller.paymentModeTED.text != "") {
      controller.bookingModel.paymentMode = controller.paymentModeTED.text;
      controller.bookingModel.paymentTransactionId =
          controller.paymentReferenceTED.text;
      if (controller.receiptNoTED.text == "") {
        controller.bookingModel.receiptNo = "";
      } else
        controller.bookingModel.receiptNo = controller.receiptNoTED.text;
      // Get.toNamed(AddCustomerDetailsScreen.id);
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
                  controller.bookingId,
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
                    BookingsCalenderWidgetLogic bookingCalenderLogic =
                        BookingsCalenderWidgetLogic();
                    bookingCalenderLogic.onDateSelected(
                        bookingCalenderLogic.controller.lastDateIndex);
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

  datePicker(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now().subtract(Duration(days: 36500)),
        maxTime: DateTime.now(), onChanged: (date) {
      // //print('change $date');
      controller.paymentDate = date;
    }, onConfirm: (date) {
      // //print('confirm $date');
      controller.paymentDate = date;
      controller.update();
    },
        currentTime: controller.paymentDate,
        theme: DatePickerTheme(
          cancelStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            color: Colors.black87,
          ),
          doneStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          itemStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ));
  }

  addPoolSessionDateTime() {
    DateTime selectedPoolDate;
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
            BookingsCalenderWidget(
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
                    if (controller.bookingModel.poolDate == null)
                      controller.bookingModel.poolDate = [];
                    controller.bookingModel.poolDate.add(selectedPoolDate);
                    controller.bookingModel.poolDate =
                        controller.bookingModel.poolDate.toSet().toList();
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
    DateTime selectedDiveDate;
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
            BookingsCalenderWidget(
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
                    if (controller.bookingModel.diveDate == null)
                      controller.bookingModel.diveDate = [];
                    controller.bookingModel.diveDate.add(selectedDiveDate);
                    controller.bookingModel.diveDate =
                        controller.bookingModel.diveDate.toSet().toList();

                    //print(controller.bookingModel.diveDate);
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
    DateTime selectedTheoryDate;
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
            BookingsCalenderWidget(
              autoScrollController: autoScrollControllerTheory,
              highlightInvalidTime: true,
              calenderType: FilterType.Theory,
              startDate: DateTime.now(),
              onDateTimeSelected: (date) {
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
                    if (controller.bookingModel.theoryDate == null)
                      controller.bookingModel.theoryDate = [];
                    controller.bookingModel.theoryDate.add(selectedTheoryDate);
                    controller.bookingModel.theoryDate =
                        controller.bookingModel.theoryDate.toSet().toList();
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
    //print("createBooking");
    controller.bookingModel.bookingDate = [];

    if (controller.bookingModel.theoryDate != null &&
        controller.bookingModel.theoryDate.isNotEmpty) {
      controller.bookingModel.theoryDate.forEach((element) {
        //print(getStringDate(element));
        controller.bookingModel.bookingDate.add(getStringDate(element));
      });
    }
    if (controller.bookingModel.poolDate != null &&
        controller.bookingModel.poolDate.isNotEmpty) {
      controller.bookingModel.poolDate.forEach((element) {
        //print(getStringDate(element));
        controller.bookingModel.bookingDate.add(getStringDate(element));
      });
    }
    if (controller.bookingModel.diveDate != null &&
        controller.bookingModel.diveDate.isNotEmpty) {
      controller.bookingModel.diveDate.forEach((element) {
        //print(getStringDate(element));
        controller.bookingModel.bookingDate.add(getStringDate(element));
      });
    }
    // controller.bookingModel.payments = [controller.bookingModel.paid];
    try {
      log(controller.bookingModel.toMap().toString());
    } catch (e) {
      print(e);
    }
    log(controller.bookingModel.noOfPersons.toString());
    controller.bookingId =
        await FirebaseApi.addNewBooking(controller.bookingModel);
    LogModel logModel =
        LogModel(type: LogType.bookingCreated, bookingId: controller.bookingId);
    FirebaseFirestore.instance.collection("logs").doc().set(logModel.toMap());
    controller.update();
  }

  onContinueChooseDatesPressed() {
    if (controller.bookingModel.theoryDate != null ||
        controller.bookingModel.poolDate != null ||
        controller.bookingModel.diveDate != null) {
      Get.toNamed(NewBookingScreen.id);
      //log((controller.bookingModel.pax).toString());
      // createBooking();
      // Get.defaultDialog(
      //   title: "",
      //   titlePadding: EdgeInsets.all(0),
      //   titleStyle: TextStyle(fontSize: 0),
      //   content: GetBuilder<NewBookingController>(builder: (controller) {
      //     if (controller.bookingId != null)
      //       return Column(
      //         children: [
      //           SizedBox(height: 50),
      //           Icon(
      //             Icons.check_circle_outline_rounded,
      //             color: AppColors.background.skyBlue,
      //             size: 30,
      //           ),
      //           SizedBox(height: 20),
      //           Text(
      //             controller.bookingId,
      //             style: TextStyle(fontSize: FontSize.title),
      //           ),
      //           Text("Booking Created Successfully"),
      //           SizedBox(height: 20),
      //           AppButton.miniFlat(
      //             text: "Okay",
      //             bgColor: AppColors.background.black,
      //             textColor: AppColors.text.white,
      //             onTap: () async {
      //               DashBoardScreenLogic dashboardlogic =
      //                   DashBoardScreenLogic();
      //               dashboardlogic.controller.currentIndex = 0;
      //               Get.offAllNamed(DashBoardScreen.id);
      //               controller.reset();
      //             },
      //           )
      //         ],
      //       );
      //     return Container(
      //       height: 150,
      //       child: Center(
      //         child: CircularProgressIndicator(
      //           color: Colors.black,
      //           strokeWidth: 1,
      //         ),
      //       ),
      //     );
      //   }),
      // );
    } else
      showToast("Please select at-least one session");
  }

  void onCheckPressed() {
    if (controller.emailTED.text != "" &&
        controller.fNameTED.text != "" &&
        controller.paxTED.text != "" &&
        controller.phoneNumberTED.text != "") {
      controller.bookingModel.pax = [];
      controller.bookingModel.pax.add({
        "email": controller.emailTED.text,
        "first-name": controller.fNameTED.text,
        "last-name": controller.lNameTED.text,
        "countryCode": controller.countryCodeTED.text,
        "phoneNumber": controller.phoneNumberTED.text,
        "isoCode": controller.isoCode,
      });
      controller.bookingModel.noOfPersons = getInt(controller.paxTED.text);
      disposeKeyboard();
      Get.toNamed(BookDateTime.id);
      //log((controller.bookingModel.pax).toString());
    } else {
      showToast("Invalid Input");
    }
  }

  Future<bool> isCustomerExists() async {
    var d = await FirebaseFirestore.instance
        .collection("customers")
        .doc(controller.emailTED.text)
        .get();
    Map<String, dynamic> data = d.data();
    if (data == null) return false;
    controller.customerModel = CustomerModel.fromMap(data);
    log(controller.customerModel.toMap().toString());
    controller.fNameTED.text = controller.customerModel.firstName;
    controller.lNameTED.text = controller.customerModel.lastName;
    controller.phoneNumberTED.text = controller.customerModel.phoneNumber;
    controller.countryCodeTED.text = controller.customerModel.countryCode;
    return true;
  }
}

class NewBookingController extends GetxController {
  String _bookingId;

  TextEditingController emailTED = TextEditingController();
  TextEditingController fNameTED = TextEditingController();
  TextEditingController lNameTED = TextEditingController();
  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController remarksTED = TextEditingController();
  TextEditingController priceTED = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode remarksNode = FocusNode();

  AutoScrollController autoScrollController = AutoScrollController();
  CustomerModel customerModel = CustomerModel();

  String _diveLocation = "Pondicherry";

  bool _discountSwitch = true;

  DateTime _paymentDate = DateTime.now();

  bool _taxable = true;

  bool customerExist = false;

  bool _getDetailsPressed = false;

  DateTime get paymentDate => _paymentDate;

  String get bookingId => _bookingId;

  bool get discountSwitch => _discountSwitch;

  bool get taxable => _taxable;

  bool get getDetailsPressed => _getDetailsPressed;

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

  set bookingId(String value) {
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

  BookingModel _bookingModel = BookingModel();

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

  List<ActivityModel> selectedActivity = [];

  double _cost = 0;
  double _balance = 0;
  double _discount = 0;
  double _totalCost = 0;
  double _taxableAmount = 0;

  List<ActivityModel> activities = [];

  reset() {
    //print("reset data");
    _bookingId = null;
    _diveLocation = "Pondicherry";
    _discountSwitch = true;
    _paymentDate = DateTime.now();
    locationTED.text = "";
    bookingModel = BookingModel();
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
    selectedActivity = [];
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
  }

  bool _showLoading = true;

  String _isoCode = "IN";

  String get isoCode {
    return _isoCode;
  }

  String get diveLocation => _diveLocation;

  bool get showLoading => _showLoading;

  double get cost => _cost;

  double get balance => _balance;

  double get totalCost => _totalCost;

  double get discount => _discount;

  BookingModel get bookingModel => _bookingModel;

  double get taxableAmount => _taxableAmount;

  set taxableAmount(double value) {
    _taxableAmount = value;
    update();
  }

  set isoCode(String value) {
    _isoCode = value;
    update();
  }

  set diveLocation(String value) {
    _diveLocation = value;
    update();
  }

  set bookingModel(BookingModel value) {
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

///TODO :: Check please
/*
class NewBookingLogic {
  NewBookingLogic() {
    this.getDataFromFireBase();
  }

  NewBookingController controller = Get.put(NewBookingController());

  getDataFromFireBase() async {
    QuerySnapshot<Map<String, dynamic>> catalogue =
        await FirebaseFirestore.instance.collection('catalogue').get();
    controller.activities = [];
    for (int i = 0; i < catalogue.docs.length; i++) {
      ActivityModel activity = ActivityModel.fromMap(catalogue.docs[i].data());
      controller.activities.add(activity);
      controller.activities
          .sort((a1, a2) => a2.priority.compareTo(a1.priority));
      controller.showLoading = false;
    }
  }

  getPrice() {
    var tax;
    //print("getPrice");
    controller.cost = 0;
    for (int i = 0; i < controller.selectedActivity.length; i++) {
      controller.selectedActivity.forEach((activity) {
        //print(activity.price);
        controller.cost += activity.price;
        tax = controller.cost * 0.18;
        controller.cost = controller.cost + tax;
      });
    }
    //print(controller.cost);
    if (controller.paxTED.text != null) {
      try {
        controller.cost = int.parse(controller.paxTED.text) * controller.cost;
      } catch (e) {
        controller.cost = 0;
      }
    }
    getDiscount();
    getTotalAmount();
    getBalanceAmount();
  }

  getTotalAmount() {
    double discountAmount;
    if (controller.discountSwitch) {
      try {
        discountAmount = controller.cost *
            (double.parse(controller.discountTED.text) / 100.0);
      } catch (e) {
        discountAmount = 0;
      }
      return controller.totalCost = controller.cost - discountAmount;
    } else {
      try {
        discountAmount = double.parse(controller.discountTED.text);
      } catch (e) {
        discountAmount = 0;
      }
      return controller.totalCost = controller.cost - discountAmount;
    }
  }

  getDiscount() {
    if (controller.discountSwitch) {
      getDiscountInPercent();
    } else {
      getDiscountInINR();
    }
  }

  getDiscountInPercent() {
    //print("getDiscountPercent");
    try {
      controller.discount =
          controller.cost * (int.parse(controller.discountTED.text) / 100.0);
    } catch (e) {
      controller.discount = 0;
    }
  }

  getDiscountInINR() {
    //print("getDiscountINPNR");
    try {
      controller.discount = double.parse(controller.discountTED.text);
    } catch (e) {
      controller.discount = 0;
    }
  }

  getBalanceAmount() {
    int payingNow;
    try {
      payingNow = int.parse(controller.payingNowTED.text);
    } catch (e) {
      payingNow = 0;
    }
    controller.balance = (controller.totalCost - payingNow).toPrecision(2);
  }

  onContinuePressedBookingForm() {
    if (controller.selectedActivity.length != 0 &&
        controller.paxTED.text != "" &&
        controller.discountTED.text != "" &&
        controller.payingNowTED.text != "" &&
        controller.balance > 0) {
      controller.bookingModel.activity = controller.selectedActivity;
      controller.bookingModel.location = controller.diveLocation;
      try {
        controller.bookingModel.noOfPersons = int.parse(controller.paxTED.text);
      } catch (e) {
        controller.bookingModel.noOfPersons = 0;
      }

      try {
        controller.bookingModel.discount =
            double.parse(controller.discountTED.text);
      } catch (e) {
        controller.bookingModel.discount = 0;
      }

      try {
        controller.bookingModel.paid =
            int.parse(controller.payingNowTED.text).toDouble();
      } catch (e) {
        controller.bookingModel.paid = 0;
      }
      controller.bookingModel.price = controller.cost;
      controller.bookingModel.tax = controller.taxableAmount;
      controller.bookingModel.totalCost = controller.totalCost;
      controller.bookingModel.balance = controller.balance;
      controller.bookingModel.pax = [];
      if (controller.payingNowTED.text == 0.toString())
        Get.toNamed(AddCustomerDetailsScreen.id);
      else
        Get.toNamed(PaymentDetailsScreen.id);
    } else
      showToast("Invalid Balance");
  }

  onPaymentDetailsFilled() {
    if (controller.paymentReferenceTED.text != "" &&
        controller.receiptNoTED.text != "" &&
        controller.paymentModeTED.text != "") {
      controller.bookingModel.paymentMode = controller.paymentModeTED.text;
      controller.bookingModel.paymentTransactionId =
          controller.paymentReferenceTED.text;
      controller.bookingModel.receiptNo = controller.receiptNoTED.text;
      Get.toNamed(AddCustomerDetailsScreen.id);
    } else {
      showToast("Invalid Input");
    }
  }

  datePicker(context) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now().subtract(Duration(days: 36500)),
        maxTime: DateTime.now(), onChanged: (date) {
      //print('change $date');
      controller.paymentDate = date;
    }, onConfirm: (date) {
      //print('confirm $date');
      controller.paymentDate = date;
      controller.update();
    },
        currentTime: controller.paymentDate,
        theme: DatePickerTheme(
          cancelStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            color: Colors.black87,
          ),
          doneStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          itemStyle: TextStyle(
            fontFamily: AppFonts.nunito,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ));
  }

  // onContinuePressedPaymentSuccessfulPage() async {
  //   // //print(controller.bookingModel.toMap());
  //   // var id = await FirebaseApi.addNewBooking(controller.bookingModel);
  //   // //print(id);
  //   Get.toNamed(BookDateTime.id);
  // }

  onChoosePoolSessionPressed() {
    DateTime selectedPoolDate;
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
            BookingsCalenderWidget(
              highlightInvalidTime: true,
              startDate: DateTime.now(),
              onDateTimeSelected: (date) {
                //print("updated");
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
                    controller.bookingModel.poolDate = selectedPoolDate;
                    //print(controller.bookingModel.poolDate);
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

  onChooseDiveSessionPressed() {
    DateTime selectedDiveDate;
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
            BookingsCalenderWidget(
              highlightInvalidTime: true,
              startDate: DateTime.now(),
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
                    controller.bookingModel.diveDate = selectedDiveDate;
                    //print(controller.bookingModel.diveDate);
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

  onChooseTheorySessionPressed() {
    DateTime selectedDiveDate;
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
            BookingsCalenderWidget(
              highlightInvalidTime: true,
              startDate: DateTime.now(),
              onDateTimeSelected: (date) {
                selectedDiveDate = date;
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
                    controller.bookingModel.theoryDate = selectedDiveDate;
                    //print(controller.bookingModel.theoryDate);
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
    //print("createBooking");
    controller.bookingModel.bookingDate = [];
    if (controller.bookingModel.theoryDate != null)
      controller.bookingModel.bookingDate
          .add(getStringDate(controller.bookingModel.theoryDate));
    if (controller.bookingModel.poolDate != null)
      controller.bookingModel.bookingDate
          .add(getStringDate(controller.bookingModel.poolDate));
    if (controller.bookingModel.diveDate != null)
      controller.bookingModel.bookingDate
          .add(getStringDate(controller.bookingModel.diveDate));

    // controller.bookingModel.activity = controller.selectedActivity;
    controller.bookingId =
        await FirebaseApi.addNewBooking(controller.bookingModel);
    //print(controller.bookingId);
    controller.update();
  }

  onContinueChooseDatesPressed() {
    if (controller.bookingModel.theoryDate != null ||
        controller.bookingModel.poolDate != null ||
        controller.bookingModel.diveDate != null) {
      createBooking();
      Get.defaultDialog(
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
                  controller.bookingId,
                  style: TextStyle(fontSize: FontSize.title),
                ),
                Text("Booking Created Successfully"),
                SizedBox(height: 20),
                AppButton.miniFlat(
                  text: "Okay",
                  bgColor: AppColors.background.black,
                  textColor: AppColors.text.white,
                  onTap: () async {
                    DashBoardScreenLogic dashboardlogic =
                        DashBoardScreenLogic();
                    dashboardlogic.controller.currentIndex = 0;
                    Get.offAllNamed(DashBoardScreen.id);
                    controller.reset();
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
      showToast("Please select at-least one session");
  }

  void onCheckPressed() {
    if (controller.emailTED.text != "" &&
        controller.fNameTED.text != "" &&
        controller.lNameTED.text != "") {
      if (controller.bookingModel.pax == null) controller.bookingModel.pax = [];
      controller.bookingModel.pax.add({
        "email": controller.emailTED.text,
        "first-name": controller.fNameTED.text,
        "last-name": controller.lNameTED.text,
        "countryCode": controller.countryCodeTED.text,
        "phoneNumber": controller.phoneNumberTED.text,
        "remarks": controller.remarksTED.text,
      });
      disposeKeyboard();
      Get.toNamed(BookDateTime.id);
    }
  }
}

class NewBookingController extends GetxController {
  String _bookingId;

  TextEditingController emailTED = TextEditingController();
  TextEditingController fNameTED = TextEditingController();
  TextEditingController lNameTED = TextEditingController();
  TextEditingController phoneNumberTED = TextEditingController();
  TextEditingController remarksTED = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();
  FocusNode remarksNode = FocusNode();

  String _diveLocation = "Pondicherry";

  bool _discountSwitch = true;

  DateTime _paymentDate = DateTime.now();

  DateTime get paymentDate => _paymentDate;

  String get bookingId => _bookingId;

  bool get discountSwitch => _discountSwitch;

  set paymentDate(DateTime value) {
    _paymentDate = value;
    update();
  }

  set discountSwitch(bool value) {
    _discountSwitch = value;
    update();
  }

  set bookingId(String value) {
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

  BookingModel _bookingModel = BookingModel();

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

  List<ActivityModel> selectedActivity = [];

  double _cost = 0;
  double _balance = 0;
  double _discount = 0;
  double _totalCost = 0;
  double _taxableAmount = 0;

  List<ActivityModel> activities = [];

  reset() {
    //print("reset data");
    _bookingId = null;
    _diveLocation = "Pondicherry";
    _discountSwitch = true;
    _paymentDate = DateTime.now();
    locationTED.text = "";
    bookingModel = BookingModel();
    emailTED.text = "";
    fNameTED.text = "";
    lNameTED.text = "";
    paxTED.text = "";
    discountTED.text = "";
    payingNowTED.text = "";
    paymentModeTED.text = "";
    paymentReferenceTED.text = "";
    phoneNumberTED.text = "";
    countryCodeTED.text = "";
    remarksTED.text = "";
    receiptNoTED.text = "";
    selectedActivity = [];
    _cost = 0;
    _taxableAmount = 0;
    _balance = 0;
    _discount = 0;
    _totalCost = 0;
    activities = [];
  }

  bool _showLoading = true;
  String _isoCode = "IN";

  String get isoCode => _isoCode;

  String get diveLocation => _diveLocation;

  bool get showLoading => _showLoading;

  double get cost => _cost;

  double get balance => _balance;

  double get totalCost => _totalCost;

  double get discount => _discount;

  BookingModel get bookingModel => _bookingModel;

  double get taxableAmount => _taxableAmount;

  set taxableAmount(double value) {
    _taxableAmount = value;
    update();
  }

  set isoCode(String value) {
    _isoCode = value;
    update();
  }

  set diveLocation(String value) {
    _diveLocation = value;
    update();
  }

  set bookingModel(BookingModel value) {
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
*/
