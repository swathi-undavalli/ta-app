import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class EditBookingNewLogic {
  EditBookingNewLogic() {
    getDataFromFireBase();
  }

  EditBookingNewController controller = Get.put(EditBookingNewController());

  getDataFromFireBase() async {
    //print("Strated");
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
    //print(controller.activities);
    //print("ended");
  }
}

class EditBookingNewController extends GetxController {
  BookingModel bookingModel;
  TextEditingController activityNAmeTED = TextEditingController();
  TextEditingController depositTED = TextEditingController();
  TextEditingController balanceTED = TextEditingController();
  TextEditingController paxTED = TextEditingController();
  TextEditingController remarksTED = TextEditingController();
  TextEditingController invoiceTED = TextEditingController();
  TextEditingController phoneTED = TextEditingController();
  TextEditingController countryCodeTED = TextEditingController();
  TextEditingController emailTED = TextEditingController();
  TextEditingController priceTED = TextEditingController();
  TextEditingController discountTED = TextEditingController();
  TextEditingController totalAmountTED = TextEditingController();
  TextEditingController firstNameTED = TextEditingController();
  TextEditingController lastNameTED = TextEditingController();

  FocusNode activityNode = FocusNode();
  FocusNode invoiceNoNode = FocusNode();
  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
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

  DateTime startDate = DateTime.now();

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
}
