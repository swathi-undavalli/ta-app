import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';

class EditPaymentsLogic {

  EditPaymentsController controller = Get.put(EditPaymentsController());

}

class EditPaymentsController extends GetxController {

  BookingModel? bookingModel;

  TextEditingController paymentTED = TextEditingController();
  TextEditingController paymentModeTED = TextEditingController();
  TextEditingController receiptNoTED = TextEditingController();
  TextEditingController referenceNoTED = TextEditingController();

  List<String> paymentOptions = [
    'Cash',
    'Razor Pay',
    'Bank Transfer',
    'UPI',
    'Card',
  ];
}
