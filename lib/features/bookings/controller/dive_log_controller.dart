import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/firebase/api.dart';
import '../../../core/util/utils.dart';
import '../../boat/models/boat_details.dart';
import '../models/booking_model.dart';
import '../models/dive-log-model.dart';

class DiveLogLogic {
  DiveLogController controller = Get.put(DiveLogController());

  Future<void> onSubmitPressed() async {
    if (isValid == false) return;

    controller.showLoading = true;
    controller.update();

    String id = DateTime.now().microsecondsSinceEpoch.toString();
    DateTime newTime = DateTime(
      controller.selectedDate.year,
      controller.selectedDate.month,
      controller.selectedDate.day,
      controller.selectedTime.hour,
      controller.selectedTime.minute,
    );
    DiveLogModel diveLogModel = DiveLogModel(
      timeIn: Timestamp.fromDate(newTime),
      instructor: controller.instructor[0],
      course: (controller.booking?.activity != null &&
              controller.booking!.activity!.isNotEmpty)
          ? controller.booking!.activity![0]!.name!
          : '-',
      diveSite: controller.diveSiteTED.text,
      tankNo: int.tryParse(controller.tankNoTED.text) ?? 0,
      bottomTime: int.tryParse(controller.bottomTimeTED.text) ?? 0,
      maxDepth: double.tryParse(controller.maxDepthTED.text) ?? 0,
      bookingId: controller.booking!.id!,
      id: controller.diveLog?.id ?? id,
      rentalEquipment: controller.rentalEquipmentTED.text,
      tankType: controller.tankTypeTED.text.capitalizeFirst,
    );

    await firebaseApi.updateDiveLog(diveLogModel, controller.email);

    controller.showLoading = false;
    controller.update();

    showToast(
      (controller.diveLog != null)
          ? 'Log edited Successfully'
          : 'Log added successfully',
    );
    Get.back();
  }

  bool get isValid {
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
    controller.tankTypeTED.text = '';
    controller.bottomTimeTED.text = '';
    controller.maxDepthTED.text = '';
    controller.rentalEquipmentTED.text = '';
    controller.instructor = [];
    controller.selectedTime = TimeOfDay.now();
    controller.selectedDate = DateTime.now();
    controller.showLoading = false;
    controller.diveLog = null;
  }
}

class DiveLogController extends GetxController {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  List<Instructor> instructor = [];
  TextEditingController diveSiteTED = TextEditingController();
  TextEditingController tankNoTED = TextEditingController();
  TextEditingController tankTypeTED = TextEditingController();
  TextEditingController bottomTimeTED = TextEditingController();
  TextEditingController maxDepthTED = TextEditingController();
  TextEditingController rentalEquipmentTED = TextEditingController();
  int? nitrox;
  int? air;
  String? diveSiteError;
  String? tankNoError;
  String? bottomTimeError;
  String? maxDepthError;
  String? instructorError;
  Booking? booking;
  String? email;
  bool showLoading = false;
  DiveLogModel? diveLog;
}
