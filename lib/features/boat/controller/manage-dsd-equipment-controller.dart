import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/models/boats.dart';
import 'package:intl/intl.dart';

class ManageDSDEquipmentLogic {
  ManageDSDEquipmentController controller = Get.put(ManageDSDEquipmentController());

  Future<void> init() async {
    var d = await FirebaseFirestore.instance
        .collection("dailyBoats")
        .doc(DateFormat("dd-MM-yyyy").format(DateTime.now()))
        .get();

    Map<String, dynamic>? data = d.data();
    if (data != null) {
      controller.boatsModel = BoatsModel.fromJson(data);

      controller.bdcTED.text = controller.boatsModel?.dsd.bcd ?? '';
      controller.regTED.text = controller.boatsModel?.dsd.reg ?? '';
      controller.maskTED.text = controller.boatsModel?.dsd.mask ?? '';
      controller.powerMaskTED.text = controller.boatsModel?.dsd.powerMask ?? '';
      controller.finsTED.text = controller.boatsModel?.dsd.fins ?? '';
      controller.bootsTED.text = controller.boatsModel?.dsd.boots ?? '';
      controller.weightsTED.text = controller.boatsModel?.dsd.weight ?? '';

      controller.dayOffTED.text = controller.boatsModel?.dsd.dayOff ?? '';
      controller.leavesTED.text = controller.boatsModel?.dsd.leaves ?? '';
      controller.generalNotesTED.text = controller.boatsModel?.dsd.generalNotes ?? '';
      controller.highTideTED.text = controller.boatsModel?.dsd.highTides ?? '';
      controller.lowTideTED.text = controller.boatsModel?.dsd.lowTides ?? '';
      controller.wavesTED.text = controller.boatsModel?.dsd.waves ?? '';
      controller.windsTED.text = controller.boatsModel?.dsd.winds ?? '';
    }
  }

  Future<void> onSubmitPressed() async {
    Dsd dsd = Dsd(
      bcd: controller.bdcTED.text,
      boots: controller.bootsTED.text,
      fins: controller.finsTED.text,
      mask: controller.maskTED.text,
      powerMask: controller.powerMaskTED.text,
      reg: controller.regTED.text,
      weight: controller.weightsTED.text,
      dayOff: controller.dayOffTED.text,
      leaves: controller.leavesTED.text,
      generalNotes: controller.generalNotesTED.text,
      highTides: controller.highTideTED.text,
      lowTides: controller.lowTideTED.text,
      waves: controller.wavesTED.text,
      winds: controller.windsTED.text,
    );

    log("done");
    controller.boatsModel = controller.boatsModel?.copyWith(dsd: dsd);
    log("done");
    log(controller.boatsModel!.toJson().toString());

    if (controller.boatsModel != null)
      await FirebaseFirestore.instance
          .collection("dailyBoats")
          .doc(DateFormat("dd-MM-yyyy").format(DateTime.now()))
          .set(controller.boatsModel!.toJson());

    log("done");
    Get.back();
  }
}

class ManageDSDEquipmentController extends GetxController {
  TextEditingController bdcTED = TextEditingController();
  TextEditingController regTED = TextEditingController();
  TextEditingController maskTED = TextEditingController();
  TextEditingController powerMaskTED = TextEditingController();
  TextEditingController finsTED = TextEditingController();
  TextEditingController bootsTED = TextEditingController();
  TextEditingController weightsTED = TextEditingController();
  TextEditingController dayOffTED = TextEditingController();
  TextEditingController leavesTED = TextEditingController();
  TextEditingController generalNotesTED = TextEditingController();
  TextEditingController highTideTED = TextEditingController();
  TextEditingController lowTideTED = TextEditingController();
  TextEditingController wavesTED = TextEditingController();
  TextEditingController windsTED = TextEditingController();

  BoatsModel? boatsModel;

  reset() {
    bdcTED.text = "";
    regTED.text = "";
    maskTED.text = "";
    powerMaskTED.text = "";
    finsTED.text = "";
    bootsTED.text = "";
    weightsTED.text = "";
    dayOffTED.text = "";
    leavesTED.text = "";
    generalNotesTED.text = "";
    highTideTED.text = "";
    lowTideTED.text = "";
    wavesTED.text = "";
    windsTED.text = "";
  }
}
