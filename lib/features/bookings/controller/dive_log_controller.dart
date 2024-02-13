import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../boat/models/boat_details.dart';
import '../models/booking_model.dart';
import '../models/customer_model.dart';

class DiveLogLogic {
  DiveLogController controller = Get.put(DiveLogController());

  Future<void> onSubmitPressed() async {
    if (isValid()) {
      var d = await FirebaseFirestore.instance.collection('customers').doc(controller.email).get();
      Map<String, dynamic>? data = d.data();

      if (data != null) {
        CustomerModel customerModel = CustomerModel.fromMap(data);
      }
    }
  }

  bool isValid() {
    bool isValid = true;
    controller.diveSiteError = null;
    controller.tankNoError = null;
    controller.bottomTimeError = null;
    controller.maxDepthError = null;
    controller.instructorError = null;

    if (controller.diveSiteTED.text.isEmpty) {
      controller.diveSiteError = 'Required';
      isValid = false;
      controller.update();
    }
    if (controller.tankNoTED.text.isEmpty) {
      controller.tankNoError = 'Required';
      isValid = false;
      controller.update();
    }
    if (controller.bottomTimeTED.text.isEmpty) {
      controller.bottomTimeError = 'Required';
      isValid = false;
      controller.update();
    }
    if (controller.maxDepthTED.text.isEmpty) {
      controller.maxDepthError = 'Required';
      isValid = false;
      controller.update();
    }
    if (controller.instructor.isEmpty) {
      controller.instructorError = 'Required';
      isValid = false;
      controller.update();
    }
    return isValid;
  }

  clear() {
    controller.diveSiteError = null;
    controller.tankNoError = null;
    controller.bottomTimeError = null;
    controller.maxDepthError = null;
    controller.instructorError = null;
    controller.diveSiteTED.text = '';
    controller.tankNoTED.text = '';
    controller.bottomTimeTED.text = '';
    controller.maxDepthTED.text = '';
    controller.instructor = [];
    controller.selectedTime = TimeOfDay.now();
    controller.selectedDate = DateTime.now();
  }
}

class DiveLogController extends GetxController {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  List<Instructor> instructor = [];
  TextEditingController diveSiteTED = TextEditingController();
  TextEditingController tankNoTED = TextEditingController();
  TextEditingController bottomTimeTED = TextEditingController();
  TextEditingController maxDepthTED = TextEditingController();
  String? diveSiteError;
  String? tankNoError;
  String? bottomTimeError;
  String? maxDepthError;
  String? instructorError;
  Booking? booking;
  String? email;
}
