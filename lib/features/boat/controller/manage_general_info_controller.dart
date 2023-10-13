import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/widgets/time_picker.dart';
import '../models/boats.dart';
import 'package:intl/intl.dart';

class ManageGeneralInfoLogic {
  ManageGeneralInfoController controller =
      Get.put(ManageGeneralInfoController());

  Future<void> init() async {
    controller.showLoading = true;
    var d = await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(controller.selectedDate))
        .get();

    Map<String, dynamic>? data = d.data();
    BoatsModel? boatsModel = BoatsModel.fromMap(data);
    if (boatsModel.dsd == null) {
      controller.currentDsd = Dsd(
          bcd: Bcd(xs: 0, s: 0, m: 0, l: 0, xl: 0, xxl: 0, kids: 0, xxs: 0),
          fins: 0,
          mask: 0,
          regulator: 0,
          powerMask: 0,
          weights: Weights(w3: 0, w4: 0, w5: 0, w6: 0, w7: 0),
          dayOffs: [],
          generalNotes: null,
          highTides: null,
          lowTides: null,
          waves: null,
          winds: null,
          leaves: [],
          powerNotes: null,
          dsdPool: [],
          dsdOceanHead: [],
          courseCenter: [],
          harboursStaff: [],
          centerStaff: [],);
    } else {
      controller.currentDsd = boatsModel.dsd!;

      controller.highTideTime =
          TimePicker.getDateTime(controller.currentDsd.highTides) ??
              DateTime.now();
      controller.lowTideTime =
          TimePicker.getDateTime(controller.currentDsd.lowTides) ??
              DateTime.now();
      controller.generalNotesTED.text =
          controller.currentDsd.generalNotes ?? '';
      controller.windsTED.text = controller.currentDsd.winds ?? '';
      controller.wavesTED.text = controller.currentDsd.waves ?? '';
      controller.powerNotesTED.text = controller.currentDsd.powerNotes ?? '';
    }
    controller.showLoading = false;
  }

  Future<void> onDateChanged(DateTime date) async {
    controller.selectedDate = date;
    controller.showLoading = true;
    await init();
    controller.showLoading = false;
  }

  Future<void> onSubmitPressed() async {
    controller.currentDsd.highTides =
        TimePicker.getFormattedTime(controller.highTideTime);
    controller.currentDsd.lowTides =
        TimePicker.getFormattedTime(controller.lowTideTime);

    controller.currentDsd.generalNotes = controller.generalNotesTED.text;
    controller.currentDsd.winds = controller.windsTED.text;
    controller.currentDsd.waves = controller.wavesTED.text;
    controller.currentDsd.powerNotes = controller.powerNotesTED.text;

    await FirebaseFirestore.instance
        .collection('dailyBoats')
        .doc(DateFormat('dd-MM-yyyy').format(controller.selectedDate))
        .set({'dsd': controller.currentDsd.toJson()}, SetOptions(merge: true));
    Get.back();
  }
}

class ManageGeneralInfoController extends GetxController {
  TextEditingController generalNotesTED = TextEditingController();
  TextEditingController wavesTED = TextEditingController();
  TextEditingController windsTED = TextEditingController();
  TextEditingController powerNotesTED = TextEditingController();

  BoatsModel? boatsModel;
  bool _showLoading = false;
  DateTime selectedDate = DateTime.now();
  DateTime highTideTime = DateTime.now();
  DateTime lowTideTime = DateTime.now();
  late Dsd currentDsd;

  bool get showLoading => _showLoading;

  set showLoading(bool value) {
    _showLoading = value;
    update();
  }

  reset() {
    generalNotesTED.text = '';
    wavesTED.text = '';
    windsTED.text = '';
    powerNotesTED.text = '';
    highTideTime = DateTime.now();
    lowTideTime = DateTime.now();
    selectedDate = DateTime.now();
  }
}
