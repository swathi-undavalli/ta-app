import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:temple_adventures/core/util/app-func.dart';
import 'package:temple_adventures/core/widgets/app-button.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class EditBookingDetailsLogic {
  EditBookingDetailsLogic() {
    getDataFromFireBase();
  }

  EditBookingDetailsController controller =
      Get.put(EditBookingDetailsController());
  DateTime pickedTime = DateTime.now();

  onChoosePoolSessionPressed() {
    DateTime selectedDiveDate = controller.bookingModel.poolDate;

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
                print("updated");
                selectedDiveDate = date;
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
                    if (selectedDiveDate != null &&
                        selectedDiveDate.hour != null &&
                        selectedDiveDate.minute != null &&
                        selectedDiveDate.day != null) {
                      controller.bookingModel.poolDate = selectedDiveDate;
                      print(controller.bookingModel.poolDate);
                      controller.update();
                      Get.back();
                    } else {
                      showToast("Select Time");
                    }
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
    DateTime selectedDiveDate = controller.bookingModel.diveDate;

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
                    if (selectedDiveDate != null &&
                        selectedDiveDate.hour != null &&
                        selectedDiveDate.minute != null &&
                        selectedDiveDate.day != null) {
                      controller.bookingModel.diveDate = selectedDiveDate;
                      print(controller.bookingModel.diveDate);
                      controller.update();
                      Get.back();
                    } else {
                      showToast("Select Time");
                    }
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
    DateTime selectedDiveDate = controller.bookingModel.theoryDate;
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
                    if (selectedDiveDate != null &&
                        selectedDiveDate.hour != null &&
                        selectedDiveDate.minute != null &&
                        selectedDiveDate.day != null) {
                      controller.bookingModel.theoryDate = selectedDiveDate;
                      print(controller.bookingModel.theoryDate);
                      controller.update();
                      Get.back();
                    } else {
                      showToast("Select Time");
                    }
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

  getDataFromFireBase() async {
    print("Strated");
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
    print(controller.activities);
    print("ended");
  }

  getPrice() {
    var tax;
    print("getPrice");
    controller.cost = 0;
    try {
      controller.cost += int.parse(controller.priceTED.text);
    } catch (e) {
      controller.cost += 0;
      showToast("Invalid Input");
    }
    print(controller.cost);
    if (controller.paxTED.text != null) {
      try {
        controller.cost = int.parse(controller.paxTED.text) * controller.cost;
      } catch (e) {
        controller.cost = 1 * controller.cost;
      }
    }
    getDiscount();
    getDiscountAmount();
    getTotalAmount();
    getBalanceAmount();
  }

  getDiscountAmount() {
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

  getTotalAmount() {
    if (controller.taxable) {
      controller.taxableAmount = controller.totalCost * 0.18;
      return controller.totalAmountTED.text =
          (controller.totalCost + controller.taxableAmount).toString();
    } else {
      controller.taxableAmount = 0;
      return controller.totalAmountTED.text =
          (controller.totalCost + controller.taxableAmount).toString();
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
    print("getDiscountPercent");
    try {
      controller.discount =
          controller.cost * (int.parse(controller.discountTED.text) / 100.0);
    } catch (e) {
      controller.discount = 0;
    }
  }

  getDiscountInINR() {
    print("getDiscountINPNR");
    try {
      controller.discount = double.parse(controller.discountTED.text);
    } catch (e) {
      controller.discount = 0;
    }
  }

  getBalanceAmount() {
    int payingNow;
    try {
      payingNow = int.parse(controller.depositTED.text);
    } catch (e) {
      payingNow = 0;
    }
    controller.balanceTED.text =
        (double.parse(controller.totalAmountTED.text) - payingNow)
            .toPrecision(2)
            .toString();
  }
}

class EditBookingDetailsController extends GetxController {
  BookingModel bookingModel;
  TextEditingController activityNAmeTED = TextEditingController();
  TextEditingController depositTED = TextEditingController();
  TextEditingController balanceTED = TextEditingController();
  TextEditingController paxTED = TextEditingController();
  TextEditingController remarksTED = TextEditingController();
  TextEditingController phoneTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController emailTED = TextEditingController();
  TextEditingController priceTED = TextEditingController();
  TextEditingController discountTED = TextEditingController();
  TextEditingController totalAmountTED = TextEditingController();

  FocusNode activityNode = FocusNode();
  FocusNode discountNode = FocusNode();
  FocusNode priceNode = FocusNode();
  FocusNode totalAmountNode = FocusNode();
  FocusNode depositNode = FocusNode();
  FocusNode balanceNode = FocusNode();
  FocusNode paxNode = FocusNode();
  FocusNode remarksNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode timeNode = FocusNode();

  String _isoCode;

  bool _discountSwitch = true;

  List<ActivityModel> activities = [];

  bool _showLoading = true;

  bool _taxable = false;

  double _cost;

  double _totalCost;

  double _taxableAmount;

  double _discount;

  String get isoCode => _isoCode;

  bool get discountSwitch => _discountSwitch;

  bool get showLoading => _showLoading;

  bool get taxable => _taxable;

  double get cost => _cost;

  double get totalCost => _totalCost;

  double get taxableAmount => _taxableAmount;

  double get discount => _discount;

  set discount(double value) {
    _discount = value;
    update();
  }

  set taxableAmount(double value) {
    _taxableAmount = value;
    update();
  }

  set totalCost(double value) {
    _totalCost = value;
    update();
  }

  set cost(double value) {
    _cost = value;
    update();
  }

  set taxable(bool value) {
    _taxable = value;
    update();
  }

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  set discountSwitch(bool value) {
    _discountSwitch = value;
    update();
  }

  set isoCode(String value) {
    _isoCode = value;
    update();
  }

  reset() {
    activityNAmeTED.text = "";
    priceTED.text = "";
    paxTED.text = "";
    discountTED.text = "";
    discountSwitch = true;
    taxable = false;
    totalAmountTED.text = "";
    depositTED.text = "";
    balanceTED.text = "";
    remarksTED.text = "";
    emailTED.text = "";
    _isoCode = null;
    phoneTED.text = "";
  }

  allReset() {
    activityNAmeTED.text = "";
    priceTED.text = "";
    paxTED.text = "";
    discountTED.text = "";
    discountSwitch = true;
    taxable = false;
    totalAmountTED.text = "";
    depositTED.text = "";
    balanceTED.text = "";
    remarksTED.text = "";
    // emailTED.text = "";
    // _isoCode = null;
    // phoneTED.text = "";
  }
}
