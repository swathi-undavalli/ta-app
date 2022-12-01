import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/booking_calender_widget_old/bookings_calender_widget_controller_old.dart';
import 'package:temple_adventures/core/widgets/bookings_calender_widget/bookings_calender_widget_controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/home/model/employee.dart';

class AddPaymentsLogic {
  AddPaymentsController controller = Get.put(AddPaymentsController());

  onPaymentDetailsFilled() {
    if (controller.paymentModeTED.text != "") {
      if (controller.depositTED.text != "") {
        controller.bookingModel.payments.add(
          PaymentModel(
            amount: double.parse(controller.depositTED.text),
            collectedBy: currentEmployee.name,
            reciptNo: controller.receiptNoTED.text,
            referenceNo: controller.paymentReferenceTED.text,
            paymentMode: controller.paymentModeTED.text,
            time: DateTime.now(),
          ),
        );
        FirebaseFirestore.instance
            .collection("bookings")
            .doc(controller.bookingModel.id)
            .set(controller.bookingModel.toMap());
        Get.back();
        controller.reset();
        BookingsCalenderWidgetLogicNew bookingCalenderLogicNew =
            BookingsCalenderWidgetLogicNew();
        bookingCalenderLogicNew.onDateSelected(
          bookingCalenderLogicNew.controller.lastDateIndex,
        );
      } else {
        Fluttertoast.showToast(msg: "Invalid Deposit");
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid PaymentMode");
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
}

class AddPaymentsController extends GetxController {
  DateTime _paymentDate = DateTime.now();

  TextEditingController depositTED = TextEditingController();
  TextEditingController paymentModeTED = TextEditingController();
  TextEditingController paymentReferenceTED = TextEditingController();
  TextEditingController receiptNoTED = TextEditingController();

  FocusNode depositNode = FocusNode();
  FocusNode paymentReferenceNode = FocusNode();
  FocusNode receiptNoNode = FocusNode();
  BookingModel bookingModel;

  reset() {
    depositTED.text = "";
    paymentModeTED.text = "";
    paymentReferenceTED.text = "";
    receiptNoTED.text = "";
  }

  List<String> paymentOptions = [
    'Cash',
    'Razor Pay',
    'Bank Transfer',
    'UPI',
    'Card',
  ];

  DateTime get paymentDate => _paymentDate;

  set paymentDate(DateTime value) {
    _paymentDate = value;
    update();
  }
}
