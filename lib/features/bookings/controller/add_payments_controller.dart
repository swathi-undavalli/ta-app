import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../core/widgets/bookings_calender_widget/bookings_calender_widget_controller_new.dart';
import '../../employees/model/employee.dart';
import '../models/booking_model.dart';

class AddPaymentsLogic {
  AddPaymentsController controller = Get.put(AddPaymentsController());

  onPaymentDetailsFilled(BuildContext context, String balance) {
    if (controller.paymentModeTED.text != '') {
      if (controller.depositTED.text != '' &&
          double.parse(controller.depositTED.text) > 0 &&
          double.parse(controller.depositTED.text) <= double.parse(balance)) {
        controller.bookingModel!.payments!.add(
          PaymentModel(
            amount: double.parse(controller.depositTED.text),
            collectedBy: currentEmployee!.name,
            reciptNo: controller.receiptNoTED.text,
            referenceNo: controller.paymentReferenceTED.text,
            paymentMode: controller.paymentModeTED.text,
            time: DateTime.now(),
          ),
        );
        FirebaseFirestore.instance
            .collection('bookings')
            .doc(controller.bookingModel!.id)
            .set(controller.bookingModel!.toMap());
        Navigator.pop(context);
        controller.reset();
        BookingsCalenderWidgetLogicNew bookingCalenderLogicNew = BookingsCalenderWidgetLogicNew();
        bookingCalenderLogicNew.onDateSelected(bookingCalenderLogicNew.controller.selectedDate);
      } else {
        Fluttertoast.showToast(msg: 'Invalid Deposit');
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid PaymentMode');
    }
  }

  datePicker(context) {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now().subtract(const Duration(days: 36500)),
      maxTime: DateTime.now(),
      onChanged: (date) {
        // //print('change $date');
        controller.paymentDate = date;
      },
      onConfirm: (date) {
        // //print('confirm $date');
        controller.paymentDate = date;
        controller.update();
      },
      currentTime: controller.paymentDate,
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
  Booking? bookingModel;

  reset() {
    depositTED.text = '';
    paymentModeTED.text = '';
    paymentReferenceTED.text = '';
    receiptNoTED.text = '';
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
